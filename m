Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751767Ab3LKTSd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 14:18:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35666 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750945Ab3LKTSa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 14:18:30 -0500
Date: Wed, 11 Dec 2013 20:18:55 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>, Darren Hart <dvhart@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>
Subject: PATCH? introduce get_compound_page (Was: process 'stuck' at exit)
Message-ID: <20131211191855.GA32485@redhat.com>
References: <20131210203559.GA1209@redhat.com> <20131210204925.GB27373@redhat.com> <20131210213431.GA6342@redhat.com> <20131210214143.GG27373@redhat.com> <CA+55aFwr2e5x13fA+QWjt=iJFmCcugFErdqaeeUtH4XPBExC6Q@mail.gmail.com> <CA+55aFxLbFWhgzg=Rn0rhUpoOjbTE3QqUSxHTsCyk8GjDUFxJg@mail.gmail.com> <CA+55aFw_emAUOr5BYx0TfTCGEOrW6-ZRATWbm00DvCXsGD7=DQ@mail.gmail.com> <20131211170844.GA21700@redhat.com> <alpine.DEB.2.02.1312111814010.28330@ionos.tec.linutronix.de> <20131211175615.GA24546@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131211175615.GA24546@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/11, Oleg Nesterov wrote:
>
> On 12/11, Thomas Gleixner wrote:
> >
> > On Wed, 11 Dec 2013, Oleg Nesterov wrote:
> > >
> > > I have to admit, I do not understand why we can't avoid this altogether.
> > >
> > > __get_page_tail() can find the stable ->first_page, why get_futex_key()
> > > can't ?
> >
> > Because it can be split under us.
>
> I understand, but why we can't rely on compound_lock() like
> __get_page_tail() does?
>
> OK, could you please explain why something like the pseudo-code
> below can't work?

Seriously. Can the path below work?

With this change get_futex_key() can simply do

	page_head = get_compound_head(page);
	if (page_head)
		put_page(page);
	else
		page_head = page;

instead of CONFIG_TRANSPARENT_HUGEPAGE/else code.

(and we can also remove "bool get_page_head" from __get_page_tail_foll).

I am sure I missed something. But I am curious and I'd like to understand
what I have missed.

Thanks,

Oleg.

--- a/mm/swap.c
+++ b/mm/swap.c
@@ -210,7 +210,7 @@ EXPORT_SYMBOL(put_page);
  * This function is exported but must not be called by anything other
  * than get_page(). It implements the slow path of get_page().
  */
-bool __get_page_tail(struct page *page)
+static struct page *__get_compound_head(struct page *page, bool and_tail)
 {
 	/*
 	 * This takes care of get_page() if run on a tail page
@@ -234,8 +234,9 @@ bool __get_page_tail(struct page *page)
 				 * cannot race here.
 				 */
 				VM_BUG_ON(!PageHead(page_head));
-				__get_page_tail_foll(page, false);
-				return true;
+				if (and_tail)
+					get_huge_page_tail(page);
+				return page_head;
 			} else {
 				/*
 				 * __split_huge_page_refcount run
@@ -260,17 +261,34 @@ bool __get_page_tail(struct page *page)
 		flags = compound_lock_irqsave(page_head);
 		/* here __split_huge_page_refcount won't run anymore */
 		if (likely(PageTail(page))) {
-			__get_page_tail_foll(page, false);
+			if (and_tail)
+				get_huge_page_tail(page);
 			got = true;
 		}
 		compound_unlock_irqrestore(page_head, flags);
-		if (unlikely(!got))
+
+		if (likely(got))
+			return page_head;
+		else
 			put_page(page_head);
 	}
-	return got;
+	return NULL;
+}
+
+bool __get_page_tail(struct page *page)
+{
+	return !!__get_compound_head(page, true);
 }
 EXPORT_SYMBOL(__get_page_tail);
 
+struct page *get_compound_head(struct page *page)
+{
+	if (PageTail(page))
+		return __get_compound_head(page, false);
+	else
+		return NULL;
+}
+
 /**
  * put_pages_list() - release a list of pages
  * @pages: list of pages threaded on page->lru

