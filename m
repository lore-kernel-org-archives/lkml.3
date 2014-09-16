Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754161AbaIPNAd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 09:00:33 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:22432 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753895AbaIPM7h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 08:59:37 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-b4-541834359383
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
Subject: [PATCH v5 1/4] PM / Runtime: Add getter for quering the IRQ safe option
Date: Tue, 16 Sep 2014 14:59:17 +0200
Message-id: <1410872360-27029-2-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1410872360-27029-1-git-send-email-k.kozlowski@samsung.com>
References: <1410872360-27029-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrELMWRmVeSWpSXmKPExsVy+t/xK7qmJhIhBidvmllsnLGe1WL61AuM
	Fqun/mW1OPBnB6PF6xeGFmeb3rBbLJk8n9Vi1pS9TBYL25awWFzeNYfN4nPvEUaL25d5LdYe
	uctu8e5lhMXdU0fZLN7emc5iceb0JVaLCb8vsFkcXxtu8bJvP4uDiEdLcw+bx+YVWh6L97xk
	8rhzbQ+bx5I3h1g9tlxtZ/GYffcHo0ffllWMHitWf2f3+LxJzmPv598sAdxRXDYpqTmZZalF
	+nYJXBk7fs9lLbgoWLHo8nz2BsZ7fF2MnBwSAiYS/3vusULYYhIX7q1n62Lk4hASWMoo8e9n
	MzuE08ck0fFhGgtIFZuAscTm5UvAqkQEjrBIPLv3BMxhFjjKKDG99y0TSJWwQIDEgmuXGUFs
	FgFVifbf85hBbF4Bd4n24x1MEPvkJE4emwy2m1PAQ+L63mtgNUJANTenTmCewMi7gJFhFaNo
	amlyQXFSeq6hXnFibnFpXrpecn7uJkZIPHzZwbj4mNUhRgEORiUe3ox/4iFCrIllxZW5hxgl
	OJiVRHg9NCVChHhTEiurUovy44tKc1KLDzEycXBKNTBOm/VXMuboTMNJaxTPT+aL2pTr3jO9
	aIZlYKpqgm/Rat9i7y2C557uP7n0geuhkBj/mfGzyvI0LV493lly/Uhjn2y8sua5ied+eIcK
	TD+xp9b56btlF4QiqsPOTt4SbfPoCav+bbZ/jvWNUcuCLkqa7BDcnZ15+JpffU2CmVfV5FPT
	zh6pfhqrxFKckWioxVxUnAgAjl5JQ2UCAAA=
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

