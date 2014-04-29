Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755614AbaD2HNa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 03:13:30 -0400
Received: from ozlabs.org ([103.22.144.67]:41544 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750749AbaD2HN2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 03:13:28 -0400
Date: Tue, 29 Apr 2014 17:13:21 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Aaron Tomlin <atomlin@redhat.com>, Don Zickus <dzickus@redhat.com>
Subject: linux-next: build failure after merge of the akpm-current tree
Message-Id: <20140429171321.69409c76a15ad2a97761585c@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.1 (GTK+ 2.24.23; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__29_Apr_2014_17_13_21_+1000_fTlGq2cc/i2h0y4N"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__29_Apr_2014_17_13_21_+1000_fTlGq2cc/i2h0y4N
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

After merging the akpm tree, today's linux-next build (sparc64 defconfig)
failed like this:

arch/sparc/kernel/process_64.c: In function 'arch_trigger_all_cpu_backtrace=
':
arch/sparc/kernel/process_64.c:267:3: error: ISO C90 forbids mixed declarat=
ions and code [-Werror=3Ddeclaration-after-statement]
cc1: all warnings being treated as errors

Caused by commit dd0063a16aa1 ("nmi: provide the option to issue an NMI
back trace to every cpu but current").

I have no idea why I did not see this yesterday.

I applied the following fix up patch:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 29 Apr 2014 17:10:00 +1000
Subject: [PATCH] nmi-provide-the-option-to-issue-an-nmi-back-trace-to-every=
-cpu-but-current-fix

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 arch/sparc/kernel/process_64.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/sparc/kernel/process_64.c b/arch/sparc/kernel/process_64.c
index 65b405c36421..9975a6dbca0a 100644
--- a/arch/sparc/kernel/process_64.c
+++ b/arch/sparc/kernel/process_64.c
@@ -261,10 +261,12 @@ void arch_trigger_all_cpu_backtrace(bool include_self)
 	smp_fetch_global_regs();
=20
 	for_each_online_cpu(cpu) {
+		struct global_reg_snapshot *gp;
+
 		if (!include_self && cpu =3D=3D this_cpu)
 			continue;
=20
-		struct global_reg_snapshot *gp =3D &global_cpu_snapshot[cpu].reg;
+		gp =3D &global_cpu_snapshot[cpu].reg;
=20
 		__global_reg_poll(gp);
=20
--=20
2.0.0.rc0

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__29_Apr_2014_17_13_21_+1000_fTlGq2cc/i2h0y4N
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTX1EWAAoJEMDTa8Ir7ZwVMwMP/3/cpl3vglIXCkT/3aZCRRko
c/IcMC29Gfcqc38ehSRB9/OtnywTCWFR1ubEe4V6w5XJkk+QaqgypQ/1nEo/83Lx
taczxsMcND2hz+5PHDM5hik2V3+53B49c4/r7CXkaONc3IUhaRx2ZzZ7urYmj9+j
bfo+qM6EWT6yw+8MJVFrjtTku9kc8Sn9vrWArPal28UqgMOQvQCHXdJZd5kFOUK5
u8vtbDAeHCASC9dSsOFSTWzTf7eWuAKE6puRsy11BUoknuXo2ttPR+kvPBUdzfJj
eXY4VPNH6PKTEAwAOqEyyK6ocfFj9WNG3BlHzr0NUqzeryslKZvGJG8QKxN2nMlH
PeIvPTh8rhY8sGoZS02qesRSpsgiUqWfd9AD4NgyCFD4kW1/eWERI2FeKfY4Jm0w
nYBygQ1aZfH2tVmZ2FgZzWf6oJXCTHgIgOciLN+xjLtRUzeYGr4asIC/kmvN30YX
tRYmIlxRso/NNLAKRydn7Z0viK4HVtBmb9IzxMABC2SYMaNurCI9A3Mb4vKPVJnf
mBR5mlpliwGKho55ze8QKeG+MfoTw9elQ4K8jn+ARXkzNn/a6jfdMoLAzS3MjJva
pZzxSyvylcMvTa+6KS41PKMq3Jvl0Phe8vI638PxDETY/hAINhHDFqsIEJYMiZ3G
NOFDiaRXRFgRIyZnjOar
=nQ+T
-----END PGP SIGNATURE-----

--Signature=_Tue__29_Apr_2014_17_13_21_+1000_fTlGq2cc/i2h0y4N--
