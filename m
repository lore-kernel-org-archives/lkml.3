Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756932Ab3K0Pfg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 10:35:36 -0500
Received: from mail-la0-f52.google.com ([209.85.215.52]:38903 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756769Ab3K0Pfc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 10:35:32 -0500
From: Ulf Hansson <ulf.hansson@linaro.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, linux-pm@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Kevin Hilman <khilman@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 3/5] PM / Runtime: Add second macro for definition of runtime PM callbacks
Date: Wed, 27 Nov 2013 16:34:58 +0100
Message-Id: <1385566500-7666-4-git-send-email-ulf.hansson@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1385566500-7666-1-git-send-email-ulf.hansson@linaro.org>
References: <1385566500-7666-1-git-send-email-ulf.hansson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is allowed and will in many cases make sense to have the runtime PM
callbacks to be defined for CONFIG_PM instead of CONFIG_PM_RUNTIME.

Since the PM core disables runtime PM during system suspend, before the
.suspend_late callbacks are invoked, drivers could at this point
directly invoke it's runtime PM callbacks or even walk through it's bus
or power domain, to put it's device into low power state.

Use the new macro SET_PM_RUNTIME_PM_OPS in cases were the above makes
sense. Make sure the callbacks are encapsulated within CONFIG_PM
instead of CONFIG_PM_RUNTIME.

Do note that the old macro SET_RUNTIME_PM_OPS, which is being quite
widely used right now, requires the callbacks to be defined for
CONFIG_PM_RUNTIME. In many cases it will certainly be convenient to
convert to the new macro above, but still some cases are optimal for
only CONFIG_PM_RUNTIME.

Cc: Kevin Hilman <khilman@linaro.org>
Cc: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
---
 include/linux/pm.h |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/include/linux/pm.h b/include/linux/pm.h
index 5bce0d4..529657c 100644
--- a/include/linux/pm.h
+++ b/include/linux/pm.h
@@ -320,6 +320,15 @@ struct dev_pm_ops {
 #define SET_RUNTIME_PM_OPS(suspend_fn, resume_fn, idle_fn)
 #endif
 
+#ifdef CONFIG_PM
+#define SET_PM_RUNTIME_PM_OPS(suspend_fn, resume_fn, idle_fn) \
+	.runtime_suspend = suspend_fn, \
+	.runtime_resume = resume_fn, \
+	.runtime_idle = idle_fn,
+#else
+#define SET_PM_RUNTIME_PM_OPS(suspend_fn, resume_fn, idle_fn)
+#endif
+
 /*
  * Use this if you want to use the same suspend and resume callbacks for suspend
  * to RAM and hibernation.
-- 
1.7.9.5

