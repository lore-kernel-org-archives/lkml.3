Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753735AbaIPIxv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 04:53:51 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:14444 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753183AbaIPIwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 04:52:15 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-93-5417fa3856d3
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Russell King <linux@arm.linux.org.uk>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        dmaengine@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Michal Simek <michal.simek@xilinx.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Randy Dunlap <rdunlap@infradead.org>,
        Alan Stern <stern@rowland.harvard.edu>, linux-doc@vger.kernel.org,
        linux-pm@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v4 1/4] PM / Runtime: Add getter for quering the IRQ safe option
Date: Tue, 16 Sep 2014 10:51:31 +0200
Message-id: <1410857494-15936-2-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1410857494-15936-1-git-send-email-k.kozlowski@samsung.com>
References: <1410857494-15936-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrELMWRmVeSWpSXmKPExsVy+t/xy7oWv8RDDD69tLLYOGM9q8X0qRcY
	LVZP/ctqceDPDkaL1y8MLc42vWG3WDJ5PqvFrCl7mSwWti1hsbi8aw6bxefeI4wWty/zWqw9
	cpfd4t3LCIu7p46yWby9M53F4szpS6wWE35fYLM4vjbc4mXffhYHEY+W5h42j80rtDwW73nJ
	5HHn2h42jyVvDrF6bLnazuIx++4PRo++LasYPVas/s7u8XmTnMfez79ZArijuGxSUnMyy1KL
	9O0SuDJ2/J7LWnBRsGLR5fnsDYz3+LoYOTkkBEwkXp5YygZhi0lcuLceyObiEBJYyihx8fxS
	KKePSWJx/yQmkCo2AWOJzcuXgCVEBI6wSDy79wTMYRY4yigxvfctWJWwQIDEmjU7WUFsFgFV
	iWl/5zCD2LwC7hKXP/yC2icncfLYZLAaTgEPiUlzr7OD2EJANQf23mGfwMi7gJFhFaNoamly
	QXFSeq6RXnFibnFpXrpecn7uJkZIPHzdwbj0mNUhRgEORiUe3hkbxUKEWBPLiitzDzFKcDAr
	ifA++CQeIsSbklhZlVqUH19UmpNafIiRiYNTqoFxZkNcwWPpptrEWpmlnw7xe3y9nlL6f17V
	pHd9qbtZDdy/PjP/NcNojc+Zz9ZV6V1Xj8/bGFvfcctv0Vez2u+yhwIuHmApO7WIOSGzZn+b
	3uqPf3b7KivX5GZF/bc5fZIh3jtXuC0q7v7Nz8dLxJW5Y76bvs4/fed1rXRv1L+sN9Przkq+
	efpLiaU4I9FQi7moOBEAcXDgqWUCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a simple getter pm_runtime_is_irq_safe() for quering whether runtime
PM IRQ safe was set or not.

Various bus drivers implementing runtime PM may use choose to suspend
differently based on IRQ safeness status of child driver (e.g. do not
unprepare the clock if IRQ safe is not set).

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 Documentation/power/runtime_pm.txt | 4 ++++
 include/linux/pm_runtime.h         | 6 ++++++
 2 files changed, 10 insertions(+)

diff --git a/Documentation/power/runtime_pm.txt b/Documentation/power/runtime_pm.txt
index f32ce5419573..397b81593142 100644
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

