Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752885AbaBGPpb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 10:45:31 -0500
Received: from mta-out.inet.fi ([195.156.147.13]:47019 "EHLO jenni2.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752013AbaBGPpZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 10:45:25 -0500
Date: Fri, 7 Feb 2014 17:42:32 +0200
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Anvin <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ning Qu <quning@google.com>, Dave Hansen <dave.hansen@linux.intel.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>
Subject: [RFC, PATCH] mm: map few pages around fault address if they are in
 page cache
Message-ID: <20140207154232.GA18611@node.dhcp.inet.fi>
References: <CA+55aFzNxTtvNX7zqBELHs489e5mEx1sM=i=red=aQAGviXrNw@mail.gmail.com>
 <CA+55aFxpBkTn3LvSzxFj7ZoxuY=Rrg0OoAVuk5dK-ZLsO8kk4A@mail.gmail.com>
 <20140206005534.GA27848@node.dhcp.inet.fi>
 <CA+55aFx70seh4VD+=ZKHrjTCrinG0Hq3=X6ygCeOeuNCSG8n8Q@mail.gmail.com>
 <CA+55aFwfGVCVouh5uap3UPy92vc4N9OrRRa-NpYT9ZMicU6w8w@mail.gmail.com>
 <CA+55aFyq31f=30YeRbZbqgBFp13Zdk=Gb-UiLRqeR48MOfVwag@mail.gmail.com>
 <20140206222450.GA8823@node.dhcp.inet.fi>
 <CA+55aFysEbwfzJxVbZY6X+eEZ5KSgO5b8-S_a=-nrLj0sQfecA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFysEbwfzJxVbZY6X+eEZ5KSgO5b8-S_a=-nrLj0sQfecA@mail.gmail.com>
User-Agent: Mutt/1.5.22.1-rc1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 06, 2014 at 05:31:55PM -0800, Linus Torvalds wrote:
> On Thu, Feb 6, 2014 at 2:24 PM, Kirill A. Shutemov <kirill@shutemov.name> wrote:
> >
> > If we want to reduce number of page fault with less overhead we probably
> > should concentrate on minor page fault -- populate pte around fault
> > address which already in page cache. It should cover scripting use-case
> > pretty well.
> 
> That's what my patch largely does. Except I screwed up and didn't use
> FAULT_FLAG_ALLOW_RETRY in fault_around().

I fail to see how you avoid touching backing storage.

> Anyway, my patch kind of works, but I'm starting to hate it. I think I
> want to try to extend the "->fault()" interface to allow
> filemap_fault() to just fill in multiple pages.
> 
> We alread have that "vmf->page" thing, we could make it a small array
> easily. That would allow proper gang lookup, and much more efficient
> "fill in multiple entries in one go" in mm/memory.c.

See patch below.

I extended ->fault() interface: added pointer to array of pages and
nr_pages. If ->fault() nows about new interface and use it, it fills array
and set VM_FAULT_AROUND bit in return code. Only filemap_fault()
converted at the moment.

I haven't tested it much, but my kvm boots. There're few places where code
should be fixed. __do_fault() and filemap_fault() are too ugly and need to
be cleaned.

I don't have any performance data yet.

Any thoughts?

---
 include/linux/mm.h |  11 +++++
 mm/filemap.c       | 142 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
 mm/memory.c        |  58 ++++++++++++++++++++--
 3 files changed, 204 insertions(+), 7 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 35527173cf50..deb65c0850a9 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -181,6 +181,9 @@ extern pgprot_t protection_map[16];
 #define FAULT_FLAG_KILLABLE	0x20	/* The fault task is in SIGKILL killable region */
 #define FAULT_FLAG_TRIED	0x40	/* second try */
 #define FAULT_FLAG_USER		0x80	/* The fault originated in userspace */
+#define FAULT_FLAG_AROUND	0x100	/* Get ->nr_pages pages around fault
+					 * address
+					 */
 
 /*
  * vm_fault is filled by the the pagefault handler and passed to the vma's
@@ -200,6 +203,13 @@ struct vm_fault {
 					 * is set (which is also implied by
 					 * VM_FAULT_ERROR).
 					 */
+
+	int nr_pages;			/* Number of pages to faultin, naturally
+					 * aligned around virtual_address
+					 */
+	struct page **pages;		/* Pointer to array to store nr_pages
+					 * pages.
+					 */
 };
 
 /*
@@ -962,6 +972,7 @@ static inline int page_mapped(struct page *page)
 #define VM_FAULT_LOCKED	0x0200	/* ->fault locked the returned page */
 #define VM_FAULT_RETRY	0x0400	/* ->fault blocked, must retry */
 #define VM_FAULT_FALLBACK 0x0800	/* huge page fault failed, fall back to small */
+#define VM_FAULT_AROUND 0x1000
 
 #define VM_FAULT_HWPOISON_LARGE_MASK 0xf000 /* encodes hpage index for large hwpoison */
 
diff --git a/mm/filemap.c b/mm/filemap.c
index b7749a92021c..1cabb15a5847 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -884,6 +884,64 @@ repeat:
 	return ret;
 }
 
+void find_get_pages_or_null(struct address_space *mapping, pgoff_t start,
+			    unsigned int nr_pages, struct page **pages)
+{
+	struct radix_tree_iter iter;
+	void **slot;
+
+	if (unlikely(!nr_pages))
+		return;
+
+	memset(pages, 0, sizeof(struct page *) * nr_pages);
+
+	rcu_read_lock();
+restart:
+	radix_tree_for_each_slot(slot, &mapping->page_tree, &iter, start) {
+		struct page *page;
+repeat:
+		page = radix_tree_deref_slot(slot);
+		if (unlikely(!page))
+			continue;
+
+		if (radix_tree_exception(page)) {
+			if (radix_tree_deref_retry(page)) {
+				/*
+				 * Transient condition which can only trigger
+				 * when entry at index 0 moves out of or back
+				 * to root: none yet gotten, safe to restart.
+				 */
+				WARN_ON(iter.index);
+				goto restart;
+			}
+			/*
+			 * Otherwise, shmem/tmpfs must be storing a swap entry
+			 * here as an exceptional entry: so skip over it -
+			 * we only reach this from invalidate_mapping_pages().
+			 */
+			continue;
+		}
+
+		if (!page_cache_get_speculative(page))
+			goto repeat;
+
+		if (page->index - start >= nr_pages) {
+			page_cache_release(page);
+			break;
+		}
+
+		/* Has the page moved? */
+		if (unlikely(page != *slot)) {
+			page_cache_release(page);
+			goto repeat;
+		}
+
+		pages[page->index - start] = page;
+	}
+
+	rcu_read_unlock();
+}
+
 /**
  * find_get_pages_contig - gang contiguous pagecache lookup
  * @mapping:	The address_space to search
@@ -1595,6 +1653,67 @@ static void do_async_mmap_readahead(struct vm_area_struct *vma,
 					   page, offset, ra->ra_pages);
 }
 
+static void lock_secondary_pages(struct vm_area_struct *vma,
+		struct vm_fault *vmf)
+{
+	struct file *file = vma->vm_file;
+	struct address_space *mapping = file->f_mapping;
+	unsigned long address = (unsigned long)vmf->virtual_address;
+	int primary_idx = (address >> PAGE_SHIFT) & (vmf->nr_pages - 1);
+	pgoff_t size;
+	int i;
+
+	for (i = 0; i < vmf->nr_pages; i++) {
+		unsigned long addr = address + PAGE_SIZE * (i - primary_idx);
+
+		if (i == primary_idx || !vmf->pages[i])
+			continue;
+
+		if (addr < vma->vm_start || addr >= vma->vm_end)
+			goto put;
+		if (!trylock_page(vmf->pages[i]))
+			goto put;
+		/* Truncated? */
+		if (unlikely(vmf->pages[i]->mapping != mapping))
+			goto unlock;
+
+		if (unlikely(!PageUptodate(vmf->pages[i])))
+			goto unlock;
+
+		/*
+		 * We have a locked page in the page cache, now we need to
+		 * check that it's up-to-date. If not, it is going to be due to
+		 * an error.
+		 */
+		size = (i_size_read(mapping->host) + PAGE_CACHE_SIZE - 1)
+			>> PAGE_CACHE_SHIFT;
+		if (unlikely(vmf->pages[i]->index >= size))
+			goto unlock;
+
+		continue;
+unlock:
+		unlock_page(vmf->pages[i]);
+put:
+		put_page(vmf->pages[i]);
+		vmf->pages[i] = NULL;
+	}
+}
+
+static void unlock_and_put_secondary_pages(struct vm_fault *vmf)
+{
+	unsigned long address = (unsigned long)vmf->virtual_address;
+	int primary_idx = (address >> PAGE_SHIFT) & (vmf->nr_pages - 1);
+	int i;
+
+	for (i = 0; i < vmf->nr_pages; i++) {
+		if (i == primary_idx || !vmf->pages[i])
+			continue;
+		unlock_page(vmf->pages[i]);
+		page_cache_release(vmf->pages[i]);
+		vmf->pages[i] = NULL;
+	}
+}
+
 /**
  * filemap_fault - read in file data for page fault handling
  * @vma:	vma in which the fault was taken
@@ -1617,6 +1736,8 @@ int filemap_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 	pgoff_t offset = vmf->pgoff;
 	struct page *page;
 	pgoff_t size;
+	unsigned long address = (unsigned long)vmf->virtual_address;
+	int primary_idx = (address >> PAGE_SHIFT) & (vmf->nr_pages - 1);
 	int ret = 0;
 
 	size = (i_size_read(inode) + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
@@ -1626,7 +1747,15 @@ int filemap_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 	/*
 	 * Do we have something in the page cache already?
 	 */
-	page = find_get_page(mapping, offset);
+	if (vmf->flags & FAULT_FLAG_AROUND) {
+		find_get_pages_or_null(mapping, offset - primary_idx,
+				vmf->nr_pages, vmf->pages);
+		page = vmf->pages[primary_idx];
+		lock_secondary_pages(vma, vmf);
+		ret |= VM_FAULT_AROUND;
+	} else
+		page = find_get_page(mapping, offset);
+
 	if (likely(page) && !(vmf->flags & FAULT_FLAG_TRIED)) {
 		/*
 		 * We found the page, so try async readahead before
@@ -1638,14 +1767,18 @@ int filemap_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 		do_sync_mmap_readahead(vma, ra, file, offset);
 		count_vm_event(PGMAJFAULT);
 		mem_cgroup_count_vm_event(vma->vm_mm, PGMAJFAULT);
-		ret = VM_FAULT_MAJOR;
+		ret |= VM_FAULT_MAJOR;
 retry_find:
 		page = find_get_page(mapping, offset);
 		if (!page)
 			goto no_cached_page;
+		if (vmf->flags & FAULT_FLAG_AROUND)
+			vmf->pages[primary_idx] = page;
 	}
 
 	if (!lock_page_or_retry(page, vma->vm_mm, vmf->flags)) {
+		unlock_and_put_secondary_pages(vmf);
+		ret &= ~VM_FAULT_AROUND;
 		page_cache_release(page);
 		return ret | VM_FAULT_RETRY;
 	}
@@ -1671,6 +1804,7 @@ retry_find:
 	 */
 	size = (i_size_read(inode) + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
 	if (unlikely(offset >= size)) {
+		unlock_and_put_secondary_pages(vmf);
 		unlock_page(page);
 		page_cache_release(page);
 		return VM_FAULT_SIGBUS;
@@ -1694,6 +1828,8 @@ no_cached_page:
 	if (error >= 0)
 		goto retry_find;
 
+	unlock_and_put_secondary_pages(vmf);
+
 	/*
 	 * An error return from page_cache_read can result if the
 	 * system is low on memory, or a problem occurs while trying
@@ -1722,6 +1858,8 @@ page_not_uptodate:
 	if (!error || error == AOP_TRUNCATED_PAGE)
 		goto retry_find;
 
+	unlock_and_put_secondary_pages(vmf);
+
 	/* Things didn't work out. Return zero to tell the mm layer so. */
 	shrink_readahead_size_eio(file, ra);
 	return VM_FAULT_SIGBUS;
diff --git a/mm/memory.c b/mm/memory.c
index 6768ce9e57d2..e94d86ac7d5a 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3283,6 +3283,9 @@ oom:
 	return VM_FAULT_OOM;
 }
 
+#define FAULT_AROUND_PAGES 32
+#define FAULT_AROUND_MASK (FAULT_AROUND_PAGES - 1)
+
 /*
  * __do_fault() tries to create a new page mapping. It aggressively
  * tries to share with existing pages, but makes a separate copy if
@@ -3303,12 +3306,13 @@ static int __do_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 	pte_t *page_table;
 	spinlock_t *ptl;
 	struct page *page;
+	struct page *pages[FAULT_AROUND_PAGES];
 	struct page *cow_page;
 	pte_t entry;
 	int anon = 0;
 	struct page *dirty_page = NULL;
 	struct vm_fault vmf;
-	int ret;
+	int i, ret;
 	int page_mkwrite = 0;
 
 	/*
@@ -3336,14 +3340,35 @@ static int __do_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 	vmf.flags = flags;
 	vmf.page = NULL;
 
+	/* Do fault around only for read faults on linear mapping */
+	if (flags & (FAULT_FLAG_WRITE | FAULT_FLAG_NONLINEAR)) {
+		vmf.nr_pages = 0;
+		vmf.pages = NULL;
+	} else {
+		vmf.nr_pages = FAULT_AROUND_PAGES;
+		vmf.pages = pages;
+		vmf.flags |= FAULT_FLAG_AROUND;
+	}
 	ret = vma->vm_ops->fault(vma, &vmf);
+
+	/* ->fault don't know about FAULT_FLAG_AROUND */
+	if ((vmf.flags & FAULT_FLAG_AROUND) && !(ret & VM_FAULT_AROUND)) {
+		vmf.flags &= ~FAULT_FLAG_AROUND;
+	}
 	if (unlikely(ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE |
 			    VM_FAULT_RETRY)))
 		goto uncharge_out;
 
 	if (unlikely(PageHWPoison(vmf.page))) {
-		if (ret & VM_FAULT_LOCKED)
-			unlock_page(vmf.page);
+		if (ret & VM_FAULT_LOCKED) {
+			if (vmf.flags & FAULT_FLAG_AROUND) {
+				for (i = 0; i < FAULT_AROUND_PAGES; i++) {
+					if (pages[i])
+						unlock_page(pages[i]);
+				}
+			} else
+				unlock_page(vmf.page);
+		}
 		ret = VM_FAULT_HWPOISON;
 		goto uncharge_out;
 	}
@@ -3352,9 +3377,10 @@ static int __do_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 	 * For consistency in subsequent calls, make the faulted page always
 	 * locked.
 	 */
-	if (unlikely(!(ret & VM_FAULT_LOCKED)))
+	if (unlikely(!(ret & VM_FAULT_LOCKED))) {
+		BUG_ON(ret & VM_FAULT_AROUND); // FIXME
 		lock_page(vmf.page);
-	else
+	} else
 		VM_BUG_ON(!PageLocked(vmf.page));
 
 	/*
@@ -3401,6 +3427,28 @@ static int __do_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 
 	page_table = pte_offset_map_lock(mm, pmd, address, &ptl);
 
+	for (i = 0; (vmf.flags & FAULT_FLAG_AROUND) && i < FAULT_AROUND_PAGES;
+			i++) {
+		int primary_idx = (address >> PAGE_SHIFT) & FAULT_AROUND_MASK;
+		pte_t *pte = page_table - primary_idx + i;
+		unsigned long addr = address + PAGE_SIZE * (i - primary_idx);
+
+		if (!pages[i])
+			continue;
+		if (i == primary_idx || !pte_none(*pte))
+			goto skip;
+		if (PageHWPoison(vmf.page))
+			goto skip;
+		flush_icache_page(vma, pages[i]);
+		entry = mk_pte(pages[i], vma->vm_page_prot);
+		inc_mm_counter_fast(mm, MM_FILEPAGES);
+		page_add_file_rmap(pages[i]);
+		set_pte_at(mm, addr, pte, entry);
+		update_mmu_cache(vma, addr, pte);
+skip:
+		unlock_page(pages[i]);
+	}
+
 	/*
 	 * This silly early PAGE_DIRTY setting removes a race
 	 * due to the bad i386 page protection. But it's valid
-- 
 Kirill A. Shutemov
