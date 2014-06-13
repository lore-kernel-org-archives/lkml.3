Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753334AbaFMUAQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 16:00:16 -0400
Received: from smtprelay01.ispgateway.de ([80.67.31.39]:53425 "EHLO
	smtprelay01.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752101AbaFMUAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 16:00:14 -0400
X-Greylist: delayed 606 seconds by postgrey-1.27 at vger.kernel.org; Fri, 13 Jun 2014 16:00:13 EDT
From: Christoph Jaeger <christophjaeger@linux.com>
To: rjw@rjwysocki.net, lenb@kernel.org
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christoph Jaeger <christophjaeger@linux.com>
Subject: [PATCH] ACPI: use kstrto*() instead of simple_strto*()
Date: Fri, 13 Jun 2014 21:49:58 +0200
Message-Id: <1402688998-20142-1-git-send-email-christophjaeger@linux.com>
X-Mailer: git-send-email 1.9.3
X-Df-Sender: MTg4NDM4Mw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

simple_strto*() are obsolete; use kstrto*() instead. Add proper error
checking.

Signed-off-by: Christoph Jaeger <christophjaeger@linux.com>
---
 drivers/acpi/battery.c | 5 ++++-
 drivers/acpi/osl.c     | 3 ++-
 drivers/acpi/tables.c  | 3 ++-
 3 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/acpi/battery.c b/drivers/acpi/battery.c
index e48fc98..5963e6f 100644
--- a/drivers/acpi/battery.c
+++ b/drivers/acpi/battery.c
@@ -930,7 +930,10 @@ static ssize_t acpi_battery_write_alarm(struct file *file,
 		goto end;
 	}
 	alarm_string[count] = '\0';
-	battery->alarm = simple_strtol(alarm_string, NULL, 0);
+	if (kstrtoint(alarm_string, 0, &battery->alarm)) {
+		result = -EINVAL;
+		goto end;
+	}
 	result = acpi_battery_set_alarm(battery);
       end:
 	if (!result)
diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
index 3f2bdc8..bad25b0 100644
--- a/drivers/acpi/osl.c
+++ b/drivers/acpi/osl.c
@@ -235,7 +235,8 @@ void acpi_os_vprintf(const char *fmt, va_list args)
 static unsigned long acpi_rsdp;
 static int __init setup_acpi_rsdp(char *arg)
 {
-	acpi_rsdp = simple_strtoul(arg, NULL, 16);
+	if (kstrtoul(arg, 16, &acpi_rsdp))
+		return -EINVAL;
 	return 0;
 }
 early_param("acpi_rsdp", setup_acpi_rsdp);
diff --git a/drivers/acpi/tables.c b/drivers/acpi/tables.c
index 05550ba..6d5a6cd 100644
--- a/drivers/acpi/tables.c
+++ b/drivers/acpi/tables.c
@@ -360,7 +360,8 @@ static int __init acpi_parse_apic_instance(char *str)
 	if (!str)
 		return -EINVAL;
 
-	acpi_apic_instance = simple_strtoul(str, NULL, 0);
+	if (kstrtoint(str, 0, &acpi_apic_instance))
+		return -EINVAL;
 
 	pr_notice("Shall use APIC/MADT table %d\n", acpi_apic_instance);
 
-- 
1.9.3

