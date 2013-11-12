Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755542Ab3KLNzd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 08:55:33 -0500
Received: from eu1sys200aog110.obsmtp.com ([207.126.144.129]:45407 "EHLO
	eu1sys200aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753801Ab3KLNyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 08:54:19 -0500
From: <srinivas.kandagatla@st.com>
To: <linux-arm-kernel@lists.infradead.org>, <netdev@vger.kernel.org>
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        Srinivas Kandagatla <srinivas.kandagatla@st.com>,
        Stuart Menefy <stuart.menefy@st.com>, Pavel Machek <pavel@ucw.cz>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.com>, <stephen.gallimore@st.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Grant Likely <grant.likely@linaro.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kernel@stlinux.com>, <linux-pm@vger.kernel.org>
Subject: [PATCH RFC 07/10] PM / wakeup : Introduce device_child_may_wakeup
Date: Tue, 12 Nov 2013 13:52:57 +0000
Message-ID: <1384264377-7609-1-git-send-email-srinivas.kandagatla@st.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1384264311-7308-1-git-send-email-srinivas.kandagatla@st.com>
References: <1384264311-7308-1-git-send-email-srinivas.kandagatla@st.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.65.51.59]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@st.com>

This patch introduces device_child_may_wakeup function, which will be
useful for wrapper or SoC level driver power management code.
Without this patch each driver has to write this same code to get the
functionality.

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@st.com>
---
 drivers/base/power/wakeup.c |   23 +++++++++++++++++++++++
 include/linux/pm_wakeup.h   |    1 +
 2 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/drivers/base/power/wakeup.c b/drivers/base/power/wakeup.c
index 2d56f41..270f000 100644
--- a/drivers/base/power/wakeup.c
+++ b/drivers/base/power/wakeup.c
@@ -342,6 +342,29 @@ int device_set_wakeup_enable(struct device *dev, bool enable)
 }
 EXPORT_SYMBOL_GPL(device_set_wakeup_enable);
 
+/* callback for device_child_may_wakeup */
+static int __device_child_may_wakeup(struct device *dev, void *c)
+{
+	return device_may_wakeup(dev);
+}
+
+/**
+ * device_child_may_wakeup - Check if any of the child devices are wakeup
+ * sources.
+ * @dev: parent device to handle.
+ *
+ * Function to check if any of the children of a given parent are wakeup
+ * sources.
+ *
+ * This function will return true if any one of the children of given parent
+ * are wakeup sources, else it returns false.
+ */
+bool device_child_may_wakeup(struct device *parent)
+{
+	return device_for_each_child(parent, NULL, __device_child_may_wakeup);
+}
+EXPORT_SYMBOL_GPL(device_child_may_wakeup);
+
 /*
  * The functions below use the observation that each wakeup event starts a
  * period in which the system should not be suspended.  The moment this period
diff --git a/include/linux/pm_wakeup.h b/include/linux/pm_wakeup.h
index a0f7080..b376584 100644
--- a/include/linux/pm_wakeup.h
+++ b/include/linux/pm_wakeup.h
@@ -93,6 +93,7 @@ extern int device_wakeup_disable(struct device *dev);
 extern void device_set_wakeup_capable(struct device *dev, bool capable);
 extern int device_init_wakeup(struct device *dev, bool val);
 extern int device_set_wakeup_enable(struct device *dev, bool enable);
+bool device_child_may_wakeup(struct device *parent);
 extern void __pm_stay_awake(struct wakeup_source *ws);
 extern void pm_stay_awake(struct device *dev);
 extern void __pm_relax(struct wakeup_source *ws);
-- 
1.7.6.5

