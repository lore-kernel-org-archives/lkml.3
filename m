Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751153Ab3KUF3g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 00:29:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44954 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750724Ab3KUF3f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 00:29:35 -0500
Date: Thu, 21 Nov 2013 13:28:37 +0800
From: Baoquan He <bhe@redhat.com>
To: "Sumner, William" <bill.sumner@hp.com>
Cc: Takao Indoh <indou.takao@jp.fujitsu.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "ddutile@redhat.com" <ddutile@redhat.com>,
        "ishii.hironobu@jp.fujitsu.com" <ishii.hironobu@jp.fujitsu.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>
Subject: Re: [RFC PATCH] Crashdump Accepting Active IOMMU
Message-ID: <20131121052837.GB9199@dhcp-16-252.nay.redhat.com>
References: <875D89B79D1D86448A583A7302C022A055A67790@G9W0337.americas.hpqcorp.net>
 <5281CE7C.6080105@jp.fujitsu.com>
 <875D89B79D1D86448A583A7302C022A055A8A530@G4W3299.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <875D89B79D1D86448A583A7302C022A055A8A530@G4W3299.americas.hpqcorp.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bill,

I have tested this prototype patch on hp z420, it works very well.
Looking forward to your formal patch set. I can help test and review.

Baoquan
Thanks

On 11/18/13 at 11:30pm, Sumner, William wrote:
> Thank you for testing this RFC patch.  It is great to have confirmation that the code works in a different test environment.
> 
> You asked: "What is the status of this patch?"
> I have made a few changes since the RFC version of this patch:
> 
> 1. Consolidated all of the operational code into the "copy..." functions.  The "process..." functions were primarily used for diagnostics and exploration; however, there was a small amount of operational code that used the "process..." functions. This operational code has been moved into the "copy..." functions.
> 
> 2. Removed the "Process ..." functions and the diagnostic code that ran on that function set.  This removed about 1/4 of the code -- which this operational patch no longer needs.  These portions of the RFC patch could be formatted as a separate patch and submitted independently at a later date.
> 
> 3. Re-formatted the code to the Linux Coding Standards.  The checkpatch script still finds some lines to complain about; however these lines are either (1) lines that I did not change, or (2) lines that only changed by adding a level of indent which pushed them over 80-characters, or (3) new lines whose intent is far clearer when longer than 80-characters (allowed by the Linux Coding Standards.)
> 
> 4. Updated the remaining debug print to be significantly more flexible.  This allows control over the amount of debug print to the console -- which can vary widely.
> 
> 5. Fixed a couple of minor bugs found by testing on a machine with a very large IO configuration.
> 
> 
> You asked: " Do you have a plan to post new version?"
> Yes.  I am in the process of dividing the code into a set of 6 or 7 patches, and completing the due-diligence on these patches before submitting them.
> 
> Bill
> 
> -----Original Message-----
> From: Takao Indoh [mailto:indou.takao@jp.fujitsu.com]
> Sent: Tuesday, November 12, 2013 12:45 AM
> To: Sumner, William; bhelgaas@google.com; alex.williamson@redhat.com; ddutile@redhat.com
> Cc: linux-pci@vger.kernel.org; kexec@lists.infradead.org; linux-kernel@vger.kernel.org; iommu@lists.linux-foundation.org; ishii.hironobu@jp.fujitsu.com; dwmw2@infradead.org
> Subject: Re: [RFC PATCH] Crashdump Accepting Active IOMMU
> 
> Hi Bill,
> 
> What is the status of this patch? It works and DMA problems on kdump are
> solved as far as I tested. Do you have a plan to post new version?
> 
> Thanks,
> Takao Indoh
> 
> (2013/09/27 8:25), Sumner, William wrote:
> > This Request For Comment submission is primarily to solicit comments on a concept for how kdump can handle legacy DMA IO leftover from the panicked kernel and comments on early prototype code to implement it.  Some level of interest was noted when I proposed this concept in June; however, for generating serious discussion there is no substitute for a working prototype.
> >
> > This concept modifies the behavior of the iommu in the (new) crashdump kernel:
> > 1. to accept the iommu hardware in an active state,
> > 2. to leave the current translations in-place so that legacy DMA will continue using its current buffers until the device drivers in the crashdump kernel initialize and initialize their devices,
> > 3. to use different portions of the iova address ranges for the device drivers in the crashdump kernel than the iova ranges that were in-use at the time of the panic.
> >
> > Advantages of this concept:
> > 1. All manipulation of the IO-device is done by the Linux device-driver for that device.
> > 2. This concept behaves in a very similar manner to operation without an active iommu.
> > 3. Any activity between the IO-device and its RMRR areas is handled by the device-driver in the same manner as during a non-kdump boot.
> > 4. If an IO-device has no driver in the kdump kernel, it is simply left alone.  This supports the practice of creating a special kdump kernel without drivers for any devices that are not required for taking a crashdump.
> >
> >
> >
> > About the early-prototype code in the patch below:
> > --------------------------------------------------
> > 1. It works on one machine that reproduced the original problem -- still need to test it on a lot of other machines with various IO configurations.
> >
> > 2. Currently implemented for intel-iommu architecture only,
> >
> > 3. It is based near TOT from kernel.org.  The TOT version of 'crash' reads the dump that is produced.
> >
> > 4. It is definitely prototype-only and not yet ready to propose as a patch for inclusion into Linux proper.
> >
> > 5. Although this patch is not yet intended for incorporation into mainstream Linux, it should install and operate for anyone who wants to experiment with it.  Because this patch changes the low-level IO-operation, and because of its very-limited testing, I strongly advise against installing this patch on any system that contains production data.
> >
> > 6. For this RFC, I decided to leave-in all of the debugging, diagnostic, temporary, and test code so that it would be readily available.  In a (future) patch submission, much of this would need to be either eliminated, separated into a diagnostics area, moved under conditional compilation, or something else.  We'll see what the Linux community recommends.
> >
> >
> >
> > At a high level, this code:
> > ===========================
> > * is entirely within intel-iommu.c
> > * operates primarily during iommu initialization and device-driver initialization
> >
> > During intel-iommu hardware initialization:
> > -------------------------------------------
> > In intel_iommu_init(void)
> > * If (This is the crash kernel)
> >    .  Set flag: crashdump_accepting_active_iommu (all changes below check this)
> >    .  Skip disabling the iommu hardware translations
> >
> > In init_dmars()
> > * Duplicate the intel iommu translation tables from the old kernel in the new kernel
> >    . The root-entry table, all context-entry tables, and all page-translation-entry tables
> >    . The duplicate tables contain updated physical addresses to link them together.
> >    . The duplicate tables are mapped into kernel virtual addresses in the new kernel
> >      which allows most of the existing iommu code to operate without change.
> >    . Do some minimal sanity-checks during the copy
> >    . Place the address of the new root-entry structure into "struct intel_iommu"
> >
> > * Skip setting-up new domains for 'si', 'rmrr', 'isa'
> >    . Translations for 'rmrr' and 'isa' ranges have been copied from the old kernel
> >    . This prototype does not yet handle pass-through
> >
> > * Existing (unchanged) code near the end of dmar_init:
> >    . Loads the address of the (now new) root-entry structure from "struct intel_iommu"
> >      into the iommu hardware and does the iommu hardware flushes. This changes the
> >      active translation tables from the ones in the old kernel to the copies in the new kernel.
> >    . This is legal because the translations in the two sets of tables are currently identical:
> >        Intel(r) Virtualization Technology for Directed I/O. Architecture Specification,
> >        February 2011, Rev. 1.3  (section 11.2, paragraph 2)
> >
> > In iommu_init_domains()
> > * Mark as in-use all domain-id's from the old kernel
> >    . In case the new kernel contains a device that was not in the old kernel
> >      and a new, unused domain-id is actually needed, the bitmap will give us one.
> >
> > When a new domain is created for a device:
> > ------------------------------------------
> > * If (this device has a context in the old kernel)
> >    . Get domain-id, address-width, and IOVA ranges from the old kernel context;
> >    . Get address(page-entry-tables) from the copy in the new kernel;
> >    . And apply all of the above values to the new domain structure.
> > * Else
> >    . Create a new domain as normal
> >
> > I would very much like the advice of the Linux community on how to proceed.
> >
> > Signed-off-by: Bill Sumner <bill.sumner@hp.com>
> >
> > Bill
> >
> >
> >
> >>From c1c6102f2a82e9450c6e3ea76f250bb35e6b1992 Mon Sep 17 00:00:00 2001
> > From: Bill <bill.sumner@hp.com>
> > Date: Thu, 26 Sep 2013 15:37:48 -0600
> > Subject: [PATCH] rfc-crashdump-accepting-active-iommu.patch
> 
> <<< NOTE: I deleted the code of my RFC patch from this email reply in order to shorten the email thread -- leaving only the original email header to make it easy to find the code in previous posts. -- Bill (Nov. 18, 2013) >>>
> 
> 
> 
> _______________________________________________
> kexec mailing list
> kexec@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kexec
