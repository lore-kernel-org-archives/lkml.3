Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754745AbaC0JSx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 05:18:53 -0400
Received: from order.stressinduktion.org ([87.106.68.36]:34608 "EHLO
	order.stressinduktion.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753406AbaC0JSv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 05:18:51 -0400
Date: Thu, 27 Mar 2014 10:18:49 +0100
From: Hannes Frederic Sowa <hannes@stressinduktion.org>
To: Daniel Borkmann <dborkman@redhat.com>
Cc: Sasha Levin <sasha.levin@oracle.com>, davem@davemloft.net, tytso@mit.edu,
        linux-kernel@vger.kernel.org, eric.dumazet@gmail.com
Subject: Re: [PATCH] random32: avoid attempt to late reseed if in the middle of seeding
Message-ID: <20140327091849.GC30181@order.stressinduktion.org>
Mail-Followup-To: Daniel Borkmann <dborkman@redhat.com>,
	Sasha Levin <sasha.levin@oracle.com>, davem@davemloft.net,
	tytso@mit.edu, linux-kernel@vger.kernel.org, eric.dumazet@gmail.com
References: <1395853958-5083-1-git-send-email-sasha.levin@oracle.com> <53336049.4060901@redhat.com> <53336425.6030409@oracle.com> <20140327022138.GB30181@order.stressinduktion.org> <5333E983.2030509@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5333E983.2030509@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 27, 2014 at 10:04:03AM +0100, Daniel Borkmann wrote:
> On 03/27/2014 03:21 AM, Hannes Frederic Sowa wrote:
> >On Wed, Mar 26, 2014 at 07:35:01PM -0400, Sasha Levin wrote:
> >>On 03/26/2014 07:18 PM, Daniel Borkmann wrote:
> >>>On 03/26/2014 06:12 PM, Sasha Levin wrote:
> >>>>Commit 4af712e8df ("random32: add prandom_reseed_late() and call when
> >>>>nonblocking pool becomes initialized") has added a late reseed stage
> >>>>that happens as soon as the nonblocking pool is marked as initialized.
> >>>>
> >>>>This fails in the case that the nonblocking pool gets initialized
> >>>>during __prandom_reseed()'s call to get_random_bytes(). In that case
> >>>>we'd double back into __prandom_reseed() in an attempt to do a late
> >>>>reseed - deadlocking on 'lock' early on in the boot process.
> >>>>
> >>>>Instead, just avoid even waiting to do a reseed if a reseed is already
> >>>>occuring.
> >>>>
> >>>>Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
> >>>
> >>>Thanks for catching! (If you want Dave to pick it up, please also
> >>>Cc netdev.)
> >>>
> >>>Why not via spin_trylock_irqsave() ? Thus, if we already hold the
> >>>lock, we do not bother any longer with doing the same work twice
> >>>and just return.
> >
> >I totally agree with Daniel spin_trylock_irqsave seems like the best
> >solution.
> >
> >In case we really want to make sure that even early seeding doesn't
> >race with late seed and the pool is only filled by another CPU, we would
> >actually need per-cpu bools to get this case correct.
> 
> But then again, we would just exit via spin_trylock_irqsave()
> now, no? Whenever something enters this section protected under
> irq save spinlock we would do a reseed of the entire state (s1-s4)
> for each cpu.

If early reseed races with late one, we would actually need to spin on
maybe another cpu, so the early call can leave critical section before
late call enters. If we don't spin we could possibly miss the late call
when nonblocking pool is fully seeded (entropy may be added in batches
and first cpus of the early reseeding might miss better entropy).

If the early call blocks the late call, maybe even on another cpu, the late
call should spin until the early call left the critical section. We can only
deadlock on same cpu.

I consider this just hypothetical.

Bye,

  Hannes
