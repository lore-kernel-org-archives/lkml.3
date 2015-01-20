Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753562AbbATDSP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 22:18:15 -0500
Received: from mail1.windriver.com ([147.11.146.13]:60566 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753201AbbATDSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 22:18:08 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <linux-kernel@vger.kernel.org>
CC: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, <x86@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH 2/3] x86: delete EISA_VLB_PRIMING Kconfig option and code
Date: Mon, 19 Jan 2015 22:18:20 -0500
Message-ID: <1421723901-32303-3-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <1421723901-32303-1-git-send-email-paul.gortmaker@windriver.com>
References: <1421723901-32303-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There was one instance of a VLB card which would emulate
an EISA ID response ID when primed with a certain I/O
handshake.

Since (a) VLB was largely confined to 486 vintage motherboards
from the early/mid 1990s and (b) there was only one card that
needed this and (c) we are dropping EISA support from x86,
everything relating to this option can be removed w/o impacting
any other architectures that might be unwilling to drop EISA
support just yet.

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 Documentation/eisa.txt      |  4 ++--
 drivers/eisa/Kconfig        | 10 ----------
 drivers/eisa/eisa-bus.c     | 10 ----------
 drivers/eisa/virtual_root.c |  2 +-
 4 files changed, 3 insertions(+), 23 deletions(-)

diff --git a/Documentation/eisa.txt b/Documentation/eisa.txt
index a55e491..983fea4 100644
--- a/Documentation/eisa.txt
+++ b/Documentation/eisa.txt
@@ -172,8 +172,8 @@ virtual_root.force_probe :
 
 Force the probing code to probe EISA slots even when it cannot find an
 EISA compliant mainboard (nothing appears on slot 0). Defaults to 0
-(don't force), and set to 1 (force probing) when either
-CONFIG_ALPHA_JENSEN or CONFIG_EISA_VLB_PRIMING are set.
+(don't force), and set to 1 (force probing) when CONFIG_ALPHA_JENSEN
+is set.
 
 ** Random notes :
 
diff --git a/drivers/eisa/Kconfig b/drivers/eisa/Kconfig
index 2705284..c3df390 100644
--- a/drivers/eisa/Kconfig
+++ b/drivers/eisa/Kconfig
@@ -1,16 +1,6 @@
 #
 # EISA configuration
 #
-config EISA_VLB_PRIMING
-	bool "Vesa Local Bus priming"
-	depends on X86 && EISA
-	default n
-	---help---
-	  Activate this option if your system contains a Vesa Local
-	  Bus (VLB) card that identify itself as an EISA card (such as
-	  the Adaptec AHA-284x).
-
-	  When in doubt, say N.
 
 config EISA_PCI_EISA
 	bool "Generic PCI/EISA bridge"
diff --git a/drivers/eisa/eisa-bus.c b/drivers/eisa/eisa-bus.c
index 612afea..805c4dc 100644
--- a/drivers/eisa/eisa-bus.c
+++ b/drivers/eisa/eisa-bus.c
@@ -81,16 +81,6 @@ static char __init *decode_eisa_sig(unsigned long addr)
 	int i;
 
 	for (i = 0; i < 4; i++) {
-#ifdef CONFIG_EISA_VLB_PRIMING
-		/*
-		 * This ugly stuff is used to wake up VL-bus cards
-		 * (AHA-284x is the only known example), so we can
-		 * read the EISA id.
-		 *
-		 * Thankfully, this only exists on x86...
-		 */
-		outb(0x80 + i, addr);
-#endif
 		sig[i] = inb(addr + i);
 
 		if (!i && (sig[0] & 0x80))
diff --git a/drivers/eisa/virtual_root.c b/drivers/eisa/virtual_root.c
index 535e4f9..432797f 100644
--- a/drivers/eisa/virtual_root.c
+++ b/drivers/eisa/virtual_root.c
@@ -14,7 +14,7 @@
 #include <linux/moduleparam.h>
 #include <linux/init.h>
 
-#if defined(CONFIG_ALPHA_JENSEN) || defined(CONFIG_EISA_VLB_PRIMING)
+#if defined(CONFIG_ALPHA_JENSEN)
 #define EISA_FORCE_PROBE_DEFAULT 1
 #else
 #define EISA_FORCE_PROBE_DEFAULT 0
-- 
2.2.1

