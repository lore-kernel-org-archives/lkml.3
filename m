Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755057AbaEHPCi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 11:02:38 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:49434 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752046AbaEHO4n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 10:56:43 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Tony Lindgren <tony@atomide.com>,
        Kishon Vijay Abraham I <kishon@ti.com>, Felipe Balbi <balbi@ti.com>
Subject: [PATCH] bus/omap_l3: avoid sync initcall for modules
Date: Thu,  8 May 2014 16:56:17 +0200
Message-Id: <1399560990-1402858-6-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1399560990-1402858-1-git-send-email-arnd@arndb.de>
References: <1399560433-1402630-1-git-send-email-arnd@arndb.de>
 <1399560990-1402858-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:Vbt/kdlQhHHsAr+8qNcIWnhnS/v+0iX8sI5JmHDTtv4
 PRrbju4QPti/76GC1saxASnKEC72kDMFcDC/pnwhb5QRr95jAP
 DAd07TR70PpwN8GH4hdHXMNG/N/8mbNyONiOPXPrXQHi08wrS6
 DScN9PVdDSIfOLV/oqm8uCEMR7VuujB0AzFnqV4i5QKk5X+jLG
 TYqXnv2Sofp1S7aIH9U1j/D1vX6LinjEVLpIKhaHF38sEQDBIb
 WIwJaLqncrxQ1R6uRXttpeyVJUbe4oqhc/IFX5YvQE9lFlYT3q
 MmkWGsxZvRk5bOW8sCJCkVcZNWFNW4YpLvhUJH/xtifWCY5aXC
 32rx6CZYWtNSnrf+M9FeI/ZNeyoltp4JTZzvXNmw8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The postcore_initcall_sync() macro is only defined for built-in
code, but the omap_l3 bus code can be built as a module, which
currently causes a build failure.

This works around the problem by using #ifdef MODULE to decide
whether to use a regular module_init() function or not.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Kishon Vijay Abraham I <kishon@ti.com>
Cc: Felipe Balbi <balbi@ti.com>
---
 drivers/bus/omap_l3_noc.c | 4 ++++
 drivers/bus/omap_l3_smx.c | 4 ++++
 2 files changed, 8 insertions(+)

diff --git a/drivers/bus/omap_l3_noc.c b/drivers/bus/omap_l3_noc.c
index feeecae..648f158 100644
--- a/drivers/bus/omap_l3_noc.c
+++ b/drivers/bus/omap_l3_noc.c
@@ -257,7 +257,11 @@ static int __init omap4_l3_init(void)
 {
 	return platform_driver_register(&omap4_l3_driver);
 }
+#ifdef MODULE
+module_init(omap4_l3_init);
+#else
 postcore_initcall_sync(omap4_l3_init);
+#endif
 
 static void __exit omap4_l3_exit(void)
 {
diff --git a/drivers/bus/omap_l3_smx.c b/drivers/bus/omap_l3_smx.c
index acc2164..f752d1b 100644
--- a/drivers/bus/omap_l3_smx.c
+++ b/drivers/bus/omap_l3_smx.c
@@ -288,7 +288,11 @@ static int __init omap3_l3_init(void)
 {
 	return platform_driver_probe(&omap3_l3_driver, omap3_l3_probe);
 }
+#ifdef MODULE
+module_init(omap3_l3_init);
+#else
 postcore_initcall_sync(omap3_l3_init);
+#endif
 
 static void __exit omap3_l3_exit(void)
 {
-- 
1.8.3.2

