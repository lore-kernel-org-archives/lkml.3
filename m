Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754909AbaKNIwY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 03:52:24 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:21083 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754637AbaKNIun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 03:50:43 -0500
X-AuditID: cbfec7f4-b7f6c6d00000120b-ec-5465c25f2faf
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, Russell King <linux@arm.linux.org.uk>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, dmaengine@vger.kernel.org
Cc: Kevin Hilman <khilman@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v12 1/6] PM / Runtime: Add getter for querying the IRQ safe
 option
Date: Fri, 14 Nov 2014 09:50:28 +0100
Message-id: <1415955033-29093-2-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1415955033-29093-1-git-send-email-k.kozlowski@samsung.com>
References: <1415955033-29093-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLLMWRmVeSWpSXmKPExsVy+t/xy7rxh1JDDJq/illsnLGe1WL61AuM
	Fqun/mW1eP3C0OLp5sdMFmeb3rBbdE5cwm4xa8peJovLu+awWXzuPcJocfsyr8XaI3fZLe6e
	Ospmceb0JVaLCb8vsFkcXxtu8bJvP4uDoEdLcw+bx+yOmawei/e8ZPLYtKqTzePOtT1sHluu
	trN4zL77g9Gjb8sqRo8Vq7+ze3zeJBfAFcVlk5Kak1mWWqRvl8CVselqYsE2oYqtn/pYGxh3
	8HcxcnJICJhIXFj9nB3CFpO4cG89WxcjF4eQwFJGia6L7xlBEkICfUwSL/bYgNhsAsYSm5cv
	ASsSEWhnluhbN5UNJMEssIhJommqIogtLBAicXDDPyYQm0VAVWL2h4fMIDavgLvE+217oLbJ
	SZw8NpkVxOYU8JCYvHEVC8Qyd4nPl/8wT2DkXcDIsIpRNLU0uaA4KT3XUK84Mbe4NC9dLzk/
	dxMjJMi/7GBcfMzqEKMAB6MSD69BQWqIEGtiWXFl7iFGCQ5mJRFepd1AId6UxMqq1KL8+KLS
	nNTiQ4xMHJxSDYyhgU+uGW2pWm4dt6f+s9WbXbJz99p/SHmsyGTC+PFZuGRUxc2XrO+ll7HJ
	sM3fwCaxb2vorJe2Bznt9GJe7zrOpvG2c9qGr7Z6ph3T/3etf/n+ltnHyX+52W5PjtUIfG9X
	UxV/R72m/qSNmnzabAF+fq0/y6uXTr10U/yRxqqwBTeDv3aeaLBQYinOSDTUYi4qTgQAaqj0
	glACAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a simple getter pm_runtime_is_irq_safe() for querying whether runtime
PM IRQ safe was set or not.

Various bus drivers implementing runtime PM may use choose to suspend
differently based on IRQ safeness status of child driver (e.g. do not
unprepare the clock if IRQ safe is not set).

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>
Acked-by: Rafael J. Wysocki <rjw@rjwysocki.net>
---
 Documentation/power/runtime_pm.txt | 4 ++++
 include/linux/pm_runtime.h         | 6 ++++++
 2 files changed, 10 insertions(+)

diff --git a/Documentation/power/runtime_pm.txt b/Documentation/power/runtime_pm.txt
index 0e5ea26b255a..44fe1d28a163 100644
--- a/Documentation/power/runtime_pm.txt
+++ b/Documentation/power/runtime_pm.txt
@@ -468,6 +468,10 @@ drivers/base/power/runtime.c and include/linux/pm_runtime.h:
     - set the power.irq_safe flag for the device, causing the runtime-PM
       callbacks to be invoked with interrupts off
 
+  bool pm_runtime_is_irq_safe(struct device *dev);
+    - return true if power.irq_safe flag was set for the device, causing
+      the runtime-PM callbacks to be invoked with interrupts off
+
   void pm_runtime_mark_last_busy(struct device *dev);
     - set the power.last_busy field to the current time
 
diff --git a/include/linux/pm_runtime.h b/include/linux/pm_runtime.h
index 367f49b9a1c9..44d74f0f182e 100644
--- a/include/linux/pm_runtime.h
+++ b/include/linux/pm_runtime.h
@@ -128,6 +128,11 @@ static inline void pm_runtime_mark_last_busy(struct device *dev)
 	ACCESS_ONCE(dev->power.last_busy) = jiffies;
 }
 
+static inline bool pm_runtime_is_irq_safe(struct device *dev)
+{
+	return dev->power.irq_safe;
+}
+
 #else /* !CONFIG_PM_RUNTIME */
 
 static inline int __pm_runtime_idle(struct device *dev, int rpmflags)
@@ -167,6 +172,7 @@ static inline bool pm_runtime_enabled(struct device *dev) { return false; }
 
 static inline void pm_runtime_no_callbacks(struct device *dev) {}
 static inline void pm_runtime_irq_safe(struct device *dev) {}
+static inline bool pm_runtime_is_irq_safe(struct device *dev) { return false; }
 
 static inline bool pm_runtime_callbacks_present(struct device *dev) { return false; }
 static inline void pm_runtime_mark_last_busy(struct device *dev) {}
-- 
1.9.1

