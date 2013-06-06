Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756788Ab3FFBd7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 21:33:59 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:24120 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756739Ab3FFBd5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 21:33:57 -0400
X-IronPort-AV: E=Sophos;i="4.87,810,1363104000"; 
   d="scan'208";a="7472795"
From: liguang <lig.fnst@cn.fujitsu.com>
To: Len Brown <lenb@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Matthew Garrett <matthew.garrett@nebula.com>, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, platform-driver-x86@vger.kernel.org,
        liguang <lig.fnst@cn.fujitsu.com>
Subject: [PATCH RFC 3/3] cpu_physic_hotplug: register handler for ec space notifier
Date: Thu, 6 Jun 2013 09:32:16 +0800
Message-Id: <1370482336-636-4-git-send-email-lig.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1370482336-636-1-git-send-email-lig.fnst@cn.fujitsu.com>
References: <1370482336-636-1-git-send-email-lig.fnst@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/06/06 09:32:06,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/06/06 09:32:13,
	Serialize complete at 2013/06/06 09:32:13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: liguang <lig.fnst@cn.fujitsu.com>
---
 drivers/platform/x86/cpu_physic_hotplug.c |   27 +++++++++++++++++++++++++--
 1 files changed, 25 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/cpu_physic_hotplug.c b/drivers/platform/x86/cpu_physic_hotplug.c
index a52c042..a84c999 100644
--- a/drivers/platform/x86/cpu_physic_hotplug.c
+++ b/drivers/platform/x86/cpu_physic_hotplug.c
@@ -9,6 +9,9 @@ MODULE_AUTHOR("Li Guang");
 MODULE_DESCRIPTION("CPU physically hot-plug/unplug Driver");
 MODULE_LICENSE("GPL");
 
+#define EC_SPACE_CPU_IDX       3
+#define EC_SPACE_CPU_OFFSET    4
+
 static int cpu_logic_hotplug_notify(struct notifier_block *nfb,
 				unsigned long action, void *hcpu)
 {
@@ -36,6 +39,26 @@ static struct notifier_block cpu_logic_hotplug_notifier =
 static int cpu_physic_hotplug_notify(struct notifier_block *nfb,
 				 unsigned char *s)
 {
+	u8 index = 0, val = 0;
+	bool cpu_state = false;
+	struct acpi_processor *pr;
+
+	ec_read(EC_SPACE_CPU_IDX, &index);
+	if (index == 0)
+		goto out;
+	pr = per_cpu(processors, index);
+
+	ec_read(EC_SPACE_CPU_OFFSET + index/8, &val);
+	if (val & 1 << index/8)
+		cpu_state = true;
+
+	if (pr->flags.need_hotplug_init & cpu_state)
+		cpu_up(pr->id);
+	else
+		cpu_down(pr->id);
+
+out:
+    return NOTIFY_OK;
 }
 
 static struct notifier_block cpu_physic_hotplug_notifier =
@@ -46,14 +69,14 @@ static struct notifier_block cpu_physic_hotplug_notifier =
 static int __init cpu_qemu_hotplug_init(void)
 {
 	register_hotcpu_notifier(&cpu_logic_hotplug_notifier);
-	register_ec_gpe_notifier(&cpu_physic_hotplug_notifier);
+	register_ec_space_notifier(&cpu_physic_hotplug_notifier);
 	return 0;
 }
 
 static void __exit cpu_qemu_hotplug_exit(void)
 {
 	unregister_hotcpu_notifier(&cpu_logic_hotplug_notifier);
-	unregister_ec_gpe_notifier(&cpu_physic_hotplug_notifier);
+	unregister_ec_space_notifier(&cpu_physic_hotplug_notifier);
 }
 
 module_init(cpu_qemu_hotplug_init);
-- 
1.7.2.5

