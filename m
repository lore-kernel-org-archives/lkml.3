Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757981Ab3E0LQQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 07:16:16 -0400
Received: from merlin.infradead.org ([205.233.59.134]:40731 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757709Ab3E0LQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 07:16:13 -0400
Date: Mon, 27 May 2013 13:15:57 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, x86@kernel.org,
        dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
        robclark@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
        mingo@elte.hu, linux-media@vger.kernel.org,
        Dave Airlie <airlied@redhat.com>
Subject: Re: [PATCH v3 2/3] mutex: add support for wound/wait style locks, v3
Message-ID: <20130527111557.GB4341@laptop>
References: <20130428165914.17075.57751.stgit@patser>
 <20130428170407.17075.80082.stgit@patser>
 <20130430191422.GA5763@phenom.ffwll.local>
 <519CA976.9000109@canonical.com>
 <20130522161831.GQ18810@twins.programming.kicks-ass.net>
 <519CFF56.90600@canonical.com>
 <20130527082149.GE2781@laptop>
 <51A32F0E.9000206@canonical.com>
 <20130527102457.GA4341@laptop>
 <51A33AD0.4030406@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51A33AD0.4030406@canonical.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 27, 2013 at 12:52:00PM +0200, Maarten Lankhorst wrote:
> The reason ttm needed it was because there was another lock that interacted
> with the ctx lock in a weird way. The ww lock it was using was inverted with another
> lock, so it had to grab that lock first, perform a trylock on the ww lock, and if that failed
> unlock the lock, wait for it to be unlocked, then retry the same thing again.
> I'm so glad I managed to fix that mess, if you really need ww_mutex_trylock with a ctx,
> it's an indication your locking is wrong.
> 
> For ww_mutex_trylock with a context to be of any use you would also need to return
> 0 or a -errno, (-EDEADLK, -EBUSY (already locked by someone else), or -EALREADY).
> This would make the trylock very different from other trylocks, and very confusing because
> if (ww_mutex_trylock(lock, ctx)) would not do what you would think it would do.

Yuck ;-)

Anyway, what I was thinking of is something like:

	T0		T1

	try A
			lock B
	lock B
			lock A

Now, if for some reason T1 won the lottery such that T0 would have to be
wounded, T0's context would indicate its the first entry and not return
-EDEADLK.

OTOH, anybody doing creative things like that might well deserve
whatever they get ;-)

> > The thing is; if there could exist something like:
> >
> >   ww_mutex_trylock(struct ww_mutex *, struct ww_acquire_ctx *ctx);
> >
> > Then we should not now take away that name and make it mean something
> > else; namely: ww_mutex_trylock_single().
> >
> > Unless we want to allow .ctx=NULL to mean _single.
> >
> > As to why I proposed that (.ctx=NULL meaning _single); I suppose because
> > I'm a minimalist at heart.
> Minimalism isn't bad, it's just knowing when to sto

:-)
