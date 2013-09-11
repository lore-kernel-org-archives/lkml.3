Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755844Ab3IKE62 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 00:58:28 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:22176 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754227Ab3IKE45 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 00:56:57 -0400
X-Authority-Analysis: v=2.0 cv=V4T/IJbi c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=d61uSk3pmVQA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=IyirI3jM9YkA:10 a=tBb2bbeoAAAA:8 a=xNf9USuDAAAA:8 a=VwQbUJbxAAAA:8 a=sh80caI12km7YMYbzp0A:9 a=YuKU6ANggZ8A:10 a=YPTUPuSgPjgA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042927.745462416@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:30:41 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Thorsten Glaser <tg@debian.org>, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [214/251] m68k/atari: ARAnyM - Fix NatFeat module support
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0214-m68k-atari-ARAnyM-Fix-NatFeat-module-support.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert@linux-m68k.org>

[ Upstream commit e8184e10f89736a23ea6eea8e24cd524c5c513d2 ]

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
Cc: stable@vger.kernel.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/m68k/emu/natfeat.c |   23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

diff --git a/arch/m68k/emu/natfeat.c b/arch/m68k/emu/natfeat.c
index 2291a7d..fa277ae 100644
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
-- 
1.7.10.4


