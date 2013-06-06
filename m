Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756818Ab3FFBuf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 21:50:35 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:47036 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756699Ab3FFBuc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 21:50:32 -0400
X-IronPort-AV: E=Sophos;i="4.87,810,1363104000"; 
   d="scan'208";a="7472976"
From: liguang <lig.fnst@cn.fujitsu.com>
To: Len Brown <lenb@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Matthew Garrett <matthew.garrett@nebula.com>, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, platform-driver-x86@vger.kernel.org,
        =?UTF-8?q?Andreas=20F=C3=A4rber?= <afaerber@suse.de>,
        Igor Mammedov <imammedo@redhat.com>, liguang <lig.fnst@cn.fujitsu.com>
Subject: [PATCH RFC v2 3/3] cpu_physic_hotplug: register handler for ec space notifier
Date: Thu, 6 Jun 2013 09:40:35 +0800
Message-Id: <1370482835-764-4-git-send-email-lig.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1370482835-764-1-git-send-email-lig.fnst@cn.fujitsu.com>
References: <1370482835-764-1-git-send-email-lig.fnst@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/06/06 09:40:18,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/06/06 09:48:46,
	Serialize complete at 2013/06/06 09:48:46
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: liguang <lig.fnst@cn.fujitsu.com>
---
 drivers/platform/x86/cpu_physic_hotplug.c |   30 ++++++++++++++++++++++++++--
 1 files changed, 27 insertions(+), 3 deletions(-)

diff --git a/drivers/platform/x86/cpu_physic_hotplug.c b/drivers/platform/x86/cpu_physic_hotplug.c
index a52c042..1cdac1b 100644
--- a/drivers/platform/x86/cpu_physic_hotplug.c
+++ b/drivers/platform/x86/cpu_physic_hotplug.c
@@ -9,6 +9,11 @@ MODULE_AUTHOR("Li Guang");
 MODULE_DESCRIPTION("CPU physically hot-plug/unplug Driver");
 MODULE_LICENSE("GPL");
 
+#define EC_SPACE_CPU_IDX       3
+#define EC_SPACE_CPU_OFFSET    4
+#define EC_SPACE_CPU_CMD	   2
+#define EC_CPU_EJECT		 0xE7
+
 static int cpu_logic_hotplug_notify(struct notifier_block *nfb,
 				unsigned long action, void *hcpu)
 {
@@ -20,6 +25,7 @@ static int cpu_logic_hotplug_notify(struct notifier_block *nfb,
 		case CPU_ONLINE:
 			break;
 		case CPU_DEAD:
+			ec_write(EC_SPACE_CPU_CMD, EC_CPU_EJECT);
 			break;
 		default:
 			break;
@@ -34,8 +40,26 @@ static struct notifier_block cpu_logic_hotplug_notifier =
 };
 
 static int cpu_physic_hotplug_notify(struct notifier_block *nfb,
-				 unsigned char *s)
+				 unsigned long action, void *s)
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
+
+out:
+    return NOTIFY_OK;
 }
 
 static struct notifier_block cpu_physic_hotplug_notifier =
@@ -46,14 +70,14 @@ static struct notifier_block cpu_physic_hotplug_notifier =
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

