Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752748AbaC0CVk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 22:21:40 -0400
Received: from order.stressinduktion.org ([87.106.68.36]:34093 "EHLO
	order.stressinduktion.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751519AbaC0CVj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 22:21:39 -0400
Date: Thu, 27 Mar 2014 03:21:38 +0100
From: Hannes Frederic Sowa <hannes@stressinduktion.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Daniel Borkmann <dborkman@redhat.com>, davem@davemloft.net, tytso@mit.edu,
        linux-kernel@vger.kernel.org, eric.dumazet@gmail.com
Subject: Re: [PATCH] random32: avoid attempt to late reseed if in the middle of seeding
Message-ID: <20140327022138.GB30181@order.stressinduktion.org>
Mail-Followup-To: Sasha Levin <sasha.levin@oracle.com>,
	Daniel Borkmann <dborkman@redhat.com>, davem@davemloft.net,
	tytso@mit.edu, linux-kernel@vger.kernel.org, eric.dumazet@gmail.com
References: <1395853958-5083-1-git-send-email-sasha.levin@oracle.com> <53336049.4060901@redhat.com> <53336425.6030409@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <53336425.6030409@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 26, 2014 at 07:35:01PM -0400, Sasha Levin wrote:
> On 03/26/2014 07:18 PM, Daniel Borkmann wrote:
> >On 03/26/2014 06:12 PM, Sasha Levin wrote:
> >>Commit 4af712e8df ("random32: add prandom_reseed_late() and call when
> >>nonblocking pool becomes initialized") has added a late reseed stage
> >>that happens as soon as the nonblocking pool is marked as initialized.
> >>
> >>This fails in the case that the nonblocking pool gets initialized
> >>during __prandom_reseed()'s call to get_random_bytes(). In that case
> >>we'd double back into __prandom_reseed() in an attempt to do a late
> >>reseed - deadlocking on 'lock' early on in the boot process.
> >>
> >>Instead, just avoid even waiting to do a reseed if a reseed is already
> >>occuring.
> >>
> >>Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
> >
> >Thanks for catching! (If you want Dave to pick it up, please also
> >Cc netdev.)
> >
> >Why not via spin_trylock_irqsave() ? Thus, if we already hold the
> >lock, we do not bother any longer with doing the same work twice
> >and just return.

I totally agree with Daniel spin_trylock_irqsave seems like the best
solution.

In case we really want to make sure that even early seeding doesn't
race with late seed and the pool is only filled by another CPU, we would
actually need per-cpu bools to get this case correct.

I really doubt this isn't worth the effort and wouldn't do that.

> Your code looks much better, I'll should really stop sending patches
> too early in the morning...
> 
> It's also worth adding lib/random32.c to the MAINTAINERS file, as my
> list of recipients is solely based on what get_maintainer.pl tells
> me to do (and I'm assuming that I'm not the last person who will be
> sending patches for this).

Would be a nice idea, especially because prandom_u32 changes are sensitive to
network security and should get reviewed there, too.

Greetings,

  Hannes

