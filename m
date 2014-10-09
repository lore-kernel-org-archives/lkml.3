Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751061AbaJIEup (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 00:50:45 -0400
Received: from ozlabs.org ([103.22.144.67]:53357 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750705AbaJIEuf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 00:50:35 -0400
Date: Thu, 9 Oct 2014 15:50:18 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tejun Heo <tj@kernel.org>, Rusty Russell <rusty@rustcorp.com.au>,
        Christoph Lameter <cl@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: linux-next: manual merge of the percpu tree with the tip tree
Message-ID: <20141009155018.0b8f26f6@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/iG5sr5sZ1a8J7qcJrqkN+pp"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/iG5sr5sZ1a8J7qcJrqkN+pp
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the percpu tree got a conflict in
kernel/irq_work.c between commit 76a33061b932 ("irq_work: Force raised
irq work to run on irq work interrupt") from the tip tree and commit
22127e93c587 ("time: Replace __get_cpu_var uses") from the percpu tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc kernel/irq_work.c
index 385b85aded19,345d19edcdae..000000000000
--- a/kernel/irq_work.c
+++ b/kernel/irq_work.c
@@@ -113,12 -113,10 +113,12 @@@ bool irq_work_needs_cpu(void
  {
  	struct llist_head *raised, *lazy;
 =20
- 	raised =3D &__get_cpu_var(raised_list);
- 	lazy =3D &__get_cpu_var(lazy_list);
+ 	raised =3D this_cpu_ptr(&raised_list);
+ 	lazy =3D this_cpu_ptr(&lazy_list);
 -	if (llist_empty(raised) && llist_empty(lazy))
 -		return false;
 +
 +	if (llist_empty(raised) || arch_irq_work_has_interrupt())
 +		if (llist_empty(lazy))
 +			return false;
 =20
  	/* All work should have been flushed before going offline */
  	WARN_ON_ONCE(cpu_is_offline(smp_processor_id()));

--Sig_/iG5sr5sZ1a8J7qcJrqkN+pp
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUNhQRAAoJEMDTa8Ir7ZwVueoP/ReceBSkl2xZU0r/s1U5RLMU
5/d3Ll0prby3YRl7njOuz9XHlRyYGRpspdS9p9J24su586f/3uoQmQM2YiyAbTiu
6WIVaVehby+faCeLRcCVRrPZ1WurWwjoCLYFRhcshTvACAvEpNQAluaNAiDwwPp1
e4MUMXfHT4n0pt4Uw2LOKnHIHmzTJUDo7FkzGOc71XVxFYVt7FeXwyPAa5CzwBJ3
70o1zrs/6CmCW9D30eyCSTssFdQ1kR3XszW0hV0TyPXvv9xvsJyMf1MlAQYol00p
vyceFWYGEjntMZpu+NrmwmL/mulFlFaXt4VB69Uah0J2OzLQ98guITohsYPQFmKq
8J11O+d3rf5TBsjPIlT/bA9hnSMSDbopQOppLD6/sFx1DEcV6lMKHay2My7s5o1e
fnlkl5A/Otbfy0h05gGKF81xwdA79gV7lW08qpEznjiqu6QVXpSZ/d6EDmyc66pQ
OZkvhcVYzCunWR2OLS7fMJCI0q/fRxN8EIFnukDPcBCf+e4lAXZtjPQv/7to2QQ2
a/XHFrYQCYL2p63TyaPS2Imeh6I81RylE0COYRxoKKTQET9P7t5tLIxPsEH/fNli
1ABBpfiiiudil5xm69RCGssogt6c5VLNcpuji1Z7HmfWN9jSlRT3cdHC60P35vqJ
I9fUeKTWeuN0aeDcGFTo
=IbwC
-----END PGP SIGNATURE-----

--Sig_/iG5sr5sZ1a8J7qcJrqkN+pp--
