Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756201Ab3EFT5U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 15:57:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37627 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755573Ab3EFT5S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 15:57:18 -0400
From: Andrea Arcangeli <aarcange@redhat.com>
To: qemu-devel@nongnu.org, linux-kernel@vger.kernel.org
Cc: Isaku Yamahata <yamahata@valinux.co.jp>,
        Juan Quintela <quintela@redhat.com>,
        Orit Wasserman <owasserm@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Anthony Liguori <aliguori@us.ibm.com>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>, Hugh Dickins <hughd@google.com>
Subject: [PATCH 4/4] mm: sys_remap_anon_pages
Date: Mon,  6 May 2013 21:57:01 +0200
Message-Id: <1367870221-12676-5-git-send-email-aarcange@redhat.com>
In-Reply-To: <1367870221-12676-1-git-send-email-aarcange@redhat.com>
References: <1367870221-12676-1-git-send-email-aarcange@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This new syscall will move anon pages across vmas, atomically and
without touching the vmas.

It only works on non shared anonymous pages because those can be
relocated without generating non linear anon_vmas in the rmap code.

It is the ideal mechanism to handle userspace page faults. Normally
the destination vma will have VM_USERFAULT set with
madvise(MADV_USERFAULT) while the source vma will normally have
VM_DONTCOPY set with madvise(MADV_DONTFORK).

MADV_DONTFORK set in the source vma avoids remap_anon_pages to fail if
the process forks during the userland page fault.

The thread triggering the sigbus signal handler by touching an
unmapped hole in the MADV_USERFAULT region, should take care to
receive the data belonging in the faulting virtual address in the
source vma. The data can come from the network, storage or any other
I/O device. After the data has been safely received in the private
area in the source vma, it will call remap_anon_pages to map the page
in the faulting address in the destination vma atomically. And finally
it will return from the signal handler.

It is an alternative to mremap.

It only works if the vma protection bits are identical from the source
and destination vma.

It can remap non shared anonymous pages within the same vma too.

If the source virtual memory range has any unmapped holes, or if the
destination virtual memory range is not a whole unmapped hole,
remap_anon_pages will fail with -EFAULT. This provides a very strict
behavior to avoid any chance of memory corruption going unnoticed if
there are userland race conditions. Only one thread should resolve the
userland page fault at any given time for any given faulting
address. This means that if two threads try to both call
remap_anon_pages on the same destination address at the same time, the
second thread will get an explicit -EFAULT retval from this syscall.

The destination range with VM_USERFAULT set should be completely empty
or remap_anon_pages will fail with -EFAULT. It's recommended to call
madvise(MADV_USERFAULT) immediately after the destination range has
been allocated with malloc() or posix_memalign(), so that the
VM_USERFAULT vma will be splitted before a tranparent hugepage fault
could fill the VM_USERFAULT region if it doesn't start hugepage
aligned. That will ensure the VM_USERFAULT area remains empty after
allocation, regardless of its alignment.

The main difference with mremap is that if used to fill holes in
unmapped anonymous memory vmas (if used in combination with
MADV_USERFAULT) remap_anon_pages won't create lots of unmergeable
vmas. mremap instead would create lots of vmas (because of non linear
vma->vm_pgoff) leading to -ENOMEM failures (the number of vmas is
limited).

MADV_USERFAULT and remap_anon_pages() can be tested with a program
like below:

===

static unsigned char *c, *tmp;

void userfault_sighandler(int signum, siginfo_t *info, void *ctx)
{
	unsigned char *addr = info->si_addr;
	int len = 4096;
	int ret;

	addr = (unsigned char *) ((unsigned long) addr & ~((2*1024*1024)-1));
	len = 2*1024*1024;
	if (addr >= c && addr < c + SIZE) {
		unsigned long offset = addr - c;
		ret = syscall(SYS_remap_anon_pages, c+offset, tmp+offset, len);
		if (ret)
			perror("sigbus remap_anon_pages"), exit(1);
		//printf("sigbus offset %lu\n", offset);
		return;
	}

	printf("sigbus error addr %p c %p tmp %p\n", addr, c, tmp), exit(1);
}

int main()
{
	struct sigaction sa;
	int ret;
	unsigned long i;
	/*
	 * Fails with THP due lack of alignment because of memset
	 * pre-filling the destination
	 */
	c = mmap(0, SIZE, PROT_READ|PROT_WRITE,
		 MAP_ANONYMOUS|MAP_PRIVATE, -1, 0);
	if (c == MAP_FAILED)
		perror("mmap"), exit(1);
	tmp = mmap(0, SIZE, PROT_READ|PROT_WRITE,
		   MAP_ANONYMOUS|MAP_PRIVATE, -1, 0);
	if (tmp == MAP_FAILED)
		perror("mmap"), exit(1);
	ret = posix_memalign((void **)&c, 2*1024*1024, SIZE);
	if (ret)
		perror("posix_memalign"), exit(1);
	ret = posix_memalign((void **)&tmp, 2*1024*1024, SIZE);
	if (ret)
		perror("posix_memalign"), exit(1);
	/*
	 * MADV_USERFAULT must run before memset, to avoid THP 2m
	 * faults to map memory into "tmp", if "tmp" isn't allocated
	 * with hugepage alignment.
	 */
	if (madvise(c, SIZE, MADV_USERFAULT))
		perror("madvise"), exit(1);
	memset(tmp, 0xaa, SIZE);

	sa.sa_sigaction = userfault_sighandler;
	sigemptyset(&sa.sa_mask);
	sa.sa_flags = SA_SIGINFO;
	sigaction(SIGBUS, &sa, NULL);

	ret = syscall(SYS_remap_anon_pages, c, tmp, SIZE);
	if (ret)
		perror("remap_anon_pages"), exit(1);

	for (i = 0; i < SIZE; i += 4096) {
		if ((i/4096) % 2) {
			/* exercise read and write MADV_USERFAULT */
			c[i+1] = 0xbb;
		}
		if (c[i] != 0xaa)
			printf("error %x offset %lu\n", c[i], i), exit(1);
	}

	return 0;
}
===

With postcopy live migration to use a single network socket, the vcpu
thread triggering the fault will normally use some interprocess
communication with the thread doing the postcopy background transfer,
to request a specific address, and it'll wait an ack before returning
from the signal. The thread receiving the faulting address, will also
solve the concurrency of the sigbus handler potentially happening
simultaneously on the same address on different vcpu threads (so
calling remap_anon_pages only once for each range received). So
remap_anon_pages in the above testcase runs within the signal handler,
but in production postcopy, it can run in a different thread.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
---
 arch/x86/syscalls/syscall_32.tbl |   1 +
 arch/x86/syscalls/syscall_64.tbl |   1 +
 include/linux/huge_mm.h          |   6 +
 include/linux/syscalls.h         |   3 +
 kernel/sys_ni.c                  |   1 +
 mm/fremap.c                      | 440 +++++++++++++++++++++++++++++++++++++++
 mm/huge_memory.c                 | 100 +++++++++
 7 files changed, 552 insertions(+)

diff --git a/arch/x86/syscalls/syscall_32.tbl b/arch/x86/syscalls/syscall_32.tbl
index e6d55f0..cd2f186 100644
--- a/arch/x86/syscalls/syscall_32.tbl
+++ b/arch/x86/syscalls/syscall_32.tbl
@@ -357,3 +357,4 @@
 348	i386	process_vm_writev	sys_process_vm_writev		compat_sys_process_vm_writev
 349	i386	kcmp			sys_kcmp
 350	i386	finit_module		sys_finit_module
+351	i386	remap_anon_pages	sys_remap_anon_pages
diff --git a/arch/x86/syscalls/syscall_64.tbl b/arch/x86/syscalls/syscall_64.tbl
index 38ae65d..ac240fd 100644
--- a/arch/x86/syscalls/syscall_64.tbl
+++ b/arch/x86/syscalls/syscall_64.tbl
@@ -320,6 +320,7 @@
 311	64	process_vm_writev	sys_process_vm_writev
 312	common	kcmp			sys_kcmp
 313	common	finit_module		sys_finit_module
+314	common	remap_anon_pages	sys_remap_anon_pages
 
 #
 # x32-specific system call numbers start at 512 to avoid cache impact
diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index 528454c..f9edf11 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -33,6 +33,12 @@ extern int move_huge_pmd(struct vm_area_struct *vma,
 extern int change_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
 			unsigned long addr, pgprot_t newprot,
 			int prot_numa);
+extern int remap_anon_pages_huge_pmd(struct mm_struct *mm,
+				     pmd_t *dst_pmd, pmd_t *src_pmd,
+				     struct vm_area_struct *dst_vma,
+				     struct vm_area_struct *src_vma,
+				     unsigned long dst_addr,
+				     unsigned long src_addr);
 
 enum transparent_hugepage_flag {
 	TRANSPARENT_HUGEPAGE_FLAG,
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 313a8e0..00a4781 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -486,6 +486,9 @@ asmlinkage long sys_mremap(unsigned long addr,
 asmlinkage long sys_remap_file_pages(unsigned long start, unsigned long size,
 			unsigned long prot, unsigned long pgoff,
 			unsigned long flags);
+asmlinkage long sys_remap_anon_pages(unsigned long dst_start,
+				     unsigned long src_start,
+				     unsigned long len);
 asmlinkage long sys_msync(unsigned long start, size_t len, int flags);
 asmlinkage long sys_fadvise64(int fd, loff_t offset, size_t len, int advice);
 asmlinkage long sys_fadvise64_64(int fd, loff_t offset, loff_t len, int advice);
diff --git a/kernel/sys_ni.c b/kernel/sys_ni.c
index 395084d..3d401eb 100644
--- a/kernel/sys_ni.c
+++ b/kernel/sys_ni.c
@@ -172,6 +172,7 @@ cond_syscall(sys_mincore);
 cond_syscall(sys_madvise);
 cond_syscall(sys_mremap);
 cond_syscall(sys_remap_file_pages);
+cond_syscall(sys_remap_anon_pages);
 cond_syscall(compat_sys_move_pages);
 cond_syscall(compat_sys_migrate_pages);
 
diff --git a/mm/fremap.c b/mm/fremap.c
index 87da359..e4018a2 100644
--- a/mm/fremap.c
+++ b/mm/fremap.c
@@ -257,3 +257,443 @@ out:
 
 	return err;
 }
+
+static void double_pt_lock(spinlock_t *ptl1,
+			   spinlock_t *ptl2)
+	__acquires(ptl1)
+	__acquires(ptl2)
+{
+	spinlock_t *ptl_tmp;
+
+	if (ptl1 > ptl2) {
+		/* exchange ptl1 and ptl2 */
+		ptl_tmp = ptl1;
+		ptl1 = ptl2;
+		ptl2 = ptl_tmp;
+	}
+	/* lock in virtual address order to avoid lock inversion */
+	spin_lock(ptl1);
+	if (ptl1 != ptl2)
+		spin_lock_nested(ptl2, SINGLE_DEPTH_NESTING);
+}
+
+static void double_pt_unlock(spinlock_t *ptl1,
+			     spinlock_t *ptl2)
+	__releases(ptl1)
+	__releases(ptl2)
+{
+	spin_unlock(ptl1);
+	if (ptl1 != ptl2)
+		spin_unlock(ptl2);
+}
+
+/*
+ * The page_table_lock and mmap_sem for reading are held by the
+ * caller. Just move the page from src_pmd to dst_pmd if possible,
+ * and return true if succeeded in moving the page.
+ */
+static int remap_anon_pages_pte(struct mm_struct *mm,
+				pte_t *dst_pte, pte_t *src_pte, pmd_t *src_pmd,
+				struct vm_area_struct *dst_vma,
+				struct vm_area_struct *src_vma,
+				unsigned long dst_addr,
+				unsigned long src_addr,
+				spinlock_t *dst_ptl,
+				spinlock_t *src_ptl)
+{
+	struct page *src_page;
+	swp_entry_t entry;
+	pte_t orig_src_pte, orig_dst_pte;
+	struct anon_vma *src_anon_vma, *dst_anon_vma;
+
+	spin_lock(dst_ptl);
+	orig_dst_pte = *dst_pte;
+	spin_unlock(dst_ptl);
+	if (!pte_none(orig_dst_pte))
+		return -EFAULT;
+
+	spin_lock(src_ptl);
+	orig_src_pte = *src_pte;
+	spin_unlock(src_ptl);
+	if (pte_none(orig_src_pte))
+		return -EFAULT;
+
+	if (pte_present(orig_src_pte)) {
+		/*
+		 * Pin the page while holding the lock to be sure the
+		 * page isn't freed under us
+		 */
+		spin_lock(src_ptl);
+		if (!pte_same(orig_src_pte, *src_pte)) {
+			spin_unlock(src_ptl);
+			return -EAGAIN;
+		}
+		src_page = vm_normal_page(src_vma, src_addr, orig_src_pte);
+		if (!src_page || !PageAnon(src_page) ||
+		    page_mapcount(src_page) != 1) {
+			spin_unlock(src_ptl);
+			return -EFAULT;
+		}
+
+		get_page(src_page);
+		spin_unlock(src_ptl);
+
+		/* block all concurrent rmap walks */
+		lock_page(src_page);
+
+		/*
+		 * page_referenced_anon walks the anon_vma chain
+		 * without the page lock. Serialize against it with
+		 * the anon_vma lock, the page lock is not enough.
+		 */
+		src_anon_vma = page_get_anon_vma(src_page);
+		if (!src_anon_vma) {
+			/* page was unmapped from under us */
+			unlock_page(src_page);
+			put_page(src_page);
+			return -EAGAIN;
+		}
+		anon_vma_lock_write(src_anon_vma);
+
+		double_pt_lock(dst_ptl, src_ptl);
+
+		if (!pte_same(*src_pte, orig_src_pte) ||
+		    !pte_same(*dst_pte, orig_dst_pte) ||
+		    page_mapcount(src_page) != 1) {
+			double_pt_unlock(dst_ptl, src_ptl);
+			anon_vma_unlock_write(src_anon_vma);
+			put_anon_vma(src_anon_vma);
+			unlock_page(src_page);
+			put_page(src_page);
+			return -EAGAIN;
+		}
+
+		BUG_ON(!PageAnon(src_page));
+		/* the PT lock is enough to keep the page pinned now */
+		put_page(src_page);
+
+		dst_anon_vma = (void *) dst_vma->anon_vma + PAGE_MAPPING_ANON;
+		ACCESS_ONCE(src_page->mapping) = ((struct address_space *)
+						  dst_anon_vma);
+		ACCESS_ONCE(src_page->index) = linear_page_index(dst_vma,
+								 dst_addr);
+
+		ptep_clear_flush(src_vma, src_addr, src_pte);
+
+		orig_dst_pte = mk_pte(src_page, dst_vma->vm_page_prot);
+		orig_dst_pte = maybe_mkwrite(pte_mkdirty(orig_dst_pte),
+					     dst_vma);
+
+		set_pte_at(mm, dst_addr, dst_pte, orig_dst_pte);
+
+		double_pt_unlock(dst_ptl, src_ptl);
+
+		anon_vma_unlock_write(src_anon_vma);
+		put_anon_vma(src_anon_vma);
+
+		/* unblock rmap walks */
+		unlock_page(src_page);
+
+		mmu_notifier_invalidate_page(mm, src_addr);
+	} else {
+		if (pte_file(orig_src_pte))
+			return -EFAULT;
+
+		entry = pte_to_swp_entry(orig_src_pte);
+		if (non_swap_entry(entry)) {
+			if (is_migration_entry(entry)) {
+				migration_entry_wait(mm, src_pmd, src_addr);
+				return -EAGAIN;
+			}
+			return -EFAULT;
+		}
+
+		if (swp_entry_swapcount(entry) != 1)
+			return -EFAULT;
+
+		double_pt_lock(dst_ptl, src_ptl);
+
+		if (!pte_same(*src_pte, orig_src_pte) ||
+		    !pte_same(*dst_pte, orig_dst_pte) ||
+		    swp_entry_swapcount(entry) != 1) {
+			double_pt_unlock(dst_ptl, src_ptl);
+			return -EAGAIN;
+		}
+
+		if (pte_val(ptep_get_and_clear(mm, src_addr, src_pte)) !=
+		    pte_val(orig_src_pte))
+			BUG();
+		set_pte_at(mm, dst_addr, dst_pte, orig_src_pte);
+
+		double_pt_unlock(dst_ptl, src_ptl);
+	}
+
+	return 0;
+}
+
+pmd_t *mm_alloc_pmd(struct mm_struct *mm, unsigned long address)
+{
+	pgd_t *pgd;
+	pud_t *pud;
+	pmd_t *pmd = NULL;
+
+	pgd = pgd_offset(mm, address);
+	pud = pud_alloc(mm, pgd, address);
+	if (pud)
+		pmd = pmd_alloc(mm, pud, address);
+	return pmd;
+}
+
+/**
+ * sys_remap_anon_pages - remap arbitrary anonymous pages of an existing vma
+ * @dst_start: start of the destination virtual memory range
+ * @src_start: start of the source virtual memory range
+ * @len: length of the virtual memory range
+ *
+ * sys_remap_anon_pages remaps arbitrary anonymous pages atomically in
+ * zero copy. It only works on non shared anonymous pages because
+ * those can be relocated without generating non linear anon_vmas in
+ * the rmap code.
+ *
+ * It is the ideal mechanism to handle userspace page faults. Normally
+ * the destination vma will have VM_USERFAULT set with
+ * madvise(MADV_USERFAULT) while the source vma will have VM_DONTCOPY
+ * set with madvise(MADV_DONTFORK).
+ *
+ * The thread receiving the page during the userland page fault
+ * (MADV_USERFAULT) (inside the sigbus signal handler) will receive
+ * the faulting page in the source vma through the network, storage or
+ * any other I/O device (MADV_DONTFORK in the source vma avoids
+ * remap_anon_pages to fail if the process forks during the userland
+ * page fault), then it will call remap_anon_pages to map the page in
+ * the faulting address in the destination vma and finally it will
+ * return from the signal handler.
+ *
+ * This syscall works purely via pagetables, so it's the most
+ * efficient way to move physical non shared anonymous pages across
+ * different virtual addresses. Unlike mremap()/mmap()/munmap() it
+ * does not create any new vmas. The mapping in the destination
+ * address is atomic.
+ *
+ * It only works if the vma protection bits are identical from the
+ * source and destination vma.
+ *
+ * It can remap non shared anonymous pages within the same vma too.
+ *
+ * If the source virtual memory range has any unmapped holes, or if
+ * the destination virtual memory range is not a whole unmapped hole,
+ * remap_anon_pages will fail with -EFAULT. This provides a very
+ * strict behavior to avoid any chance of memory corruption going
+ * unnoticed if there are userland race conditions. Only one thread
+ * should resolve the userland page fault at any given time for any
+ * given faulting address. This means that if two threads try to both
+ * call remap_anon_pages on the same destination address at the same
+ * time, the second thread will get an explicit -EFAULT retval from
+ * this syscall.
+ *
+ * The destination range with VM_USERFAULT set should be completely
+ * empty or remap_anon_pages will fail with -EFAULT. It's recommended
+ * to call madvise(MADV_USERFAULT) immediately after the destination
+ * range has been allocated with malloc() or posix_memalign(), so that
+ * the VM_USERFAULT vma will be splitted before a tranparent hugepage
+ * fault could fill the VM_USERFAULT region. That will ensure the
+ * VM_USERFAULT area remains empty after allocation, regardless of its
+ * alignment.
+ *
+ * If there's any rmap walk that is taking the anon_vma locks without
+ * first obtaining the page lock (for example split_huge_page and
+ * page_referenced_anon), they will have to verify if the
+ * page->mapping has changed after taking the anon_vma lock. If it
+ * changed they should release the lock and retry obtaining a new
+ * anon_vma, because it means the anon_vma was changed by
+ * remap_anon_pages before the lock could be obtained. This is the
+ * only additional complexity added to the rmap code to provide this
+ * anonymous page remapping functionality.
+ */
+SYSCALL_DEFINE3(remap_anon_pages,
+		unsigned long, dst_start, unsigned long, src_start,
+		unsigned long, len)
+{
+	struct mm_struct *mm = current->mm;
+	struct vm_area_struct *src_vma, *dst_vma;
+	int err = -EINVAL;
+	pmd_t *src_pmd, *dst_pmd;
+	pte_t *src_pte, *dst_pte;
+	spinlock_t *dst_ptl, *src_ptl;
+	unsigned long src_addr, dst_addr;
+	int thp_aligned = -1;
+
+	/*
+	 * Sanitize the syscall parameters:
+	 */
+	src_start &= PAGE_MASK;
+	dst_start &= PAGE_MASK;
+	len &= PAGE_MASK;
+
+	/* Does the address range wrap, or is the span zero-sized? */
+	if (unlikely(src_start + len <= src_start))
+		return err;
+	if (unlikely(dst_start + len <= dst_start))
+		return err;
+
+	down_read(&mm->mmap_sem);
+
+	/*
+	 * Make sure the vma is not shared, that the src and dst remap
+	 * ranges are both valid and fully within a single existing
+	 * vma.
+	 */
+	src_vma = find_vma(mm, src_start);
+	if (!src_vma || (src_vma->vm_flags & VM_SHARED))
+		goto out;
+	if (src_start < src_vma->vm_start ||
+	    src_start + len > src_vma->vm_end)
+		goto out;
+
+	dst_vma = find_vma(mm, dst_start);
+	if (!dst_vma || (dst_vma->vm_flags & VM_SHARED))
+		goto out;
+	if (dst_start < dst_vma->vm_start ||
+	    dst_start + len > dst_vma->vm_end)
+		goto out;
+
+	if (pgprot_val(src_vma->vm_page_prot) !=
+	    pgprot_val(dst_vma->vm_page_prot))
+		goto out;
+
+	/* only allow remapping if both are mlocked or both aren't */
+	if ((src_vma->vm_flags & VM_LOCKED) ^ (dst_vma->vm_flags & VM_LOCKED))
+		goto out;
+
+	err = 0;
+	for (src_addr = src_start, dst_addr = dst_start;
+	     src_addr < src_start + len; ) {
+		BUG_ON(dst_addr >= dst_start + len);
+		src_pmd = mm_find_pmd(mm, src_addr);
+		if (unlikely(!src_pmd)) {
+			err = -EFAULT;
+			break;
+		}
+		dst_pmd = mm_alloc_pmd(mm, dst_addr);
+		if (unlikely(!dst_pmd)) {
+			err = -ENOMEM;
+			break;
+		}
+		if (pmd_trans_huge_lock(src_pmd, src_vma) == 1) {
+			/*
+			 * If the dst_pmd is mapped as THP don't
+			 * override it and just be strict.
+			 */
+			if (unlikely(pmd_trans_huge(*dst_pmd))) {
+				spin_unlock(&mm->page_table_lock);
+				err = -EFAULT;
+				break;
+			}
+
+			/*
+			 * Check if we can move the pmd without
+			 * splitting it. First check the address
+			 * alignment to be the same in src/dst.
+			 */
+			if (thp_aligned == -1)
+				thp_aligned = ((src_addr & ~HPAGE_PMD_MASK) ==
+					       (dst_addr & ~HPAGE_PMD_MASK));
+			if (!thp_aligned || (src_addr & ~HPAGE_PMD_MASK) ||
+			    !pmd_none(*dst_pmd)) {
+				spin_unlock(&mm->page_table_lock);
+				/* Fall through */
+				split_huge_page_pmd(src_vma, src_addr,
+						    src_pmd);
+			} else {
+				BUG_ON(dst_addr & ~HPAGE_PMD_MASK);
+				err = remap_anon_pages_huge_pmd(mm,
+								dst_pmd,
+								src_pmd,
+								dst_vma,
+								src_vma,
+								dst_addr,
+								src_addr);
+				cond_resched();
+
+				if ((!err || err == -EAGAIN) &&
+				    signal_pending(current)) {
+					err = -EINTR;
+					break;
+				}
+
+				if (err == -EAGAIN)
+					continue;
+				else if (err)
+					break;
+
+				dst_addr += HPAGE_PMD_SIZE;
+				src_addr += HPAGE_PMD_SIZE;
+				continue;
+			}
+		}
+
+		/*
+		 * We held the mmap_sem for reading so MADV_DONTNEED
+		 * can zap transparent huge pages under us, or the
+		 * transparent huge page fault can establish new
+		 * transparent huge pages under us. Be strict in that
+		 * case. This also means that unmapped holes in the
+		 * source address range will lead to returning
+		 * -EFAULT.
+		 */
+		if (unlikely(pmd_trans_unstable(src_pmd))) {
+			err = -EFAULT;
+			break;
+		}
+
+		if (unlikely(pmd_none(*dst_pmd)) &&
+		    unlikely(__pte_alloc(mm, dst_vma, dst_pmd,
+					 dst_addr))) {
+			err = -ENOMEM;
+			break;
+		}
+		/* If an huge pmd materialized from under us fail */
+		if (unlikely(pmd_trans_huge(*dst_pmd))) {
+			err = -EFAULT;
+			break;
+		}
+
+		BUG_ON(pmd_none(*dst_pmd));
+		BUG_ON(pmd_none(*src_pmd));
+		BUG_ON(pmd_trans_huge(*dst_pmd));
+		BUG_ON(pmd_trans_huge(*src_pmd));
+
+		dst_pte = pte_offset_map(dst_pmd, dst_addr);
+		src_pte = pte_offset_map(src_pmd, src_addr);
+		dst_ptl = pte_lockptr(mm, dst_pmd);
+		src_ptl = pte_lockptr(mm, src_pmd);
+
+		err = remap_anon_pages_pte(mm,
+					   dst_pte, src_pte, src_pmd,
+					   dst_vma, src_vma,
+					   dst_addr, src_addr,
+					   dst_ptl, src_ptl);
+
+		pte_unmap(dst_pte);
+		pte_unmap(src_pte);
+		cond_resched();
+
+		if ((!err || err == -EAGAIN) &&
+		    signal_pending(current)) {
+			err = -EINTR;
+			break;
+		}
+
+		if (err == -EAGAIN)
+			continue;
+		else if (err)
+			break;
+
+		dst_addr += PAGE_SIZE;
+		src_addr += PAGE_SIZE;
+	}
+
+out:
+	up_read(&mm->mmap_sem);
+	return err;
+}
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 9a2e235..2979052 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1480,6 +1480,106 @@ int change_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
 }
 
 /*
+ * The page_table_lock and mmap_sem for reading are held by the
+ * caller, but it must return after releasing the
+ * page_table_lock. Just move the page from src_pmd to dst_pmd if
+ * possible. Return zero if succeeded in moving the page, -EAGAIN if
+ * it needs to be repeated by the caller, or other errors in case of
+ * failure.
+ */
+int remap_anon_pages_huge_pmd(struct mm_struct *mm,
+			      pmd_t *dst_pmd, pmd_t *src_pmd,
+			      struct vm_area_struct *dst_vma,
+			      struct vm_area_struct *src_vma,
+			      unsigned long dst_addr,
+			      unsigned long src_addr)
+{
+	pmd_t orig_src_pmd, orig_dst_pmd;
+	struct page *src_page;
+	struct anon_vma *src_anon_vma, *dst_anon_vma;
+
+	BUG_ON(!pmd_trans_huge(*src_pmd));
+	BUG_ON(pmd_trans_splitting(*src_pmd));
+	BUG_ON(!pmd_none(*dst_pmd));
+	BUG_ON(!spin_is_locked(&mm->page_table_lock));
+	BUG_ON(!rwsem_is_locked(&mm->mmap_sem));
+
+	orig_src_pmd = *src_pmd;
+	orig_dst_pmd = *dst_pmd;
+
+	src_page = pmd_page(orig_src_pmd);
+	BUG_ON(!PageHead(src_page));
+	BUG_ON(!PageAnon(src_page));
+	if (unlikely(page_mapcount(src_page) != 1)) {
+		spin_unlock(&mm->page_table_lock);
+		return -EFAULT;
+	}
+
+	get_page(src_page);
+	spin_unlock(&mm->page_table_lock);
+
+	mmu_notifier_invalidate_range_start(mm, src_addr,
+					    src_addr + HPAGE_PMD_SIZE);
+
+	/* block all concurrent rmap walks */
+	lock_page(src_page);
+
+	/*
+	 * split_huge_page walks the anon_vma chain without the page
+	 * lock. Serialize against it with the anon_vma lock, the page
+	 * lock is not enough.
+	 */
+	src_anon_vma = page_get_anon_vma(src_page);
+	if (!src_anon_vma) {
+		unlock_page(src_page);
+		put_page(src_page);
+		mmu_notifier_invalidate_range_end(mm, src_addr,
+						  src_addr + HPAGE_PMD_SIZE);
+		return -EAGAIN;
+	}
+	anon_vma_lock_write(src_anon_vma);
+
+	spin_lock(&mm->page_table_lock);
+	if (unlikely(!pmd_same(*src_pmd, orig_src_pmd) ||
+		     !pmd_same(*dst_pmd, orig_dst_pmd) ||
+		     page_mapcount(src_page) != 1)) {
+		spin_unlock(&mm->page_table_lock);
+		anon_vma_unlock_write(src_anon_vma);
+		put_anon_vma(src_anon_vma);
+		unlock_page(src_page);
+		put_page(src_page);
+		mmu_notifier_invalidate_range_end(mm, src_addr,
+						  src_addr + HPAGE_PMD_SIZE);
+		return -EAGAIN;
+	}
+
+	BUG_ON(!PageHead(src_page));
+	BUG_ON(!PageAnon(src_page));
+	/* the PT lock is enough to keep the page pinned now */
+	put_page(src_page);
+
+	dst_anon_vma = (void *) dst_vma->anon_vma + PAGE_MAPPING_ANON;
+	ACCESS_ONCE(src_page->mapping) = (struct address_space *) dst_anon_vma;
+	ACCESS_ONCE(src_page->index) = linear_page_index(dst_vma, dst_addr);
+
+	if (pmd_val(pmdp_clear_flush(src_vma, src_addr, src_pmd)) !=
+	    pmd_val(orig_src_pmd))
+		BUG();
+	set_pmd_at(mm, dst_addr, dst_pmd, mk_huge_pmd(src_page, dst_vma));
+	spin_unlock(&mm->page_table_lock);
+
+	anon_vma_unlock_write(src_anon_vma);
+	put_anon_vma(src_anon_vma);
+
+	/* unblock rmap walks */
+	unlock_page(src_page);
+
+	mmu_notifier_invalidate_range_end(mm, src_addr,
+					  src_addr + HPAGE_PMD_SIZE);
+	return 0;
+}
+
+/*
  * Returns 1 if a given pmd maps a stable (not under splitting) thp.
  * Returns -1 if it maps a thp under splitting. Returns 0 otherwise.
  *
