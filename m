Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752709Ab3G2Aig (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jul 2013 20:38:36 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:37099 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485Ab3G2Aie (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jul 2013 20:38:34 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <51F5B966.9080405@jp.fujitsu.com>
Date: Mon, 29 Jul 2013 09:37:58 +0900
From: Takao Indoh <indou.takao@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: bhelgaas@google.com
CC: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        iommu@lists.linux-foundation.org, kexec@lists.infradead.org,
        ishii.hironobu@jp.fujitsu.com, ddutile@redhat.com, bill.sumner@hp.com,
        alex.williamson@redhat.com, vgoyal@redhat.com, hbabu@us.ibm.com
Subject: Re: [PATCH v2] PCI: Reset PCIe devices to stop ongoing DMA
References: <1368509365-2260-1-git-send-email-indou.takao@jp.fujitsu.com> <CAErSpo4t_2Xw76p3Z9FVzyyK-MBovavDu9D=pYoPMjESSxgT=w@mail.gmail.com> <51B19DF3.2070009@jp.fujitsu.com> <CAErSpo6dfEnzriHD_aWZB_3E-kSzauhNRHPd+VuFX5HONVKgqw@mail.gmail.com> <51B6BEDB.3000509@jp.fujitsu.com> <CAErSpo5u8qGALt6C+tuPYXdd2YgyMH6fnPnA+afUteEZ7kY0iw@mail.gmail.com> <51B93221.2040505@jp.fujitsu.com> <CAErSpo5tVK-Z3aOdMTzab-S8o5zLVtDOFQ8-LSYpUgbrJSsxuw@mail.gmail.com> <51BA7BB6.1080104@jp.fujitsu.com> <51EF7466.20703@jp.fujitsu.com> <CAErSpo5B7NzVfxwW3bQnfK+iK+DrRsWQd2Cm14z5PWNnRHWL5w@mail.gmail.com>
In-Reply-To: <CAErSpo5B7NzVfxwW3bQnfK+iK+DrRsWQd2Cm14z5PWNnRHWL5w@mail.gmail.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/07/26 2:00), Bjorn Helgaas wrote:
> On Wed, Jul 24, 2013 at 12:29 AM, Takao Indoh
> <indou.takao@jp.fujitsu.com> wrote:
>> Sorry for letting this discussion slide, I was busy on other works:-(
>> Anyway, the summary of previous discussion is:
>> - My patch adds new initcall(fs_initcall) to reset all PCIe endpoints on
>>    boot. This expects PCI enumeration is done before IOMMU
>>    initialization as follows.
>>      (1) PCI enumeration
>>      (2) fs_initcall ---> device reset
>>      (3) IOMMU initialization
>> - This works on x86, but does not work on other architecture because
>>    IOMMU is initialized before PCI enumeration on some architectures. So,
>>    device reset should be done where IOMMU is initialized instead of
>>    initcall.
>> - Or, as another idea, we can reset devices in first kernel(panic kernel)
>>
>> Resetting devices in panic kernel is against kdump policy and seems not to
>> be good idea. So I think adding reset code into iommu initialization is
>> better. I'll post patches for that.
> 
> Of course nobody *wants* to do anything in the panic kernel.  But
> simply saying "it's against kdump policy and seems not to be a good
> idea" is not a technical argument.  There are things that are
> impractical to do in the kdump kernel, so they have to be done in the
> panic kernel even though we know the kernel is unreliable and the
> attempt may fail.

Accessing kernel data in panic kernel causes panic again, so
- Don't touch kernel data in panic situation
- Jump to kdump kernel as quickly as possible, and do things in safe
  kernel
These are basic "kdump policy". Of course if there are any works which
we cannot do in kdump kernel and can do only in panic kernel, for
example saving registers or stopping cpus, we should do them in panic
kernel.

Resetting devices in panic kernel is worth considering if we can safely
find pci_dev and reset it, but I have no idea how to do that because
for example struct pci_dev may be borken.

> 
> My point about IOMMU and PCI initialization order doesn't go away just
> because it doesn't fit "kdump policy."  Having system initialization
> occur in a logical order is far more important than making kdump work.

My next plan is as follows. I think this is matched to logical order
on boot.

drivers/pci/pci.c
- Add function to reset bus, for example, pci_reset_bus(struct pci_bus *bus)

drivers/iommu/intel-iommu.c
- On initialization, if IOMMU is already enabled, call this bus reset
  function before disabling and re-enabling IOMMU.

Thanks,
Takao Indoh

