Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753355Ab3IJVtj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 17:49:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36345 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752468Ab3IJVpK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 17:45:10 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        kexec@lists.infradead.org
Cc: akpm@linux-foundation.org, zohar@linux.vnet.ibm.com,
        d.kasatkin@samsung.com, ebiederm@xmission.com, hpa@zytor.com,
        matthew.garrett@nebula.com, vgoyal@redhat.com
Subject: [PATCH 14/16] kexec: Export sysfs attributes for secureboot and secure modules to user space
Date: Tue, 10 Sep 2013 17:44:29 -0400
Message-Id: <1378849471-10521-15-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1378849471-10521-1-git-send-email-vgoyal@redhat.com>
References: <1378849471-10521-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

User space kexec-tools need to know whether to verify signature of kernel
image being loaded. This patch exports two knobs to user space. One is
for knowing if  secureboot is enabled, this knob will be set to 1 if secure
boot is enabled. Other knob is secure_module_enabled. This knob will be set
to 1 if secure modules is one.

kexec-tools will verify signature of kernel image if either secureboot is
enabled or secure modules is enabled. The only difference between two is
that kexec-tools will set secureboot on in bootparams being passed to
second kernel if secureboot is on in first kernel.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 kernel/ksysfs.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/kernel/ksysfs.c b/kernel/ksysfs.c
index 6ada93c..7262245 100644
--- a/kernel/ksysfs.c
+++ b/kernel/ksysfs.c
@@ -18,6 +18,8 @@
 #include <linux/stat.h>
 #include <linux/sched.h>
 #include <linux/capability.h>
+#include <linux/efi.h>
+#include <linux/module.h>
 
 #define KERNEL_ATTR_RO(_name) \
 static struct kobj_attribute _name##_attr = __ATTR_RO(_name)
@@ -101,6 +103,25 @@ static ssize_t kexec_crash_loaded_show(struct kobject *kobj,
 }
 KERNEL_ATTR_RO(kexec_crash_loaded);
 
+static ssize_t secureboot_enabled_show(struct kobject *kobj,
+				       struct kobj_attribute *attr, char *buf)
+{
+	/* TODO: Change it once secureboot patches are in */
+	return sprintf(buf, "%d\n", 1);
+}
+KERNEL_ATTR_RO(secureboot_enabled);
+
+static ssize_t secure_modules_enabled_show(struct kobject *kobj,
+				       struct kobj_attribute *attr, char *buf)
+{
+	/*
+	 * TODO: Change it once secure_modules() or secure_level() patches
+	 * are in
+	 */
+	return sprintf(buf, "%d\n", 1);
+}
+KERNEL_ATTR_RO(secure_modules_enabled);
+
 static ssize_t kexec_crash_size_show(struct kobject *kobj,
 				       struct kobj_attribute *attr, char *buf)
 {
@@ -196,6 +217,10 @@ static struct attribute * kernel_attrs[] = {
 	&kexec_crash_size_attr.attr,
 	&vmcoreinfo_attr.attr,
 #endif
+#ifdef CONFIG_EFI
+	&secureboot_enabled_attr.attr,
+#endif
+	&secure_modules_enabled_attr.attr,
 	&rcu_expedited_attr.attr,
 	NULL
 };
-- 
1.8.3.1

