Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755764AbaIZR0X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 13:26:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35426 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754703AbaIZR0V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 13:26:21 -0400
Date: Fri, 26 Sep 2014 19:25:35 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Andres Lagar-Cavilla <andreslc@google.com>
Cc: Gleb Natapov <gleb@kernel.org>, Radim Krcmar <rkrcmar@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, Rik van Riel <riel@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>,
        Andy Lutomirski <luto@amacapital.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sasha.levin@oracle.com>, Jianyu Zhan <nasa4836@gmail.com>,
        Paul Cassella <cassella@cray.com>, Hugh Dickins <hughd@google.com>,
        Peter Feiner <pfeiner@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Subject: RFC: get_user_pages_locked|unlocked to leverage VM_FAULT_RETRY
Message-ID: <20140926172535.GC4590@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2014 at 02:50:29PM -0700, Andres Lagar-Cavilla wrote:
> It's nearly impossible to name it right because 1) it indicates we can
> relinquish 2) it returns whether we still hold the mmap semaphore.
> 
> I'd prefer it'd be called mmap_sem_hold, which conveys immediately
> what this is about ("nonblocking" or "locked" could be about a whole
> lot of things)

To me FOLL_NOWAIT/FAULT_FLAG_RETRY_NOWAIT is nonblocking,
"locked"/FAULT_FLAG_ALLOW_RETRY is still very much blocking, just
without the mmap_sem, so I called it "locked"... but I'm fine to
change the name to mmap_sem_hold. Just get_user_pages_mmap_sem_hold
seems less friendly than get_user_pages_locked(..., &locked). locked
as you used comes intuitive when you do later "if (locked) up_read".

Then I added an _unlocked kind which is a drop in replacement for many
places just to clean it up.

get_user_pages_unlocked and get_user_pages_fast are equivalent in
semantics, so any call of get_user_pages_unlocked(current,
current->mm, ...) has no reason to exist and should be replaced to
get_user_pages_fast unless "force = 1" (gup_fast has no force param
just to make the argument list a bit more confusing across the various
versions of gup).

get_user_pages over time should be phased out and dropped.

> I can see that. My background for coming into this is very similar: in
> a previous life we had a file system shim that would kick up into
> userspace for servicing VM memory. KVM just wouldn't let the file
> system give up the mmap semaphore. We had /proc readers hanging up all
> over the place while userspace was servicing. Not happy.
> 
> With KVM (now) and the standard x86 fault giving you ALLOW_RETRY, what
> stands in your way? Methinks that gup_fast has no slowpath fallback
> that turns on ALLOW_RETRY. What would oppose that being the global
> behavior?

It should become the global behavior. Just it doesn't need to become a
global behavior immediately for all kind of gups (i.e. video4linux
drivers will never need to poke into the KVM guest user memory so it
doesn't matter if they don't use gup_locked immediately). Even then we
can still support get_user_pages_locked(...., locked=NULL) for
ptrace/coredump and other things that may not want to trigger the
userfaultfd protocol and just get an immediate VM_FAULT_SIGBUS.

Userfaults will just VM_FAULT_SIGBUS (translated to -EFAULT by all gup
invocations) and not invoke the userfaultfd protocol, if
FAULT_FLAG_ALLOW_RETRY is not set. So any gup_locked with locked ==
NULL or or gup() (without locked parameter) will not invoke the
userfaultfd protocol.

But I need gup_fast to use FAULT_FLAG_ALLOW_RETRY because core places
like O_DIRECT uses it.

I tried to do a RFC patch below that goes into this direction and
should be enough for a start to solve all my issues with the mmap_sem
holding inside handle_userfault(), comments welcome.

=======
>From 41918f7d922d1e7fc70f117db713377e7e2af6e9 Mon Sep 17 00:00:00 2001
From: Andrea Arcangeli <aarcange@redhat.com>
Date: Fri, 26 Sep 2014 18:36:53 +0200
Subject: [PATCH 1/2] mm: gup: add get_user_pages_locked and
 get_user_pages_unlocked

We can leverage the VM_FAULT_RETRY functionality in the page fault
paths better by using either get_user_pages_locked or
get_user_pages_unlocked.

The former allow conversion of get_user_pages invocations that will
have to pass a "&locked" parameter to know if the mmap_sem was dropped
during the call. Example from:

    down_read(&mm->mmap_sem);
    do_something()
    get_user_pages(tsk, mm, ..., pages, NULL);
    up_read(&mm->mmap_sem);

to:

    int locked = 1;
    down_read(&mm->mmap_sem);
    do_something()
    get_user_pages_locked(tsk, mm, ..., pages, &locked);
    if (locked)
        up_read(&mm->mmap_sem);

The latter is suitable only as a drop in replacement of the form:

    down_read(&mm->mmap_sem);
    get_user_pages(tsk, mm, ..., pages, NULL);
    up_read(&mm->mmap_sem);

into:

    get_user_pages_unlocked(tsk, mm, ..., pages);

Where tsk, mm, the intermediate "..." paramters and "pages" can be any
value as before. Just the last parameter of get_user_pages (vmas) must
be NULL for get_user_pages_locked|unlocked to be usable (the latter
original form wouldn't have been safe anyway if vmas wasn't null, for
the former we just make it explicit by dropping the parameter).

If vmas is not NULL these two methods cannot be used.

This patch then applies the new forms in various places, in some case
also replacing it with get_user_pages_fast whenever tsk and mm are
current and current->mm. get_user_pages_unlocked varies from
get_user_pages_fast only if mm is not current->mm (like when
get_user_pages works on some other process mm). Whenever tsk and mm
matches current and current->mm get_user_pages_fast must always be
used to increase performance and get the page lockless (only with irq
disabled).

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
---
 arch/mips/mm/gup.c                 |   8 +-
 arch/powerpc/mm/gup.c              |   6 +-
 arch/s390/kvm/kvm-s390.c           |   4 +-
 arch/s390/mm/gup.c                 |   6 +-
 arch/sh/mm/gup.c                   |   6 +-
 arch/sparc/mm/gup.c                |   6 +-
 arch/x86/mm/gup.c                  |   7 +-
 drivers/dma/iovlock.c              |  10 +--
 drivers/iommu/amd_iommu_v2.c       |   6 +-
 drivers/media/pci/ivtv/ivtv-udma.c |   6 +-
 drivers/misc/sgi-gru/grufault.c    |   3 +-
 drivers/scsi/st.c                  |  10 +--
 drivers/video/fbdev/pvr2fb.c       |   5 +-
 include/linux/mm.h                 |   7 ++
 mm/gup.c                           | 147 ++++++++++++++++++++++++++++++++++---
 mm/mempolicy.c                     |   2 +-
 mm/nommu.c                         |  23 ++++++
 mm/process_vm_access.c             |   7 +-
 mm/util.c                          |  10 +--
 net/ceph/pagevec.c                 |   9 +--
 20 files changed, 200 insertions(+), 88 deletions(-)

diff --git a/arch/mips/mm/gup.c b/arch/mips/mm/gup.c
index 06ce17c..20884f5 100644
--- a/arch/mips/mm/gup.c
+++ b/arch/mips/mm/gup.c
@@ -301,11 +301,9 @@ slow_irqon:
 	start += nr << PAGE_SHIFT;
 	pages += nr;
 
-	down_read(&mm->mmap_sem);
-	ret = get_user_pages(current, mm, start,
-				(end - start) >> PAGE_SHIFT,
-				write, 0, pages, NULL);
-	up_read(&mm->mmap_sem);
+	ret = get_user_pages_unlocked(current, mm, start,
+				      (end - start) >> PAGE_SHIFT,
+				      write, 0, pages);
 
 	/* Have to be a bit careful with return values */
 	if (nr > 0) {
diff --git a/arch/powerpc/mm/gup.c b/arch/powerpc/mm/gup.c
index d874668..b70c34a 100644
--- a/arch/powerpc/mm/gup.c
+++ b/arch/powerpc/mm/gup.c
@@ -215,10 +215,8 @@ int get_user_pages_fast(unsigned long start, int nr_pages, int write,
 		start += nr << PAGE_SHIFT;
 		pages += nr;
 
-		down_read(&mm->mmap_sem);
-		ret = get_user_pages(current, mm, start,
-				     nr_pages - nr, write, 0, pages, NULL);
-		up_read(&mm->mmap_sem);
+		ret = get_user_pages_unlocked(current, mm, start,
+					      nr_pages - nr, write, 0, pages);
 
 		/* Have to be a bit careful with return values */
 		if (nr > 0) {
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 81b0e11..37ca29a 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -1092,9 +1092,7 @@ long kvm_arch_fault_in_page(struct kvm_vcpu *vcpu, gpa_t gpa, int writable)
 	hva = gmap_fault(gpa, vcpu->arch.gmap);
 	if (IS_ERR_VALUE(hva))
 		return (long)hva;
-	down_read(&mm->mmap_sem);
-	rc = get_user_pages(current, mm, hva, 1, writable, 0, NULL, NULL);
-	up_read(&mm->mmap_sem);
+	rc = get_user_pages_unlocked(current, mm, hva, 1, writable, 0, NULL);
 
 	return rc < 0 ? rc : 0;
 }
diff --git a/arch/s390/mm/gup.c b/arch/s390/mm/gup.c
index 639fce46..5c586c7 100644
--- a/arch/s390/mm/gup.c
+++ b/arch/s390/mm/gup.c
@@ -235,10 +235,8 @@ int get_user_pages_fast(unsigned long start, int nr_pages, int write,
 	/* Try to get the remaining pages with get_user_pages */
 	start += nr << PAGE_SHIFT;
 	pages += nr;
-	down_read(&mm->mmap_sem);
-	ret = get_user_pages(current, mm, start,
-			     nr_pages - nr, write, 0, pages, NULL);
-	up_read(&mm->mmap_sem);
+	ret = get_user_pages_unlocked(current, mm, start,
+			     nr_pages - nr, write, 0, pages);
 	/* Have to be a bit careful with return values */
 	if (nr > 0)
 		ret = (ret < 0) ? nr : ret + nr;
diff --git a/arch/sh/mm/gup.c b/arch/sh/mm/gup.c
index 37458f3..e15f52a 100644
--- a/arch/sh/mm/gup.c
+++ b/arch/sh/mm/gup.c
@@ -257,10 +257,8 @@ slow_irqon:
 		start += nr << PAGE_SHIFT;
 		pages += nr;
 
-		down_read(&mm->mmap_sem);
-		ret = get_user_pages(current, mm, start,
-			(end - start) >> PAGE_SHIFT, write, 0, pages, NULL);
-		up_read(&mm->mmap_sem);
+		ret = get_user_pages_unlocked(current, mm, start,
+			(end - start) >> PAGE_SHIFT, write, 0, pages);
 
 		/* Have to be a bit careful with return values */
 		if (nr > 0) {
diff --git a/arch/sparc/mm/gup.c b/arch/sparc/mm/gup.c
index 1aed043..fa7de7d 100644
--- a/arch/sparc/mm/gup.c
+++ b/arch/sparc/mm/gup.c
@@ -219,10 +219,8 @@ slow:
 		start += nr << PAGE_SHIFT;
 		pages += nr;
 
-		down_read(&mm->mmap_sem);
-		ret = get_user_pages(current, mm, start,
-			(end - start) >> PAGE_SHIFT, write, 0, pages, NULL);
-		up_read(&mm->mmap_sem);
+		ret = get_user_pages_unlocked(current, mm, start,
+			(end - start) >> PAGE_SHIFT, write, 0, pages);
 
 		/* Have to be a bit careful with return values */
 		if (nr > 0) {
diff --git a/arch/x86/mm/gup.c b/arch/x86/mm/gup.c
index 207d9aef..2ab183b 100644
--- a/arch/x86/mm/gup.c
+++ b/arch/x86/mm/gup.c
@@ -388,10 +388,9 @@ slow_irqon:
 		start += nr << PAGE_SHIFT;
 		pages += nr;
 
-		down_read(&mm->mmap_sem);
-		ret = get_user_pages(current, mm, start,
-			(end - start) >> PAGE_SHIFT, write, 0, pages, NULL);
-		up_read(&mm->mmap_sem);
+		ret = get_user_pages_unlocked(current, mm, start,
+					      (end - start) >> PAGE_SHIFT,
+					      write, 0, pages);
 
 		/* Have to be a bit careful with return values */
 		if (nr > 0) {
diff --git a/drivers/dma/iovlock.c b/drivers/dma/iovlock.c
index bb48a57..12ea7c3 100644
--- a/drivers/dma/iovlock.c
+++ b/drivers/dma/iovlock.c
@@ -95,17 +95,11 @@ struct dma_pinned_list *dma_pin_iovec_pages(struct iovec *iov, size_t len)
 		pages += page_list->nr_pages;
 
 		/* pin pages down */
-		down_read(&current->mm->mmap_sem);
-		ret = get_user_pages(
-			current,
-			current->mm,
+		ret = get_user_pages_fast(
 			(unsigned long) iov[i].iov_base,
 			page_list->nr_pages,
 			1,	/* write */
-			0,	/* force */
-			page_list->pages,
-			NULL);
-		up_read(&current->mm->mmap_sem);
+			page_list->pages);
 
 		if (ret != page_list->nr_pages)
 			goto unpin;
diff --git a/drivers/iommu/amd_iommu_v2.c b/drivers/iommu/amd_iommu_v2.c
index 5f578e8..6963b73 100644
--- a/drivers/iommu/amd_iommu_v2.c
+++ b/drivers/iommu/amd_iommu_v2.c
@@ -519,10 +519,8 @@ static void do_fault(struct work_struct *work)
 
 	write = !!(fault->flags & PPR_FAULT_WRITE);
 
-	down_read(&fault->state->mm->mmap_sem);
-	npages = get_user_pages(NULL, fault->state->mm,
-				fault->address, 1, write, 0, &page, NULL);
-	up_read(&fault->state->mm->mmap_sem);
+	npages = get_user_pages_unlocked(NULL, fault->state->mm,
+					 fault->address, 1, write, 0, &page);
 
 	if (npages == 1) {
 		put_page(page);
diff --git a/drivers/media/pci/ivtv/ivtv-udma.c b/drivers/media/pci/ivtv/ivtv-udma.c
index 7338cb2..96d866b 100644
--- a/drivers/media/pci/ivtv/ivtv-udma.c
+++ b/drivers/media/pci/ivtv/ivtv-udma.c
@@ -124,10 +124,8 @@ int ivtv_udma_setup(struct ivtv *itv, unsigned long ivtv_dest_addr,
 	}
 
 	/* Get user pages for DMA Xfer */
-	down_read(&current->mm->mmap_sem);
-	err = get_user_pages(current, current->mm,
-			user_dma.uaddr, user_dma.page_count, 0, 1, dma->map, NULL);
-	up_read(&current->mm->mmap_sem);
+	err = get_user_pages_unlocked(current, current->mm,
+			user_dma.uaddr, user_dma.page_count, 0, 1, dma->map);
 
 	if (user_dma.page_count != err) {
 		IVTV_DEBUG_WARN("failed to map user pages, returned %d instead of %d\n",
diff --git a/drivers/misc/sgi-gru/grufault.c b/drivers/misc/sgi-gru/grufault.c
index f74fc0c..cd20669 100644
--- a/drivers/misc/sgi-gru/grufault.c
+++ b/drivers/misc/sgi-gru/grufault.c
@@ -198,8 +198,7 @@ static int non_atomic_pte_lookup(struct vm_area_struct *vma,
 #else
 	*pageshift = PAGE_SHIFT;
 #endif
-	if (get_user_pages
-	    (current, current->mm, vaddr, 1, write, 0, &page, NULL) <= 0)
+	if (get_user_pages_fast(vaddr, 1, write, &page) <= 0)
 		return -EFAULT;
 	*paddr = page_to_phys(page);
 	put_page(page);
diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index aff9689..c89dcfa 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -4536,18 +4536,12 @@ static int sgl_map_user_pages(struct st_buffer *STbp,
 		return -ENOMEM;
 
         /* Try to fault in all of the necessary pages */
-	down_read(&current->mm->mmap_sem);
         /* rw==READ means read from drive, write into memory area */
-	res = get_user_pages(
-		current,
-		current->mm,
+	res = get_user_pages_fast(
 		uaddr,
 		nr_pages,
 		rw == READ,
-		0, /* don't force */
-		pages,
-		NULL);
-	up_read(&current->mm->mmap_sem);
+		pages);
 
 	/* Errors and no page mapped should return here */
 	if (res < nr_pages)
diff --git a/drivers/video/fbdev/pvr2fb.c b/drivers/video/fbdev/pvr2fb.c
index 167cfff..ff81f65 100644
--- a/drivers/video/fbdev/pvr2fb.c
+++ b/drivers/video/fbdev/pvr2fb.c
@@ -686,10 +686,7 @@ static ssize_t pvr2fb_write(struct fb_info *info, const char *buf,
 	if (!pages)
 		return -ENOMEM;
 
-	down_read(&current->mm->mmap_sem);
-	ret = get_user_pages(current, current->mm, (unsigned long)buf,
-			     nr_pages, WRITE, 0, pages, NULL);
-	up_read(&current->mm->mmap_sem);
+	ret = get_user_pages_fast((unsigned long)buf, nr_pages, WRITE, pages);
 
 	if (ret < nr_pages) {
 		nr_pages = ret;
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 32ba786..69f692d 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1197,6 +1197,13 @@ long get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
 		    unsigned long start, unsigned long nr_pages,
 		    int write, int force, struct page **pages,
 		    struct vm_area_struct **vmas);
+long get_user_pages_locked(struct task_struct *tsk, struct mm_struct *mm,
+		    unsigned long start, unsigned long nr_pages,
+		    int write, int force, struct page **pages,
+		    int *locked);
+long get_user_pages_unlocked(struct task_struct *tsk, struct mm_struct *mm,
+		    unsigned long start, unsigned long nr_pages,
+		    int write, int force, struct page **pages);
 int get_user_pages_fast(unsigned long start, int nr_pages, int write,
 			struct page **pages);
 struct kvec;
diff --git a/mm/gup.c b/mm/gup.c
index 91d044b..19e17ab 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -576,6 +576,134 @@ int fixup_user_fault(struct task_struct *tsk, struct mm_struct *mm,
 	return 0;
 }
 
+static inline long __get_user_pages_locked(struct task_struct *tsk,
+					   struct mm_struct *mm,
+					   unsigned long start,
+					   unsigned long nr_pages,
+					   int write, int force,
+					   struct page **pages,
+					   struct vm_area_struct **vmas,
+					   int *locked,
+					   bool immediate_unlock)
+{
+	int flags = FOLL_TOUCH;
+	long ret, pages_done;
+	bool lock_dropped;
+
+	if (locked) {
+		/* if VM_FAULT_RETRY can be returned, vmas become invalid */
+		BUG_ON(vmas);
+		/* check caller initialized locked */
+		BUG_ON(*locked != 1);
+	} else {
+		/*
+		 * Not really important, the value is irrelevant if
+		 * locked is NULL, but BUILD_BUG_ON costs nothing.
+		 */
+		BUILD_BUG_ON(immediate_unlock);
+	}
+
+	if (pages)
+		flags |= FOLL_GET;
+	if (write)
+		flags |= FOLL_WRITE;
+	if (force)
+		flags |= FOLL_FORCE;
+
+	pages_done = 0;
+	lock_dropped = false;
+	for (;;) {
+		ret = __get_user_pages(tsk, mm, start, nr_pages, flags, pages,
+				       vmas, locked);
+		if (!locked)
+			/* VM_FAULT_RETRY couldn't trigger, bypass */
+			return ret;
+
+		/* VM_FAULT_RETRY cannot return errors */
+		if (!*locked) {
+			BUG_ON(ret < 0);
+			BUG_ON(nr_pages == 1 && ret);
+		}
+
+		if (!pages)
+			/* If it's a prefault don't insist harder */
+			return ret;
+
+		if (ret > 0) {
+			nr_pages -= ret;
+			pages_done += ret;
+			if (!nr_pages)
+				break;
+		}
+		if (*locked) {
+			/* VM_FAULT_RETRY didn't trigger */
+			if (!pages_done)
+				pages_done = ret;
+			break;
+		}
+		/* VM_FAULT_RETRY triggered, so seek to the faulting offset */
+		pages += ret;
+		start += ret << PAGE_SHIFT;
+
+		/*
+		 * Repeat on the address that fired VM_FAULT_RETRY
+		 * without FAULT_FLAG_ALLOW_RETRY but with
+		 * FAULT_FLAG_TRIED.
+		 */
+		*locked = 1;
+		lock_dropped = true;
+		down_read(&mm->mmap_sem);
+		ret = __get_user_pages(tsk, mm, start, nr_pages, flags | FOLL_TRIED,
+				       pages, NULL, NULL);
+		if (ret != 1) {
+			BUG_ON(ret > 1);
+			if (!pages_done)
+				pages_done = ret;
+			break;
+		}
+		nr_pages--;
+		pages_done++;
+		if (!nr_pages)
+			break;
+		pages++;
+		start += PAGE_SIZE;
+	}
+	if (!immediate_unlock && lock_dropped && *locked) {
+		/*
+		 * We must let the caller know we temporarily dropped the lock
+		 * and so the critical section protected by it was lost.
+		 */
+		up_read(&mm->mmap_sem);
+		*locked = 0;
+	}
+	return pages_done;
+}
+
+long get_user_pages_locked(struct task_struct *tsk, struct mm_struct *mm,
+			   unsigned long start, unsigned long nr_pages,
+			   int write, int force, struct page **pages,
+			   int *locked)
+{
+	return __get_user_pages_locked(tsk, mm, start, nr_pages, write, force,
+				       pages, NULL, locked, false);
+}
+EXPORT_SYMBOL(get_user_pages_locked);
+
+long get_user_pages_unlocked(struct task_struct *tsk, struct mm_struct *mm,
+			     unsigned long start, unsigned long nr_pages,
+			     int write, int force, struct page **pages)
+{
+	long ret;
+	int locked = 1;
+	down_read(&mm->mmap_sem);
+	ret = __get_user_pages_locked(tsk, mm, start, nr_pages, write, force,
+				      pages, NULL, &locked, true);
+	if (locked)
+		up_read(&mm->mmap_sem);
+	return ret;
+}
+EXPORT_SYMBOL(get_user_pages_unlocked);
+
 /*
  * get_user_pages() - pin user pages in memory
  * @tsk:	the task_struct to use for page fault accounting, or
@@ -625,22 +753,19 @@ int fixup_user_fault(struct task_struct *tsk, struct mm_struct *mm,
  * use the correct cache flushing APIs.
  *
  * See also get_user_pages_fast, for performance critical applications.
+ *
+ * get_user_pages should be gradually obsoleted in favor of
+ * get_user_pages_locked|unlocked. Nothing should use get_user_pages
+ * because it cannot pass FAULT_FLAG_ALLOW_RETRY to handle_mm_fault in
+ * turn disabling the userfaultfd feature (after that "inline" can be
+ * cleaned up from get_user_pages_locked).
  */
 long get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
 		unsigned long start, unsigned long nr_pages, int write,
 		int force, struct page **pages, struct vm_area_struct **vmas)
 {
-	int flags = FOLL_TOUCH;
-
-	if (pages)
-		flags |= FOLL_GET;
-	if (write)
-		flags |= FOLL_WRITE;
-	if (force)
-		flags |= FOLL_FORCE;
-
-	return __get_user_pages(tsk, mm, start, nr_pages, flags, pages, vmas,
-				NULL);
+	return __get_user_pages_locked(tsk, mm, start, nr_pages, write, force,
+				       pages, vmas, NULL, false);
 }
 EXPORT_SYMBOL(get_user_pages);
 
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 8f5330d..6606c10 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -881,7 +881,7 @@ static int lookup_node(struct mm_struct *mm, unsigned long addr)
 	struct page *p;
 	int err;
 
-	err = get_user_pages(current, mm, addr & PAGE_MASK, 1, 0, 0, &p, NULL);
+	err = get_user_pages_fast(addr & PAGE_MASK, 1, 0, &p);
 	if (err >= 0) {
 		err = page_to_nid(p);
 		put_page(p);
diff --git a/mm/nommu.c b/mm/nommu.c
index a881d96..8a06341 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -213,6 +213,29 @@ long get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
 }
 EXPORT_SYMBOL(get_user_pages);
 
+long get_user_pages_locked(struct task_struct *tsk, struct mm_struct *mm,
+			   unsigned long start, unsigned long nr_pages,
+			   int write, int force, struct page **pages,
+			   int *locked)
+{
+	return get_user_pages(tsk, mm, start, nr_pages, write, force,
+			      pages, NULL);
+}
+EXPORT_SYMBOL(get_user_pages_locked);
+
+long get_user_pages_unlocked(struct task_struct *tsk, struct mm_struct *mm,
+			     unsigned long start, unsigned long nr_pages,
+			     int write, int force, struct page **pages)
+{
+	long ret;
+	down_read(&mm->mmap_sem);
+	ret = get_user_pages(tsk, mm, start, nr_pages, write, force,
+			     pages, NULL);
+	up_read(&mm->mmap_sem);
+	return ret;
+}
+EXPORT_SYMBOL(get_user_pages_unlocked);
+
 /**
  * follow_pfn - look up PFN at a user virtual address
  * @vma: memory mapping
diff --git a/mm/process_vm_access.c b/mm/process_vm_access.c
index 5077afc..b159769 100644
--- a/mm/process_vm_access.c
+++ b/mm/process_vm_access.c
@@ -99,11 +99,8 @@ static int process_vm_rw_single_vec(unsigned long addr,
 		size_t bytes;
 
 		/* Get the pages we're interested in */
-		down_read(&mm->mmap_sem);
-		pages = get_user_pages(task, mm, pa, pages,
-				      vm_write, 0, process_pages, NULL);
-		up_read(&mm->mmap_sem);
-
+		pages = get_user_pages_unlocked(task, mm, pa, pages,
+						vm_write, 0, process_pages);
 		if (pages <= 0)
 			return -EFAULT;
 
diff --git a/mm/util.c b/mm/util.c
index 093c973..1b93f2d 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -247,14 +247,8 @@ int __weak get_user_pages_fast(unsigned long start,
 				int nr_pages, int write, struct page **pages)
 {
 	struct mm_struct *mm = current->mm;
-	int ret;
-
-	down_read(&mm->mmap_sem);
-	ret = get_user_pages(current, mm, start, nr_pages,
-					write, 0, pages, NULL);
-	up_read(&mm->mmap_sem);
-
-	return ret;
+	return get_user_pages_unlocked(current, mm, start, nr_pages,
+				       write, 0, pages);
 }
 EXPORT_SYMBOL_GPL(get_user_pages_fast);
 
diff --git a/net/ceph/pagevec.c b/net/ceph/pagevec.c
index 5550130..5504783 100644
--- a/net/ceph/pagevec.c
+++ b/net/ceph/pagevec.c
@@ -23,17 +23,16 @@ struct page **ceph_get_direct_page_vector(const void __user *data,
 	if (!pages)
 		return ERR_PTR(-ENOMEM);
 
-	down_read(&current->mm->mmap_sem);
 	while (got < num_pages) {
-		rc = get_user_pages(current, current->mm,
-		    (unsigned long)data + ((unsigned long)got * PAGE_SIZE),
-		    num_pages - got, write_page, 0, pages + got, NULL);
+		rc = get_user_pages_fast((unsigned long)data +
+					 ((unsigned long)got * PAGE_SIZE),
+					 num_pages - got,
+					 write_page, pages + got);
 		if (rc < 0)
 			break;
 		BUG_ON(rc == 0);
 		got += rc;
 	}
-	up_read(&current->mm->mmap_sem);
 	if (rc < 0)
 		goto fail;
 	return pages;


Then to make an example your patch would have become:

===
>From 74d88763cde285354fb78806ffb332030d1f0739 Mon Sep 17 00:00:00 2001
From: Andres Lagar-Cavilla <andreslc@google.com>
Date: Fri, 26 Sep 2014 18:36:56 +0200
Subject: [PATCH 2/2] kvm: Faults which trigger IO release the mmap_sem
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

When KVM handles a tdp fault it uses FOLL_NOWAIT. If the guest memory
has been swapped out or is behind a filemap, this will trigger async
readahead and return immediately. The rationale is that KVM will kick
back the guest with an "async page fault" and allow for some other
guest process to take over.

If async PFs are enabled the fault is retried asap from an async
workqueue. If not, it's retried immediately in the same code path. In
either case the retry will not relinquish the mmap semaphore and will
block on the IO. This is a bad thing, as other mmap semaphore users
now stall as a function of swap or filemap latency.

This patch ensures both the regular and async PF path re-enter the
fault allowing for the mmap semaphore to be relinquished in the case
of IO wait.

Reviewed-by: Radim Krčmář <rkrcmar@redhat.com>
Signed-off-by: Andres Lagar-Cavilla <andreslc@google.com>
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
---
 include/linux/mm.h  | 1 +
 mm/gup.c            | 4 ++++
 virt/kvm/async_pf.c | 4 +---
 virt/kvm/kvm_main.c | 4 ++--
 4 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 69f692d..71dbe03 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1997,6 +1997,7 @@ static inline struct page *follow_page(struct vm_area_struct *vma,
 #define FOLL_HWPOISON	0x100	/* check page is hwpoisoned */
 #define FOLL_NUMA	0x200	/* force NUMA hinting page fault */
 #define FOLL_MIGRATION	0x400	/* wait for page to replace migration entry */
+#define FOLL_TRIED	0x800	/* a retry, previous pass started an IO */
 
 typedef int (*pte_fn_t)(pte_t *pte, pgtable_t token, unsigned long addr,
 			void *data);
diff --git a/mm/gup.c b/mm/gup.c
index 19e17ab..369b3f6 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -281,6 +281,10 @@ static int faultin_page(struct task_struct *tsk, struct vm_area_struct *vma,
 		fault_flags |= FAULT_FLAG_ALLOW_RETRY;
 	if (*flags & FOLL_NOWAIT)
 		fault_flags |= FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_RETRY_NOWAIT;
+	if (*flags & FOLL_TRIED) {
+		VM_WARN_ON_ONCE(fault_flags & FAULT_FLAG_ALLOW_RETRY);
+		fault_flags |= FAULT_FLAG_TRIED;
+	}
 
 	ret = handle_mm_fault(mm, vma, address, fault_flags);
 	if (ret & VM_FAULT_ERROR) {
diff --git a/virt/kvm/async_pf.c b/virt/kvm/async_pf.c
index d6a3d09..44660ae 100644
--- a/virt/kvm/async_pf.c
+++ b/virt/kvm/async_pf.c
@@ -80,9 +80,7 @@ static void async_pf_execute(struct work_struct *work)
 
 	might_sleep();
 
-	down_read(&mm->mmap_sem);
-	get_user_pages(NULL, mm, addr, 1, 1, 0, NULL, NULL);
-	up_read(&mm->mmap_sem);
+	get_user_pages_unlocked(NULL, mm, addr, 1, 1, 0, NULL);
 	kvm_async_page_present_sync(vcpu, apf);
 
 	spin_lock(&vcpu->async_pf.lock);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 95519bc..921bce7 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1170,8 +1170,8 @@ static int hva_to_pfn_slow(unsigned long addr, bool *async, bool write_fault,
 					      addr, write_fault, page);
 		up_read(&current->mm->mmap_sem);
 	} else
-		npages = get_user_pages_fast(addr, 1, write_fault,
-					     page);
+		npages = get_user_pages_unlocked(current, current->mm, addr, 1,
+						 write_fault, 0, page);
 	if (npages != 1)
 		return npages;
 


This isn't bisectable in this order and it's untested anyway. It needs
more patchsplits.

This is just an initial RFC to know if it's ok to go into this
direction.

If it's ok I'll do some testing and submit it more properly. If your
patches goes in first it's fine and I'll just replace the call in KVM
to get_user_pages_unlocked (or whatever we want to call that thing).

I'd need to get this (or equivalent solution) merged before
re-submitting the userfaultfd patchset. I think the above benefits the
kernel as a whole in terms of mmap_sem holdtimes regardless of
userfaultfd so it should be good.

> Well, IIUC every code path that has ALLOW_RETRY dives in the second
> time with FAULT_TRIED or similar. In the common case, you happily
> blaze through the second time, but if someone raced in while all locks
> were given up, one pays the price of the second time being a full
> fault hogging the mmap sem. At some point you need to not keep being
> polite otherwise the task starves. Presumably the risk of an extra
> retry drops steeply every new gup retry. Maybe just try three times is
> good enough. It makes for ugly logic though.

I was under the idea that if one looped forever with VM_FAULT_RETRY
it'd eventually succeed, but it risks doing more work, so I'm also
sticking to the "locked != NULL" first, seek to the first page that
returned VM_FAULT_RETRY and issue a nr_pages=1 gup with locked ==
NULL, and then continue with locked != NULL at the next page. Just
like you did in the KVM slow path. And if "pages" array is NULL I bail
out at the first VM_FAULT_RETRY failure without insisting with further
gup calls of the "&locked" kind, your patch had just 1 page but you
also bailed out.

What this code above does is basically to generalize your optimization
to KVM and it makes it global and at the same time it avoids me
trouble in handle_userfault().

While at it I also converted some obvious candidate for gup_fast that
had no point in running slower (which I should split off in a separate
patch).

Thanks,
Andrea
