Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964857AbaDIPOf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 11:14:35 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:40672 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933782AbaDIPO2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 11:14:28 -0400
From: Tomasz Nowicki <tomasz.nowicki@linaro.org>
To: rjw@rjwysocki.net, lenb@kernel.org, tony.luck@intel.com, bp@alien8.de,
        bp@suse.de, m.chehab@samsung.com
Cc: linux-edac@vger.kernel.org, x86@kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-acpi@lists.linaro.org,
        Tomasz Nowicki <tomasz.nowicki@linaro.org>
Subject: [PATCH 5/7] acpi, apei, ghes: Attach NMI init/deinit functions while CONFIG_ACPI_APEI_NMI is enabled.
Date: Wed,  9 Apr 2014 17:14:33 +0200
Message-Id: <1397056476-9183-6-git-send-email-tomasz.nowicki@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1397056476-9183-1-git-send-email-tomasz.nowicki@linaro.org>
References: <1397056476-9183-1-git-send-email-tomasz.nowicki@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks to more generic way of init/deinit error notification, we can
register NMI related calls in runtime. It happens before walking through
GHES entries, so probe function will treat NMI as supported.

Signed-off-by: Tomasz Nowicki <tomasz.nowicki@linaro.org>
---
 drivers/acpi/apei/ghes.c |   21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
index 7a0d66e..aaf8db3 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -906,7 +906,6 @@ static void ghes_estatus_pool_shrink(unsigned long len)
 {
 	ghes_estatus_pool_size_request -= PAGE_ALIGN(len);
 }
-#endif
 
 static int ghes_notify_init_nmi(struct ghes *ghes)
 {
@@ -941,6 +940,20 @@ static void ghes_notify_remove_nmi(struct ghes *ghes)
 	ghes_estatus_pool_shrink(len);
 }
 
+static void ghes_init_nmi(void)
+{
+	init_irq_work(&ghes_proc_irq_work, ghes_proc_in_irq);
+	ghes_notify_tab[ACPI_HEST_NOTIFY_NMI].init_call = ghes_notify_init_nmi;
+	ghes_notify_tab[ACPI_HEST_NOTIFY_NMI].remove_call = ghes_notify_remove_nmi;
+
+}
+#else
+inline static void ghes_init_nmi(void)
+{
+
+}
+#endif
+
 static int ghes_notify_init_polled(struct ghes *ghes)
 {
 	ghes->timer.function = ghes_poll_func;
@@ -1018,9 +1031,7 @@ static struct ghes_notify_setup
 		[ACPI_HEST_NOTIFY_SCI]      = {"SCI",
 					       ghes_notify_init_sci,
 					       ghes_notify_remove_sci},
-		[ACPI_HEST_NOTIFY_NMI]      = {"NMI",
-					       ghes_notify_init_nmi,
-					       ghes_notify_remove_nmi},
+		[ACPI_HEST_NOTIFY_NMI]      = {"NMI", NULL, NULL},
 		[ACPI_HEST_NOTIFY_CMCI]     = {"CMCI", NULL, NULL},
 		[ACPI_HEST_NOTIFY_MCE]      = {"MCE", NULL, NULL},
 };
@@ -1141,7 +1152,7 @@ static int __init ghes_init(void)
 		return -EINVAL;
 	}
 
-	init_irq_work(&ghes_proc_irq_work, ghes_proc_in_irq);
+	ghes_init_nmi();
 
 	rc = ghes_ioremap_init();
 	if (rc)
-- 
1.7.9.5

