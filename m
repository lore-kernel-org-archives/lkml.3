Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756550AbaEIKDv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 06:03:51 -0400
Received: from casper.infradead.org ([85.118.1.10]:48381 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756531AbaEIKDu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 06:03:50 -0400
Date: Fri, 9 May 2014 12:03:46 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: riel@redhat.com
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, mgorman@suse.de,
        chegu_vinod@hp.com
Subject: Re: [PATCH 2/4] sched,numa: weigh nearby nodes for task placement on
 complex NUMA topologies
Message-ID: <20140509100346.GS30445@twins.programming.kicks-ass.net>
References: <1399569811-14362-1-git-send-email-riel@redhat.com>
 <1399569811-14362-3-git-send-email-riel@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="icsXL8FABjDeMLkQ"
Content-Disposition: inline
In-Reply-To: <1399569811-14362-3-git-send-email-riel@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--icsXL8FABjDeMLkQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 08, 2014 at 01:23:29PM -0400, riel@redhat.com wrote:
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

So you add an O(nr_nodes) loop to task_weight(), but that in itself is
already called from O(nr_nodes) loops, yielding a total complexity of
O(nr_nodes^2).

This might be fine, but algorithmic complexity should very much be a
part of the changelog I think.

--icsXL8FABjDeMLkQ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTbKgCAAoJEHZH4aRLwOS641IP/0oGnZasOIsx6HIAgekyWian
DevpkYIk6TZ+7WhnyVKuUMegYlzQgMnnsIJbeiZ3i9LZBIkK1W+jxKBh/JEnT2Qd
ecDHEwCABjGEKa4XTyG0h2oYLMTgtNuWvNulhcfYw8KzKcQalKaNPJVtm0wPTugX
y2dMplAPPnp6H2gVveuBu6QtdjwdafHV7lE7lrzjGFv3nfIJDTEdInhthXqGV2Jy
PfE1272niRueOqzBTGXqWt2DhQpfJZ3MqaP2XGwa+XONooz9fe118Qcg1qR3ZCyg
wGmi+FEuxHDCbY/QbmycBNfCl9t+YAy7SPKjay5jKr0BJ70oRGvjHXtXNCgtHiTP
a7rPu+3jpCxzrj5lwUTjWQrze2fNwp9vnI2L2GD7o7SQ3kAY7hIePHBlEIkkVAUn
hv5Q9Ymy79b0/s5FE+QiTs0Cl/hLHDQUozM69UMbwCyHB3jvgrJgK/sWqGi+x8BT
q/7XFSsCUkBwHM49e7LSJWvE/qkj3c87aryitZyoiy3ztubs971PvYBEoA4pAqj6
eU/J+p6HxvyJuoQpgocCQnud10g5mi/PpE4iNsbO+bAhIg8iZnt10lNfLwsq7kM7
qV21GPtLLrxmFmNpXPeIrprklvKDmZxabagg57hnk122YGwtFizepYB2ZMttaPDX
m+bxFJGBcr+GPzI8/i9b
=E/X9
-----END PGP SIGNATURE-----

--icsXL8FABjDeMLkQ--
