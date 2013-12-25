Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751518Ab3LYC7a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Dec 2013 21:59:30 -0500
Received: from mga14.intel.com ([143.182.124.37]:51772 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751232Ab3LYC72 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Dec 2013 21:59:28 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,546,1384329600"; 
   d="asc'?scan'208";a="330096178"
Date: Tue, 24 Dec 2013 21:40:48 -0500
From: "Chen, Gong" <gong.chen@linux.intel.com>
To: Prarit Bhargava <prarit@redhat.com>
Cc: linux-kernel@vger.kernel.org, Michel Lespinasse <walken@google.com>,
        Seiji Aguchi <seiji.aguchi@hds.com>,
        Yang Zhang <yang.z.zhang@Intel.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Janet Morgan <janet.morgan@Intel.com>, Tony Luck <tony.luck@Intel.com>,
        Ruiv Wang <ruiv.wang@gmail.com>, Andi Kleen <ak@linux.intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>, x86@kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] x86, irq, fix logical AND/OR error in
 check_irq_vectors_for_cpu_disable()
Message-ID: <20131225024048.GA29542@gchen.bj.intel.com>
Mail-Followup-To: Prarit Bhargava <prarit@redhat.com>,
	linux-kernel@vger.kernel.org, Michel Lespinasse <walken@google.com>,
	Seiji Aguchi <seiji.aguchi@hds.com>,
	Yang Zhang <yang.z.zhang@Intel.com>,
	Paul Gortmaker <paul.gortmaker@windriver.com>,
	Janet Morgan <janet.morgan@Intel.com>,
	Tony Luck <tony.luck@Intel.com>, Ruiv Wang <ruiv.wang@gmail.com>,
	Andi Kleen <ak@linux.intel.com>,
	"H. Peter Anvin" <hpa@linux.intel.com>, x86@kernel.org,
	stable@vger.kernel.org
References: <1387809552-20529-1-git-send-email-prarit@redhat.com>
 <20131224025059.GA24419@gchen.bj.intel.com>
 <52B989CD.6060403@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lrZ03NoBR/3+SXJZ"
Content-Disposition: inline
In-Reply-To: <52B989CD.6060403@redhat.com>
X-PGP-Key-ID: A43922C7
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--lrZ03NoBR/3+SXJZ
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 24, 2013 at 08:19:09AM -0500, Prarit Bhargava wrote:
> On 12/23/2013 09:51 PM, Chen, Gong wrote:
> > On Mon, Dec 23, 2013 at 09:39:12AM -0500, Prarit Bhargava wrote:
> >> diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
> >> index 7d40698..aed7acc 100644
> >> --- a/arch/x86/kernel/irq.c
> >> +++ b/arch/x86/kernel/irq.c
> >> @@ -281,7 +281,7 @@ int check_irq_vectors_for_cpu_disable(void)
> >>  			desc =3D irq_to_desc(irq);
> >>  			data =3D irq_desc_get_irq_data(desc);
> >>  			affinity =3D data->affinity;
> >> -			if (irq_has_action(irq) || !irqd_is_per_cpu(data) ||
> >> +			if (irq_has_action(irq) && !irqd_is_per_cpu(data) &&
> >>  			    !cpumask_subset(affinity, cpu_online_mask))
> >>  				this_count++;
> > Hi, Prarit
> >=20
> > I noticed that you don't mention another question I asked in last mail.
> >=20
> > "It looks like cpu_online_mask will be updated until cpu_disable_common
> > is called, but your check_vectors is called before that."
>=20
> Oh, I'm sorry ... Yes, check_irq_vectors_for_cpu_disable() is called befo=
re we
> remove the CPU from the maps.  If there is an error then we have to do mu=
ch less
> clean up of the code.  I explicitly take into account the cpu that is bei=
ng
> downed into the check vectors code.
>=20
Here is my question: How to decide this_count can be incrased?
1) it is a valid irq(irq_has_action) 2) it is not percpu irq(!irqd_is_per_c=
pu)
3) it is not shared with left online cpus(!cpumask_subset)

For item 3, I have some concerns.
Your current codes are called before cpu_disable_common, so affinity and
cpu_online_mask are both not updated. BTW, it means your calculation
for count is not correct because it concludes one to-be-off-lined cpu

+       for_each_online_cpu(cpu) {
+               if (cpu =3D=3D smp_processor_id())
+                       continue;
+               for (vector =3D FIRST_EXTERNAL_VECTOR; vector < NR_VECTORS;
+                    vector++) {
+                       if (per_cpu(vector_irq, cpu)[vector] < 0)
+                               count++;
+               }
+       }

Back to my question, assume cpu1 will be off-lined and one irq affinity is
set as (1, 2) -- this irq will be bypassed. Looks good. But if one irq
affinity is set as only (1), -- this irq is bypassed, too. Not right!

Furthermore, you even can't use cpumask_subset as evaluation condition,
whatever affinity/cpu_online_mask is updated or not. Let me paste the
comment of cpumask_subset:
/**
 * cpumask_subset - (*src1p & ~*src2p) =3D=3D 0
 * @src1p: the first input
 * @src2p: the second input
 *
 * Returns 1 if *@src1p is a subset of *@src2p, else returns 0
 */
Here we can see, even if src1p is an empty set, it still can be considered
as the subset of src2p. For our this special case, I mean cpu1 will
be off-lined and one irq affinity is set as (1). If this irq affinity
is updated to (0), it means no cpu is bound to this irq, but the
calculation of cpumask_subset will return true and this irq will be
bypassed. For this case, cpumask_empty should be more suitable.

--lrZ03NoBR/3+SXJZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJSukWwAAoJEI01n1+kOSLH35sP/jr52bZBYtnsfjnuSLWDX4F1
3VMipWUXPspYFQUQjR8oklijGWxw+TKrnVYlDRDjxOaUMAklN/0GBFARk4XRVc2p
8pVXUqk7YeM3SemR6Z71rU7fxkXcpn98SW+DapFtTMguWqqPNg2MzMcg5+OAbvEh
FHU1lcJpPKVNRA9VNEx8Jr5V6BJx7xoQarKYBPGqBdt1VnkJV/aINvBAr38vGBlm
Lx1xYCgPiBzVMecljKifZOqLHcf3UmYVTU77N/1oFUVo91LEbTK/gnnOOqew6jl8
dvKl1m8plxFIeZHtNcQdGkSGgiKDxbO7ivqKJdw3DwENOcuYxO/cJMEpTL0kYUsX
fNc13TXgRuAUnc94RgMn+CtLK9qOFt+CaS7MExWNVXagunudIY7VWlMyQhLRMPjb
ZvC7H/wAvxsz4Y63WLx0Kf4BVfRk4gMXKPmjmPb/HMfEO2jVdY/DC2hMrGbqVSfX
/3ZxS4BOEo9b1xJwHieyCx0zMmvxBjfmVjEf5Fkk98HOmqUibGbn6T/j9a/lQPNA
jq+dL6fImp8VCG1tLibkEpxYiJD7mQgoiSSU/8X1pMz8ZZAcFHVhqFWPY6osIZeA
rY2A19CmegH/CpJlCFACwnAdXnr6LxQFPgW7QVj8IE4QkHZKUCOrYyNBXOp1dkmA
4CTvM4RjMk8wPu7baKfg
=3fpI
-----END PGP SIGNATURE-----

--lrZ03NoBR/3+SXJZ--
