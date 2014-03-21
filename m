Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753512AbaCUEX1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 00:23:27 -0400
Received: from ozlabs.org ([203.10.76.45]:42108 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751420AbaCUEXO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 00:23:14 -0400
Date: Fri, 21 Mar 2014 15:23:03 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Stephane Eranian <eranian@google.com>
Subject: linux-next: manual merge of the tip tree with Linus' tree
Message-Id: <20140321152303.5e4071c94957a70831edd1a1@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__21_Mar_2014_15_23_03_+1100_UUE4hhb1cD8HTSyH"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__21_Mar_2014_15_23_03_+1100_UUE4hhb1cD8HTSyH
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the tip tree got a conflict in
arch/x86/kernel/cpu/perf_event_intel_uncore.c between commit 2c666adacc9e
("x86, intel, uncore: Fix CPU hotplug callback registration") from Linus'
tree and commit 411cf180fa00 ("perf/x86/uncore: fix initialization of
cpumask") from the tip tree.

I fixed it up (maybe incorrectly - see below) and can carry the fix as
necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/x86/kernel/cpu/perf_event_intel_uncore.c
index 28922f62eb29,bd2253d40cff..000000000000
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
@@@ -3868,6 -4234,41 +4234,41 @@@ static int __init uncore_pmus_register(
  	return 0;
  }
 =20
+ static void __init uncore_cpumask_init(void)
+ {
+ 	int cpu;
+=20
+ 	/*
+ 	 * ony invoke once from msr or pci init code
+ 	 */
+ 	if (!cpumask_empty(&uncore_cpu_mask))
+ 		return;
+=20
 -	get_online_cpus();
++	cpu_notifier_register_begin();
+=20
+ 	for_each_online_cpu(cpu) {
+ 		int i, phys_id =3D topology_physical_package_id(cpu);
+=20
+ 		for_each_cpu(i, &uncore_cpu_mask) {
+ 			if (phys_id =3D=3D topology_physical_package_id(i)) {
+ 				phys_id =3D -1;
+ 				break;
+ 			}
+ 		}
+ 		if (phys_id < 0)
+ 			continue;
+=20
+ 		uncore_cpu_prepare(cpu, phys_id);
+ 		uncore_event_init_cpu(cpu);
+ 	}
+ 	on_each_cpu(uncore_cpu_setup, NULL, 1);
+=20
 -	register_cpu_notifier(&uncore_cpu_nb);
++	__register_cpu_notifier(&uncore_cpu_nb);
+=20
 -	put_online_cpus();
++	cpu_notifier_register_done();
+ }
+=20
+=20
  static int __init intel_uncore_init(void)
  {
  	int ret;

--Signature=_Fri__21_Mar_2014_15_23_03_+1100_UUE4hhb1cD8HTSyH
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTK76vAAoJEMDTa8Ir7ZwVGjgP/ivFVvladrihLURVghvhTLTf
ZhmjGJ+lQj+SjucfIm8DI1lFJb89snhwOh3cp6gRv+q1ZGRBhBn9kUjn5NhrlTBy
g3NllaqNzETaeSVGCUXf24T198U/+4AFq43+WaX7xYJvmpuNW3CjljMNR7l8sREE
SucSlvQC86zLoFkhVJgE0C4AQ7zooqd4tDA+s65dntMeDyt95Bmh1SC9sVhdkacg
Rpnzc08HQBqOxEb8S60HLKpEepXaAckt8AW13NXccmx4RCu8bxHRNeXAr6gNLniN
bWvvi02klMYykbj6fGVyPjsaU7B091Xslhs60Oi6d8scix18NR8lj+ELIFjqITnn
ELhEPJgf1tSDuB3gtDFGi2fPGBbgkHrTBY92AV5x4gdODVoaeXvBNKyNG3FjFmdy
0AIbssZx1fF/rZ+o+jqbOZXDPNfXJetqJC7yrPjh//no3Qh0GtT61q06wrR8kj+J
7+0WZNpuA7Ocyhxhbzgr/eaED9XeKTZcZ026RXE/wVnfJqziZfqxRM2rkQJTKbaW
/2UFqpIDQld1StXFvFwe7xzhLH7p43ywtShirOV9lt4IRU2ICyzSP7zkh6f97cv2
oYKXFmUaqgnAirKDVttf9b2gNKTIf+rBCIWZfBx/AnIsy354jkYa9lRCXZkRkmLa
A/T5pVwr0fEK+GBKUYIx
=DKYq
-----END PGP SIGNATURE-----

--Signature=_Fri__21_Mar_2014_15_23_03_+1100_UUE4hhb1cD8HTSyH--
