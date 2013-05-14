Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932398Ab3ENOuR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 10:50:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8166 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932266Ab3ENOtn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 10:49:43 -0400
From: Igor Mammedov <imammedo@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Greg KH <gregkh@linuxfoundation.org>, chuck.anderson@oracle.com
Subject: [PATCH 1/2] cpu: fix "crash_notes" and "crash_notes_size" leaks in register_cpu()
Date: Tue, 14 May 2013 16:46:06 +0200
Message-Id: <1368542767-2126-2-git-send-email-imammedo@redhat.com>
In-Reply-To: <1368542767-2126-1-git-send-email-imammedo@redhat.com>
References: <1368542767-2126-1-git-send-email-imammedo@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"crash_notes" and "crash_notes_size" are dynamically created
with device_create_file() but aren't deleted anywhere.
Define "crash_notes" and "crash_notes_size" statically via
attribute groups so that device_register would create them
automatically and files would be destroyed when CPU is destroyed.

Signed-off-by: Igor Mammedov <imammedo@redhat.com>
Tested-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/base/cpu.c |   25 ++++++++++++++++++-------
 1 files changed, 18 insertions(+), 7 deletions(-)

diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
index 3d48fc8..8f9e264 100644
--- a/drivers/base/cpu.c
+++ b/drivers/base/cpu.c
@@ -164,7 +164,24 @@ static ssize_t show_crash_notes_size(struct device *dev,
 	return rc;
 }
 static DEVICE_ATTR(crash_notes_size, 0400, show_crash_notes_size, NULL);
+
+static struct attribute *crash_note_cpu_attrs[] = {
+	&dev_attr_crash_notes.attr,
+	&dev_attr_crash_notes_size.attr,
+	NULL
+};
+
+static struct attribute_group crash_note_cpu_attr_group = {
+	.attrs = crash_note_cpu_attrs,
+};
+#endif
+
+static const struct attribute_group *common_cpu_attr_groups[] = {
+#ifdef CONFIG_KEXEC
+	&crash_note_cpu_attr_group,
 #endif
+	NULL
+};
 
 /*
  * Print cpu online, possible, present, and system maps
@@ -280,6 +297,7 @@ int __cpuinit register_cpu(struct cpu *cpu, int num)
 #ifdef CONFIG_ARCH_HAS_CPU_AUTOPROBE
 	cpu->dev.bus->uevent = arch_cpu_uevent;
 #endif
+	cpu->dev.groups = common_cpu_attr_groups;
 	error = device_register(&cpu->dev);
 	if (!error && cpu->hotpluggable)
 		register_cpu_control(cpu);
@@ -288,13 +306,6 @@ int __cpuinit register_cpu(struct cpu *cpu, int num)
 	if (!error)
 		register_cpu_under_node(num, cpu_to_node(num));
 
-#ifdef CONFIG_KEXEC
-	if (!error)
-		error = device_create_file(&cpu->dev, &dev_attr_crash_notes);
-	if (!error)
-		error = device_create_file(&cpu->dev,
-					   &dev_attr_crash_notes_size);
-#endif
 	return error;
 }
 
-- 
1.7.1

