Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933157AbaKMNhn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 08:37:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58088 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753768AbaKMNhl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 08:37:41 -0500
Date: Thu, 13 Nov 2014 21:37:08 +0800
From: Baoquan He <bhe@redhat.com>
To: "Li, ZhenHua" <zhen-hual@hp.com>
Cc: Minfei Huang <mhuang@redhat.com>, kexec@lists.infradead.org,
        joro@8bytes.org, dwmw2@infradead.org, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] x86/iommu: fix incorrect bit operations in setting
 values
Message-ID: <20141113133708.GA1678@dhcp-17-102.nay.redhat.com>
References: <1415172619-4801-1-git-send-email-zhen-hual@hp.com>
 <20141112112832.GA3334@dhcp-17-108.nay.redhat.com>
 <546474AF.2030902@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <546474AF.2030902@hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/13/14 at 05:06pm, Li, ZhenHua wrote:
> Minfei,
> Thanks for your testing.
> On my system, I got error messages:
> 
> [    8.019096] usb usb2: New USB device strings: Mfr=3, Product=2,
> SerialNumber=1
> [    8.019617] dmar: DRHD: handling fault status reg 102
> [    8.019621] dmar: DMAR:[DMA Read] Request device [01:00.0] fault
> addr fff6a000
> [    8.019621] DMAR:[fault reason 06] PTE Read access is not set
> [    8.019627] dmar: DRHD: handling fault status reg 202
> [    8.019631] dmar: DMAR:[DMA Read] Request device [21:00.0] fault
> addr fff6a000
> [    8.019631] DMAR:[fault reason 06] PTE Read access is not set
> [    8.019638] dmar: DRHD: handling fault status reg 202
> [    8.019641] dmar: DMAR:[DMA Read] Request device [41:00.0] fault
> addr fff6a000
> [    8.019641] DMAR:[fault reason 06] PTE Read access is not set
> [    8.019647] dmar: DRHD: handling fault status reg 202
> [    8.019651] dmar: DMAR:[DMA Read] Request device [61:00.0] fault
> addr fff6a000
> [    8.019651] DMAR:[fault reason 06] PTE Read access is not set
> 
> And this patch can fix this.
> 
> 
> The reason you do not get error messages may be there is no ongoing DMA
> request on your PCI devices when kdump kernel boots, I am not sure of
> this.

I think Minfei means he applied this patch, so no error message is got.
The patches he listed includes this one:

0006-x86-iommu-fix-incorrect-bit-operations-in-setting-va.patch

Hi Zhenhua, 

Below is abstracted from Joerg's comments which he and David discussed
and get to this conclusion. So the 1st step is the same as your patches,
how do you think the 2nd step?

	1. If the VT-d driver finds the IOMMU enabled, it reuses its
           root-context table. This way the IOMMU must not be disabled
           and re-enabled, eliminating the race we have now.
           Other data structures like the context-entries are copied
           over from the old kernel.  We basically keep all mappings
           from the old kernel, allowing any in-flight DMA to succeed.
           No memory or disk data corruption.
           The issue here is, that we modify data from the old kernel
           which is about to be dumped. But there are ways to work
           around that.

        2. When a device driver issues the first dma_map command for a
           device, we assign a new and empty page-table, thus removing
           all mappings from the old kernel for the device.
           Rationale is, that at this point the device driver should
           have reset the device to a point where all in-flight DMA is
           canceled.

Thanks
Baoquan

> 
> Zhenhua
> On 11/12/2014 07:28 PM, Minfei Huang wrote:
> >The kdump starts 2nd kernel without any error message when I use
> >3.18.0-rc4 merged last 6 patchs. The following is the message which 2nd
> >kernel prints during booting.
> >
> >Patchset:
> >	0001-iommu-vt-d-Update-iommu_attach_domain-and-its-caller.patch
> >	0002-iommu-vt-d-Items-required-for-kdump.patch
> >	0003-iommu-vt-d-data-types-and-functions-used-for-kdump.patch
> >	0004-iommu-vt-d-Add-domain-id-functions.patch
> >	0005-iommu-vt-d-enable-kdump-support-in-iommu-module.patch
> >	0006-x86-iommu-fix-incorrect-bit-operations-in-setting-va.patch
> >
> >log:
> >[    1.689604] IOMMU intel_iommu_in_crashdump = true
> >[    1.694310] IOMMU Skip disabling iommu hardware translations
> >[    1.699987] DMAR: No ATSR found
> >[    1.703151] IOMMU Copying translate tables from panicked kernel
> >[    1.710786] IOMMU: root_new_virt:0xffff8800296ec000 phys:0x0000296ec000
> >[    1.717401] IOMMU:0 Domain ids from panicked kernel:
> >[    1.722364] DID did:13(0x000d)
> >[    1.725424] DID did:12(0x000c)
> >[    1.728482] DID did:11(0x000b)
> >[    1.731542] DID did:10(0x000a)
> >[    1.734603] DID did:6(0x0006)
> >[    1.737574] DID did:7(0x0007)
> >[    1.740549] DID did:5(0x0005)
> >[    1.743522] DID did:9(0x0009)
> >[    1.746495] DID did:8(0x0008)
> >[    1.749467] DID did:4(0x0004)
> >[    1.752439] DID did:3(0x0003)
> >[    1.755413] DID did:2(0x0002)
> >[    1.758385] DID did:0(0x0000)
> >[    1.761357] DID did:1(0x0001)
> >[    1.764331] ----------------------------------------
> >[    1.769302] IOMMU 0 0xfed50000: using Queued invalidation
> >
> >On 11/05/14 at 03:30pm, Li, Zhen-Hua wrote:
> >>The function context_set_address_root() and set_root_value are setting new
> >>address in a wrong way, and this patch is trying to fix this problem.
> >>
> >>According to Intel Vt-d specs(Feb 2011, Revision 1.3), Chapter 9.1 and 9.2,
> >>field ctp in root entry is using bits 12:63, field asr in context entry is
> >>using bits 12:63.
> >>
> >>To set these fields, the following functions are used:
> >>static inline void context_set_address_root(struct context_entry *context,
> >>         unsigned long value);
> >>and
> >>static inline void set_root_value(struct root_entry *root, unsigned long value)
> >>
> >>But they are using an invalid method to set these fields, in current code, only
> >>a '|' operator is used to set it. This will not set the asr to the expected
> >>value if it has an old value.
> >>
> >>For example:
> >>Before calling this function,
> >>	context->lo = 0x3456789012111;
> >>	value = 0x123456789abcef12;
> >>
> >>After we call context_set_address_root(context, value), expected result is
> >>	context->lo == 0x123456789abce111;
> >>
> >>But the actual result is:
> >>	context->lo == 0x1237577f9bbde111;
> >>
> >>So we need to clear bits 12:63 before setting the new value, this will fix
> >>this problem.
> >>
> >>Signed-off-by: Li, Zhen-Hua <zhen-hual@hp.com>
> >>---
> >>  drivers/iommu/intel-iommu.c | 2 ++
> >>  1 file changed, 2 insertions(+)
> >>
> >>diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
> >>index a27d6cb..11ac47b 100644
> >>--- a/drivers/iommu/intel-iommu.c
> >>+++ b/drivers/iommu/intel-iommu.c
> >>@@ -195,6 +195,7 @@ static inline void set_root_present(struct root_entry *root)
> >>  }
> >>  static inline void set_root_value(struct root_entry *root, unsigned long value)
> >>  {
> >>+	root->val &= ~VTD_PAGE_MASK;
> >>  	root->val |= value & VTD_PAGE_MASK;
> >>  }
> >>
> >>@@ -247,6 +248,7 @@ static inline void context_set_translation_type(struct context_entry *context,
> >>  static inline void context_set_address_root(struct context_entry *context,
> >>  					    unsigned long value)
> >>  {
> >>+	context->lo &= ~VTD_PAGE_MASK;
> >>  	context->lo |= value & VTD_PAGE_MASK;
> >>  }
> >>
> >>--
> >>2.0.0-rc0
> >>
> >>--
> >>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> >>the body of a message to majordomo@vger.kernel.org
> >>More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >>Please read the FAQ at  http://www.tux.org/lkml/
> 
> 
> _______________________________________________
> kexec mailing list
> kexec@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kexec
