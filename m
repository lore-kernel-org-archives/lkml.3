Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754101AbaFQHUe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 03:20:34 -0400
Received: from www.linutronix.de ([62.245.132.108]:35277 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752550AbaFQHUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 03:20:33 -0400
Date: Tue, 17 Jun 2014 09:20:29 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Darren Hart <darren@dvhart.com>
cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Davidlohr Bueso <davidlohr@hp.com>,
        Kees Cook <kees@outflux.net>, wad@chromium.org
Subject: Re: [patch V2 5/5] futex: Simplify futex_lock_pi_atomic() and make
 it more robust
In-Reply-To: <1402950997.15603.39.camel@rage>
Message-ID: <alpine.DEB.2.10.1406170910010.5170@nanos>
References: <20140611202744.676528190@linutronix.de>   <20140611204237.361836310@linutronix.de>  <1402638363.22229.23.camel@fury.dvhart.com>  <alpine.DEB.2.10.1406131033440.5170@nanos>  <alpine.DEB.2.10.1406131136140.5170@nanos>  <alpine.DEB.2.10.1406131137020.5170@nanos>
 <1402950997.15603.39.camel@rage>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Jun 2014, Darren Hart wrote:
> On Fri, 2014-06-13 at 11:44 +0200, Thomas Gleixner wrote:
> Two general concerns, we appear to be eliminating both the force_take
> and the retry.
> 
> The force_take only occurs if TID==0, and that is covered here in a
> cleaner way, so I believe we are good here.
> 
> As for the retry, the remaining use case (outside of TID==0 ->
> force_take=1 -> retry) appears to be that userspace changed the value
> while we were running. Reading the value early doesn't protect us from
> this scenario. How does this change account for that?
>       
> It looks to me that before we would retry, while here we just give up
> and return -EAGAIN..., which is addressed in futex_lock_pi(), but not in
> the futex_requeue() callsite for futex_proxy_trylock_atomic. It does
> handle it, but I guess also needs a comment update to "The owner was
> exiting" to include "or userspace changed the value" as you did for
> futex_lock_pi().

Right. I moved the handling back to the call site which has to handle
the various error return codes anyway. 
 
> >From my analysis, this is a good cleanup and makes the code for
> explicit. I'm nervous about missing corner cases, and would like to
> understand what level of testing this has received. We need to add PI
> locking tests to futextest. There are some in glibc. Which tests were
> run to validate PI locking?

I ran it against everything I have. libc tests, your stuff, rt-tests
and random exploit and corner case exposure code I collected/wrote in
the last few weeks.

Thanks,

	tglx
