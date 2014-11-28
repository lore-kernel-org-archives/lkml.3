Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751291AbaK1KyL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 05:54:11 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54304 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750896AbaK1KyF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 05:54:05 -0500
From: Juergen Gross <jgross@suse.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        konrad.wilk@oracle.com, david.vrabel@citrix.com,
        boris.ostrovsky@oracle.com, x86@kernel.org, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, andrew.cooper3@citrix.com
Cc: Juergen Gross <jgross@suse.com>
Subject: [PATCH V4 00/10] xen: Switch to virtual mapped linear p2m list
Date: Fri, 28 Nov 2014 11:53:49 +0100
Message-Id: <1417172039-8627-1-git-send-email-jgross@suse.com>
X-Mailer: git-send-email 2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paravirtualized kernels running on Xen use a three level tree for
translation of guest specific physical addresses to machine global
addresses. This p2m tree is used for construction of page table
entries, so the p2m tree walk is performance critical.

By using a linear virtual mapped p2m list accesses to p2m elements
can be sped up while even simplifying code. To achieve this goal
some p2m related initializations have to be performed later in the
boot process, as the final p2m list can be set up only after basic
memory management functions are available.

Changes in V4:
- carved out style corrections into new patch 1 as requested by David Vrabel
- minor modification in patch 5 (former patch 3) as suggested by David Vrabel
- carved out change of page allocation scheme from p2m.c into own patch as
  requested by Konrad Wilk, corrected for 32 bit as requested by Andrew Cooper
- added several comments
- simplified error handling in patch 4 (former patch 2)

Changes in V3:
- Carved out (new) patch 1 to make pure code movement more obvious
  as requested by David Vrabel
- New patch 6 introducing __pfn_to_mfn() (taken from patch 7) as
  requested by David Vrabel
- New patch 8 to speed up set_phys_to_machine() as suggested by
  David Vrabel

Changes in V2:
- splitted patch 2 in 4 smaller ones as requested by David Vrabel
- added highmem check when remapping kernel memory as requested by
  David Vrabel


Juergen Gross (10):
  xen: fix some style issues in p2m.c
  xen: Make functions static
  xen: use common page allocation function in p2m.c
  xen: Delay remapping memory of pv-domain
  xen: Delay m2p_override initialization
  xen: Delay invalidating extra memory
  x86: Introduce function to get pmd entry pointer
  xen: Hide get_phys_to_machine() to be able to tune common path
  xen: switch to linear virtual mapped sparse p2m list
  xen: Speed up set_phys_to_machine() by using read-only mappings

 arch/x86/include/asm/pgtable_types.h |    1 +
 arch/x86/include/asm/xen/page.h      |   48 +-
 arch/x86/mm/pageattr.c               |   20 +
 arch/x86/xen/mmu.c                   |   38 +-
 arch/x86/xen/p2m.c                   | 1320 ++++++++++++++--------------------
 arch/x86/xen/setup.c                 |  443 ++++++------
 arch/x86/xen/xen-ops.h               |    6 +-
 7 files changed, 838 insertions(+), 1038 deletions(-)

-- 
2.1.2

