Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752027AbaJ0Gsq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 02:48:46 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45784 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751318AbaJ0Gsn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 02:48:43 -0400
From: Juergen Gross <jgross@suse.com>
To: hpa@zytor.com, x86@kernel.org, tglx@linutronix.de, mingo@redhat.com,
        stefan.bader@canonical.com, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com, konrad.wilk@oracle.com,
        ville.syrjala@linux.intel.com, david.vrabel@citrix.com,
        jbeulich@suse.com, toshi.kani@hp.com
Cc: Juergen Gross <jgross@suse.com>
Subject: [PATCH V4 0/3] x86: Full support of PAT
Date: Mon, 27 Oct 2014 07:48:30 +0100
Message-Id: <1414392513-24645-1-git-send-email-jgross@suse.com>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The x86 architecture offers via the PAT (Page Attribute Table) a way to
specify different caching modes in page table entries. The PAT MSR contains
8 entries each specifying one of 6 possible cache modes. A pte references one
of those entries via 3 bits: _PAGE_PAT, _PAGE_PWT and _PAGE_PCD.

The Linux kernel currently supports only 4 different cache modes. The PAT MSR
is set up in a way that the setting of _PAGE_PAT in a pte doesn't matter: the
top 4 entries in the PAT MSR are the same as the 4 lower entries.

This results in the kernel not supporting e.g. write-through mode. Especially
this cache mode would speed up drivers of video cards which now have to use
uncached accesses.

OTOH some old processors (Pentium) don't support PAT correctly and the Xen
hypervisor has been using a different PAT MSR configuration for some time now
and can't change that as this setting is part of the ABI.

This patch set abstracts the cache mode from the pte and introduces tables to
translate between cache mode and pte bits (the default cache mode "write back"
is hard-wired to PAT entry 0). The tables are statically initialized with
values being compatible to old processors and current usage. As soon as the
PAT MSR is changed (or - in case of Xen - is read at boot time) the tables are
changed accordingly. Requests of mappings with special cache modes are always
possible now, in case they are not supported there will be a fallback to a
compatible but slower mode.

Summing it up, this patch set adds the following features:
- capability to support WT and WP cache modes on processors with full PAT
  support
- processors with no or uncorrect PAT support are still working as today, even
  if WT or WP cache mode are selected by drivers for some pages
- reduction of Xen special handling regarding cache mode

Changes in V4:
- rebased to 3.18-rc2

Changes in V3:
- corrected two minor nits (UC_MINUS, again) detected by Toshi Kani

Changes in V2:
- simplified handling of PAT MSR write under Xen as suggested by David Vrabel
- removed resetting of pat_enabled under Xen
- two small corrections requested by Toshi Kani (UC_MINUS cache mode in
  vermilion driver, fix 32 bit kernel build failure)
- correct build error on non-x86 arch by moving definition of
  update_cache_mode_entry() to x86 specific header

Changes since RFC:
- renamed functions and variables as suggested by Toshi Kani
- corrected cache mode bits for WT and WP
- modified handling of PAT MSR write under Xen as suggested by Jan Beulich


Juergen Gross (3):
  x86: Make page cache mode a real type
  x86: Enable PAT to use cache mode translation tables
  Support Xen pv-domains using PAT

 arch/x86/include/asm/cacheflush.h         |  38 ++++---
 arch/x86/include/asm/fb.h                 |   6 +-
 arch/x86/include/asm/io.h                 |   2 +-
 arch/x86/include/asm/pat.h                |   7 +-
 arch/x86/include/asm/pgtable.h            |  19 ++--
 arch/x86/include/asm/pgtable_types.h      |  96 ++++++++++++----
 arch/x86/mm/dump_pagetables.c             |  24 ++--
 arch/x86/mm/init.c                        |  37 ++++++
 arch/x86/mm/init_64.c                     |   9 +-
 arch/x86/mm/iomap_32.c                    |  15 ++-
 arch/x86/mm/ioremap.c                     |  63 ++++++-----
 arch/x86/mm/mm_internal.h                 |   2 +
 arch/x86/mm/pageattr.c                    |  84 ++++++++------
 arch/x86/mm/pat.c                         | 181 +++++++++++++++++++-----------
 arch/x86/mm/pat_internal.h                |  22 ++--
 arch/x86/mm/pat_rbtree.c                  |   8 +-
 arch/x86/pci/i386.c                       |   4 +-
 arch/x86/xen/enlighten.c                  |  25 ++---
 arch/x86/xen/mmu.c                        |  47 +-------
 arch/x86/xen/xen-ops.h                    |   1 -
 drivers/video/fbdev/gbefb.c               |   3 +-
 drivers/video/fbdev/vermilion/vermilion.c |   6 +-
 22 files changed, 420 insertions(+), 279 deletions(-)

-- 
1.8.4.5

