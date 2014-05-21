Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751985AbaEUH67 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 03:58:59 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:36097 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069AbaEUH65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 03:58:57 -0400
Date: Wed, 21 May 2014 09:58:44 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: bsegall@google.com
Cc: Roman Gushchin <klamm@yandex-team.ru>, linux-kernel@vger.kernel.org,
        pjt@google.com, chris.j.arges@canonical.com,
        gregkh@linuxfoundation.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] sched: tg_set_cfs_bandwidth() causes rq->lock deadlock
Message-ID: <20140521075844.GE30445@twins.programming.kicks-ass.net>
References: <87mwej0yja.wl%klamm@yandex-team.ru>
 <xm26k39n3pl9.fsf@sword-of-the-dawn.mtv.corp.google.com>
 <87lhu215ky.wl%klamm@yandex-team.ru>
 <20140519103247.GX30445@twins.programming.kicks-ass.net>
 <xm26wqdh3cde.fsf@sword-of-the-dawn.mtv.corp.google.com>
 <20140520131526.GE11096@twins.programming.kicks-ass.net>
 <xm2638g42rpp.fsf@sword-of-the-dawn.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oGFO+oxyJKcF5bVg"
Content-Disposition: inline
In-Reply-To: <xm2638g42rpp.fsf@sword-of-the-dawn.mtv.corp.google.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--oGFO+oxyJKcF5bVg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, May 20, 2014 at 12:08:34PM -0700, bsegall@google.com wrote:
> Yeah, I believe the whole timer_active/cancel-before-start was to not
> lose the timer while still avoiding the HRTIMER_RESTART/hrtimer_start
> race. I'm not sure what, if anything, all the other ~35 users of
> HRTIMER_RESTART do about this. At least some do hrtimer_cancel();
> hrtimer_start(); though.

Yeah, I've not yet had the courage to go look through the tree :-/

That said, I've got a growing suspicion that I'm missing something
obvious and simple here.

> So, this and the other changes will ensure that a period timer is always
> queued. However, this also means that if we race so that we take
> cfs_b->lock before the period timer, but late enough that the interrupt
> has fired and we see !queued, we will hrtimer_forward the entire period
> here.

Right you are, missed that.

> What assign_cfs_rq_runtime does is insufficient - it doesn't
> unthrottle any other cfs_rqs, and since start_bandwidth_timer
> hrtimer_forwarded the period away, neither will
> (do_)sched_cfs_period_timer. (In addition throttle doesn't even do that,
> but that's probably easy enough to fix)

So I had a closer look at the bandwidth bits because of this, and it
strikes me as odd that __refill_cfs_bandwidth_runtime() does an
unconditional fill of cfs_b->runtime.

What I would have expected to see is something like:

	cfs_b->runtime += overruns * cfs_b->quota;
	if (cfs_b->runtime > cfs_b->quota)
		cfs_b->runtime = cfs_b->quota;

Which refills the runtime based on the overruns that happened and
respects the negative runtime accrued from previous inaccuracies.

If you unconditionally top-up like currently happens its possible to
consistently use more time than specified; due to the 1 jiffy throttle
granularity.

> I suppose we could check hrtimer_active and if so record any periods
> start_bandwidth_timer used for sched_cfs_period_timer, which could then
> force a do_sched_cfs_period_timer call. Perhaps something like this
> (equally untested) patch on top of your patch.

You left the new ->stored_periods unused but the idea was clear enough.

Anyway, given that you don't actually use overruns for anything except
pointless stats we could cheat and assume any trigger of the handler is
due to at least 1 overrun, that should trigger the unthrottle code
methinks.

In any case, I think your tracking overruns like that does make sense,
and its something the rt.c code needs too, as it suffers from the same
problem, so maybe we can roll that into the generic
start_bandwidth_timer() thing.

/me goes see if he can track down his suspicion and find shiny simple
truth at the end of it.

--oGFO+oxyJKcF5bVg
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTfFy0AAoJEHZH4aRLwOS68ksP/3wvGkRnXo2EYOjchQw7NadC
cLmqS8v7QR62iUB79rwWTxV/er1ZD3L/RmKqj9BxaBovJdWfRu2AHfl0vIm/ilG0
VrZhPm3Qe40XtM2LZ4j+A+YJf0xlKGUHriOpwq0lhURs0Qq1jDcZHWF2+n1+A1hT
N7wW66QP3X1GM27YwUmRPyKz/pDX84Gn5Lfu00Tbz9BRismi5f7F7DJagyvNSPEd
TDrvcQGqcrQ4eeuNBxSCg5J6lFe7tOMkm9SEPFOsZzCsjmPyGQ9Vy3RwRi/ZoNAk
i5W3RImTd9B9Wep0oPNC/mm9HjQpTGEBwXHIu1rnTkuaW+XjVkgUpHoXKfWeU6V6
VlCi9cyAkjWRjl5gZ037Di2nB8I2lylrZY7wyKhrXOL/0G/9Umv0rj2LCFeq5XYX
84wHmwpX94EDfp8VQ6ej1qjYBT2Y4B1KXbyHSfpMoI0ymgARmJSq0Bmjvbjh2hfG
7/YQSkYlf+8E+9HSz9Y9UPviBDgttnA6dwAuJviYdHmCphOWKcSmakLgNK8lCZVM
GcMp4l2BEcSJWHnPpsihkCVe6Ym8NaLevLWLzwiYbqo77M38tcXjriZ5vxid3CPY
RsbS6lB3b5l3GvLw8BEJKGmpi9raTd0TYO1carO7PXaNYJW12h23EcImiTHcr1QK
t0TC3cBcIDQQ5wxxE4hl
=69TR
-----END PGP SIGNATURE-----

--oGFO+oxyJKcF5bVg--
