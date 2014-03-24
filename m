Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753629AbaCXSIu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 14:08:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50822 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752754AbaCXSIt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 14:08:49 -0400
Date: Mon, 24 Mar 2014 19:07:40 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        David Woodhouse <dwmw2@infradead.org>,
        Richard Weinberger <richard@nod.at>, Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 01/11] signals: kill sigfindinword()
Message-ID: <20140324180740.GA3679@redhat.com>
References: <20140323193730.GA10464@redhat.com> <20140323193745.GA10482@redhat.com> <CAMuHMdUcDpKbo9r4MJA+FGeBq4WT_V_TW2wG+yQvHqbGxvaqBA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdUcDpKbo9r4MJA+FGeBq4WT_V_TW2wG+yQvHqbGxvaqBA@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Geert,

On 03/24, Geert Uytterhoeven wrote:
>
> Hi Oleg,
>
> On Sun, Mar 23, 2014 at 8:37 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> > It has no users and it doesn't look useful. I do not know why/when it
> > was introduced, I can't even find any user in the git history.
>
> 2.1.68pre1 for i386, 2.1.87pre1 for m68k (which used to follow i386 very
> closely ;-), but never used in mainline code.
>
> > Signed-off-by: Oleg Nesterov <oleg@redhat.com>
>
> Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

Thanks ;)

Do you think __HAVE_ARCH_SIG_* actually make sense? Only __i386__ and m68k
define _BITOPS, and nobody defines _SETOPS. Does this asm really helps to
generate a better code?

It seems to me it would be better to always use the generic code, although
perhaps we should cleanup it and even convert to use bitops/bitmask. The
home-grown bitmask implementation in signal.h looks a bit ugly.

At least we should move the definition of sigset_t into linux/signal.h,
this should be simple. It must be the same on every arch anyway, at least
has_pending_signals() assumes that sigset_t == long[_NSIG_WORDS].

And I can't understand why do we need rt_sigmask()... I think we can just
do

	- #define sigmask(sig)	(1UL << ((sig) - 1))
	+ #define sigmask(sig)  (1ULL << ((sig) - 1))

This should not change the code generation, gcc is smart enough, sig is
always constant...

Looks like, this code needs a lot of boring cleanups.

Oleg.

