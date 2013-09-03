Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934222Ab3ICXwK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 19:52:10 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:33622 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934104Ab3ICXua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 19:50:30 -0400
From: Matthew Garrett <matthew.garrett@nebula.com>
To: linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org, keescook@chromium.org, hpa@zytor.com,
        Matthew Garrett <matthew.garrett@nebula.com>
Subject: [PATCH V3 04/11] ACPI: Limit access to custom_method
Date: Tue,  3 Sep 2013 19:50:11 -0400
Message-Id: <1378252218-18798-5-git-send-email-matthew.garrett@nebula.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1378252218-18798-1-git-send-email-matthew.garrett@nebula.com>
References: <1378252218-18798-1-git-send-email-matthew.garrett@nebula.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 2001:470:1f07:1371:6267:20ff:fec3:2318
X-SA-Exim-Mail-From: matthew.garrett@nebula.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

custom_method effectively allows arbitrary access to system memory, making
it possible for an attacker to circumvent restrictions on module loading.
Disable it if any such restrictions have been enabled.

Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>
---
 drivers/acpi/custom_method.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/acpi/custom_method.c b/drivers/acpi/custom_method.c
index 12b62f2..50647b3 100644
--- a/drivers/acpi/custom_method.c
+++ b/drivers/acpi/custom_method.c
@@ -29,6 +29,9 @@ static ssize_t cm_write(struct file *file, const char __user * user_buf,
 	struct acpi_table_header table;
 	acpi_status status;
 
+	if (secure_modules())
+		return -EPERM;
+
 	if (!(*ppos)) {
 		/* parse the table header to get the table length */
 		if (count <= sizeof(struct acpi_table_header))
-- 
1.8.3.1

