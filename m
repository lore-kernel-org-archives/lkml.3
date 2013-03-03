Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754718Ab3CCWvQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 17:51:16 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:59940 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754551Ab3CCWvP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 17:51:15 -0500
Date: Sun, 3 Mar 2013 22:51:10 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, David Miller <davem@davemloft.net>
Subject: Re: [RFC][PATCH] making vfree() safe from interrupt contexts
Message-ID: <20130303225110.GQ4503@ZenIV.linux.org.uk>
References: <20130303184736.GM4503@ZenIV.linux.org.uk>
 <CA+55aFzxNKDdJsjT-xtv_XEWkCstFxN4hhhPz078p4LJZuHD2Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzxNKDdJsjT-xtv_XEWkCstFxN4hhhPz078p4LJZuHD2Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 03, 2013 at 02:34:00PM -0800, Linus Torvalds wrote:
> On Sun, Mar 3, 2013 at 10:47 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> >         To bring back the thing discussed back in, IIRC, December: we have
> > a bunch of places where inability to do vfree() from interrupt contexts
> > (the most common case is doing that from RCU callback) leads to very
> > ugly open-coded schemes that delay it one way or another.  We can let vfree()
> > itself do that instead.  AFAICS, it works; the diff below covers several
> > obvious cases found just by grep.  I'm fairly sure that there's more code
> > that could benefit from that...
> 
> I have nothing against the patch, but I hate seeing it just before I
> am getting ready to close the merge window.

Of course.  In any case, I want it to sit in -next for a cycle; the question
is, which tree would it be better in?

> And I'm not willing to apply it, since I think it's buggy: the whole
> point of deferred_vfree() is that it is for irq context, yet it's not
> using an irq-safe lock. So nested interrupts can deadlock.

Point.  It really should be spin_lock_irq(), not spin_lock_bh().  Another
good point, from Torsten Kaiser, is that vfree(NULL) should be usable
from interrupt contexts as well (as it were, none of the users introduced
in this patch do that, but we'd better not leave landmines for when somebody
does).

> So I think the concept is fine, the patch is probably fine after just
> changing the spinlock to be irq-safe, but the timing is horrible. It
> doesn't seem to be *that* urgent, so maybe you could just put it in
> your queue for 3.10 after fixing the irq locking?

Sure, no problem.  I'll put the following into e.g. vfs.git#vfree (on top
of -rc1, once you release it) and leave it in never-rebase mode.  Anyone
who cares to use it (netdev folks, for example) is welcome to pull that
sucker into their tree; I will pull it into vfs.git#for-next and do
fdtable stuff on top of that.  It's just that I got burnt on inter-tree
dependencies once and I'd rather avoid the experience...

Anybody with objections against that plan?  The patch below (again, *NOT*
intended for merge into mainline before -rc1) is just the mm/vmalloc.c
side of the things; it will end up in vfs.git#vfree, will never get rebased
and with it vfree() is safe to call from interrupt contexts, such as RCU
callbacks, etc.

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 0f751f2..0f53ca1 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -1176,6 +1176,32 @@ void __init vm_area_register_early(struct vm_struct *vm, size_t align)
 	vm_area_add_early(vm);
 }
 
+struct vfree_deferred {
+	spinlock_t lock;
+	void *list;
+	struct work_struct wq;
+};
+
+static DEFINE_PER_CPU(struct vfree_deferred, vfree_deferred);
+
+static void __vunmap(const void *, int);
+
+static void free_work(struct work_struct *w)
+{
+	struct vfree_deferred *p = container_of(w, struct vfree_deferred, wq);
+	void *list;
+
+	spin_lock_irq(&p->lock);
+	list = p->list;
+	p->list = NULL;
+	spin_unlock_irq(&p->lock);
+	while (list) {
+		void *next = *(void **)list;
+		__vunmap(list, 1);
+		list = next;
+	}
+}
+
 void __init vmalloc_init(void)
 {
 	struct vmap_area *va;
@@ -1184,10 +1210,15 @@ void __init vmalloc_init(void)
 
 	for_each_possible_cpu(i) {
 		struct vmap_block_queue *vbq;
+		struct vfree_deferred *p;
 
 		vbq = &per_cpu(vmap_block_queue, i);
 		spin_lock_init(&vbq->lock);
 		INIT_LIST_HEAD(&vbq->free);
+		p = &per_cpu(vfree_deferred, i);
+		spin_lock_init(&p->lock);
+		p->list = NULL;
+		INIT_WORK(&p->wq, free_work);
 	}
 
 	/* Import existing vmlist entries. */
@@ -1474,9 +1505,6 @@ static void __vunmap(const void *addr, int deallocate_pages)
 {
 	struct vm_struct *area;
 
-	if (!addr)
-		return;
-
 	if ((PAGE_SIZE-1) & (unsigned long)addr) {
 		WARN(1, KERN_ERR "Trying to vfree() bad address (%p)\n", addr);
 		return;
@@ -1512,6 +1540,17 @@ static void __vunmap(const void *addr, int deallocate_pages)
 	return;
 }
 
+static inline void deferred_vfree(void *addr)
+{
+	struct vfree_deferred *p = &get_cpu_var(vfree_deferred);
+	spin_lock(&p->lock);
+	*(void **)addr = p->list;
+	p->list = addr;
+	schedule_work(&p->wq);
+	spin_unlock(&p->lock);
+	put_cpu_var(vfree_deferred);
+}
+
 /**
  *	vfree  -  release memory allocated by vmalloc()
  *	@addr:		memory base address
@@ -1519,16 +1558,16 @@ static void __vunmap(const void *addr, int deallocate_pages)
  *	Free the virtually continuous memory area starting at @addr, as
  *	obtained from vmalloc(), vmalloc_32() or __vmalloc(). If @addr is
  *	NULL, no operation is performed.
- *
- *	Must not be called in interrupt context.
  */
 void vfree(const void *addr)
 {
-	BUG_ON(in_interrupt());
-
 	kmemleak_free(addr);
-
-	__vunmap(addr, 1);
+	if (!addr)
+		return;
+	if (unlikely(in_interrupt()))
+		deferred_vfree((void *)addr);
+	else
+		__vunmap(addr, 1);
 }
 EXPORT_SYMBOL(vfree);
 
@@ -1545,7 +1584,8 @@ void vunmap(const void *addr)
 {
 	BUG_ON(in_interrupt());
 	might_sleep();
-	__vunmap(addr, 0);
+	if (addr)
+		__vunmap(addr, 0);
 }
 EXPORT_SYMBOL(vunmap);
 
