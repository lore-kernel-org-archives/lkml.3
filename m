Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751849Ab3LKRzt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 12:55:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55214 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751508Ab3LKRzs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 12:55:48 -0500
Date: Wed, 11 Dec 2013 18:56:15 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>, Darren Hart <dvhart@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>
Subject: Re: process 'stuck' at exit.
Message-ID: <20131211175615.GA24546@redhat.com>
References: <CA+55aFzLnheC6W+Db=-MVr6aR5UzP-c1Q1yk_aN-9gxSjUpANw@mail.gmail.com> <20131210203559.GA1209@redhat.com> <20131210204925.GB27373@redhat.com> <20131210213431.GA6342@redhat.com> <20131210214143.GG27373@redhat.com> <CA+55aFwr2e5x13fA+QWjt=iJFmCcugFErdqaeeUtH4XPBExC6Q@mail.gmail.com> <CA+55aFxLbFWhgzg=Rn0rhUpoOjbTE3QqUSxHTsCyk8GjDUFxJg@mail.gmail.com> <CA+55aFw_emAUOr5BYx0TfTCGEOrW6-ZRATWbm00DvCXsGD7=DQ@mail.gmail.com> <20131211170844.GA21700@redhat.com> <alpine.DEB.2.02.1312111814010.28330@ionos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1312111814010.28330@ionos.tec.linutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/11, Thomas Gleixner wrote:
>
> On Wed, 11 Dec 2013, Oleg Nesterov wrote:
> >
> > I know almost nothing about THP, but why we may need write == true in
> > this case?
> >
> > IOW,
> >
> > > -		if (likely(__get_user_pages_fast(address, 1, 1, &page) == 1)) {
> > > +		if (likely(__get_user_pages_fast(address, 1, !ro, &page) == 1)) {
> >
> > can't
> > 		if (likely(__get_user_pages_fast(address, 1, 0, &page) == 1)) {
> >
> > work?
>
> If the futex call needs to write to that address, we need a writeable
> mapping, right? And get_user_pages_fast() will verify that for us.

Yes sure. I meant __get_user_pages_fast() which is called to find
page_head.

> > I have to admit, I do not understand why we can't avoid this altogether.
> >
> > __get_page_tail() can find the stable ->first_page, why get_futex_key()
> > can't ?
>
> Because it can be split under us.

I understand, but why we can't rely on compound_lock() like
__get_page_tail() does?

OK, could you please explain why something like the pseudo-code
below can't work?

Oleg.


--- x/mm/swap.c
+++ x/mm/swap.c
@@ -210,7 +210,7 @@ EXPORT_SYMBOL(put_page);
  * This function is exported but must not be called by anything other
  * than get_page(). It implements the slow path of get_page().
  */
-bool __get_page_tail(struct page *page)
+struct page *__get_page_tail(struct page *page)
 {
 	/*
 	 * This takes care of get_page() if run on a tail page
@@ -235,7 +235,7 @@ bool __get_page_tail(struct page *page)
 				 */
 				VM_BUG_ON(!PageHead(page_head));
 				__get_page_tail_foll(page, false);
-				return true;
+				return page_head;
 			} else {
 				/*
 				 * __split_huge_page_refcount run
@@ -247,7 +247,7 @@ bool __get_page_tail(struct page *page)
 				 * slab on x86).
 				 */
 				put_page(page_head);
-				return false;
+				return NULL;
 			}
 		}
 
@@ -264,10 +264,12 @@ bool __get_page_tail(struct page *page)
 			got = true;
 		}
 		compound_unlock_irqrestore(page_head, flags);
-		if (unlikely(!got))
+		if (likely(got))
+			return page_head;
+		else
 			put_page(page_head);
 	}
-	return got;
+	return NULL;
 }
 EXPORT_SYMBOL(__get_page_tail);
 
--- x/kernel/futex.c
+++ x/kernel/futex.c
@@ -282,41 +282,11 @@ again:
 	else
 		err = 0;
 
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	page_head = page;
-	if (unlikely(PageTail(page))) {
+	page_head = __get_page_tail(page);
+	if (page_head) {
 		put_page(page);
-		/* serialize against __split_huge_page_splitting() */
-		local_irq_disable();
-		if (likely(__get_user_pages_fast(address, 1, 1, &page) == 1)) {
-			page_head = compound_head(page);
-			/*
-			 * page_head is valid pointer but we must pin
-			 * it before taking the PG_lock and/or
-			 * PG_compound_lock. The moment we re-enable
-			 * irqs __split_huge_page_splitting() can
-			 * return and the head page can be freed from
-			 * under us. We can't take the PG_lock and/or
-			 * PG_compound_lock on a page that could be
-			 * freed from under us.
-			 */
-			if (page != page_head) {
-				get_page(page_head);
-				put_page(page);
-			}
-			local_irq_enable();
-		} else {
-			local_irq_enable();
-			goto again;
-		}
-	}
-#else
-	page_head = compound_head(page);
-	if (page != page_head) {
-		get_page(page_head);
-		put_page(page);
-	}
-#endif
+	else
+		page_head = page;
 
 	lock_page(page_head);
 

