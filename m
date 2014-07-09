Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753137AbaGIKno (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 06:43:44 -0400
Received: from casper.infradead.org ([85.118.1.10]:58656 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739AbaGIKnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 06:43:43 -0400
Date: Wed, 9 Jul 2014 12:43:32 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>,
        Rik van Riel <riel@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        Mike Galbraith <efault@gmx.de>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>
Subject: Re: [PATCH v3 01/12] sched: fix imbalance flag reset
Message-ID: <20140709104332.GS19379@twins.programming.kicks-ass.net>
References: <1404144343-18720-1-git-send-email-vincent.guittot@linaro.org>
 <1404144343-18720-2-git-send-email-vincent.guittot@linaro.org>
 <53BB61E9.80200@linux.vnet.ibm.com>
 <CAKfTPtA8BVPtRRLzomqnGp7_uaSbFYmFTrrt4fpQTOb7qyjddg@mail.gmail.com>
 <53BCBD0E.2070609@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="k0QEB357i8jZX4tx"
Content-Disposition: inline
In-Reply-To: <53BCBD0E.2070609@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--k0QEB357i8jZX4tx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jul 09, 2014 at 09:24:54AM +0530, Preeti U Murthy wrote:
> In the example that I mention above, t1 and t2 are on the rq of cpu0;
> while t1 is running on cpu0, t2 is on the rq but does not have cpu1 in
> its cpus allowed mask. So during load balance, cpu1 tries to pull t2,
> cannot do so, and hence LBF_ALL_PINNED flag is set and it jumps to
> out_balanced. Note that there are only two sched groups at this level of
> sched domain.one with cpu0 and the other with cpu1. In this scenario we
> do not try to do active load balancing, atleast thats what the code does
> now if LBF_ALL_PINNED flag is set.

I think Vince is right in saying that in this scenario ALL_PINNED won't
be set. move_tasks() will iterate cfs_rq::cfs_tasks, that list will also
include the current running task.

And can_migrate_task() only checks for current after the pinning bits.

> Continuing with the above explanation; when LBF_ALL_PINNED flag is
> set,and we jump to out_balanced, we clear the imbalance flag for the
> sched_group comprising of cpu0 and cpu1,although there is actually an
> imbalance. t2 could still be migrated to say cpu2/cpu3 (t2 has them in
> its cpus allowed mask) in another sched group when load balancing is
> done at the next sched domain level.

And this is where Vince is wrong; note how
update_sg_lb_stats()/sg_imbalance() uses group->sgc->imbalance, but
load_balance() sets: sd_parent->groups->sgc->imbalance, so explicitly
one level up.

So what we can do I suppose is clear 'group->sgc->imbalance' at
out_balanced.

In any case, the entirely of this group imbalance crap is just that,
crap. Its a terribly difficult situation and the current bits more or
less fudge around some of the common cases. Also see the comment near
sg_imbalanced(). Its not a solid and 'correct' anything. Its a bunch of
hacks trying to deal with hard cases.

A 'good' solution would be prohibitively expensive I fear.

--k0QEB357i8jZX4tx
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTvRzUAAoJEHZH4aRLwOS6MicQAKcWnLCmVn5wcCXla0m5T56m
U4I5SsbiBt35/+X+2bTh5MAKSj5mZZF2WopU0ZFtcc5KBi7Bd5krYgiTl9d3JgBb
usGF4e3EJG3Dagkcl4BmcTEFF5X8KxJBKrr7kWC6u63h4K7WgGIigfWjB1GFJDjw
6Lkn9orGH11GNN4eNreUfHMgzPSTt8Vxh9iHCDJ0RWn58HvBlWibdeQp0aRtoWjB
+GEW1bxcse89F5twRbyYE3YbPpkxpMsWZC1faRRh+tEYN2a+bULYtK3xTILjgLcs
B1YdoStlKGqoTIdZkj7Y+ija3epaERGAbqSyxAj0TlSsBGxlidDeNNkJ86sH3jXS
TfkZh4s+4fIxU8Twu72DosM8+y2MH9kFvMQUvrmATEVyhKXeZvEYFIj33akycG1f
7xmtAaMcocshoOxoalPbcilrmRTumlQSXs+Jp+e29/G01EjtrUe8g3Hg8ZFdLgMF
6rUOZkkwMtWolroNOhDu69/wEZn9JUfxFuQnMdHn5gh76805tU9sMg2SSY9112iX
VKpckYoU+1M7tglhVG9M8SLOwN+7p81hlDELE5U6whKgQs9SEQuYVq1p31F4tNo0
+IqsFmpfmge14sc+MfEW/Z+Rk8EEpqgPMn+LigZKy63p+RkH8Ykt5JF+4QUK0RUw
62UBsT1zQrDp7c+gwBT0
=aXZk
-----END PGP SIGNATURE-----

--k0QEB357i8jZX4tx--
