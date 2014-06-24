Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755306AbaFXRSo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 13:18:44 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:51791 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752520AbaFXRSm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 13:18:42 -0400
Date: Tue, 24 Jun 2014 19:18:19 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Robert Richter <rric@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>
Subject: Re: [RFC v2 5/7] perf: add a pmu capability for "exclusive" events
Message-ID: <20140624171819.GQ3213@twins.programming.kicks-ass.net>
References: <1402501310-31940-1-git-send-email-alexander.shishkin@linux.intel.com>
 <1402501310-31940-6-git-send-email-alexander.shishkin@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="apqMg07LpBOyFFAR"
Content-Disposition: inline
In-Reply-To: <1402501310-31940-6-git-send-email-alexander.shishkin@linux.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--apqMg07LpBOyFFAR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 11, 2014 at 06:41:48PM +0300, Alexander Shishkin wrote:
> +static bool exclusive_event_ok(struct perf_event *event,
> +			      struct perf_event_context *ctx)
> +{
> +	struct perf_event *iter_event;
> +
> +	if (!(event->pmu->capabilities & PERF_PMU_CAP_EXCLUSIVE))
> +		return true;
> +
> +	list_for_each_entry(iter_event, &ctx->event_list, event_entry) {
> +		if (exclusive_event_match(iter_event, event))
> +			return false;
> +	}

This list iteration needs either rcu or ctx->lock or ctx->mutex, and the
two callsites below don't have either afaict.

> +
> +	return true;
> +}
> +
>  /**
>   * sys_perf_event_open - open a performance event, associate it to a tas=
k/cpu
>   *
> @@ -7261,6 +7287,11 @@ SYSCALL_DEFINE5(perf_event_open,
>  		goto err_alloc;
>  	}
> =20
> +	if (!exclusive_event_ok(event, ctx)) {
> +		err =3D -EBUSY;
> +		goto err_context;
> +	}
> +
>  	if (task) {
>  		put_task_struct(task);
>  		task =3D NULL;
> @@ -7427,6 +7458,13 @@ perf_event_create_kernel_counter(struct perf_event=
_attr *attr, int cpu,
>  		goto err_free;
>  	}
> =20
> +	if (!exclusive_event_ok(event, ctx)) {
> +		perf_unpin_context(ctx);
> +		put_ctx(ctx);
> +		err =3D -EBUSY;
> +		goto err_free;
> +	}
> +
>  	WARN_ON_ONCE(ctx->parent_ctx);
>  	mutex_lock(&ctx->mutex);
>  	perf_install_in_context(ctx, event, cpu);
> --=20
> 2.0.0
>=20

--apqMg07LpBOyFFAR
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTqbLWAAoJEHZH4aRLwOS61GUP/iWDt1S/Op9UsKYjdG5TZlbV
78u/hploPyVc5yTlmqxsT2djyIUJ7n+v+Ijj8Uw/idfaykm0YBVe0JxbEyl38NO3
XvlYt4USqrJSnI/3oS+gw53AItG1/K8WXxeUFpcCqbqHFl9vpnUjxd8qgYjjehPr
MKx5JH9FdmSXbuvaIymKfIOuwuvCTzJjPcn8+JhAB2dUGGZSGJE5G03Dr1Kw4IxO
NdGfxrvepn7zdkV04fBE/afU9m7qrePcdUkc+rWw+9+pQXK68fiIMpDC1jUKXpvT
i4felfGA9N0rSqyUYaDr+iLUSbygOe0S3280p5SYUHi+qPRRGP7+5vCVnT5Ur7eG
dVu8QpgSP5EayoFIOZGPZh4uefBSn9c11ZC8bxHteqdDINfG1eHdnrJ4Fk3u5HZu
Qy0HcaNFqG7etJPhDmLM25DJItDL16qGXKzoxKgNBtkhIZcuYhXimsZhjklPit9k
QMOqeh07yIlBmMkfYVErFiBkrdaqPNLNRpLP3JsIkmrBQhyTB5eHEU/2lWrsLmG/
o7vXXm7OYUT5wLxO7dE5JNcmRYAjW3jXDZe+uVJagnabUDrlexOJD0gRWVLnM/qS
JaAERs+Up4HhvYFQ2Mx0OK4oUfLG5+78+oLfAw3mo3ZIeBe6NVFysHd2BbuJTb+5
peeJkkhaIZX/owCi3yEk
=SwJb
-----END PGP SIGNATURE-----

--apqMg07LpBOyFFAR--
