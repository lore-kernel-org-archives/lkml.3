Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759766Ab3HNJzi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 05:55:38 -0400
Received: from georges.telenet-ops.be ([195.130.137.68]:55926 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752319Ab3HNJzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 05:55:36 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org
Cc: Thorsten Glaser <tg@debian.org>, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 1/2] m68k/atari: ARAnyM - Fix NatFeat module support
Date: Wed, 14 Aug 2013 11:55:28 +0200
Message-Id: <1376474129-14339-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As pointed out by Andreas Schwab, pointers passed to ARAnyM NatFeat calls
should be physical addresses, not virtual addresses.

Fortunately on Atari, physical and virtual kernel addresses are the same,
as long as normal kernel memory is concerned, so this usually worked fine
without conversion.

But for modules, pointers to literal strings are located in vmalloc()ed
memory. Depending on the version of ARAnyM, this causes the nf_get_id()
call to just fail, or worse, crash ARAnyM itself with e.g.

    Gotcha! Illegal memory access. Atari PC = $968c

This is a big issue for distro kernels, who want to have all drivers as
loadable modules in an initrd.

Add a wrapper for nf_get_id() that copies the literal to the stack to
work around this issue.

Reported-by: Thorsten Glaser <tg@debian.org>
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
Queued for 3.11 and stable

 arch/m68k/emu/natfeat.c |   23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

diff --git a/arch/m68k/emu/natfeat.c b/arch/m68k/emu/natfeat.c
index cb574ae..5a8da88 100644
--- a/arch/m68k/emu/natfeat.c
+++ b/arch/m68k/emu/natfeat.c
@@ -19,9 +19,11 @@
 #include <asm/machdep.h>
 #include <asm/natfeat.h>
 
+extern long nf_get_id2(const char *feature_name);
+
 asm("\n"
-"	.global nf_get_id,nf_call\n"
-"nf_get_id:\n"
+"	.global nf_get_id2,nf_call\n"
+"nf_get_id2:\n"
 "	.short	0x7300\n"
 "	rts\n"
 "nf_call:\n"
@@ -30,12 +32,25 @@ asm("\n"
 "1:	moveq.l	#0,%d0\n"
 "	rts\n"
 "	.section __ex_table,\"a\"\n"
-"	.long	nf_get_id,1b\n"
+"	.long	nf_get_id2,1b\n"
 "	.long	nf_call,1b\n"
 "	.previous");
-EXPORT_SYMBOL_GPL(nf_get_id);
 EXPORT_SYMBOL_GPL(nf_call);
 
+long nf_get_id(const char *feature_name)
+{
+	/* feature_name may be in vmalloc()ed memory, so make a copy */
+	char name_copy[32];
+	size_t n;
+
+	n = strlcpy(name_copy, feature_name, sizeof(name_copy));
+	if (n >= sizeof(name_copy))
+		return 0;
+
+	return nf_get_id2(name_copy);
+}
+EXPORT_SYMBOL_GPL(nf_get_id);
+
 void nfprint(const char *fmt, ...)
 {
 	static char buf[256];
-- 
1.7.9.5

