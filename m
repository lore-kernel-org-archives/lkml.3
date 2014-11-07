Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752062AbaKGLrM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 06:47:12 -0500
Received: from dotsec.net ([62.75.224.215]:41970 "EHLO styx.dotsec.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751464AbaKGLrL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 06:47:11 -0500
From: Alban Bedel <albeu@free.fr>
To: linux-kernel@vger.kernel.org
Cc: linux-mips@linux-mips.org, Ralf Baechle <ralf@linux-mips.org>,
        Alban Bedel <albeu@free.fr>
Subject: [PATCH 1/2] MIPS: ath79: Use the firmware lib to parse the kernel command line
Date: Fri,  7 Nov 2014 12:44:35 +0100
Message-Id: <1415360676-28064-1-git-send-email-albeu@free.fr>
X-Mailer: git-send-email 2.0.0
X-SA-Score: -1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No need to duplicate code that is available in the firmware library.
It also give us access to the firmware environment which is needed
to read the initrd address and size.

Signed-off-by: Alban Bedel <albeu@free.fr>
---
 arch/mips/ath79/prom.c | 30 ++----------------------------
 1 file changed, 2 insertions(+), 28 deletions(-)

diff --git a/arch/mips/ath79/prom.c b/arch/mips/ath79/prom.c
index e9cbd7c..80a0bff 100644
--- a/arch/mips/ath79/prom.c
+++ b/arch/mips/ath79/prom.c
@@ -16,39 +16,13 @@
 
 #include <asm/bootinfo.h>
 #include <asm/addrspace.h>
+#include <asm/fw/fw.h>
 
 #include "common.h"
 
-static inline int is_valid_ram_addr(void *addr)
-{
-	if (((u32) addr > KSEG0) &&
-	    ((u32) addr < (KSEG0 + ATH79_MEM_SIZE_MAX)))
-		return 1;
-
-	if (((u32) addr > KSEG1) &&
-	    ((u32) addr < (KSEG1 + ATH79_MEM_SIZE_MAX)))
-		return 1;
-
-	return 0;
-}
-
-static __init void ath79_prom_init_cmdline(int argc, char **argv)
-{
-	int i;
-
-	if (!is_valid_ram_addr(argv))
-		return;
-
-	for (i = 0; i < argc; i++)
-		if (is_valid_ram_addr(argv[i])) {
-			strlcat(arcs_cmdline, " ", sizeof(arcs_cmdline));
-			strlcat(arcs_cmdline, argv[i], sizeof(arcs_cmdline));
-		}
-}
-
 void __init prom_init(void)
 {
-	ath79_prom_init_cmdline(fw_arg0, (char **)fw_arg1);
+	fw_init_cmdline();
 }
 
 void __init prom_free_prom_memory(void)
-- 
2.0.0

