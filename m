Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754095AbaIXH73 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 03:59:29 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55537 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753313AbaIXH7W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 03:59:22 -0400
Date: Wed, 24 Sep 2014 00:58:06 -0700
From: tip-bot for Andy Lutomirski <tipbot@zytor.com>
Message-ID: <tip-f12c1f9002d27374fd205f6e692891116ca22272@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        luto@amacapital.net, akpm@linux-foundation.org, tglx@linutronix.de,
        sfr@canb.auug.org.au
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        luto@amacapital.net, akpm@linux-foundation.org, sfr@canb.auug.org.au,
        tglx@linutronix.de
In-Reply-To: <53d96ad5.80ywqrbs33ZBCQej%akpm@linux-foundation.org>
References: <53d96ad5.80ywqrbs33ZBCQej%akpm@linux-foundation.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/vdso] x86/vdso: Fix vdso2c's special_pages[]
  error checking
Git-Commit-ID: f12c1f9002d27374fd205f6e692891116ca22272
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f12c1f9002d27374fd205f6e692891116ca22272
Gitweb:     http://git.kernel.org/tip/f12c1f9002d27374fd205f6e692891116ca22272
Author:     Andy Lutomirski <luto@amacapital.net>
AuthorDate: Wed, 30 Jul 2014 14:59:49 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 24 Sep 2014 09:55:38 +0200

x86/vdso: Fix vdso2c's special_pages[] error checking

Stephen Rothwell's compiler did something amazing: it unrolled a
loop, discovered that one iteration of that loop contained an
always-true test, and emitted a warning that will IMO only serve
to convince people to disable the warning.

That bogus warning caused me to wonder what prompted such an
absurdity from his compiler, and I discovered that the code in
question was, in fact, completely wrong -- I was looking things
up in the wrong array.

This affects 3.16 as well, but the only effect is to screw up
the error checking a bit.  vdso2c's output is unaffected.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andy Lutomirski <luto@amacapital.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/53d96ad5.80ywqrbs33ZBCQej%25akpm@linux-foundation.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/vdso/vdso2c.h | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/arch/x86/vdso/vdso2c.h b/arch/x86/vdso/vdso2c.h
index fd57829..0224987 100644
--- a/arch/x86/vdso/vdso2c.h
+++ b/arch/x86/vdso/vdso2c.h
@@ -109,16 +109,18 @@ static void BITSFUNC(go)(void *raw_addr, size_t raw_len,
 
 	/* Validate mapping addresses. */
 	for (i = 0; i < sizeof(special_pages) / sizeof(special_pages[0]); i++) {
-		if (!syms[i])
+		INT_BITS symval = syms[special_pages[i]];
+
+		if (!symval)
 			continue;  /* The mapping isn't used; ignore it. */
 
-		if (syms[i] % 4096)
+		if (symval % 4096)
 			fail("%s must be a multiple of 4096\n",
 			     required_syms[i].name);
-		if (syms[sym_vvar_start] > syms[i] + 4096)
-			fail("%s underruns begin_vvar\n",
+		if (symval + 4096 < syms[sym_vvar_start])
+			fail("%s underruns vvar_start\n",
 			     required_syms[i].name);
-		if (syms[i] + 4096 > 0)
+		if (symval + 4096 > 0)
 			fail("%s is on the wrong side of the vdso text\n",
 			     required_syms[i].name);
 	}
