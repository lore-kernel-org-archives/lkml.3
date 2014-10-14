Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755674AbaJNVic (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 17:38:32 -0400
Received: from ozlabs.org ([103.22.144.67]:37201 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751078AbaJNVib (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 17:38:31 -0400
Date: Wed, 15 Oct 2014 08:38:22 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        Christoph Lameter <cl@linux-foundation.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [GIT PULL] percpu consistent-ops changes for v3.18-rc1
Message-ID: <20141015083822.0f78e28b@canb.auug.org.au>
In-Reply-To: <20141014130752.GA14897@htj.dyndns.org>
References: <20141014130752.GA14897@htj.dyndns.org>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/Vb3l5xclFy/5zU3BkBXVcsM"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/Vb3l5xclFy/5zU3BkBXVcsM
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Linus,

On Tue, 14 Oct 2014 09:07:52 -0400 Tejun Heo <tj@kernel.org> wrote:
>
> 2. arch/s390/kernel/vtime.c
>=20
> b5f87f15e200 ("s390/idle: consolidate idle functions and definitions")
> removes two functions which contained percpu accesses.
>=20
>   <<<<<<< HEAD
>   =3D=3D=3D=3D=3D=3D=3D
>   void __kprobes vtime_stop_cpu(void)
>   {
> 	  struct s390_idle_data *idle =3D this_cpu_ptr(&s390_idle);
> 	  unsigned long long idle_time;
> 	  unsigned long psw_mask;
>=20
> 	  trace_hardirqs_on();
>=20
> 	  /* Wait for external, I/O or machine check interrupt. */
> 	  psw_mask =3D PSW_KERNEL_BITS | PSW_MASK_WAIT | PSW_MASK_DAT |
> 		  PSW_MASK_IO | PSW_MASK_EXT | PSW_MASK_MCHECK;
> 	  idle->nohz_delay =3D 0;
>=20
> 	  /* Call the assembler magic in entry.S */
> 	  psw_idle(idle, psw_mask);
>=20
> 	  /* Account time spent with enabled wait psw loaded as idle time. */
> 	  idle->sequence++;
> 	  smp_wmb();
> 	  idle_time =3D idle->clock_idle_exit - idle->clock_idle_enter;
> 	  idle->clock_idle_enter =3D idle->clock_idle_exit =3D 0ULL;
> 	  idle->idle_time +=3D idle_time;
> 	  idle->idle_count++;
> 	  account_idle_time(idle_time);
> 	  smp_wmb();
> 	  idle->sequence++;
>   }
>=20
>   cputime64_t s390_get_idle_time(int cpu)
>   {
> 	  struct s390_idle_data *idle =3D &per_cpu(s390_idle, cpu);
> 	  unsigned long long now, idle_enter, idle_exit;
> 	  unsigned int sequence;
>=20
> 	  do {
> 		  now =3D get_tod_clock();
> 		  sequence =3D ACCESS_ONCE(idle->sequence);
> 		  idle_enter =3D ACCESS_ONCE(idle->clock_idle_enter);
> 		  idle_exit =3D ACCESS_ONCE(idle->clock_idle_exit);
> 	  } while ((sequence & 1) || (ACCESS_ONCE(idle->sequence) !=3D sequence)=
);
> 	  return idle_enter ? ((idle_exit ?: now) - idle_enter) : 0;
>   }
>=20
>   >>>>>>> 513d1a2884a49654f368b5fa25ef186e976bdada
>=20
> The conflicting code can be removed.

This actually moved some of the code into a new file and so, for
completeness, I have been carrying the following merge fix patch (which
you could include in the merge - but I am not sure if it matters if the
old accessors are still around):

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 7 Oct 2014 16:44:38 +1100
Subject: [PATCH] s390: fixup for Replace __get_cpu_var uses

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 arch/s390/kernel/idle.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/kernel/idle.c b/arch/s390/kernel/idle.c
index c75fbae1e37e..9d19a91dc6a6 100644
--- a/arch/s390/kernel/idle.c
+++ b/arch/s390/kernel/idle.c
@@ -20,7 +20,7 @@ static DEFINE_PER_CPU(struct s390_idle_data, s390_idle);
=20
 void __kprobes enabled_wait(void)
 {
-	struct s390_idle_data *idle =3D &__get_cpu_var(s390_idle);
+	struct s390_idle_data *idle =3D this_cpu_ptr(&s390_idle);
 	unsigned long long idle_time;
 	unsigned long psw_mask;
=20
--=20
2.1.1

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/Vb3l5xclFy/5zU3BkBXVcsM
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUPZfTAAoJEMDTa8Ir7ZwVLyEP+wV5tTLG0nZwLJ3kR8OISaqZ
C8RUT+/Bs6rccI4rgqFrj4tlwb75jGfNQg+06yfdbEuWbw0X15R3LUd+Q0VEVchI
2PwvGRssni9SfngZit8MuGOWJPofIacTYZiCxMsPolvBvBysvNgLcAblDDpHWqei
VzRwIiwDcxh5XsL0faTxy17VmfkK5leeVrGRjWPBnu59F6cjCMB9ek5vWwRzNRCh
m+ahXKwyzLF68FEJirNss/kDzGc3pu+K38d/+YIXFRzWjknagbqM9aQSC6nWVHts
HKuImjfb70e8PJL06bBA8GrPatLhunEDFJwBdYQSkDaAbfY2OuJk3IvilabG5CV+
YmldB+h29y/vTsbWN++qoAXfVHFcE/nEWiEWqMbGGDiJ2N60qCsi3Vbog2uwhVU3
CQ0Ty2BCazypdTONUy+rt/imw6x6u7NjvIJo34NU5zatIWVxkRB26IuP9qYDNdo4
o/igSsL3vuqcKmhcPsSL++nLQ5lMYChtyyM0/dZV2CRTCCc1VDDMeB97l6X4dKE1
C/jUjt4mRS7kROUP0aT1ThABnN0vBao0ytybb3XmYGNa6200J9fOZ31Z+p0aVsVX
EVm+RUMbfH9Ueco+rd0KSocTs8K8tBCgWvK4NQkE+1gJMILsZ+5Rn5OJPlfBSyGK
PnxR79Hhg8qd+xib9RYD
=Snos
-----END PGP SIGNATURE-----

--Sig_/Vb3l5xclFy/5zU3BkBXVcsM--
