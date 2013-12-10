Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751928Ab3LJV56 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 16:57:58 -0500
Received: from mail-vc0-f182.google.com ([209.85.220.182]:50673 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834Ab3LJV5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 16:57:50 -0500
MIME-Version: 1.0
In-Reply-To: <20131210214143.GG27373@redhat.com>
References: <20131210154724.GA30020@redhat.com>
	<CA+55aFxgFAfcQKDoDhmJcCRb5pfxumxJ9OmpUhhNzs+CY_Yqqw@mail.gmail.com>
	<alpine.DEB.2.02.1312102001090.28330@ionos.tec.linutronix.de>
	<CA+55aFzLnheC6W+Db=-MVr6aR5UzP-c1Q1yk_aN-9gxSjUpANw@mail.gmail.com>
	<20131210203559.GA1209@redhat.com>
	<20131210204925.GB27373@redhat.com>
	<20131210213431.GA6342@redhat.com>
	<20131210214143.GG27373@redhat.com>
Date: Tue, 10 Dec 2013 13:57:49 -0800
X-Google-Sender-Auth: 5gWOuwauOrtKwE1vlpdsPrJBUIA
Message-ID: <CA+55aFwr2e5x13fA+QWjt=iJFmCcugFErdqaeeUtH4XPBExC6Q@mail.gmail.com>
Subject: Re: process 'stuck' at exit.
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Jones <davej@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Darren Hart <dvhart@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 10, 2013 at 1:41 PM, Dave Jones <davej@redhat.com> wrote:
>
> http://codemonkey.org.uk/junk/trace

Hmm. Ok, so something is calling [__]get_user_pages_fast() and
put_page() in a loop, but the trace doesn't show what that "something"
is, because it is itself not ever called.

However, that pattern does seem to imply that the loop is in
get_futex_key(), because all the other loops I see seem to be calling
other things as well.

And the __get_user_pages_fast() call implies that it's the THP case
that triggers the "unlikely(PageTail(page))" case. And anyway,
otherwise we'd see lock_page()/unlock_page() too.

So it looks like __get_user_pages_fast() fails, and keeps failing.
Andrea, this is your code, any ideas? Commit a5b338f2b0b1f ("thp:
update futex compound knowledge") to be exact.

                   Linus
