Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752743AbbA1Uwo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:52:44 -0500
Received: from mout.kundenserver.de ([212.227.126.187]:57456 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752439AbbA1Uwl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:52:41 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Dmitry Kasatkin <dmitry.kasatkin@intel.com>,
        David Howells <dhowells@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH] MPILIB: avoid assembler warning
Date: Wed, 28 Jan 2015 17:24:36 +0100
Message-ID: <16372019.BFlLRod3Eu@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:WhzkrIhzJFbWFYzNeGRe5c+XjIU3D2331xRk6aqNs2jxlmsr3dx
 B9iNra5nvVVVXr1bek2rKsbPPv0/ShLNShjlPSSnlSGyKtb5+0FUvw0W+oLrViLpdVJ7Ggv
 LZVwrg2YyqGCJB16RSjQ2QwQojEccrfr23tusqmbsV4qOaYJf4FXnX2lWahxs6+xe5Ftfik
 NSz+110Rior3PUxmzr3RQ==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A wrapper around the umull assembly instruction might reuse
the input register as an output, which is undefined on
some ARM machines, as pointed out by this assembler warning:

  CC      lib/mpi/generic_mpih-mul1.o
/tmp/ccxJuxIy.s: Assembler messages:
/tmp/ccxJuxIy.s:53: rdhi, rdlo and rm must all be different
  CC      lib/mpi/generic_mpih-mul2.o
/tmp/ccI0scAD.s: Assembler messages:
/tmp/ccI0scAD.s:53: rdhi, rdlo and rm must all be different
  CC      lib/mpi/generic_mpih-mul3.o
/tmp/ccMvVQcp.s: Assembler messages:
/tmp/ccMvVQcp.s:53: rdhi, rdlo and rm must all be different

This changes the constraints to force different registers to
be used as output.

Signed-off-by: Arnd Bergmann <arnd@arnd.de>
---
Not sure who would be the best person to pick this patch up.

diff --git a/lib/mpi/longlong.h b/lib/mpi/longlong.h
index aac511417ad1..c4dbdb506174 100644
--- a/lib/mpi/longlong.h
+++ b/lib/mpi/longlong.h
@@ -216,7 +216,7 @@ extern UDItype __udiv_qrnnd(UDItype *, UDItype, UDItype, UDItype);
 	__asm__ ("%@ Inlined umul_ppmm\n" \
 		"umull %r1, %r0, %r2, %r3" \
 	: "=&r" ((USItype)(xh)), \
-			"=r" ((USItype)(xl)) \
+			"=&r" ((USItype)(xl)) \
 	: "r" ((USItype)(a)), \
 			"r" ((USItype)(b)) \
 	: "r0", "r1")

