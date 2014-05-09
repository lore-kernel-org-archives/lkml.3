Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756838AbaEIOv4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 10:51:56 -0400
Received: from [217.156.133.130] ([217.156.133.130]:15804 "EHLO
	imgpgp01.kl.imgtec.org" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751744AbaEIOvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 10:51:52 -0400
X-PGP-Universal: processed;
	by imgpgp01.kl.imgtec.org on Fri, 09 May 2014 15:51:50 +0100
Message-ID: <536CEB7E.9080007@imgtec.com>
Date: Fri, 9 May 2014 15:51:42 +0100
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        <luto@amacapital.net>, <nicolas.pitre@linaro.org>,
        <daniel.lezcano@linaro.org>, <umgwanakikbuti@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        linux-metag <linux-metag@vger.kernel.org>
Subject: Re: [RFC][PATCH 6/8] sched,idle: Avoid spurious wakeup IPIs
References: <20140411134243.160989490@infradead.org> <20140411135218.478299389@infradead.org> <CAAG0J9_q1KsUx10-XAb7AJnxv2ehctg6q1KME7ahsk1OZV8vZQ@mail.gmail.com> <20140509141520.GV2844@laptop.programming.kicks-ass.net>
In-Reply-To: <20140509141520.GV2844@laptop.programming.kicks-ass.net>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="XRGQ5l3AK6IVg9cdokvLQ2Rg8eMijQUpC"
X-Originating-IP: [192.168.154.101]
X-ESG-ENCRYPT-TAG: 2110538f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--XRGQ5l3AK6IVg9cdokvLQ2Rg8eMijQUpC
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 09/05/14 15:15, Peter Zijlstra wrote:
> On Fri, May 09, 2014 at 02:37:27PM +0100, James Hogan wrote:
>> Hi Peter,
>>
>> On 11 April 2014 14:42, Peter Zijlstra <peterz@infradead.org> wrote:
>>> +       return !(fetch_or(&ti->flags, _TIF_NEED_RESCHED) & _TIF_POLLI=
NG_NRFLAG);
>>
>> This breaks the build on metag, and I suspect arm64 too:
>=20
> Yep, I just got a patch for arm64.
>=20
>> kernel/sched/core.c In function =E2=80=98set_nr_and_not_polling=E2=80=99=
:
>> kernel/sched/core.c +531 : error: =E2=80=98_TIF_POLLING_NRFLAG=E2=80=99=
 undeclared
>>
>> since metag/arm64 define TIF_POLLING_NRFLAG but not
>> _TIF_POLLING_NRFLAG. Could you please fix that prior to your patch to
>> avoid breaking bisection?
>=20
> Ingo, is there any git magic to make that happen? Can we have a tree
> with 2 patches (one for ARM64 and one for metag) before the sched/core
> tree?
>=20
>> BTW what is it that determines whether an arch needs TIF_POLLING_NRFLA=
G?
>=20
> Any SMP arch that has a polling idle function of any kind (including th=
e
> default cpu_idle_poll()).
>=20
> That said, even if that's true, not having TIF_POLLING_NRFLAG isn't
> fatal, just sub-optimal in that we'll send an unconditional IPI to wake=

> the CPU even though its polling TIF_NEED_RESCHED and doesn't need
> anything other than that write to wake up.
>=20
> Most archs have (x86) hlt or (arm) wfi like idle instructions, and if
> that is your only possible idle function, you'll require the interrupt
> to wake up and there's really no point to having the POLLING bit.
>=20
> Lastly, having the POLLING bit and not needing it is similarly non-fata=
l.
>=20

Thanks. I think the flag can go for Metag then. I suggest the following
patch.

Cheers
James

=46rom 15dd3f9cc18bdb1c8c4d2c395778421022250aa8 Mon Sep 17 00:00:00 2001
From: James Hogan <james.hogan@imgtec.com>
Date: Fri, 9 May 2014 15:36:21 +0100
Subject: [PATCH] metag: Remove TIF_POLLING_NRFLAG

The Meta idle function jumps into the interrupt handler which
efficiently blocks waiting for the next interrupt when it reads the
interrupt status register (TXSTATI). No other (polling) idle functions
can be used, therefore TIF_POLLING_NRFLAG is unnecessary, so lets remove
it.

Peter Zijlstra said:
> Most archs have (x86) hlt or (arm) wfi like idle instructions, and if
> that is your only possible idle function, you'll require the interrupt
> to wake up and there's really no point to having the POLLING bit.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Peter Zijlstra <peterz@infradead.org>
---
 arch/metag/include/asm/thread_info.h | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/metag/include/asm/thread_info.h b/arch/metag/include/as=
m/thread_info.h
index b19e9c588a16..47711336119e 100644
--- a/arch/metag/include/asm/thread_info.h
+++ b/arch/metag/include/asm/thread_info.h
@@ -117,10 +117,8 @@ static inline int kstack_end(void *addr)
 #define TIF_SECCOMP		5	/* secure computing */
 #define TIF_RESTORE_SIGMASK	6	/* restore signal mask in do_signal() */
 #define TIF_NOTIFY_RESUME	7	/* callback before returning to user */
-#define TIF_POLLING_NRFLAG      8	/* true if poll_idle() is polling
-					   TIF_NEED_RESCHED */
-#define TIF_MEMDIE		9	/* is terminating due to OOM killer */
-#define TIF_SYSCALL_TRACEPOINT  10	/* syscall tracepoint instrumentation=
 */
+#define TIF_MEMDIE		8	/* is terminating due to OOM killer */
+#define TIF_SYSCALL_TRACEPOINT	9	/* syscall tracepoint instrumentation *=
/
=20
=20
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
--=20
1.9.2


--XRGQ5l3AK6IVg9cdokvLQ2Rg8eMijQUpC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTbOuFAAoJEGwLaZPeOHZ61eAQAJcWvjc8Yqi28VxtlP80MifD
pueJDBrBc+UdwtfE2QcdjPjR/v/l23EhR7bm8tevYqRxbIyMVlFWO57ysrMmN1pE
IJiRTY3oB78TCqDMuA/cfCV4uYPz12ekwn8+h8fgFnQrdJnkYdrgJ3d9UDcVcMHt
tFcBBhMibpl3sdRgV66Zo5zgbttICwKPem4vQXRWN5oAbLb3KNZwjcLsbF6YfgPr
0E6ly7TlrIw6yRlWVpvVB1Q2In03yorMjODe/bdrRrdr9Lzk94gVh+hOVMVHrTZt
jDKRYB7XqhLF2Lns6Obmd4CfwUP///N/pe4FLxeWdLjMBfmTI8/yPiMw9/jqyFBA
bIg6mBKxPOeh4pGqs7W3RPHzVwSzCyIRbQwgbtcf4O2As0PvaAUmBjvS2DUVSGOI
g5o6ck70JYRCO45j6sc/s1FYFqYHJjXAzcQpA85IMA36NlPFgfbo7IdhEvJXp3e3
0VEM0iG+Cx08P0tySA8PS66Uwle8wFpJ+XDdJWHFWgHK4p4Up9YrSREdjcrecmox
7bnWeTZsFaCzPK76U6yx9xypgSXXN7jOkVFT5w934Kw8NLoE6bkv9ssQLb+6gJ9f
nbZw7wMwgxtWIE+S+0sMgoNrSE3SoLMYZK8/xrSNezLOtfOqRpHL/4SnxGMF93OH
Sxs9KJZVnDmXJUE0BggI
=w+0O
-----END PGP SIGNATURE-----

--XRGQ5l3AK6IVg9cdokvLQ2Rg8eMijQUpC--
