Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752493Ab3EEVbZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 May 2013 17:31:25 -0400
Received: from mout.gmx.net ([212.227.17.21]:62476 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752433Ab3EEVbW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 May 2013 17:31:22 -0400
X-Authenticated: #1045983
X-Provags-ID: V01U2FsdGVkX1/ciLVZp1ncsIq5uxNxplWFOlnDqVmvUtAfMN60iY
	qt2NTag9X5oWFP
Date: Sun, 5 May 2013 23:31:18 +0200
From: Helge Deller <deller@gmx.de>
To: Linux Kernel Development <linux-kernel@vger.kernel.org>,
        linux-parisc@vger.kernel.org, linux-security-module@vger.kernel.org,
        dhowells@redhat.com
Subject: [PATCH] kernel/modsign_certificate.S: fix build on parisc
 architecture
Message-ID: <20130505213118.GA1622@p100.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Module signing functionality breaks the kernel build on parisc with the
following error: 

kernel/built-in.o: In function `load_module_signing_keys':
kernel/modsign_pubkey.c:67: undefined reference to `modsign_certificate_list_end'
kernel/modsign_pubkey.c:66: undefined reference to `modsign_certificate_list'
make[3]: *** [vmlinux] Error 1

The reason why the build fails is because on parisc assembly syntax is
different than on other architectures. Most importantly, a semicolon
marks the start of a comment, while exclamation marks separates
statements.

Currently the GLOBAL(name) macro uses a semicolon to separate the .globl
and the ASM_SYMBOL() statements. On PA-RISC the semicolon will now just
strip the ASM_SYMBOL() statements since it thinks it is a comment and as
such the modsign_certificate_list/modsign_certificate_list_end symbols
will not get defined and will not be in the vmlinux binary.

Fix this problem by adding an own implementation for GLOBAL() on the
PARISC architecture.

Signed-off-by: Helge Deller <deller@gmx.de>

diff --git a/kernel/modsign_certificate.S b/kernel/modsign_certificate.S
index 246b4c6..9b9c2ab 100644
--- a/kernel/modsign_certificate.S
+++ b/kernel/modsign_certificate.S
@@ -7,9 +7,17 @@
 #define ASM_SYMBOL(sym) PASTE(SYMBOL_PREFIX, sym)
 #endif
 
-#define GLOBAL(name)	\
-	.globl ASM_SYMBOL(name);	\
+#if defined(__hppa__)
+ /* HPPA/PA-RISC assembly is special: comments start with semicolon
+  * and exclamation marks separates statements. */
+ #define GLOBAL(name)	\
+	.globl ASM_SYMBOL(name) ! \
 	ASM_SYMBOL(name):
+#else
+ #define GLOBAL(name)	\
+	.globl ASM_SYMBOL(name) ; \
+	ASM_SYMBOL(name):
+#endif
 
 	.section ".init.data","aw"
 
