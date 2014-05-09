Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756734AbaEIKME (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 06:12:04 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:42634 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756453AbaEIKMA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 06:12:00 -0400
Date: Fri, 9 May 2014 12:11:52 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: riel@redhat.com
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, mgorman@suse.de,
        chegu_vinod@hp.com
Subject: Re: [PATCH 2/4] sched,numa: weigh nearby nodes for task placement on
 complex NUMA topologies
Message-ID: <20140509101152.GT30445@twins.programming.kicks-ass.net>
References: <1399569811-14362-1-git-send-email-riel@redhat.com>
 <1399569811-14362-3-git-send-email-riel@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3M7QbeJEF900HlmX"
Content-Disposition: inline
In-Reply-To: <1399569811-14362-3-git-send-email-riel@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3M7QbeJEF900HlmX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 08, 2014 at 01:23:29PM -0400, riel@redhat.com wrote:
> @@ -930,7 +987,7 @@ static inline unsigned long group_faults_cpu(struct n=
uma_group *group, int nid)
>   */
>  static inline unsigned long task_weight(struct task_struct *p, int nid)
>  {
> -	unsigned long total_faults;
> +	unsigned long total_faults, score;
> =20
>  	if (!p->numa_faults_memory)
>  		return 0;
> @@ -940,15 +997,32 @@ static inline unsigned long task_weight(struct task=
_struct *p, int nid)
>  	if (!total_faults)
>  		return 0;
> =20
> -	return 1000 * task_faults(p, nid) / total_faults;
> +	score =3D 1000 * task_faults(p, nid);
> +	score +=3D nearby_nodes_score(p, nid, true);
> +
> +	score /=3D total_faults;
> +
> +	return score;
>  }
> =20
>  static inline unsigned long group_weight(struct task_struct *p, int nid)
>  {
> -	if (!p->numa_group || !p->numa_group->total_faults)
> +	unsigned long total_faults, score;
> +
> +	if (!p->numa_group)
> +		return 0;
> +
> +	total_faults =3D p->numa_group->total_faults;
> +
> +	if (!total_faults)
>  		return 0;
> =20
> -	return 1000 * group_faults(p, nid) / p->numa_group->total_faults;
> +	score =3D 1000 * group_faults(p, nid);
> +	score +=3D nearby_nodes_score(p, nid, false);
> +
> +	score /=3D total_faults;
> +
> +	return score;
>  }

OK, and that's just sad..

See task_numa_placement(), which does:

	for_each_online_node(nid) {
		weight =3D task_weight(p, nid) + group_weight(p, nid);
		if (weight > max_weight) {
			max_weight =3D weight;
			max_nid =3D nid;
		}
	}

So not only is that loop now O(nr_nodes^2), the inner loops doubly
iterates all nodes.

Also, {task,group}_weight() functions were like cheap-ish (/me mumbles
something about people using !2^n scaling factors for no sane reason).
And they're used all over with that in mind.

But look what you did to migrate_improves_locality(), that will now
iterate all nodes _4_ times, and its called for every single task we try
and migrate during load balance, while holding rq->lock.



--3M7QbeJEF900HlmX
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTbKnoAAoJEHZH4aRLwOS63TMP/RdqTLkXPbn3irLUrf2g1xtw
IgOZ60/m2bTDvDO0LYN444Gd77JpupHb4TNjWAbXSJMv4IIRJPbJPjtMu4Px/5uc
/RbGVyK23GXiwsDZ3UfBsPbI/r03dmRpvAoyn+E/ebibltjmAEZedM6MpAidEj5V
+5ZYoEC1qRobB7tOwDpCF9pzDtXoXJqTRe/V3/f94zfmCx1tpf60BmgJ7nsyLFwy
REg4X9TyJ8UKYrVR/UBr85+qkPJazTHSbnbUp/Mwq7zXsst7uAL9yVjjCvwtZ+P3
RgdjkZpCcDGEJJo+3g9QD3Zya3DpMw6a4pqS7Vtjab6IWQWQIaf2iTsRRaoQO8rW
psQ1XWc1Tz9DSud8ljMrqqVi1ExwoV28Q2OM9S9R9ryjZQ7PZ23YZl+ef75omj5a
LD3dkZKK6zWmUxDRJguCpWf4HdTq3D77lcFxOzZvYdpb1M7uo6Sx87Qdpqjf/6uV
HLK56FDJeQUmYlsLNkqJGFAISQ7kWnEa2YEUVVS4YranBxt5DmcxkANu2WUYCrKP
5/cVoFAuiu0u4mirAoA6fH//8wRfGlAxQClvJoNKO/0LJwQwjdYqNKa/1UTGylRK
mVAltMFLSA1pj+zSrqPUhLirVJyPJ8tXmdj5ga1lbiEYM5itwfQOqHACFnp9D+z+
EibFvKBOu4CxomHNYufh
=ahUz
-----END PGP SIGNATURE-----

--3M7QbeJEF900HlmX--
