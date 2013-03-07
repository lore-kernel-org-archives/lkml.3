Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755554Ab3CGJZj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 04:25:39 -0500
Received: from bolligen.cirrax.com ([217.197.128.7]:53032 "EHLO
	mail.cirrax.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755282Ab3CGJZh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 04:25:37 -0500
From: Gaudenz Steinlin <gaudenz@soziologie.ch>
To: Andrew Cooks <acooks@gmail.com>
Cc: jyli@marvell.com,
        "open list\:INTEL IOMMU \(VT-d\)" <iommu@lists.linux-foundation.org>,
        open list <linux-kernel@vger.kernel.org>, Shun Fu <fushun@marvell.com>,
        Alex Williamson <alex.williamson@redhat.com>
Subject: Re: Marvell 88NV9143 in mini-PCIe not working with intel_iommu=on
In-Reply-To: <CAJtEV7Zyq3+YPu9Vvcxcm8nw41-ENjLuRHUzyFFzXQn-wiSf1w@mail.gmail.com>
References: <874ngpj3d9.fsf@meteor.durcheinandertal.bofh> <CAJtEV7Zyq3+YPu9Vvcxcm8nw41-ENjLuRHUzyFFzXQn-wiSf1w@mail.gmail.com>
User-Agent: Notmuch/0.15.1 (http://notmuchmail.org) Emacs/23.4.1 (x86_64-pc-linux-gnu)
Date: Thu, 07 Mar 2013 10:25:22 +0100
Message-ID: <87zjyfy325.fsf@meteor.durcheinandertal.bofh>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Andrew

Andrew Cooks <acooks@gmail.com> writes:

> On Tue, Mar 5, 2013 at 11:03 PM, Gaudenz Steinlin <gaudenz@soziologie.ch> wrote:
>>
>> [ Sending this to the MVUMI driver authors and the IOMMU list as I can't
>> tell which part is at fault. ]
>>
>> [ ... ]
>> [    4.342079] dmar: DRHD: handling fault status reg 2
>> [    4.342132] dmar: DMAR:[DMA Read] Request device [02:00.0] fault addr fffff000
>> [    4.342132] DMAR:[fault reason 02] Present bit in context entry is clear
>> [ ... ]
>> [   34.344078] mvumi 0000:02:00.1: no handshake response at state 0x2.
>> [   34.344115] mvumi 0000:02:00.1: isr : global=0x0,status=0x0.
>> [   34.344146] mvumi 0000:02:00.1: handshake failed at state 0x2.
>> [   34.344266] mvumi: probe of 0000:02:00.1 failed with error -22
>>
>
> Looks like another Marvell DMA source tag issue.

You are probably right with this. See below.

>
>> And the full lspic output for this device:
>>
>> gaudenz@meteor:~$ sudo lspci -vv -nnq -s 02:
>> 02:00.0 Mass storage controller [01ff]: Marvell Technology Group Ltd. Device [1b4b:91f3]
>>         Subsystem: Marvell Technology Group Ltd. Device [1b4b:9143]
>> ...
>>         Capabilities: [140 v1] Virtual Channel
>>                 Caps:   LPEVC=0 RefClk=100ns PATEntryBits=1
>>                 Arb:    Fixed- WRR32- WRR64- WRR128-
>>                 Ctrl:   ArbSelect=Fixed
>>                 Status: InProgress-
>>                 VC0:    Caps:   PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
>>                         Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
>>                         Ctrl:   Enable+ ID=0 ArbSelect=Fixed TC/VC=01
>>                         Status: NegoPending- InProgress-
>>
>> 02:00.1 Mass storage controller [0180]: Marvell Technology Group Ltd. Device [1b4b:9143] (rev 10)
>>         Subsystem: Marvell Technology Group Ltd. Device [1b4b:9143]
>> ...
>>         Kernel driver in use: mvumi
>>
>> 02:00.2 Non-Volatile memory controller [0108]: Marvell Technology Group Ltd. Device [1b4b:91e3] (prog-if 01)
>>         Subsystem: Marvell Technology Group Ltd. Device [1b4b:9143]
>>...
>
> In this case it seems like a multifunction device with 02:00.1 being
> the only function that the mvumi driver cares about.  So my guess is
> that 02:00.1 is issuing DMA with the incorrect tag of 02:00.0.
>
> Perhaps Alex Williamson can tell us about iommu device groups, whether
> it would be possible to group the functions together automatically and
> whether that would solve the problem. It should also be possible to
> adapt the quirk patch I posted recently to handle this, but I'm still
> waiting to hear if that patch has a future.

I adapted your quirk patch to my device and it works. As I'm very new to
this I don't know if my modifications are right or if there is a better
way to do this. Diff on top of the latest version of the quirk you
posted to the iommu list:

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index 13323f2..0ba462a 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -1684,7 +1684,7 @@ static int map_ghost_dma_fn(struct dmar_domain *domain,
 
        fn_map = pci_get_dma_source_map(pdev);
 
-       for (fn = 1; fn < 8; fn++) {
+       for (fn = 0; fn < 8; fn++) {
                if (fn_map & (1 << fn)) {
                        err = domain_context_mapping_one(domain,
                                        pci_domain_nr(pdev->bus),
diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index d311100..21b664b 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -3314,6 +3314,7 @@ static const struct pci_dev_dma_multi_func_sources {
        { PCI_VENDOR_ID_MARVELL_2, 0x9128, (1<<0)|(1<<1)},
        { PCI_VENDOR_ID_MARVELL_2, 0x9130, (1<<0)|(1<<1)},
        { PCI_VENDOR_ID_MARVELL_2, 0x9172, (1<<0)|(1<<1)},
+       { PCI_VENDOR_ID_MARVELL_2, 0x9143, (1<<0)},
        { 0 }
 };

Gaudenz

-- 
Ever tried. Ever failed. No matter.
Try again. Fail again. Fail better.
~ Samuel Beckett ~
