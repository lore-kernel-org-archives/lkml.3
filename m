Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760192Ab3IHDwL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 23:52:11 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56229 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756656Ab3IHDS7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 23:18:59 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Thorsten Glaser" <tg@debian.org>,
        "Geert Uytterhoeven" <geert@linux-m68k.org>
Date: Sun, 08 Sep 2013 03:52:01 +0100
Message-ID: <lsq.1378608721.23860783@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [073/121] m68k/atari: ARAnyM - Fix NatFeat module support
In-Reply-To: <lsq.1378608720.401499712@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.51-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert@linux-m68k.org>

commit e8184e10f89736a23ea6eea8e24cd524c5c513d2 upstream.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/m68k/emu/natfeat.c | 23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

--- a/arch/m68k/emu/natfeat.c
+++ b/arch/m68k/emu/natfeat.c
@@ -18,9 +18,11 @@
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
@@ -29,12 +31,25 @@ asm("\n"
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

