Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752169AbaE1Kaq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 06:30:46 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:34052 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780AbaE1Kap (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 06:30:45 -0400
Date: Wed, 28 May 2014 12:30:19 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Libo Chen <libo.chen@huawei.com>,
        Mike Galbraith <umgwanakikbuti@gmail.com>, mingo@elte.hu,
        LKML <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>, Li Zefan <lizefan@huawei.com>,
        Huang Qiang <h.huangqiang@huawei.com>, bp@alien8.de
Subject: Re: balance storm
Message-ID: <20140528103019.GT11096@twins.programming.kicks-ass.net>
References: <538330B7.5070503@huawei.com>
 <1401113960.23186.41.camel@marge.simpson.net>
 <53844510.1040502@huawei.com>
 <1401184553.5134.115.camel@marge.simpson.net>
 <53848A2C.5010209@huawei.com>
 <1401196807.5134.132.camel@marge.simpson.net>
 <53853604.50500@huawei.com>
 <1401242038.4721.14.camel@marge.simpson.net>
 <5385881D.4090601@huawei.com>
 <alpine.DEB.2.02.1405281106130.21720@ionos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="a3TIYp8vN9YM5Qs8"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1405281106130.21720@ionos.tec.linutronix.de>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--a3TIYp8vN9YM5Qs8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 28, 2014 at 11:08:40AM +0200, Thomas Gleixner wrote:
> On Wed, 28 May 2014, Libo Chen wrote:
>=20
> > On 2014/5/28 9:53, Mike Galbraith wrote:
> > > On Wed, 2014-05-28 at 09:04 +0800, Libo Chen wrote:
> > >=20
> > >> oh yes, no tsc only hpet in my box.
> > >=20
> > > Making poor E5-2658 box a crippled wreck.
> >=20
> > yes,it is. But cpu usage will be down from 15% to 5% when binding
> > cpu, so maybe read_hpet is not the root cause.
>=20
> Definitely hpet _IS_ the root cause on a machine as large as this,
> simply because everything gets serialized on the hpet access.
>=20
> Binding stuff to cpus just makes the timing behaviour different, so
> the hpet serialization is not that prominent, but still bad enough.
>=20
> Talk to your HW/BIOS vendor. The kernel cannot do anything about
> defunct hardware.

---
Subject: x86: FW_BUG when the TSC goes funny on hardware where it really sh=
ould be stable

It happens far too often on 'consumer' grade hardware, and sometimes on
'enterprise' too that the TSC gets marked unstable due to FW fuckage,
complain more loudly in this case.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 arch/x86/include/asm/tsc.h  | 1 +
 arch/x86/kernel/cpu/amd.c   | 4 +++-
 arch/x86/kernel/cpu/intel.c | 4 +++-
 arch/x86/kernel/tsc.c       | 7 +++++++
 4 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/tsc.h b/arch/x86/include/asm/tsc.h
index 94605c0e9cee..e33853ee0416 100644
--- a/arch/x86/include/asm/tsc.h
+++ b/arch/x86/include/asm/tsc.h
@@ -52,6 +52,7 @@ extern int check_tsc_unstable(void);
 extern int check_tsc_disabled(void);
 extern unsigned long native_calibrate_tsc(void);
=20
+extern int tsc_should_be_reliable;
 extern int tsc_clocksource_reliable;
=20
 /*
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index ce8b8ff0e0ef..46012d2ca5a1 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -483,8 +483,10 @@ static void early_init_amd(struct cpuinfo_x86 *c)
 	if (c->x86_power & (1 << 8)) {
 		set_cpu_cap(c, X86_FEATURE_CONSTANT_TSC);
 		set_cpu_cap(c, X86_FEATURE_NONSTOP_TSC);
-		if (!check_tsc_unstable())
+		if (!check_tsc_unstable()) {
+			tsc_should_be_reliable =3D 1;
 			set_sched_clock_stable();
+		}
 	}
=20
 #ifdef CONFIG_X86_64
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index a80029035bf2..2273ca1166bc 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -88,8 +88,10 @@ static void early_init_intel(struct cpuinfo_x86 *c)
 	if (c->x86_power & (1 << 8)) {
 		set_cpu_cap(c, X86_FEATURE_CONSTANT_TSC);
 		set_cpu_cap(c, X86_FEATURE_NONSTOP_TSC);
-		if (!check_tsc_unstable())
+		if (!check_tsc_unstable()) {
+			tsc_should_be_reliable =3D 1;
 			set_sched_clock_stable();
+		}
 	}
=20
 	/* Penwell and Cloverview have the TSC which doesn't sleep on S3 */
diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 57e5ce126d5a..1f93827561d8 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -40,6 +40,7 @@ static int __read_mostly tsc_disabled =3D -1;
=20
 static struct static_key __use_tsc =3D STATIC_KEY_INIT;
=20
+int tsc_should_be_reliable;
 int tsc_clocksource_reliable;
=20
 /*
@@ -994,6 +995,12 @@ void mark_tsc_unstable(char *reason)
 		clear_sched_clock_stable();
 		disable_sched_clock_irqtime();
 		pr_info("Marking TSC unstable due to %s\n", reason);
+
+		if (tsc_should_be_reliable) {
+			pr_err(FW_BUG "TSC unstable even though it should be; "
+				      "HW/BIOS broken, contact your vendor.\n");
+		}
+
 		/* Change only the rating, when not registered */
 		if (clocksource_tsc.mult)
 			clocksource_mark_unstable(&clocksource_tsc);

--a3TIYp8vN9YM5Qs8
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJThbq7AAoJEHZH4aRLwOS6rWsP+wfm7+SLiIxe0qRgey1i60Xw
Ydvafh3Sb6WITWe3nrgcdXgCp9CqaiEjkaEiLjPLv+JqMS2BAZrLi/Nnj7ZpH+7j
jhJuotV81Tsm1bD3BvynCml4dMYQuW9drDpoC4Wy+uuUsinRlNhBaRnPvl0j4vrn
fawxojik+cV887ZeT0AojBJuH4lh4DievZf3CNd8JZc/wqysDvRA+XWgwApoNXyI
1zFTBChNMxPTzbNRMBJkVh6nES18ovasunb5Z0Ov48eB2nvkfFUtpV2Y6KNK2qSz
CmchpTGoe3GwJJTC7UxwvSaOuAIGDk04Vv+XNIB0XPjQbXGPRuFWnrtpv++OGjdz
ZFtJyDkpAVscSVbx4oMuKbTLWrQy528n+s5MB9Dvm3WnFwkW760Y9jIYooIPvuFE
KlnF8kflolkR0+iChjJ/cvpUMhoqxB7rmX2nEcCl01+ud3oZ34TuC3koawcg9HDE
IEwxr7zFGc/hp/ooSFDYyZm409ABM4IEWmq6fVd2Hr3IEjkEAsbq0rCOkYaGWJ4G
85XjzYjg3ewoSHjqNvTutXc92LZey2KOHiKEbPVvIdgLqOlQtlJ0z08ymk1EhSIb
1AkFYWmV74ZTTmkdpr04wgQalUY6fzgnCdWLnWaZ+BniV9KoJn2YFGWqNOLMnwLr
N1FGGFROOjeQxZkF20nJ
=o7Gp
-----END PGP SIGNATURE-----

--a3TIYp8vN9YM5Qs8--
