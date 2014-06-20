Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751431AbaFTUMG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 16:12:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753755AbaFTUME (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 16:12:04 -0400
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave.hansen@intel.com>, Hugh Dickins <hughd@google.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        linux-kernel@vger.kernel.org,
        Naoya Horiguchi <nao.horiguchi@gmail.com>
Subject: [PATCH v3 00/13] pagewalk: improve vma handling, apply to new users
Date: Fri, 20 Jun 2014 16:11:26 -0400
Message-Id: <1403295099-6407-1-git-send-email-n-horiguchi@ah.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series is ver.3 of page table walker patchset.
In previous discussion I got an objection of moving pte handling code to
->pte_entry() callback, so in this version I've dropped all of such code.

The patchset mainly does fixing vma handling and applying page walker to
2 new users. Here is a brief overview:
  patch 1: clean up
  patch 2: fix bug-prone vma handling code
  patch 3: add another interface of page walker
  patch 4-10: clean up each of existing user
  patch 11: apply page walker to new user queue_pages_range()
  patch 12: allow clear_refs_pte_range() to handle thp (from Kirill)
  patch 13: apply page walker to new user do_mincore()

Thanks,
Naoya Horiguchi

Tree: git@github.com:Naoya-Horiguchi/linux.git
Branch: v3.16-rc1/page_table_walker.ver3
---
Summary:

Kirill A. Shutemov (1):
      mm: /proc/pid/clear_refs: avoid split_huge_page()

Naoya Horiguchi (12):
      mm/pagewalk: remove pgd_entry() and pud_entry()
      pagewalk: improve vma handling
      pagewalk: add walk_page_vma()
      smaps: remove mem_size_stats->vma and use walk_page_vma()
      clear_refs: remove clear_refs_private->vma and introduce clear_refs_test_walk()
      pagemap: use walk->vma instead of calling find_vma()
      numa_maps: remove numa_maps->vma
      numa_maps: fix typo in gather_hugetbl_stats
      memcg: apply walk_page_vma()
      arch/powerpc/mm/subpage-prot.c: use walk->vma and walk_page_vma()
      mempolicy: apply page table walker on queue_pages_range()
      mincore: apply page table walker on do_mincore()

 arch/powerpc/mm/subpage-prot.c |   6 +-
 fs/proc/task_mmu.c             | 143 ++++++++++++++++----------
 include/linux/mm.h             |  22 ++--
 mm/huge_memory.c               |  20 ----
 mm/memcontrol.c                |  36 +++----
 mm/mempolicy.c                 | 228 +++++++++++++++++------------------------
 mm/mincore.c                   | 174 ++++++++++++-------------------
 mm/pagewalk.c                  | 223 ++++++++++++++++++++++++----------------
 8 files changed, 406 insertions(+), 446 deletions(-)
