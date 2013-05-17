Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932749Ab3EQV7w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 17:59:52 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54612 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932364Ab3EQVr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 17:47:56 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Johannes Weiner <hannes@cmpxchg.org>, iceman_dvd@yahoo.com,
        Steven Truelove <steven.truelove@utoronto.ca>,
        Jianguo Wu <wujianguo@huawei.com>, Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 41/50] hugetlbfs: fix mmap failure in unaligned size request
Date: Fri, 17 May 2013 14:47:16 -0700
Message-Id: <20130517213846.996682223@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130517213842.447809965@linuxfoundation.org>
References: <20130517213842.447809965@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>

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
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Jianguo Wu <wujianguo@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/hugetlbfs/inode.c    |   20 ++++++++++----------
 include/linux/hugetlb.h |    9 ++++-----
 ipc/shm.c               |    4 +++-
 mm/mmap.c               |    6 +++++-
 4 files changed, 22 insertions(+), 17 deletions(-)

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
@@ -937,8 +941,6 @@ struct file *hugetlb_file_setup(const ch
 	struct path path;
 	struct dentry *root;
 	struct qstr quick_string;
-	struct hstate *hstate;
-	unsigned long num_pages;
 
 	*user = NULL;
 	if (!hugetlbfs_vfsmount)
@@ -972,12 +974,10 @@ struct file *hugetlb_file_setup(const ch
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
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -152,8 +152,7 @@ static inline struct hugetlbfs_sb_info *
 
 extern const struct file_operations hugetlbfs_file_operations;
 extern const struct vm_operations_struct hugetlb_vm_ops;
-struct file *hugetlb_file_setup(const char *name, unsigned long addr,
-				size_t size, vm_flags_t acct,
+struct file *hugetlb_file_setup(const char *name, size_t size, vm_flags_t acct,
 				struct user_struct **user, int creat_flags);
 
 static inline int is_file_hugepages(struct file *file)
@@ -170,8 +169,8 @@ static inline int is_file_hugepages(stru
 
 #define is_file_hugepages(file)			0
 static inline struct file *
-hugetlb_file_setup(const char *name, unsigned long addr, size_t size,
-		vm_flags_t acctflag, struct user_struct **user, int creat_flags)
+hugetlb_file_setup(const char *name, size_t size, vm_flags_t acctflag,
+		struct user_struct **user, int creat_flags)
 {
 	return ERR_PTR(-ENOSYS);
 }
@@ -294,7 +293,7 @@ static inline unsigned hstate_index_to_s
 	return hstates[index].order + PAGE_SHIFT;
 }
 
-#else
+#else	/* CONFIG_HUGETLB_PAGE */
 struct hstate {};
 #define alloc_huge_page_node(h, nid) NULL
 #define alloc_bootmem_huge_page(h) NULL
--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -479,10 +479,12 @@ static int newseg(struct ipc_namespace *
 
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
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1130,15 +1130,19 @@ SYSCALL_DEFINE6(mmap_pgoff, unsigned lon
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


