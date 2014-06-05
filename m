Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751725AbaFEI3p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 04:29:45 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:33817 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065AbaFEI3m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 04:29:42 -0400
Date: Thu, 5 Jun 2014 10:29:35 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, ak@linux.intel.com,
        jolsa@redhat.com, zheng.z.yan@intel.com,
        maria.n.dimakopoulou@gmail.com
Subject: Re: [PATCH 4/9] perf/x86: add cross-HT counter exclusion
 infrastructure
Message-ID: <20140605082935.GI3213@twins.programming.kicks-ass.net>
References: <1401917658-26065-1-git-send-email-eranian@google.com>
 <1401917658-26065-5-git-send-email-eranian@google.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zgY/UHCnsaNnNXRx"
Content-Disposition: inline
In-Reply-To: <1401917658-26065-5-git-send-email-eranian@google.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--zgY/UHCnsaNnNXRx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 04, 2014 at 11:34:13PM +0200, Stephane Eranian wrote:
> @@ -2020,12 +2050,29 @@ static void intel_pmu_cpu_starting(int cpu)
> =20
>  	if (x86_pmu.lbr_sel_map)
>  		cpuc->lbr_sel =3D &cpuc->shared_regs->regs[EXTRA_REG_LBR];
> +
> +	if (x86_pmu.flags & PMU_FL_EXCL_CNTRS) {
> +		for_each_cpu(i, topology_thread_cpumask(cpu)) {
> +			struct intel_excl_cntrs *c;
> +
> +			c =3D per_cpu(cpu_hw_events, i).excl_cntrs;
> +			if (c && c->core_id =3D=3D core_id) {
> +				cpuc->kfree_on_online[1] =3D cpuc->excl_cntrs;
> +				cpuc->excl_cntrs =3D c;
> +				cpuc->excl_thread_id =3D 1;
> +				break;
> +			}
> +		}
> +		cpuc->excl_cntrs->core_id =3D core_id;
> +		cpuc->excl_cntrs->refcnt++;
> +	}
>  }

This hard assumes theres only ever 2 threads, which is true and I
suppose more in arch/x86 will come apart the moment Intel makes a chip
with more, still, do we have topology_thread_id() or so to cure this?

--zgY/UHCnsaNnNXRx
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTkCpvAAoJEHZH4aRLwOS6x50P/0/q9uMaGx+b57zKkc/iC4YX
vjCkcwI1ZEDmsYIM8NogQjgovrRr3gcJ++xc6dTSM2vBYZFscI3ZxMk2lcCivlgv
aP9x0n1JVYQ3XefuCchdfZoATxRKJaWFlXZyGhoemxGbUw+qdut03iRTsI6ibNIW
994f8IGc+jLKKr4UptI9TBuiNIKpyhm6fdW2bbZ9ZPns/lnNGpRNe0CGL+2ZWB6F
XIdydWt+X18S9iBOcwtpKMNGyMCACU/zKoj9OTRqa7Johfe8z9peHgsBgxNYxUHQ
Q+QchoJdRSZfcnmtu8OfQ0k+pqFCA2hMPobCrFi5x1KhBTLiTDVX21ULk6nrbo8u
Mq3UCxzUoVgDKF/daUfDrfz1MoGPXZvLGvsCIyauTvWjvtS3+ICieNb/Ga/Rm/kB
9ylfUku6+MEvJg0Mh93dyURKU1sFFNJPcNSAMc51cVSK5Njliue/r/nQf+KlsQfv
rPxIhLcSZCbR04g0r+b0Zcs4zgrI5sP2GH00Xf/p3OrnMrkfoXu7bhUZfsRAEBnG
Q1FfBPFqzj25y2gPeg5jTrgN68Tmqo7J8C/DNd7IVRA7k0AYAWV3GKF9/OpaIw+2
Yg1LXeYY6VwIuTr2JmTUFQkYtqMVCl3kdtfweNbsZa3Ej9ME6OlQde6mj3EgYf7M
Erlc92XZG5G0ifgNf6a/
=k5jy
-----END PGP SIGNATURE-----

--zgY/UHCnsaNnNXRx--
