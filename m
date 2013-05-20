Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756574Ab3ETLBz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 07:01:55 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56341 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756503Ab3ETKxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 06:53:46 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Steven Truelove <steven.truelove@utoronto.ca>,
        Jianguo Wu <wujianguo@huawei.com>, Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 081/115] hugetlbfs: fix mmap failure in unaligned size request
Date: Mon, 20 May 2013 11:51:21 +0100
Message-Id: <1369047116-9378-82-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369047116-9378-1-git-send-email-luis.henriques@canonical.com>
References: <1369047116-9378-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jianguo Wu <wujianguo@huawei.com>

commit af73e4d9506d3b797509f3c030e7dcd554f7d9c4 upstream.

The current kernel returns -EINVAL unless a given mmap length is
"almost" hugepage aligned.  This is because in sys_mmap_pgoff() the
given length is passed to vm_mmap_pgoff() as it is without being aligned
with hugepage boundary.

This is a regression introduced in commit 40716e29243d ("hugetlbfs: fix
alignment of huge page requests"), where alignment code is pushed into
hugetlb_file_setup() and the variable len in caller side is not changed.

To fix this, this patch partially reverts that commit, and adds
alignment code in caller side.  And it also introduces hstate_sizelog()
in order to get proper hstate to specified hugepage size.

Addresses https://bugzilla.kernel.org/show_bug.cgi?id=56881

[akpm@linux-foundation.org: fix warning when CONFIG_HUGETLB_PAGE=n]
Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reported-by: <iceman_dvd@yahoo.com>
Cc: Steven Truelove <steven.truelove@utoronto.ca>
Cc: Jianguo Wu <wujianguo@huawei.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[ wujianguo: remove hstate_sizelog(), as 3.4 only support default
  hugepagesize for MAP_HUGETLB/SHM_HUGETLB. ]
Signed-off-by: Jianguo Wu <wujianguo@huawei.com>
Signed-off-by: Luis Henriques<luis.henriques@canonical.com>
---
 fs/hugetlbfs/inode.c    | 20 ++++++++++----------
 include/linux/hugetlb.h |  9 ++++-----
 ipc/shm.c               |  4 +++-
 mm/mmap.c               |  6 +++++-
 4 files changed, 22 insertions(+), 17 deletions(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index cc9281b..c24fe37 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -927,9 +927,13 @@ static int can_do_hugetlb_shm(void)
 	return capable(CAP_IPC_LOCK) || in_group_p(sysctl_hugetlb_shm_group);
 }
 
-struct file *hugetlb_file_setup(const char *name, unsigned long addr,
-				size_t size, vm_flags_t acctflag,
-				struct user_struct **user, int creat_flags)
+/*
+ * Note that size should be aligned to proper hugepage size in caller side,
+ * otherwise hugetlb_reserve_pages reserves one less hugepages than intended.
+ */
+struct file *hugetlb_file_setup(const char *name, size_t size,
+				vm_flags_t acctflag, struct user_struct **user,
+				int creat_flags)
 {
 	int error = -ENOMEM;
 	struct file *file;
@@ -937,8 +941,6 @@ struct file *hugetlb_file_setup(const char *name, unsigned long addr,
 	struct path path;
 	struct dentry *root;
 	struct qstr quick_string;
-	struct hstate *hstate;
-	unsigned long num_pages;
 
 	*user = NULL;
 	if (!hugetlbfs_vfsmount)
@@ -972,12 +974,10 @@ struct file *hugetlb_file_setup(const char *name, unsigned long addr,
 	if (!inode)
 		goto out_dentry;
 
-	hstate = hstate_inode(inode);
-	size += addr & ~huge_page_mask(hstate);
-	num_pages = ALIGN(size, huge_page_size(hstate)) >>
-			huge_page_shift(hstate);
 	error = -ENOMEM;
-	if (hugetlb_reserve_pages(inode, 0, num_pages, NULL, acctflag))
+	if (hugetlb_reserve_pages(inode, 0,
+			size >> huge_page_shift(hstate_inode(inode)), NULL,
+			acctflag))
 		goto out_inode;
 
 	d_instantiate(path.dentry, inode);
diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index d5d6bbe..b8cdad6 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -152,8 +152,7 @@ static inline struct hugetlbfs_sb_info *HUGETLBFS_SB(struct super_block *sb)
 
 extern const struct file_operations hugetlbfs_file_operations;
 extern const struct vm_operations_struct hugetlb_vm_ops;
-struct file *hugetlb_file_setup(const char *name, unsigned long addr,
-				size_t size, vm_flags_t acct,
+struct file *hugetlb_file_setup(const char *name, size_t size, vm_flags_t acct,
 				struct user_struct **user, int creat_flags);
 
 static inline int is_file_hugepages(struct file *file)
@@ -170,8 +169,8 @@ static inline int is_file_hugepages(struct file *file)
 
 #define is_file_hugepages(file)			0
 static inline struct file *
-hugetlb_file_setup(const char *name, unsigned long addr, size_t size,
-		vm_flags_t acctflag, struct user_struct **user, int creat_flags)
+hugetlb_file_setup(const char *name, size_t size, vm_flags_t acctflag,
+		struct user_struct **user, int creat_flags)
 {
 	return ERR_PTR(-ENOSYS);
 }
@@ -302,7 +301,7 @@ static inline unsigned hstate_index_to_shift(unsigned index)
 	return hstates[index].order + PAGE_SHIFT;
 }
 
-#else
+#else	/* CONFIG_HUGETLB_PAGE */
 struct hstate {};
 #define alloc_huge_page_node(h, nid) NULL
 #define alloc_bootmem_huge_page(h) NULL
diff --git a/ipc/shm.c b/ipc/shm.c
index f5ba6ac..54e17db 100644
--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -491,10 +491,12 @@ static int newseg(struct ipc_namespace *ns, struct ipc_params *params)
 
 	sprintf (name, "SYSV%08x", key);
 	if (shmflg & SHM_HUGETLB) {
+		size_t hugesize = ALIGN(size, huge_page_size(&default_hstate));
+
 		/* hugetlb_file_setup applies strict accounting */
 		if (shmflg & SHM_NORESERVE)
 			acctflag = VM_NORESERVE;
-		file = hugetlb_file_setup(name, 0, size, acctflag,
+		file = hugetlb_file_setup(name, hugesize, acctflag,
 					&shp->mlock_user, HUGETLB_SHMFS_INODE);
 	} else {
 		/*
diff --git a/mm/mmap.c b/mm/mmap.c
index 76b70c9..f1a9a72 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1116,15 +1116,19 @@ SYSCALL_DEFINE6(mmap_pgoff, unsigned long, addr, unsigned long, len,
 		file = fget(fd);
 		if (!file)
 			goto out;
+		if (is_file_hugepages(file))
+			len = ALIGN(len, huge_page_size(hstate_file(file)));
 	} else if (flags & MAP_HUGETLB) {
 		struct user_struct *user = NULL;
+
+		len = ALIGN(len, huge_page_size(&default_hstate));
 		/*
 		 * VM_NORESERVE is used because the reservations will be
 		 * taken when vm_ops->mmap() is called
 		 * A dummy user value is used because we are not locking
 		 * memory so no accounting is necessary
 		 */
-		file = hugetlb_file_setup(HUGETLB_ANON_FILE, addr, len,
+		file = hugetlb_file_setup(HUGETLB_ANON_FILE, len,
 						VM_NORESERVE, &user,
 						HUGETLB_ANONHUGE_INODE);
 		if (IS_ERR(file))
-- 
1.8.1.2

