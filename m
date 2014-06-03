Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755365AbaFCMWw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 08:22:52 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:45999 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753754AbaFCMWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 08:22:50 -0400
Date: Tue, 3 Jun 2014 14:22:35 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Yuyang Du <yuyang.du@intel.com>
Cc: mingo@redhat.com, rafael.j.wysocki@intel.com, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, arjan.van.de.ven@intel.com,
        len.brown@intel.com, alan.cox@intel.com, mark.gross@intel.com,
        pjt@google.com, bsegall@google.com, morten.rasmussen@arm.com,
        vincent.guittot@linaro.org, rajeev.d.muralidhar@intel.com,
        vishwesh.m.rudramuni@intel.com, nicole.chalhoub@intel.com,
        ajaya.durg@intel.com, harinarayanan.seshadri@intel.com,
        jacob.jun.pan@linux.intel.com, fengguang.wu@intel.com
Subject: Re: [RFC PATCH 10/16 v3] Workload Consolidation APIs
Message-ID: <20140603122235.GJ30445@twins.programming.kicks-ass.net>
References: <1401431772-14320-1-git-send-email-yuyang.du@intel.com>
 <1401431772-14320-11-git-send-email-yuyang.du@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lBgcuyUB+qD0f9A9"
Content-Disposition: inline
In-Reply-To: <1401431772-14320-11-git-send-email-yuyang.du@intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--lBgcuyUB+qD0f9A9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 30, 2014 at 02:36:06PM +0800, Yuyang Du wrote:
> Currently, CPU CC is per CPU. To consolidate, the formula is based on a h=
euristic.
> Suppose we have 2 CPUs, their task concurrency over time is ('-' means no
> task, 'x' having tasks):
>=20
> 1)
> CPU0: ---xxxx---------- (CC[0])
> CPU1: ---------xxxx---- (CC[1])
>=20
> 2)
> CPU0: ---xxxx---------- (CC[0])
> CPU1: ---xxxx---------- (CC[1])
>=20
> If we consolidate CPU0 and CPU1, the consolidated CC will be: CC' =3D CC[=
0] +
> CC[1] for case 1 and CC'' =3D (CC[0] + CC[1]) * 2 for case 2. For the cas=
es in
> between case 1 and 2 in terms of how xxx overlaps, the CC should be betwe=
en
> CC' and CC''. So, we uniformly use this condition for consolidation (supp=
ose
> we consolidate m CPUs to n CPUs, m > n):
>=20
> (CC[0] + CC[1] + ... + CC[m-2] + CC[m-1]) * (n + log(m-n)) >=3D<? (1 * n)=
 * n *
> consolidating_coefficient
>=20
> The consolidating_coefficient could be like 100% or more or less.
>=20

I'm still struggling to match that to the code presented.

> +/*
> + * as of now, we have the following assumption
> + * 1) every sched_group has the same weight
> + * 2) every CPU has the same computing power
> + */

Those are complete non starters.

> +/*
> + * wc_nonshielded_mask - return the nonshielded cpus in the @mask,
> + * which is unmasked by the shielded cpus
> + *
> + * traverse downward the sched_domain tree when the sched_domain contains
> + * flag SD_WORKLOAD_CONSOLIDATION, each sd may have more than two groups

WTF is a shielded/nonshielded cpu?

> +static int cpu_task_hot(struct task_struct *p, u64 now)
> +{
> +	s64 delta;
> +
> +	if (p->sched_class !=3D &fair_sched_class)
> +		return 0;
> +
> +	if (unlikely(p->policy =3D=3D SCHED_IDLE))
> +		return 0;
> +
> +	if (wc_push_hot_task)
> +		return 0;
> +
> +	/*
> +	 * Buddy candidates are cache hot:
> +	 */
> +	if (sched_feat(CACHE_HOT_BUDDY) && this_rq()->nr_running &&
> +			(&p->se =3D=3D cfs_rq_of(&p->se)->next ||
> +			 &p->se =3D=3D cfs_rq_of(&p->se)->last))
> +		return 1;
> +
> +	if (sysctl_sched_migration_cost =3D=3D -1)
> +		return 1;
> +	if (sysctl_sched_migration_cost =3D=3D 0)
> +		return 0;
> +
> +	delta =3D now - p->se.exec_start;
> +
> +	return delta < (s64)sysctl_sched_migration_cost;
> +}

In what universe to we need an exact copy of task_hot() ?

and on and on it goes.. :-(

--lBgcuyUB+qD0f9A9
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTjb4LAAoJEHZH4aRLwOS6SYsQALLCHTXAY3+MZDMfveCD14Kw
nRKAGErceliewuxAswFKJ9e33lR0GF8ixEFdqPYJk8XEQKR8P7u4Ijn6s/ud2M8V
eD8t+HF6qUztB+Zd/k5TfAV+iQtPAVJ062JotSw+Ju1Zf7GTLWe0dtvL8+TMPWb9
Wupl92OngXv/0u/+XUplmTpFGVQXUzSOuXvWqHex720/sJYJf3fde77k+k0I8Pyq
DHjabCQ1CeATPa6l7/YegThrRiZ/GDYJvuE8/pdyVrnHnX38GJOQLKRYEkatnOGy
YV49gYSFJmZGjXyWlhwElEHvo1p4tQGqjo+7Fxpc48LmOVsuPdIfXFj+j+aYemH8
ivpFKi0k+Xfo9aMyV89Q65No9vANGZRKZGHLkxvnW9/7DGnoolvfG/dyWuzc2q/2
ORFz6PyQpWY7mLMrZScgCrjIp65LqZLRe7+2YMLq1W5XKcqr5J35Xj+TQB90rm2l
iUPOgCL+DKt7i3y7oG5KC3fxakPCTCfJN1cN7d4ksrGr+ar6kEOJGofWPoNvQl42
4Kb71u/DdD4wj8XojEA/s+lFSdl2BcJ3B028t/VX3kX2v5pmIVbjMrsS0sZqsiqE
76PWDio7ThQRuLRbRI6JpIdMJMElHUyx9Dmper5522Wf9A5+ZdTT8Yk1DbmUzPOT
7uexI4oBXvFnVV2clwem
=OFDW
-----END PGP SIGNATURE-----

--lBgcuyUB+qD0f9A9--
