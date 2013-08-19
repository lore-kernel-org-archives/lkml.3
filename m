Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751211Ab3HSR0W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 13:26:22 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:51120 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059Ab3HSR0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 13:26:19 -0400
From: Matthew Garrett <matthew.garrett@nebula.com>
To: linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org, jwboyer@redhat.com, keescook@chromium.org,
        Matthew Garrett <matthew.garrett@nebula.com>
Subject: [PATCH V2 01/10] Add secure_modules() call
Date: Mon, 19 Aug 2013 13:26:02 -0400
Message-Id: <1376933171-9854-2-git-send-email-matthew.garrett@nebula.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1376933171-9854-1-git-send-email-matthew.garrett@nebula.com>
References: <1376933171-9854-1-git-send-email-matthew.garrett@nebula.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 2001:470:1f07:1371:6267:20ff:fec3:2318
X-SA-Exim-Mail-From: matthew.garrett@nebula.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide a single call to allow kernel code to determine whether the system
has been configured to either disable module loading entirely or to load
only modules signed with a trusted key.

Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>
---
 include/linux/module.h | 7 +++++++
 kernel/module.c        | 9 +++++++++
 2 files changed, 16 insertions(+)

diff --git a/include/linux/module.h b/include/linux/module.h
index 46f1ea0..0c266b2 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -509,6 +509,8 @@ int unregister_module_notifier(struct notifier_block * nb);
 
 extern void print_modules(void);
 
+extern bool secure_modules(void);
+
 #else /* !CONFIG_MODULES... */
 
 /* Given an address, look for it in the exception tables. */
@@ -619,6 +621,11 @@ static inline int unregister_module_notifier(struct notifier_block * nb)
 static inline void print_modules(void)
 {
 }
+
+static inline bool secure_modules(void)
+{
+	return false;
+}
 #endif /* CONFIG_MODULES */
 
 #ifdef CONFIG_SYSFS
diff --git a/kernel/module.c b/kernel/module.c
index 2069158..801021e 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -3852,3 +3852,12 @@ void module_layout(struct module *mod,
 }
 EXPORT_SYMBOL(module_layout);
 #endif
+
+bool secure_modules(void)
+{
+#ifdef CONFIG_MODULE_SIG
+	return (sig_enforce || modules_disabled);
+#else
+	return modules_disabled;
+#endif
+}
-- 
1.8.3.1

