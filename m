Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752631AbbAOJQw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 04:16:52 -0500
Received: from mga09.intel.com ([134.134.136.24]:21784 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751565AbbAOJQJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 04:16:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,402,1418112000"; 
   d="scan'208";a="670290668"
From: "David E. Box" <david.e.box@linux.intel.com>
To: wsa@the-dreams.de
Cc: jdelvare@suse.de, arnd@arndb.de, maxime.ripard@free-electrons.com,
        dianders@chromium.org, david.e.box@linux.intel.com,
        u.kleine-koenig@pengutronix.de,
        laurent.pinchart+renesas@ideasonboard.com,
        boris.brezillon@free-electrons.com, maxime.coquelin@st.com,
        andrew@lunn.ch, sjg@chromium.org, markus.mayer@linaro.org,
        ch.naveen@samsung.com, jacob.jun.pan@linux.intel.com,
        max.schwarz@online.de, mika.westerberg@linux.intel.com,
        skuribay@pobox.com, Romain.Baeriswyl@abilis.com, wenkai.du@intel.com,
        christian.ruppert@abilis.com, alan@linux.intel.com,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org
Subject: [PATCH V4 1/2] i2c-designware: Add i2c bus locking support
Date: Thu, 15 Jan 2015 01:12:16 -0800
Message-Id: <1421313137-1613-2-git-send-email-david.e.box@linux.intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1421313137-1613-1-git-send-email-david.e.box@linux.intel.com>
References: <1421313137-1613-1-git-send-email-david.e.box@linux.intel.com>
In-Reply-To: <1417478973-25522-1-git-send-email-david.e.box@linux.intel.com>
References: <1417478973-25522-1-git-send-email-david.e.box@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds support for acquiring and releasing a hardware bus lock in the i2c
designware core transfer function. This is needed for i2c bus controllers
that are shared with but not controlled by the kernel.

Signed-off-by: David E. Box <david.e.box@linux.intel.com>
---
 drivers/i2c/busses/i2c-designware-core.c | 26 ++++++++++++++++++++++++++
 drivers/i2c/busses/i2c-designware-core.h |  6 ++++++
 2 files changed, 32 insertions(+)

diff --git a/drivers/i2c/busses/i2c-designware-core.c b/drivers/i2c/busses/i2c-designware-core.c
index 3c20e4b..3d3ac4d 100644
--- a/drivers/i2c/busses/i2c-designware-core.c
+++ b/drivers/i2c/busses/i2c-designware-core.c
@@ -289,6 +289,15 @@ int i2c_dw_init(struct dw_i2c_dev *dev)
 	u32 hcnt, lcnt;
 	u32 reg;
 	u32 sda_falling_time, scl_falling_time;
+	int ret;
+
+	if (dev->acquire_lock) {
+		ret = dev->acquire_lock(dev);
+		if (ret) {
+			dev_err(dev->dev, "couldn't acquire bus ownership\n");
+			return ret;
+		}
+	}
 
 	input_clock_khz = dev->get_clk_rate_khz(dev);
 
@@ -302,6 +311,8 @@ int i2c_dw_init(struct dw_i2c_dev *dev)
 	} else if (reg != DW_IC_COMP_TYPE_VALUE) {
 		dev_err(dev->dev, "Unknown Synopsys component type: "
 			"0x%08x\n", reg);
+		if (dev->release_lock)
+			dev->release_lock(dev);
 		return -ENODEV;
 	}
 
@@ -368,6 +379,9 @@ int i2c_dw_init(struct dw_i2c_dev *dev)
 
 	/* configure the i2c master */
 	dw_writel(dev, dev->master_cfg , DW_IC_CON);
+
+	if (dev->release_lock)
+		dev->release_lock(dev);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(i2c_dw_init);
@@ -631,6 +645,14 @@ i2c_dw_xfer(struct i2c_adapter *adap, struct i2c_msg msgs[], int num)
 	dev->abort_source = 0;
 	dev->rx_outstanding = 0;
 
+	if (dev->acquire_lock) {
+		ret = dev->acquire_lock(dev);
+		if (ret) {
+			dev_err(dev->dev, "couldn't acquire bus ownership\n");
+			goto done_nolock;
+		}
+	}
+
 	ret = i2c_dw_wait_bus_not_busy(dev);
 	if (ret < 0)
 		goto done;
@@ -676,6 +698,10 @@ i2c_dw_xfer(struct i2c_adapter *adap, struct i2c_msg msgs[], int num)
 	ret = -EIO;
 
 done:
+	if (dev->release_lock)
+		dev->release_lock(dev);
+
+done_nolock:
 	pm_runtime_mark_last_busy(dev->dev);
 	pm_runtime_put_autosuspend(dev->dev);
 	mutex_unlock(&dev->lock);
diff --git a/drivers/i2c/busses/i2c-designware-core.h b/drivers/i2c/busses/i2c-designware-core.h
index d66b6cb..a472c91 100644
--- a/drivers/i2c/busses/i2c-designware-core.h
+++ b/drivers/i2c/busses/i2c-designware-core.h
@@ -65,6 +65,9 @@
  * @ss_lcnt: standard speed LCNT value
  * @fs_hcnt: fast speed HCNT value
  * @fs_lcnt: fast speed LCNT value
+ * @acquire_lock: function to acquire a hardware lock on the bus
+ * @release_lock: function to release a hardware lock on the bus
+ * @pm_runtime_disabled: true if pm runtime is disabled
  *
  * HCNT and LCNT parameters can be used if the platform knows more accurate
  * values than the one computed based only on the input clock frequency.
@@ -105,6 +108,9 @@ struct dw_i2c_dev {
 	u16			ss_lcnt;
 	u16			fs_hcnt;
 	u16			fs_lcnt;
+	int			(*acquire_lock)(struct dw_i2c_dev *dev);
+	void			(*release_lock)(struct dw_i2c_dev *dev);
+	bool			pm_runtime_disabled;
 };
 
 #define ACCESS_SWAP		0x00000001
-- 
1.9.1

