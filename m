Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753503AbbAMTOd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 14:14:33 -0500
Received: from mga11.intel.com ([192.55.52.93]:19418 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752592AbbAMTOb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 14:14:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,750,1413270000"; 
   d="scan'208";a="650565848"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>
Cc: linux-mm@kvack.org, Dave Hansen <dave.hansen@linux.intel.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Pavel Emelyanov <xemul@openvz.org>, linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCH 0/2] Account PMD page tables to the process
Date: Tue, 13 Jan 2015 21:14:14 +0200
Message-Id: <1421176456-21796-1-git-send-email-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 2.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently we don't account PMD page tables to the process. It can lead to
local DoS: unprivileged user can allocate >500 MiB on x86_64 per process
without being noticed by oom-killer or memory cgroup.

Proposed fix adds accounting for PMD table the same way we account for PTE
tables.

There're few corner case in the accounting (see patch 2/2) which have not
well tested yet. If anybody know any other cases we should handle, please
let me know.

Kirill A. Shutemov (2):
  mm: rename mm->nr_ptes to mm->nr_pgtables
  mm: account pmd page tables to the process

 Documentation/sysctl/vm.txt |  2 +-
 arch/x86/mm/pgtable.c       | 13 ++++++++-----
 fs/proc/task_mmu.c          |  2 +-
 include/linux/mm_types.h    |  2 +-
 kernel/fork.c               |  2 +-
 mm/debug.c                  |  4 ++--
 mm/huge_memory.c            | 10 +++++-----
 mm/hugetlb.c                |  8 ++++++--
 mm/memory.c                 |  6 ++++--
 mm/mmap.c                   |  9 +++++++--
 mm/oom_kill.c               |  8 ++++----
 11 files changed, 40 insertions(+), 26 deletions(-)

-- 
2.1.4

