Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755267AbaCLQf4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 12:35:56 -0400
Received: from g4t3426.houston.hp.com ([15.201.208.54]:4270 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754676AbaCLQfy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 12:35:54 -0400
From: "Sumner, William" <bill.sumner@hp.com>
To: Vivek Goyal <vgoyal@redhat.com>
CC: "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "indou.takao@jp.fujitsu.com" <indou.takao@jp.fujitsu.com>,
        "bhe@redhat.com" <bhe@redhat.com>, "joro@8bytes.org" <joro@8bytes.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "ddutile@redhat.com" <ddutile@redhat.com>,
        "Hatch, Douglas B (HPS Linux PM)" <doug.hatch@hp.com>,
        "ishii.hironobu@jp.fujitsu.com" <ishii.hironobu@jp.fujitsu.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "Li, Zhen-Hua" <zhen-hual@hp.com>
Subject: FW: Re: [PATCHv3 0/6] Crashdump Accepting Active IOMMU
Thread-Topic: Re: [PATCHv3 0/6] Crashdump Accepting Active IOMMU
Thread-Index: Ac89hzbzJ+BiZSAzTl2jFYUS34D2PQAiX3UQ
Date: Wed, 12 Mar 2014 16:34:18 +0000
Message-ID: <875D89B79D1D86448A583A7302C022A066E093DB@G4W3212.americas.hpqcorp.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [16.210.48.21]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Resending as plain-text.
Bill

From: Sumner, William 
Sent: Wednesday, March 12, 2014 11:15 AM
To: 'Vivek Goyal'
Cc: dwmw2@infradead.org; indou.takao@jp.fujitsu.com; bhe@redhat.com; joro@8bytes.org; linux-pci@vger.kernel.org; kexec@lists.infradead.org; alex.williamson@redhat.com; linux-kernel@vger.kernel.org; iommu@lists.linux-foundation.org; ddutile@redhat.com; Hatch, Douglas B (HPS Linux PM); ishii.hironobu@jp.fujitsu.com; bhelgaas@google.com; Li, Zhen-Hua
Subject: Re: [PATCHv3 0/6] Crashdump Accepting Active IOMMU

On Mon, Mar 10, 2014 at 04:43PM, Vivek Goyal wrote:
>On Fri, Jan 10, 2014 at 03:07:26PM -0700, Bill Sumner wrote:
>
>[..]
>> This patch set modifies the behavior of the iommu in the (new) crashdump kernel:
>> 1. to accept the iommu hardware in an active state, 2. to leave the
>> current translations in-place so that legacy DMA will continue
>>    using its current buffers until the device drivers in the crashdump kernel>>    initialize and initialize their devices, 3. to use different
>> portions of the iova address ranges for the device drivers
>>    in the crashdump kernel than the iova ranges that were in-use at the time
>>    of the panic.
>
>Conceptually, above makes sense to me. I have few queries.
>
>- Do we need to pass any kind of data from first kernel to second kernel,
>  like table size etc? Calgary IOMMU was using first kernel's tables
>  also and it was determining previous kernel's table size using saved_max_pfn.

Yes. We need to pass the intel-iommu translation tables from the first kernel to the second kernel - well, to allow the second kernel to read them.  Only the tree of tables that the intel-iommu hardware references are needed: the root-entry table, the context-entry tables, and the page-translation tables.  This patch involves only the intel-iommu -- and none of the other iommu hardware types.

During the early initialization of the new kdump kernel this patch copies (duplicates) the tree of iommu translation tables from the old kernel into the new kernel.  These tables are all linked together as a tree by physical memory addresses. The physical address of the top of the tree -- the root-entry table -- is obtained from a register in the iommu hardware. The copy operation traverses the tree in depth-first order, sanity-checking each table and then duplicating it into the kernel address space of the new kernel, linking the new tables appropriately.  If the copy succeeds then the iommu register is updated to point to the copy in the new kernel and the iommu continues translating DMA requests from IO devices.  If a sanity-check fails, the patch currently errors-out of the dump (might want to revisit this error case and see if there is something better to do.)

By copying the tables into the new kernel, all of the existing code in intel-iommu.c continues to work nearly unchanged, with only a few added initializations of fields when kdump is active and when intel-iommu.c creates its "bookkeeping" structures for the device -- to make sure they correspond to the contents of the translate tables. I made a determined effort to avoid changing the existing execution path for the non-kdump case, and to minimize the changes even when kdump is active.  

Note also that this leaves the copy of the translate tables in the old panicked kernel unused and unchanged during the operation of 'makedumpfile', so they appear correctly in the dump as they were at the time of the panic.

>
>- I don't know how IOMMU translation tables look like, but are new DMA
>  zones setup by drivers in second kernel part of same table?

Yes. The copied translation tables in the kdump kernel contain both the translations that were active at the time of the dump (which will never go away until the dump is finished and the platform is rebooted), plus any translations needed by the kdump kernel (which come and go as necessary).  As the "bookkeeping" structures are created in the new kernel (typically the first time that a device requests a translation for a buffer) they are initialized such that all IOVAs that already exist in the translate tables for tht device are marked as "not available for allocation" so all requests by device drivers in the new kernel receive IOVAs that were not in-use at the time of the panic.

> How do we
>  make sure that sufficient space is available.

So far I have not seen any problem with running out of space because of this copy;  however, I believe that this may be a valid concern with very large IO configurations -- and it deserves some attention as the community reviews and tests this patch.

> I am not sure if possible
>  table corruption from crashed kernel is an issue here or not.

Any corrupted translation tables from the crashed kernel would be a problem that would prevent using copies of them. I hope and expect that this happens rarely -- and that we would catch it during the copy when it does.

Fortunately, these tables are only manipulated by the code in intel-iommu.c - which limits the amount of code that has to be "right".  Of course, there is always the possibility that other code in the kernel could "hose" one of these tables -- so we need to sanity-check the tables before the new kernel uses them.

>
>In general, I think changelogs of these patches need to be little better.
>There seem to be lot of text and still I can't quickly wrap my head around what a particular patch is supposed to be doing.

I will work on the changelogs as I re-arrange the code and the structure of the patch-set for the next submitted version.

>
>But we definitely need to fix this issue. IOMMU issues with kdump have been troubling us for a very long time.
Strongly agree.

-- Bill
