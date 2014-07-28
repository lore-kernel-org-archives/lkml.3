Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751701AbaG1GgN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 02:36:13 -0400
Received: from mga01.intel.com ([192.55.52.88]:2029 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751033AbaG1GgM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 02:36:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,746,1400050800"; 
   d="asc'?scan'208";a="568186082"
Date: Mon, 28 Jul 2014 02:04:55 -0400
From: "Chen, Gong" <gong.chen@linux.intel.com>
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, tglx@linutronix.de,
        paulus@samba.org, benh@kernel.crashing.org, tony.luck@intel.com,
        hpa@zytor.com, jkosina@suse.cz, rafael.j.wysocki@intel.com,
        linux@arm.linux.org.uk, ralf@linux-mips.org, schwidefsky@de.ibm.com,
        davem@davemloft.net, viro@zeniv.linux.org.uk, fweisbec@gmail.com,
        cl@linux.com, akpm@linux-foundation.org, axboe@kernel.dk,
        JBottomley@parallels.com, neilb@suse.de, christoffer.dall@linaro.org,
        rostedt@goodmis.org, rric@kernel.org, gregkh@linuxfoundation.org,
        mhocko@suse.cz, david@fromorbit.com
Subject: Re: [RFC PATCH v1 13/70] x86, x2apic_cluster: _FROZEN Cleanup
Message-ID: <20140728060455.GB23092@gchen.bj.intel.com>
References: <1406080786-3938-1-git-send-email-gong.chen@linux.intel.com>
 <1406080786-3938-14-git-send-email-gong.chen@linux.intel.com>
 <20140723203628.GJ21707@pd.tnic>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UHN/qo2QbUvPLonB"
Content-Disposition: inline
In-Reply-To: <20140723203628.GJ21707@pd.tnic>
X-PGP-Key-ID: A43922C7
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UHN/qo2QbUvPLonB
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 23, 2014 at 10:36:28PM +0200, Borislav Petkov wrote:
> Those checks dealing with CPU_TASKS_FROZEN in-between make the whole
> switch statement hard to follow.
>=20
> How about we go a step further and deal with CPU_UP_CANCELED_FROZEN
> upfront and even simplify the rest:
>=20

--------8<--------
Subject: [RFC PATCH v2 13/70] x86, x2apic_cluster: _FROZEN Cleanup

Remove XXX_FROZEN state from x86/x2apic_cluster.

Signed-off-by: Chen, Gong <gong.chen@linux.intel.com>
Suggested-by: Borislav Petkov <bp@alien8.de>
---
 arch/x86/kernel/apic/x2apic_cluster.c | 37 +++++++++++++++++++++++--------=
----
 1 file changed, 24 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kernel/apic/x2apic_cluster.c b/arch/x86/kernel/apic/x=
2apic_cluster.c
index e66766b..b8a6ea8 100644
--- a/arch/x86/kernel/apic/x2apic_cluster.c
+++ b/arch/x86/kernel/apic/x2apic_cluster.c
@@ -144,6 +144,20 @@ static void init_x2apic_ldr(void)
 	}
 }
=20
+static void __update_clusterinfo(unsigned int this_cpu)
+{
+	unsigned int cpu;
+
+	for_each_online_cpu(cpu) {
+		if (x2apic_cluster(this_cpu) !=3D x2apic_cluster(cpu))
+			continue;
+		__cpu_clear(this_cpu, per_cpu(cpus_in_cluster, cpu));
+		__cpu_clear(cpu, per_cpu(cpus_in_cluster, this_cpu));
+	}
+	free_cpumask_var(per_cpu(cpus_in_cluster, this_cpu));
+	free_cpumask_var(per_cpu(ipi_mask, this_cpu));
+}
+
  /*
   * At CPU state changes, update the x2apic cluster sibling info.
   */
@@ -151,34 +165,31 @@ static int
 update_clusterinfo(struct notifier_block *nfb, unsigned long action, void =
*hcpu)
 {
 	unsigned int this_cpu =3D (unsigned long)hcpu;
-	unsigned int cpu;
 	int err =3D 0;
=20
 	switch (action) {
 	case CPU_UP_PREPARE:
 		if (!zalloc_cpumask_var(&per_cpu(cpus_in_cluster, this_cpu),
-					GFP_KERNEL)) {
+					GFP_KERNEL))
 			err =3D -ENOMEM;
-		} else if (!zalloc_cpumask_var(&per_cpu(ipi_mask, this_cpu),
-					       GFP_KERNEL)) {
+		else if (!zalloc_cpumask_var(&per_cpu(ipi_mask, this_cpu),
+					     GFP_KERNEL)) {
 			free_cpumask_var(per_cpu(cpus_in_cluster, this_cpu));
 			err =3D -ENOMEM;
 		}
 		break;
 	case CPU_UP_CANCELED:
-	case CPU_UP_CANCELED_FROZEN:
 	case CPU_DEAD:
-		for_each_online_cpu(cpu) {
-			if (x2apic_cluster(this_cpu) !=3D x2apic_cluster(cpu))
-				continue;
-			__cpu_clear(this_cpu, per_cpu(cpus_in_cluster, cpu));
-			__cpu_clear(cpu, per_cpu(cpus_in_cluster, this_cpu));
-		}
-		free_cpumask_var(per_cpu(cpus_in_cluster, this_cpu));
-		free_cpumask_var(per_cpu(ipi_mask, this_cpu));
+		__update_clusterinfo(this_cpu);
+		break;
+	default:
 		break;
 	}
=20
+	if (test_and_clear_bit(CPU_TASKS_FROZEN, &action) &&
+	    (action =3D=3D CPU_UP_CANCELED))
+		__update_clusterinfo(this_cpu);
+
 	return notifier_from_errno(err);
 }
=20
--=20
2.0.0.rc2

--UHN/qo2QbUvPLonB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJT1egHAAoJEI01n1+kOSLH00IP/iQ75LDWxhh3fBN71jGVWS9Q
hj+DNx206dc9D/jKLq5cILyqYD1vUlBHeLmtT/Lz/LXT5NRBV/m/f8sziMkxDgUJ
b/Cl431kFkCZACdLuD1ouulvDn70eDVynWy9hjZ8ED4RNz8ptprCYyn26I8mtKU+
CO1z+QGhSG9t1gnIEDAbqBII7LMYSmQxbmmJxro02fxK06vl4vT5slCjVMuoiXmL
/+yjCjbsxzqpiC3xw6LlNW6D2xqvmMZTG5VXAyWR3EsyePtB9ihWy0Uj9abH6Kge
iCCXXgFlB+TuuV6bmIJ842RhL3cWyzCfvsEeUZ9l2wdn7EcOWcZ3/AWOSmcdhMQR
h3oplK66jSzIYIHYLe8ZH9/Smgw8VlEuwkoz249+8OJ3fBVzoxw3y8KuDfXSLv2g
Ytjq445uD4FDv5J7XP2WuvTxQQ/zK/cPHRgtueSOYu5q8J/oVZBGsiKcA7J4Hzb4
lKwhX1zZzh08GHAmrGCCXWN4KTbz85NR3EWXm3AJEFAg4jibShxElFCVovIivL3A
1oZy7Nm5xEz/KZgcGadyJk4lHSx1cvkzmA4zY6V57k5uf1badVE0UszlnifCFLW3
Ugazg9EV89V4IjqRvLEqKwLsuSUmdq6uPaTIejUe+F1m44Up7ww1UXXrAmanqUmy
eio01LhtaJjpjT4vfEM4
=NVh0
-----END PGP SIGNATURE-----

--UHN/qo2QbUvPLonB--
