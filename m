Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751840Ab3LJWDf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 17:03:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:16666 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750976Ab3LJWDc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 17:03:32 -0500
Date: Tue, 10 Dec 2013 17:02:51 -0500
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Darren Hart <dvhart@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>
Subject: Re: process 'stuck' at exit.
Message-ID: <20131210220251.GB5050@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Oleg Nesterov <oleg@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Darren Hart <dvhart@linux.intel.com>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>
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
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

So, a reason that this might only be showing up now, is that in the last
week I added support to trinity to explicitly do huge page mmaps in the children,
whereas before it only ever did that with MAP_SHARED in the main pid, and then
every child inherited them on fork().

	Dave

