Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757403Ab3DWQcP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 12:32:15 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:59817 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757332Ab3DWQcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 12:32:08 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Russell King <linux@arm.linux.org.uk>
Subject: [PATCH 03/21] ARM: use optimized do_div only for EABI
Date: Tue, 23 Apr 2013 18:30:35 +0200
Message-Id: <1366734653-488286-4-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1366734653-488286-1-git-send-email-arnd@arndb.de>
References: <1366734653-488286-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:dSeyfKQRPXz/X/sH+BptpCSE/qt4hb7Sg70rkDIYGTj
 ugmIBf8F7Fn0zcoyogVIInESUxT9YuXPOLa8ywodjOLWbM5sGF
 YSEkNXP75zJJVgVYVMRlmLuvJ/VER9BNpxy7E6pl1JMldM+5MI
 tKY6RAgNMHktH8+8nbNg8t03TjKSSOBQTktLgffCtt8ZkkojYO
 duBNPdRzSr1FYPGSh8r9KHoksW/4vAgB+NfgbP8zKMWO+EmlS6
 WkNn5Pt+7g2ftaZWGUqMq2M5+RQo8/nGYSnFiLBjxoalxJ6lcP
 iho03EzLge3cTFl2SVkgom0guhtvpA5atdeG9KW3/icC5VAsxO
 J0Wt/vuRCs2GxVu3uyDCRO/JNMr6MGuLadhc30zZU
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In OABI configurations, some uses of the do_div function
cause gcc to run out of registers. To work around that,
we can force the use of the out-of-line version for
configurations that build a OABI kernel.

Without this patch, building netx_defconfig results in:

net/core/pktgen.c: In function 'pktgen_if_show':
net/core/pktgen.c:682:2775: error: can't find a register in class 'GENERAL_REGS' while reloading 'asm'
net/core/pktgen.c:682:3153: error: can't find a register in class 'GENERAL_REGS' while reloading 'asm'
net/core/pktgen.c:682:2775: error: 'asm' operand has impossible constraints
net/core/pktgen.c:682:3153: error: 'asm' operand has impossible constraints

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Russell King <linux@arm.linux.org.uk>
---
 arch/arm/include/asm/div64.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/include/asm/div64.h b/arch/arm/include/asm/div64.h
index fe92ccf..191ada6 100644
--- a/arch/arm/include/asm/div64.h
+++ b/arch/arm/include/asm/div64.h
@@ -46,7 +46,7 @@
 	__rem;							\
 })
 
-#if __GNUC__ < 4
+#if __GNUC__ < 4 || !defined(CONFIG_AEABI)
 
 /*
  * gcc versions earlier than 4.0 are simply too problematic for the
-- 
1.8.1.2

