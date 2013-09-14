Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756327Ab3INCSO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 22:18:14 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:45758 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756179Ab3INCSN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 22:18:13 -0400
Date: Sat, 14 Sep 2013 03:17:56 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Kees Cook <keescook@chromium.org>
Cc: Joe Perches <joe@perches.com>, George Spelvin <linux@horizon.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eldad Zack <eldad@fogrefinery.com>, Jan Beulich <jbeulich@suse.com>,
        Jiri Kosina <jkosina@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Subject: Re: [PATCH] vsprintf: drop comment claiming %n is ignored
Message-ID: <20130914021755.GY13318@ZenIV.linux.org.uk>
References: <20130913195335.18955.qmail@science.horizon.com>
 <1379111268.2066.22.camel@joe-AO722>
 <CAGXu5jJxJVK7cu2Sc4Sdng_rLDL8ziC6aecAi7G0zL4fYnY-9Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jJxJVK7cu2Sc4Sdng_rLDL8ziC6aecAi7G0zL4fYnY-9Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 13, 2013 at 04:03:25PM -0700, Kees Cook wrote:

> Maybe I missed this somewhere in the thread, but I'm not sure I
> understand the move to "void". Here's what I see, please correct me:
> 
> 1- seq_printf currently returns success/failure
> 2- some callers of seq_printf (correctly) use the return value as
> success/failure indication

Not all uses as success/failure are right, at that - you should *NOT*
return non-zero from ->show() on overflow.  Ever.  It should only
happen when you have a hard error and do *not* want the operation
retried.  On success ->show() returns zero - not the number of characters
written or anything like that.

> 3- some callers of seq_printf (incorrectly) use the return value as a
> length indication

> 4- both success/failure and length are important outputs from seq_printf

Not really.  Success/failure is used if you want to optimize ->show() a bit;
usually you don't.  Again, failure == overflow and it's both rare *and*
will cause all subsequent seq_...() to be no-ops until the retry.  Which
retry will follow.  Shortly.

> 5- we need a way to access the length written during the call

_Very_ rarely.  And I'd seriously suggest the use of %n in such cases.

> 6- want to minimize impact on the code base

Majority of the code base simply calls seq_printf() without caring what
it returns.  Very small minority is broken and needs to be fixed.

> Due to 1 and 2, it seems like there's no sense in changing the return
> value to void. Success/failure is already returned, and there are
> users of it. No sense changing them.

... most of them incorrect.

> The normal way to handle multiple return values (4 and 5) is to add a
> pointer argument. For example: seq_printf(s, &len, fmt, args...) where
> len can be NULL. But this runs against 6.
> 
> Due to 6, to solve 4 and 5, usually macro or inline tricks are used,
> for example:
> 
> __printf(3, 4) int seq_printf_len(struct seq_file *, size_t *len, ...);
> #define seq_printf(s, fmt, ...) seq_printf_len(s, NULL, fmt, ##__VA_ARGS__)
> 
> With this, solving 3 becomes possible (your void patch has already
> detected all the users of the return value, so we can sort out which
> expect length and which expect success/failure), and lets us actually
> remove the %n uses trivially too.

Consider that NAKed.  Reason: fucking ugly and pointless at the same time.

I don't believe that seq_printf() itself needs to be changed at all (or that
%n should be removed, actually).  Callers should be audited and fixed, of
course.  With dire warnings added to seq_file.[ch].  And no, it shouldn't
be returning void - the current calling conventions are actually right.
