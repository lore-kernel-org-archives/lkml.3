Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757442Ab3E0KZb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 06:25:31 -0400
Received: from merlin.infradead.org ([205.233.59.134]:39848 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757380Ab3E0KZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 06:25:29 -0400
Date: Mon, 27 May 2013 12:24:57 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, x86@kernel.org,
        dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
        robclark@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
        mingo@elte.hu, linux-media@vger.kernel.org,
        Dave Airlie <airlied@redhat.com>
Subject: Re: [PATCH v3 2/3] mutex: add support for wound/wait style locks, v3
Message-ID: <20130527102457.GA4341@laptop>
References: <20130428165914.17075.57751.stgit@patser>
 <20130428170407.17075.80082.stgit@patser>
 <20130430191422.GA5763@phenom.ffwll.local>
 <519CA976.9000109@canonical.com>
 <20130522161831.GQ18810@twins.programming.kicks-ass.net>
 <519CFF56.90600@canonical.com>
 <20130527082149.GE2781@laptop>
 <51A32F0E.9000206@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51A32F0E.9000206@canonical.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 27, 2013 at 12:01:50PM +0200, Maarten Lankhorst wrote:
> > Again, early.. monday.. would a trylock, even if successful still need
> > the ctx?
> No ctx for trylock is supported. You can still do a trylock while
> holding a context, but the mutex won't be a part of the context.
> Normal lockdep rules apply. lib/locking-selftest.c:
> 
> context + ww_mutex_lock first, then a trylock:
> dotest(ww_test_context_try, SUCCESS, LOCKTYPE_WW);
> 
> trylock first, then context + ww_mutex_lock:
> dotest(ww_test_try_context, FAILURE, LOCKTYPE_WW);
> 
> For now I don't want to add support for a trylock with context, I'm
> very glad I managed to fix ttm locking to not require this any more,
> and it was needed there only because it was a workaround for the
> locking being wrong.  There was no annotation for the buffer locking
> it was using, so the real problem wasn't easy to spot.

Ah, ok. 

My question really was whether there even was sense for a trylock with
context. I couldn't come up with a case for it; but I think I see one
now.

The thing is; if there could exist something like:

  ww_mutex_trylock(struct ww_mutex *, struct ww_acquire_ctx *ctx);

Then we should not now take away that name and make it mean something
else; namely: ww_mutex_trylock_single().

Unless we want to allow .ctx=NULL to mean _single.

As to why I proposed that (.ctx=NULL meaning _single); I suppose because
I'm a minimalist at heart.
