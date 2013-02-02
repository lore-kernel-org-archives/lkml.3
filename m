Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757600Ab3BBM4G (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 07:56:06 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:60381 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754197Ab3BBM4C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 07:56:02 -0500
Date: Sat, 2 Feb 2013 23:55:52 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shaohua Li <shli@kernel.org>, Wang YanQing <udknight@gmail.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: linux-next: manual merge of the akpm-current tree with Linus' tree
Message-Id: <20130202235552.ec4d7df1a82b91934fbbd84c@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Sat__2_Feb_2013_23_55_52_+1100_GzbhVhPJ.A23Zn2T"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__2_Feb_2013_23_55_52_+1100_GzbhVhPJ.A23Zn2T
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm-current tree got a conflict in
kernel/smp.c between commit f44310b98ddb ("smp: Fix SMP function call
empty cpu mask race") from Linus' tree and commit "smp: make
smp_call_function_many() use logic similar to smp_call_function_single()"
from the akpm-current tree.

I fixed it up (I think - see below) and can carry the fix as necessary
(no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc kernel/smp.c
index 69f38bd,bb92c52..0000000
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@@ -57,9 -47,11 +47,15 @@@ hotplug_cfd(struct notifier_block *nfb
  		if (!zalloc_cpumask_var_node(&cfd->cpumask, GFP_KERNEL,
  				cpu_to_node(cpu)))
  			return notifier_from_errno(-ENOMEM);
 +		if (!zalloc_cpumask_var_node(&cfd->cpumask_ipi, GFP_KERNEL,
 +				cpu_to_node(cpu)))
 +			return notifier_from_errno(-ENOMEM);
+ 		cfd->csd =3D alloc_percpu(struct call_single_data);
+ 		if (!cfd->csd) {
++			free_cpumask_var(cfd->cpumask_ipi);
+ 			free_cpumask_var(cfd->cpumask);
+ 			return notifier_from_errno(-ENOMEM);
+ 		}
  		break;
 =20
  #ifdef CONFIG_HOTPLUG_CPU
@@@ -69,7 -61,7 +65,8 @@@
  	case CPU_DEAD:
  	case CPU_DEAD_FROZEN:
  		free_cpumask_var(cfd->cpumask);
 +		free_cpumask_var(cfd->cpumask_ipi);
+ 		free_percpu(cfd->csd);
  		break;
  #endif
  	};

--Signature=_Sat__2_Feb_2013_23_55_52_+1100_GzbhVhPJ.A23Zn2T
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRDQzYAAoJEECxmPOUX5FEC18P/iB1TLi4iYbPjs342MA1Cj6f
sJvGbm8kTX1I/BI4jELzsKUMNF6WEJN3h6q3LTNK1asxM3tmdKz/j8fEpfYoGjNa
L+WJH8sorEZlWbQKfjhTHgYJpqPsJbN0ZUc5M8nGk27XxzrVGzaT5syhnwZPiY+X
NiamnmyiDHEypGsqxFQluEq0UScsw0SREXAZQIq0NYaqBaDiUeFiG5cIdswQLfxK
srn/5I8lRMZX/gFHAR1gxMgnnFqiLZ5BMFjxPblPsZa5XouQwMPyZQewFlnKdyAE
2lnaDeaqz41Z0Fb9a9tm68WRMWRQc8HanI+ZUDtcqE6ltp3cG/kwPJjaHhM/FHtn
4t52X5aTRujwj1AeDFKtp2inlAvghrXDCUY6lAuB4tG91411H5vIcYLIEo2NIWKV
X4OA9pxZ2IlvLg8uqwsz89s43DBozMviDEmp8IHiQtHOy72p9Qrka40EcMdAxN+x
Fk0osMr/bueIIzqT7MWBZiEJyEwtONUYNn6x4YvJzxZoaU6tjgfb9Nt6XVz+k9/o
25pqspCV5g9pHIR54dt5iG78X0Od+D1QcCMncCznA3+QkMMy1fKxhlvkIL2ap27/
iezbl+rDhN6odfctcbqeQ3nk+di0s++XDZLPvYDgIykpy3WHL9Y8KcTxyx3VG4qL
N5yirsvrNNYQ5ggIMM3a
=SCYj
-----END PGP SIGNATURE-----

--Signature=_Sat__2_Feb_2013_23_55_52_+1100_GzbhVhPJ.A23Zn2T--
