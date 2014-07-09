Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755835AbaGIOpE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 10:45:04 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:49337 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755782AbaGIOpC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 10:45:02 -0400
Date: Wed, 9 Jul 2014 16:44:39 +0200
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
Message-ID: <20140709144439.GF9918@twins.programming.kicks-ass.net>
References: <1404144343-18720-1-git-send-email-vincent.guittot@linaro.org>
 <1404144343-18720-2-git-send-email-vincent.guittot@linaro.org>
 <53BB61E9.80200@linux.vnet.ibm.com>
 <CAKfTPtA8BVPtRRLzomqnGp7_uaSbFYmFTrrt4fpQTOb7qyjddg@mail.gmail.com>
 <53BCBD0E.2070609@linux.vnet.ibm.com>
 <20140709104332.GS19379@twins.programming.kicks-ass.net>
 <53BD2A60.3060106@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sDKAb4OeUBrWWL6P"
Content-Disposition: inline
In-Reply-To: <53BD2A60.3060106@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--sDKAb4OeUBrWWL6P
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 09, 2014 at 05:11:20PM +0530, Preeti U Murthy wrote:
> On 07/09/2014 04:13 PM, Peter Zijlstra wrote:
> > On Wed, Jul 09, 2014 at 09:24:54AM +0530, Preeti U Murthy wrote:
> >> In the example that I mention above, t1 and t2 are on the rq of cpu0;
> >> while t1 is running on cpu0, t2 is on the rq but does not have cpu1 in
> >> its cpus allowed mask. So during load balance, cpu1 tries to pull t2,
> >> cannot do so, and hence LBF_ALL_PINNED flag is set and it jumps to
> >> out_balanced. Note that there are only two sched groups at this level =
of
> >> sched domain.one with cpu0 and the other with cpu1. In this scenario we
> >> do not try to do active load balancing, atleast thats what the code do=
es
> >> now if LBF_ALL_PINNED flag is set.
> >=20
> > I think Vince is right in saying that in this scenario ALL_PINNED won't
> > be set. move_tasks() will iterate cfs_rq::cfs_tasks, that list will also
> > include the current running task.
>=20
> Hmm.. really? Because while dequeueing a task from the rq so as to
> schedule it on a cpu, we delete its entry from the list of cfs_tasks on
> the rq.
>=20
> list_del_init(&se->group_node) in account_entity_dequeue() does that.

But set_next_entity() doesn't call account_entity_dequeue(), only
__dequeue_entity() to take it out of the rb-tree.

> > And can_migrate_task() only checks for current after the pinning bits.
> >=20
> >> Continuing with the above explanation; when LBF_ALL_PINNED flag is
> >> set,and we jump to out_balanced, we clear the imbalance flag for the
> >> sched_group comprising of cpu0 and cpu1,although there is actually an
> >> imbalance. t2 could still be migrated to say cpu2/cpu3 (t2 has them in
> >> its cpus allowed mask) in another sched group when load balancing is
> >> done at the next sched domain level.
> >=20
> > And this is where Vince is wrong; note how
> > update_sg_lb_stats()/sg_imbalance() uses group->sgc->imbalance, but
> > load_balance() sets: sd_parent->groups->sgc->imbalance, so explicitly
> > one level up.
>=20
> One level up? The group->sgc->imbalance flag is checked during
> update_sg_lb_stats(). This flag is *set during the load balancing at a
> lower level sched domain*.IOW, when the 'group' formed the sched domain.

sd_parent is one level up.

> >=20
> > So what we can do I suppose is clear 'group->sgc->imbalance' at
> > out_balanced.
>=20
> You mean 'set'? If we clear it we will have no clue about imbalances at
> lower level sched domains due to pinning. Specifically in LBF_ALL_PINNED
> case. This might prevent us from balancing out these tasks to other
> groups at a higher level domain. update_sd_pick_busiest() specifically
> relies on this flag to choose the busiest group.

No, clear, in load_balance. So set one level up, clear the current
level.

--sDKAb4OeUBrWWL6P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTvVVXAAoJEHZH4aRLwOS6UnQP/j52Qn6VjlrwiPkJ9t1YOSYt
v2vc84fXF/RJTJXrbYlpnVIsRNopulivSrO/SMfNZBQ2YVxeSbkNqP0Cs3Fex3Tt
Yijm/2Zx7upSuToRui4lA6aXEiZs2Ifs5u35K+A8LdIiUSE9i1YKPm/TXmiSws6L
rDMOASoBLnw5BvhzUOxeZSfSMWN6hqWfnA7k4F+jKOVtdQRaXxrbE7BAzIFhWcB4
Ix7zcqjfEYUfIAKUxgkRhPRTDoaqpzQnBy8qkflD1BGeJl3DVRIDneK6ryuV0aGI
YqrB7vX7gaLG4Q30yG/MgEODHq9OMZZk3HZBf3xjPMn+0PbrwELJMGS6VsfB5Ne9
f8MhLw/AGn6P/qUJL42sZ/YObb79rnMNZ6sb5guecwFvaDpNKbvY7lFsYpcb3Gt4
pwObYdxl44VcUAatSOtIYKpWHr31KNWyVePRROuUOjYbJ5usYB4MCizfNJYvin5G
3Ta+LvVie7M2OFQ+iIziyNZXyF+YfzI71LfQfS4mYASymzCYmxJeu4DHDP3t6SNC
MmKkUxNC0BD8GowUf5stH3wPLfXR/kPetOQeXe1sDFZXr8W11jcy74YeK7yAN8ru
sfZrmEWb89bDkfM/WPQGbFVmlKEnVD9M1kRzlLEgtMX/9ZQuFqom2WmiYuvZrQE3
jpY9rSWEEYFDM2bWCNoW
=2I6V
-----END PGP SIGNATURE-----

--sDKAb4OeUBrWWL6P--
