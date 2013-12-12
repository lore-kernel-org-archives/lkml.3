Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752067Ab3LLTBl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 14:01:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32452 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751853Ab3LLTBk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 14:01:40 -0500
Date: Thu, 12 Dec 2013 20:00:54 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Jones <davej@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Darren Hart <dvhart@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>
Subject: Re: process 'stuck' at exit.
Message-ID: <20131212190054.GC5408@redhat.com>
References: <20131210154724.GA30020@redhat.com>
 <CA+55aFxgFAfcQKDoDhmJcCRb5pfxumxJ9OmpUhhNzs+CY_Yqqw@mail.gmail.com>
 <alpine.DEB.2.02.1312102001090.28330@ionos.tec.linutronix.de>
 <CA+55aFzLnheC6W+Db=-MVr6aR5UzP-c1Q1yk_aN-9gxSjUpANw@mail.gmail.com>
 <20131210203559.GA1209@redhat.com>
 <20131210204925.GB27373@redhat.com>
 <20131210213431.GA6342@redhat.com>
 <20131210214143.GG27373@redhat.com>
 <CA+55aFwr2e5x13fA+QWjt=iJFmCcugFErdqaeeUtH4XPBExC6Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwr2e5x13fA+QWjt=iJFmCcugFErdqaeeUtH4XPBExC6Q@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Dec 10, 2013 at 01:57:49PM -0800, Linus Torvalds wrote:
> On Tue, Dec 10, 2013 at 1:41 PM, Dave Jones <davej@redhat.com> wrote:
> >
> > http://codemonkey.org.uk/junk/trace
> 
> Hmm. Ok, so something is calling [__]get_user_pages_fast() and
> put_page() in a loop, but the trace doesn't show what that "something"
> is, because it is itself not ever called.
> 
> However, that pattern does seem to imply that the loop is in
> get_futex_key(), because all the other loops I see seem to be calling
> other things as well.
> 
> And the __get_user_pages_fast() call implies that it's the THP case
> that triggers the "unlikely(PageTail(page))" case. And anyway,
> otherwise we'd see lock_page()/unlock_page() too.
> 
> So it looks like __get_user_pages_fast() fails, and keeps failing.
> Andrea, this is your code, any ideas? Commit a5b338f2b0b1f ("thp:
> update futex compound knowledge") to be exact.

I can only agree that the __get_user_pages_fast "write" parameter
should have been !ro instead of 1.

However it wasn't me introducing the bug, my code when patched in
early 2011 would work fine. The bug was introduced half a year later
in commit 9ea71503a8ed9184d2d0b8ccc4d269d05f7940ae .

@@ -262,8 +264,18 @@ get_futex_key(u32 __user *uaddr, int fshared, union futex_key *key)
 
 again:
        err = get_user_pages_fast(address, 1, 1, &page);
+       /*
+        * If write access is not required (eg. FUTEX_WAIT), try
+        * and get read-only access.
+        */
+       if (err == -EFAULT && rw == VERIFY_READ) {
+               err = get_user_pages_fast(address, 1, 0, &page);
+               ro = 1;
+       }
        if (err < 0)
                return err;
+       else
+               err = 0;
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
        page_head = page;
@@ -305,6 +317,13 @@ again:
        if (!page_head->mapping) {
                unlock_page(page_head);
                put_page(page_head);
+               /*
+               * ZERO_PAGE pages don't have a mapping. Avoid a busy
        loop
+               * trying to find one. RW mapping would have COW'd (and
        thus
+               * have a mapping) so this page is RO and won't ever
        change.
+               */
+               if ((page_head == ZERO_PAGE(address)))
+                       return -EFAULT;
                goto again;
        }

[..]

This commit didn't update the __get_user_pages_fast to use !ro instead
of 1, as it would have been required after the above change.

I'll now review Oleg proposed cleanup.

Thanks for tracking this down!

Andrea
