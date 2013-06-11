Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753753Ab3FKCVO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 22:21:14 -0400
Received: from mail-oa0-f50.google.com ([209.85.219.50]:47530 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752042Ab3FKCVL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 22:21:11 -0400
MIME-Version: 1.0
In-Reply-To: <51B19DF3.2070009@jp.fujitsu.com>
References: <1368509365-2260-1-git-send-email-indou.takao@jp.fujitsu.com>
 <CAErSpo4t_2Xw76p3Z9FVzyyK-MBovavDu9D=pYoPMjESSxgT=w@mail.gmail.com> <51B19DF3.2070009@jp.fujitsu.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 10 Jun 2013 20:20:50 -0600
Message-ID: <CAErSpo6dfEnzriHD_aWZB_3E-kSzauhNRHPd+VuFX5HONVKgqw@mail.gmail.com>
Subject: Re: [PATCH v2] PCI: Reset PCIe devices to stop ongoing DMA
To: Takao Indoh <indou.takao@jp.fujitsu.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "open list:INTEL IOMMU (VT-d)" <iommu@lists.linux-foundation.org>,
        kexec@lists.infradead.org, ishii.hironobu@jp.fujitsu.com,
        Don Dutile <ddutile@redhat.com>, bill.sumner@hp.com,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 7, 2013 at 2:46 AM, Takao Indoh <indou.takao@jp.fujitsu.com> wrote:
> (2013/06/07 13:14), Bjorn Helgaas wrote:

>> One thing I'm not sure about is that you are only resetting PCIe
>> devices, but I don't think the problem is actually specific to PCIe,
>> is it?  I think the same issue could occur on any system with an
>> IOMMU.  In the x86 PC world, most IOMMUs are connected with PCIe, but
>> there are systems with IOMMUs for plain old PCI devices, e.g.,
>> PA-RISC.
>
> Right, this is not specific to PCIe. The reasons why the target is only
> PCIe is just to make algorithm to reset simple. It is possible to reset
> legacy PCI devices in my patch, but code becomes somewhat complicated. I
> thought recently most systems used PCIe and there was little demand for
> resetting legacy PCI. Therefore I decided not to reset legacy PCI
> devices, but I'll do if there are requests :-)

I'm not sure you need to reset legacy devices (or non-PCI devices)
yet, but the current hook isn't anchored anywhere -- it's just an
fs_initcall() that doesn't give the reader any clue about the
connection between the reset and the problem it's solving.

If we do something like this patch, I think it needs to be done at the
point where we enable or disable the IOMMU.  That way, it's connected
to the important event, and there's a clue about how to make
corresponding fixes for other IOMMUs.

We already have a "reset_devices" boot option.  This is for the same
purpose, as far as I can tell, and I'm not sure there's value in
having both "reset_devices" and "pci=pcie_reset_endpoint_devices".  In
fact, there's nothing specific even to PCI here.  The Intel VT-d docs
seem carefully written so they could apply to either PCIe or non-PCI
devices.

>> I tried to make a list of the interesting scenarios and the events
>> that are relevant to this problem:
>>
>>      Case 1: IOMMU off in system, off in kdump kernel
>>        system kernel leaves IOMMU off
>>          DMA targets system-kernel memory
>>        kexec to kdump kernel (IOMMU off, devices untouched)
>>          DMA targets system-kernel memory (harmless)
>>        kdump kernel re-inits device
>>          DMA targets kdump-kernel memory
>>
>>      Case 2: IOMMU off in system kernel, on in kdump kernel
>>        system kernel leaves IOMMU off
>>          DMA targets system-kernel memory
>>        kexec to kdump kernel (IOMMU off, devices untouched)
>>          DMA targets system-kernel memory (harmless)
>>        kdump kernel enables IOMMU with no valid mappings
>>          DMA causes IOMMU errors (annoying but harmless)
>>        kdump kernel re-inits device
>>          DMA targets IOMMU-mapped kdump-kernel memory
>>
>>      Case 3a: IOMMU on in system kernel, kdump kernel doesn't touch IOMMU
>>        system kernel enables IOMMU
>>          DMA targets IOMMU-mapped system-kernel memory
>>        kexec to kdump kernel (IOMMU on, devices untouched)
>>          DMA targets IOMMU-mapped system-kernel memory
>>        kdump kernel doesn't know about IOMMU or doesn't touch it
>>          DMA targets IOMMU-mapped system-kernel memory
>>        kdump kernel re-inits device
>>          kernel assumes no IOMMU, so all new DMA mappings are invalid
>> because DMAs actually do go through the IOMMU
>>          (** corruption or other non-recoverable error likely **)
>>
>>      Case 3b: IOMMU on in system kernel, kdump kernel disables IOMMU
>>        system kernel enables IOMMU
>>          DMA targets IOMMU-mapped system-kernel memory
>>        kexec to kdump kernel (IOMMU on, devices untouched)
>>          DMA targets IOMMU-mapped system-kernel memory
>>        kdump kernel disables IOMMU
>>          DMA targets IOMMU-mapped system-kernel memory, but IOMMU is disabled
>>          (** corruption or other non-recoverable error likely **)
>>        kdump kernel re-inits device
>>          DMA targets kdump-kernel memory
>>
>>      Case 4: IOMMU on in system kernel, on in kdump kernel
>>        system kernel enables IOMMU
>>          DMA targets IOMMU-mapped system-kernel memory
>>        kexec to kdump kernel (IOMMU on, devices untouched)
>>          DMA targets IOMMU-mapped system-kernel memory
>>        kdump kernel enables IOMMU with no valid mappings
>>          DMA causes IOMMU errors (annoying but harmless)
>>        kdump kernel re-inits device
>>          DMA targets IOMMU-mapped kdump-kernel memory
>
> This is not harmless. Errors like PCI SERR are detected here, and it
> makes driver or system unstable, and kdump fails. I also got report that
> system hangs up due to this.

OK, let's take this slowly.  Does an IOMMU error in the system kernel
also cause SERR or make the system unstable?  Is that the expected
behavior on IOMMU errors, or is there something special about the
kdump scenario that causes SERRs?  I see lots of DMAR errors, e.g.,
those in https://bugzilla.redhat.com/show_bug.cgi?id=743790, that are
reported with printk and don't seem to cause an SERR.  Maybe the SERR
is system-specific behavior?

https://bugzilla.redhat.com/show_bug.cgi?id=568153 is another (public)
report of IOMMU errors related to a driver bug where we just get
printks, not SERR.

https://bugzilla.redhat.com/show_bug.cgi?id=743495 looks like a hang
when the kdump kernel reboots (after successfully saving a crashdump).
 But it is using "iommu=pt", which I don't believe makes sense.  The
scenario is basically case 4 above, but instead of the kdump kernel
starting with no valid IOMMU mappings, it identity-maps bus addresses
to physical memory addresses.  That's completely bogus because it's
certainly not what the system kernel did, so it's entirely likely to
make the system unstable or hang.  This is not an argument for doing a
reset; it's an argument for doing something smarter than "iommu=pt" in
the kdump kernel.

We might still want to reset PCIe devices, but I want to make sure
that we're not papering over other issues when we do.  Therefore, I'd
like to understand why IOMMU errors seem harmless in some cases but
not in others.

> Case 1:  Harmless
> Case 2:  Not tested
> Case 3a: Not tested
> Case 3b: Cause problem, fixed by my patch
> Case 4:  Cause problem, fixed by my patch
>
> I have never tested case 2 and 3a, but I think it also causes problem.

I do not believe we need to support case 3b (IOMMU on in system kernel
but disabled in kdump kernel).  There is no way to make that reliable
unless every single device that may perform DMA is reset, and since
you don't reset legacy PCI or VGA devices, you're not even proposing
to do that.

I think we need to support case 1 (for systems with no IOMMU at all)
and case 4 (IOMMU enabled in both system kernel and kdump kernel).  If
the kdump kernel can detect whether the IOMMU is enabled, that should
be enough -- it could figure out automatically whether we're in case 1
or 4.

>> Do you have any bugzilla references or problem report URLs you could
>> include here?
>
> I know three Red Hat bugzilla, but I think these are private article and
> you cannot see. I'll add you Cc list in bz so that you can see.
>
> BZ#743790: Kdump fails with intel_iommu=on
> https://bugzilla.redhat.com/show_bug.cgi?id=743790
>
> BZ#743495: Hardware error is detected with intel_iommu=on
> https://bugzilla.redhat.com/show_bug.cgi?id=743495
>
> BZ#833299: megaraid_sas doesn't work well with intel_iommu=on and iommu=pt
> https://bugzilla.redhat.com/show_bug.cgi?id=833299

Thanks for adding me to the CC lists.  I looked all three and I'm not
sure there's anything sensitive in them.  It'd be nice if they could
be made public if there's not.

Bjorn
