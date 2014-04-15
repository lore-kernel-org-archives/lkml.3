Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754272AbaDOOQK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 10:16:10 -0400
Received: from smtp.citrix.com ([66.165.176.89]:58075 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750998AbaDOOQG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 10:16:06 -0400
X-IronPort-AV: E=Sophos;i="4.97,864,1389744000"; 
   d="scan'208";a="121257946"
From: David Vrabel <david.vrabel@citrix.com>
To: <xen-devel@lists.xenproject.org>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>, <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, "Ingo Molnar" <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, <x86@kernel.org>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCHv6 0/9] x86/xen: fixes for mapping high MMIO regions (and remove _PAGE_IOMAP)
Date: Tue, 15 Apr 2014 15:15:28 +0100
Message-ID: <1397571337-20409-1-git-send-email-david.vrabel@citrix.com>
X-Mailer: git-send-email 1.7.2.5
MIME-Version: 1.0
Content-Type: text/plain
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This a fix for the problems with mapping high MMIO regions in certain
cases (e.g., the RDMA drivers) as not all mappers were specifing
_PAGE_IOMAP which meant no valid MFN could be found and the resulting
PTEs would be set as not present, causing subsequent faults.

It assumes that anything that isn't RAM (whether ballooned out or not)
is an I/O region and thus should be 1:1 in the p2m.  Specifically, the
region after the end of the E820 map and the region beyond the end of
the p2m.  Ballooned frames are still marked as missing in the p2m as
before.

As a follow on, pte_mfn_to_pfn() and pte_pfn_to_mfn() are modified to
not use the _PAGE_IOMAP PTE flag and MFN to PFN and PFN to MFN
translations will now do the right thing for all I/O regions.  This
means the Xen-specific _PAGE_IOMAP can be removed,

This series has been tested (in dom0) on all unique machines we have
in out test lab (~100 machines), some of which have PCI devices with
BARs above the end of RAM.

Note this does not fix a 32-bit dom0 trying to access BARs above 16 TB
as this is a caused by MFNs/PFNs being limited to 32-bits (unsigned
long).

You may find it useful to apply patch #3 to more easily review the
updated p2m diagram.

Changes in v6:
- don't oops in spurious_fault() after faulting on an M2P access.
  This fixes an oops when userspace unmaps an I/O regions in certain
  cases.

Changes in v5:
- improve performance of set_phys_range_identity() by not iterating
  over all pages if p2m_mid_identity or p2m_identity mid or leaves are
  already present. (Thanks to Andrew Cooper for reporting this and
  Frediano Ziglio for providing a fix.)

Changes in v4:
- fix p2m_mid_identity initialization.

Changes in v3 (not posted):
- use correct end of e820
- fix xen_remap_domain_mfn_range()

Changes in v2:
- fix to actually set end-of-RAM to 512 GiB region as 1:1.
- introduce p2m_mid_identity to efficiently store large 1:1 regions.
- Split the _PAGE_IOMAP patch into Xen and generic x86 halves.

David

