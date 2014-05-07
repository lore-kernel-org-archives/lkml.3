Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753391AbaEGFQA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 01:16:00 -0400
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:8015 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750920AbaEGFP7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 01:15:59 -0400
From: Bjorn Andersson <bjorn.andersson@sonymobile.com>
To: Russell King <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] ARM: zImage: Allow DTB to override broken ATAG_MEM
Date: Tue, 6 May 2014 22:16:16 -0700
Message-ID: <1399439776-18535-1-git-send-email-bjorn.andersson@sonymobile.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Support overriding ATAG_MEM, by specifying non-zero content of the /memory/reg
property in the appended DTB. This is needed to work around bootloaders passing
broken tags.

Signed-off-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>
---
 arch/arm/boot/compressed/atags_to_fdt.c |   18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/compressed/atags_to_fdt.c b/arch/arm/boot/compressed/atags_to_fdt.c
index d1153c8..b534cd6 100644
--- a/arch/arm/boot/compressed/atags_to_fdt.c
+++ b/arch/arm/boot/compressed/atags_to_fdt.c
@@ -95,6 +95,22 @@ static void merge_fdt_bootargs(void *fdt, const char *fdt_cmdline)
 	setprop_string(fdt, "/chosen", "bootargs", cmdline);
 }
 
+static int fdt_overrides_atag_mem(void *fdt)
+{
+	const char *memory;
+	int len = 0;
+
+	memory = getprop(fdt, "/memory", "reg", &len);
+	if (memory) {
+		while (len--) {
+			if (*memory != '\0')
+				return 1;
+		}
+	}
+
+	return 0;
+}
+
 /*
  * Convert and fold provided ATAGs into the provided FDT.
  *
@@ -180,7 +196,7 @@ int atags_to_fdt(void *atag_list, void *fdt, int total_space)
 		}
 	}
 
-	if (memcount) {
+	if (memcount && !fdt_overrides_atag_mem(fdt)) {
 		setprop(fdt, "/memory", "reg", mem_reg_property,
 			4 * memcount * memsize);
 	}
-- 
1.7.9.5

