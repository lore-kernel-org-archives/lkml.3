Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756670Ab3HRUgp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 16:36:45 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43778 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756579Ab3HRUfV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 16:35:21 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Thorsten Glaser <tg@debian.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [ 42/45] m68k/atari: ARAnyM - Fix NatFeat module support
Date: Sun, 18 Aug 2013 13:36:31 -0700
Message-Id: <20130818203623.917344097@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.3.825.g36032ce.dirty
In-Reply-To: <20130818203620.996166594@linuxfoundation.org>
References: <20130818203620.996166594@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/m68k/emu/natfeat.c |   23 +++++++++++++++++++----
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


