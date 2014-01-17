Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751630AbaAQDp1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 22:45:27 -0500
Received: from ozlabs.org ([203.10.76.45]:44781 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750898AbaAQDpZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 22:45:25 -0500
Date: Fri, 17 Jan 2014 14:45:18 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Len Brown <lenb@kernel.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the tip tree
Message-Id: <20140117144518.231fa4bccb16a8d7edd36662@canb.auug.org.au>
In-Reply-To: <52D8625C.1000902@zytor.com>
References: <20140116145829.5e4fcab103b1c5c77501ee77@canb.auug.org.au>
	<20140116121955.GQ31570@twins.programming.kicks-ass.net>
	<20140117074628.88698f59939c9002b7c12968@canb.auug.org.au>
	<20140116222536.GX30183@twins.programming.kicks-ass.net>
	<20140117093426.ee8e3d1bb2e95c9f67ec625b@canb.auug.org.au>
	<52D8625C.1000902@zytor.com>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__17_Jan_2014_14_45_18_+1100_mdrD0f9aYYlxi6dA"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__17_Jan_2014_14_45_18_+1100_mdrD0f9aYYlxi6dA
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

On Thu, 16 Jan 2014 14:51:08 -0800 "H. Peter Anvin" <hpa@zytor.com> wrote:
>
> On 01/16/2014 02:34 PM, Stephen Rothwell wrote:
> >=20
> > On Thu, 16 Jan 2014 23:25:36 +0100 Peter Zijlstra
> > <peterz@infradead.org> wrote:
> >>=20
> >> On Fri, Jan 17, 2014 at 07:46:28AM +1100, Stephen Rothwell
> >> wrote:
> >>>=20
> >>> On Thu, 16 Jan 2014 13:19:55 +0100 Peter Zijlstra
> >>> <peterz@infradead.org> wrote:
> >>>>=20
> >>>> I think the below ought to work
> >>>=20
> >>> To be clear, all you did was replace the body of mwait_idle()
> >>> with
> >>>=20
> >>> mwait_idle_with_hints(0, 0);
> >>=20
> >> Pretty much, and add the asm/mwait.h include, otherwise you'll
> >> end up with a compile fail.
> >>=20
> >>> (and the comment above it)?  I need to apply in incremental
> >>> patch in the merge commit.
> >>=20
> >> I don't think I touched the comment at all.
> >=20
>=20
> In retrospect this bit probably should have gone through the idle
> tree.  That was my bad, I need to coordinate with Len better.

So this is what I added as a merge fix patch.  Someone just needs to make
sure Linus gets this when the latter of the tow trees gets merged.

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Fri, 17 Jan 2014 14:42:06 +1100
Subject: [PATCH] x86 idle: mwait_idle merge update

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 arch/x86/kernel/process.c | 14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index db471a87fdd8..4da840f01561 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -28,6 +28,7 @@
 #include <asm/fpu-internal.h>
 #include <asm/debugreg.h>
 #include <asm/nmi.h>
+#include <asm/mwait.h>
=20
 /*
  * per-CPU TSS segments. Threads are completely 'soft' on Linux,
@@ -427,18 +428,7 @@ static int prefer_mwait_c1_over_halt(const struct cpui=
nfo_x86 *c)
=20
 static void mwait_idle(void)
 {
-	if (!need_resched()) {
-		if (this_cpu_has(X86_FEATURE_CLFLUSH_MONITOR))
-			clflush((void *)&current_thread_info()->flags);
-
-		__monitor((void *)&current_thread_info()->flags, 0, 0);
-		smp_mb();
-		if (!need_resched())
-			__sti_mwait(0, 0);
-		else
-			local_irq_enable();
-	} else
-		local_irq_enable();
+	mwait_idle_with_hints(0, 0);
 }
=20
 void select_idle_routine(const struct cpuinfo_x86 *c)
--=20
1.8.5.2


--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__17_Jan_2014_14_45_18_+1100_mdrD0f9aYYlxi6dA
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJS2KdSAAoJEMDTa8Ir7ZwVWa8P/i7U9spYNw9dHvQKG5S+qJSB
2Wx7gaAOypdvQ+gVrURKAep9N9m46/AGSx+UuJ2X9wlmN6SaV7Q5DmfoiufLX8Xq
pkc6EjmzP9rsimjwOas4VIkXdzp/DzsOhVKVF6e6FZ1G0n0nb5bFN7pk36drHXMH
ejqBijL/jdS9e0yIr4qD8CmymclSON1AkPrOpW4sM37tCbQHHWxuJk5BzxUonpGF
nUghGPqDFRVuzzwpq8q4Klb1nP3Na9nx4sUDt5HOnYmpnqxxNlyI2hUf1TAlTxRg
SrcEapnMKwGgiJMM8+G7jkiodL4ynxRb0D1D7tVptkmoFmSeHzUdwatt8Z1p7oBz
DXb+FXDMo/pIlztFR6lUs1w/SqkqbEqTYMNyOWmUn1PJE5idrNTOakZNk2L2l8qU
Ht1URah51Vkvzjz2c5ExUvix+nYM+lZ2fWNgy/bWL0KGYbVKVJzlOkzMUbhWEEOJ
5jCepJIEH3Fx0HFacLd8ecken6KDitUm6X+EILO3cAMppwlv/TzbQQgBP52jmwVk
Q4q0EQRi+cRWkjflxGP2qGrGLnmlVT0MuSLdsPzdLcnVaOGKWbUwXcb2RZ1DezKN
/widAt1Li8gchqJzqTIJNWe2oqRRZyxGWrjg9Ddq+xjhE+IksKHi0UiMfVK0acow
FYq27ByFCx6A10h3W366
=LFbW
-----END PGP SIGNATURE-----

--Signature=_Fri__17_Jan_2014_14_45_18_+1100_mdrD0f9aYYlxi6dA--
