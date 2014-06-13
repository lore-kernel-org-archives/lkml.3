Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753104AbaFMIej (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 04:34:39 -0400
Received: from www.linutronix.de ([62.245.132.108]:46119 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753092AbaFMIeh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 04:34:37 -0400
Date: Fri, 13 Jun 2014 10:34:33 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Darren Hart <darren@dvhart.com>
cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Davidlohr Bueso <davidlohr@hp.com>,
        Kees Cook <kees@outflux.net>, wad@chromium.org
Subject: Re: [patch 5/5] futex: Simplify futex_lock_pi_atomic() and make it
 more robust
In-Reply-To: <1402638363.22229.23.camel@fury.dvhart.com>
Message-ID: <alpine.DEB.2.10.1406131033440.5170@nanos>
References: <20140611202744.676528190@linutronix.de>  <20140611204237.361836310@linutronix.de> <1402638363.22229.23.camel@fury.dvhart.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Jun 2014, Darren Hart wrote:

> On Wed, 2014-06-11 at 20:45 +0000, Thomas Gleixner wrote:
> > futex_lock_pi_atomic() is a maze of retry hoops and loops.
> > 
> > Reduce it to simple and understandable states:
> 
> Heh... well...
> 
> With this patch applied (1-4 will not reproduce without 5), if userspace
> wrongly sets the uval to 0, the pi_state can end up being NULL for a
> subsequent requeue_pi operation:
> 
> [   10.426159] requeue: 00000000006022e0 to 00000000006022e4
> [   10.427737]   this:ffff88013a637da8
> [   10.428749]   waking:ffff88013a637da8
> fut2 = 0
> [   10.429994]   comparing requeue_pi_key
> [   10.431034]   prepare waiter to take the rt_mutex
> [   10.432344]   pi_state:          (null)
> [   10.433414] BUG: unable to handle kernel NULL pointer dereference at
> 0000000000000038
> 
> This occurs in the requeue loop, in the requeue_pi block at:
> 
> 	atomic_inc(&pi_state->refcount);

Hmm. Took me some time to reproduce. Digging into it now.

Thanks,

	tglx
