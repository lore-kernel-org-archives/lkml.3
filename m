Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753745AbaEHMll (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 08:41:41 -0400
Received: from mga03.intel.com ([143.182.124.21]:51835 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751641AbaEHMlj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 08:41:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1010,1389772800"; 
   d="scan'208";a="429429585"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, peterz@infradead.org,
        mingo@kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCH 1/2] mm: mark remap_file_pages() syscall as deprecated
Date: Thu,  8 May 2014 15:41:27 +0300
Message-Id: <1399552888-11024-2-git-send-email-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <1399552888-11024-1-git-send-email-kirill.shutemov@linux.intel.com>
References: <1399552888-11024-1-git-send-email-kirill.shutemov@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The remap_file_pages() system call is used to create a nonlinear mapping,
that is, a mapping in which the pages of the file are mapped into a
nonsequential order in memory. The advantage of using remap_file_pages()
over using repeated calls to mmap(2) is that the former approach does not
require the kernel to create additional VMA (Virtual Memory Area) data
structures.

Supporting of nonlinear mapping requires significant amount of non-trivial
code in kernel virtual memory subsystem including hot paths. Also to get
nonlinear mapping work kernel need a way to distinguish normal page table
entries from entries with file offset (pte_file). Kernel reserves flag in
PTE for this purpose. PTE flags are scarce resource especially on some CPU
architectures. It would be nice to free up the flag for other usage.

Fortunately, there are not many users of remap_file_pages() in the wild.
It's only known that one enterprise RDBMS implementation uses the syscall
on 32-bit systems to map files bigger than can linearly fit into 32-bit
virtual address space. This use-case is not critical anymore since 64-bit
systems are widely available.

The plan is to deprecate the syscall and replace it with an emulation.
The emulation will create new VMAs instead of nonlinear mappings. It's
going to work slower for rare users of remap_file_pages() but ABI is
preserved.

One side effect of emulation (apart from performance) is that user can hit
vm.max_map_count limit more easily due to additional VMAs. See comment for
DEFAULT_MAX_MAP_COUNT for more details on the limit.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 Documentation/vm/remap_file_pages.txt | 28 ++++++++++++++++++++++++++++
 mm/fremap.c                           |  4 ++++
 2 files changed, 32 insertions(+)
 create mode 100644 Documentation/vm/remap_file_pages.txt

diff --git a/Documentation/vm/remap_file_pages.txt b/Documentation/vm/remap_file_pages.txt
new file mode 100644
index 000000000000..560e4363a55d
--- /dev/null
+++ b/Documentation/vm/remap_file_pages.txt
@@ -0,0 +1,28 @@
+The remap_file_pages() system call is used to create a nonlinear mapping,
+that is, a mapping in which the pages of the file are mapped into a
+nonsequential order in memory. The advantage of using remap_file_pages()
+over using repeated calls to mmap(2) is that the former approach does not
+require the kernel to create additional VMA (Virtual Memory Area) data
+structures.
+
+Supporting of nonlinear mapping requires significant amount of non-trivial
+code in kernel virtual memory subsystem including hot paths. Also to get
+nonlinear mapping work kernel need a way to distinguish normal page table
+entries from entries with file offset (pte_file). Kernel reserves flag in
+PTE for this purpose. PTE flags are scarce resource especially on some CPU
+architectures. It would be nice to free up the flag for other usage.
+
+Fortunately, there are not many users of remap_file_pages() in the wild.
+It's only known that one enterprise RDBMS implementation uses the syscall
+on 32-bit systems to map files bigger than can linearly fit into 32-bit
+virtual address space. This use-case is not critical anymore since 64-bit
+systems are widely available.
+
+The plan is to deprecate the syscall and replace it with an emulation.
+The emulation will create new VMAs instead of nonlinear mappings. It's
+going to work slower for rare users of remap_file_pages() but ABI is
+preserved.
+
+One side effect of emulation (apart from performance) is that user can hit
+vm.max_map_count limit more easily due to additional VMAs. See comment for
+DEFAULT_MAX_MAP_COUNT for more details on the limit.
diff --git a/mm/fremap.c b/mm/fremap.c
index 34feba60a17e..12c3bb63b7f9 100644
--- a/mm/fremap.c
+++ b/mm/fremap.c
@@ -152,6 +152,10 @@ SYSCALL_DEFINE5(remap_file_pages, unsigned long, start, unsigned long, size,
 	int has_write_lock = 0;
 	vm_flags_t vm_flags = 0;
 
+	pr_warn_once("%s (%d) uses depricated remap_file_pages() syscall. "
+			"See Documentation/vm/remap_file_pages.txt.\n",
+			current->comm, current->pid);
+
 	if (prot)
 		return err;
 	/*
-- 
2.0.0.rc2

