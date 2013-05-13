Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755404Ab3EMWJI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 18:09:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29129 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755228Ab3EMWJG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 18:09:06 -0400
From: Igor Mammedov <imammedo@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, konrad.wilk@oracle.com,
        chuck.anderson@oracle.com, imammedo@redhat.com
Subject: [PATCH 1/2] cpu: fix "crash_notes" leak in register_cpu()
Date: Tue, 14 May 2013 00:05:31 +0200
Message-Id: <1368482732-25554-2-git-send-email-imammedo@redhat.com>
In-Reply-To: <20130513133128.GJ6811@phenom.dumpdata.com>
References: <20130513133128.GJ6811@phenom.dumpdata.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"crash_notes" is dinamically created with device_create_file() but
isn't anywhere deleted.
Define "crash_notes" statically via attribute groups so that
device_register would create it automatically and file would be
destroyed when CPU is destroyed.

Signed-off-by: Igor Mammedov <imammedo@redhat.com>
---
 drivers/base/cpu.c |   21 +++++++++++++++++----
 1 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
index fb10728..02e4d73 100644
--- a/drivers/base/cpu.c
+++ b/drivers/base/cpu.c
@@ -132,8 +132,24 @@ static ssize_t show_crash_notes(struct device *dev, struct device_attribute *att
 	return rc;
 }
 static DEVICE_ATTR(crash_notes, 0400, show_crash_notes, NULL);
+
+static struct attribute *crash_note_cpu_attrs[] = {
+	&dev_attr_crash_notes.attr,
+	NULL
+};
+
+static struct attribute_group crash_note_cpu_attr_group = {
+	.attrs = crash_note_cpu_attrs,
+};
 #endif
 
+static const struct attribute_group *common_cpu_attr_groups[] = {
+#ifdef CONFIG_KEXEC
+	&crash_note_cpu_attr_group,
+#endif
+	NULL
+};
+
 /*
  * Print cpu online, possible, present, and system maps
  */
@@ -248,6 +264,7 @@ int __cpuinit register_cpu(struct cpu *cpu, int num)
 #ifdef CONFIG_ARCH_HAS_CPU_AUTOPROBE
 	cpu->dev.bus->uevent = arch_cpu_uevent;
 #endif
+	cpu->dev.groups = common_cpu_attr_groups;
 	error = device_register(&cpu->dev);
 	if (!error && cpu->hotpluggable)
 		register_cpu_control(cpu);
@@ -256,10 +273,6 @@ int __cpuinit register_cpu(struct cpu *cpu, int num)
 	if (!error)
 		register_cpu_under_node(num, cpu_to_node(num));
 
-#ifdef CONFIG_KEXEC
-	if (!error)
-		error = device_create_file(&cpu->dev, &dev_attr_crash_notes);
-#endif
 	return error;
 }
 
-- 
1.7.1

