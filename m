Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752095Ab3LMFOi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 00:14:38 -0500
Received: from mga02.intel.com ([134.134.136.20]:44826 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751922Ab3LMFNq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 00:13:46 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,476,1384329600"; 
   d="scan'208";a="423990246"
From: David Cohen <david.a.cohen@linux.intel.com>
To: pavel@ucw.cz, rjw@rjwysocki.net, len.brown@intel.com,
        sarah.a.sharp@linux.intel.com, gregkh@linuxfoundation.org
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, santosh.shilimkar@ti.com,
        David Cohen <david.a.cohen@linux.intel.com>
Subject: [RFC/PATCH 1/3] pm: make PM macros more smart
Date: Thu, 12 Dec 2013 21:18:23 -0800
Message-Id: <1386911905-2366-2-git-send-email-david.a.cohen@linux.intel.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1386911905-2366-1-git-send-email-david.a.cohen@linux.intel.com>
References: <1386911905-2366-1-git-send-email-david.a.cohen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes SET_SYSTEM_SLEEP_PM_OPS() and SET_RUNTIME_PM_OPS() more
smart.

Despite those macros check for '#ifdef CONFIG_PM_SLEEP/RUNTIME' to avoid
setting the callbacks when such #ifdef's aren't defined, they don't
handle compiler to avoid messages like that:

drivers/usb/host/xhci-plat.c:200:12: warning: ‘xhci_plat_suspend’ defined but not used [-Wunused-function]
drivers/usb/host/xhci-plat.c:208:12: warning: ‘xhci_plat_resume’ defined but not used [-Wunused-function]

As result, those macros get rid of #ifdef's when setting callbacks but
not when implementing them.

With this patch, drivers using SET_*_PM_OPS() macros don't need to #ifdef
the callbacks implementation as well.

Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
---
 include/linux/pm.h | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/include/linux/pm.h b/include/linux/pm.h
index a224c7f5c377..41a0f3b42209 100644
--- a/include/linux/pm.h
+++ b/include/linux/pm.h
@@ -299,6 +299,8 @@ struct dev_pm_ops {
 	int (*runtime_idle)(struct device *dev);
 };
 
+#define MAKE_ME_NULL(fn) ((void *)((unsigned long)(fn) - (unsigned long)(fn)))
+
 #ifdef CONFIG_PM_SLEEP
 #define SET_SYSTEM_SLEEP_PM_OPS(suspend_fn, resume_fn) \
 	.suspend = suspend_fn, \
@@ -308,7 +310,9 @@ struct dev_pm_ops {
 	.poweroff = suspend_fn, \
 	.restore = resume_fn,
 #else
-#define SET_SYSTEM_SLEEP_PM_OPS(suspend_fn, resume_fn)
+#define SET_SYSTEM_SLEEP_PM_OPS(suspend_fn, resume_fn) \
+	.suspend = MAKE_ME_NULL(suspend_fn), \
+	.resume = MAKE_ME_NULL(resume_fn),
 #endif
 
 #ifdef CONFIG_PM_RUNTIME
@@ -317,7 +321,10 @@ struct dev_pm_ops {
 	.runtime_resume = resume_fn, \
 	.runtime_idle = idle_fn,
 #else
-#define SET_RUNTIME_PM_OPS(suspend_fn, resume_fn, idle_fn)
+#define SET_RUNTIME_PM_OPS(suspend_fn, resume_fn, idle_fn) \
+	.runtime_suspend = MAKE_ME_NULL(suspend_fn), \
+	.runtime_resume = MAKE_ME_NULL(resume_fn), \
+	.runtime_idle = MAKE_ME_NULL(idle_fn),
 #endif
 
 /*
-- 
1.8.4.2

