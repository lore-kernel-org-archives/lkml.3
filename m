Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753547AbaJMIEe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 04:04:34 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:47330 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751989AbaJMIEa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 04:04:30 -0400
Date: Mon, 13 Oct 2014 10:04:25 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/vdso tree change for v3.18
Message-ID: <20141013080425.GA16716@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-vdso-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-vdso-for-linus

   # HEAD: f12c1f9002d27374fd205f6e692891116ca22272 x86/vdso: Fix vdso2c's special_pages[] error checking

Includes a single fix to vdso error checking.

 Thanks,

	Ingo

------------------>
Andy Lutomirski (1):
      x86/vdso: Fix vdso2c's special_pages[] error checking


 arch/x86/vdso/vdso2c.h | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/arch/x86/vdso/vdso2c.h b/arch/x86/vdso/vdso2c.h
index fd57829b30d8..0224987556ce 100644
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
