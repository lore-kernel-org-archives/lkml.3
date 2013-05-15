Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754811Ab3EOEtq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 00:49:46 -0400
Received: from erley.org ([97.107.129.9]:40247 "EHLO remote.erley.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751870Ab3EOEto (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 00:49:44 -0400
X-Greylist: delayed 525 seconds by postgrey-1.27 at vger.kernel.org; Wed, 15 May 2013 00:49:44 EDT
Message-ID: <519311CF.1010209@erley.org>
Date: Wed, 15 May 2013 00:40:47 -0400
From: Pat Erley <pat-lkml@erley.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130422 Thunderbird/17.0.5
MIME-Version: 1.0
To: Andrew Cooks <acooks@gmail.com>
CC: "open list:INTEL IOMMU, (VT-d)" <iommu@lists.linux-foundation.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        "David Woodhouse (supporter:INTEL IOMMU (VT-d))" 
	<dwmw2@infradead.org>,
        "list@remote.erley.org:PCI SUBSYSTEM" <linux-pci@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>, jforbes@redhat.com
Subject: Re: Ricoh DMAR bug returns? (WAS Re: [PATCH v4] Quirk for buggy dma
 source tags with Intel IOMMU.)
References: <CAJtEV7baCffS49omM8ZTtGW-AsAnK6tV5dPbG4t3Yq_=F9uvLw@mail.gmail.com> <515E6634.701@erley.org>
In-Reply-To: <515E6634.701@erley.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/05/2013 01:50 AM, Pat Erley wrote:
> On 04/05/2013 12:44 AM, Andrew Cooks wrote:
>> On Tue, Apr 2, 2013 at 11:47 PM, Pat Erley <pat-lkml@erley.org> wrote:
>>> On 04/02/2013 10:50 AM, Andrew Cooks wrote:
>>>>
>>>> On 2 Apr 2013 15:37, "Pat Erley" <pat-lkml@erley.org
>>>> <mailto:pat-lkml@erley.org>> wrote:
>>>>   >
>>>>   > On 03/07/2013 09:35 PM, Andrew Cooks wrote:
>>>>   >>
>>>>   >> --- a/drivers/pci/quirks.c
>>>>   >> +++ b/drivers/pci/quirks.c
>>>>   >>
>>>>   >> +/* Table of multiple (ghost) source functions. This is similar
>>>> to the
>>>>   >> + * translated sources above, but with the following differences:
>>>>   >> + * 1. the device may use multiple functions as DMA sources,
>>>>   >> + * 2. these functions cannot be assumed to be actual devices,
>>>> they're simply
>>>>   >> + * incorrect DMA tags.
>>>>   >> + * 3. the specific ghost function for a request can not always be
>>>> predicted.
>>>>   >> + * For example, the actual device could be xx:yy.1 and it
>>>> could use
>>>>   >> + * both 0 and 1 for different requests, with no obvious way to
>>>> tell
>>>> when
>>>>   >> + * DMA will be tagged as comming from xx.yy.0 and and when it
>>>> will
>>>> be tagged
>>>>   >> + * as comming from xx.yy.1.
>>>>   >> + * The bitmap contains all of the functions used in DMA tags,
>>>> including the
>>>>   >> + * actual device.
>>>>   >> + * See https://bugzilla.redhat.com/show_bug.cgi?id=757166,
>>>>   >> + * https://bugzilla.kernel.org/show_bug.cgi?id=42679
>>>>   >> + * https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1089768
>>>>   >> + */
>>>>   >> +static const struct pci_dev_dma_multi_func_sources {
>>>>   >> +       u16 vendor;
>>>>   >> +       u16 device;
>>>>   >> +       u8 func_map;    /* bit map. lsb is fn 0. */
>>>>   >> +} pci_dev_dma_multi_func_sources[] = {
>>>>   >> +       { PCI_VENDOR_ID_MARVELL_2, 0x9123, (1<<0)|(1<<1)},
>>>>   >> +       { PCI_VENDOR_ID_MARVELL_2, 0x9125, (1<<0)|(1<<1)},
>>>>   >> +       { PCI_VENDOR_ID_MARVELL_2, 0x9128, (1<<0)|(1<<1)},
>>>>   >> +       { PCI_VENDOR_ID_MARVELL_2, 0x9130, (1<<0)|(1<<1)},
>>>>   >> +       { PCI_VENDOR_ID_MARVELL_2, 0x9143, (1<<0)|(1<<1)},
>>>>   >> +       { PCI_VENDOR_ID_MARVELL_2, 0x9172, (1<<0)|(1<<1)},
>>>>   >> +       { 0 }
>>>>   >> +};
>>>>   >
>>>>   >
>>>>   > Adding another buggy device.  I have a Ricoh multifunction device:
>>>>   >
>>>>   > 17:00.0 SD Host controller: Ricoh Co Ltd MMC/SD Host Controller
>>>> (rev
>>>> 01)
>>>>   > 17:00.3 FireWire (IEEE 1394): Ricoh Co Ltd R5C832 PCIe IEEE 1394
>>>>   >         Controller (rev 01)
>>>>   >
>>>>   > 17:00.0 0805: 1180:e822 (rev 01)
>>>>   > 17:00.3 0c00: 1180:e832 (rev 01)
>>>>   >
>>>>
>>>> The Ricoh device issue has been known for some time and a quirk has
>>>> been
>>>> available since commit 12ea6cad1c7d046 in June 2012.  It's slightly
>>>> different than the problem this patch tries to work around [1].
>>>
>>>
>>> Hmm, I've had this problem with many recent (vanilla) kernels, up to and
>>> including 3.9-rc5
>>>
>>>
>>>>   > that adding entries for also fixed booting.  I don't have any SD
>>>> cards or firewire devices handy to test that they work, but the system
>>>> now boots, which was not the case without your patch and IOMMU/DMAR
>>>> enabled.
>>>>
>>>> That is really strange. Could you tell us what kernel version you
>>>> tested
>>>> and provide dmesg output?
>>>
>>>
>>> I'll capture a vanilla 3.8.5 boot without any patches and iommu=off,
>>> then
>>> try to find another machine to catch what I can of a netconsole boot
>>> with
>>> iommu=on.  What's the preferred way to send these?  pastebin links?
>>>
>>> I'd been running the 'dirty' fix that's in the redhat bugzilla entry.  I
>>> checked my .config and have CONFIG_PCI_QUIRKS=y, and verified my
>>> devices are
>>> in the quirks table for the pci_func_0_dma_source fixup.
>>>
>> Do you mean that even though your hardware is specifically listed in
>> the quirk table, the quirk simply hasn't worked for you? That would be
>> unfortunate, to say the least.
>
> Precisely.
>
>> The fedora kernel included a separate patch for this issue until
>> recently (see https://bugzilla.redhat.com/show_bug.cgi?id=880051).  It
>> basically just disabled DMAR when the Ricoh device is present, the
>> same as the patch to the mailing list you mentioned.
>
> Yes, that's what I've been avoiding doing.  Every new release, I boot
> once with iommu=on, and firewire blacklisted, boot up, load the firewire
> driver.  This has caused the 'Ricoh DMAR' bug on every kernel since I
> got the laptop.  I then reboot and ....
>
>> Is the dirty fix you're referring to comment 7?
>> https://bugzilla.redhat.com/show_bug.cgi?id=605888#c7
>
> Apply this patch, which has worked fine for me, but per a commend in a
> thread I created here on 10/19/2012[1], this has a potential significant
> performance impact.  In my use case, a performance hit is worth the cost
> for the features.
>
> However, your patch(while not intended to be the fix), actually solves
> the issue on my machine.  I don't know if it also has the potential
> performance impact, but it's certainly not noticeably worse in my use case.
>
> Pat Erley
>
> [1] http://marc.info/?l=linux-pci&m=135094489232548&w=2

As a follow up, I still have this problem in 3.10.0-rc1+ (and the patch 
by Andrew to fix buggy dma source devices still fixes it).

Andrew, have you done anything with your DMA source patch since you last 
posted it?  I'm still using it and it still makes my computer happy. 
I'd happily switch to a newer revision of the patch instead of carrying 
a rebased version of what you posted in March.

Pat Erley

