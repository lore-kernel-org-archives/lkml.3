Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755575Ab3JHPZT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 11:25:19 -0400
Received: from mail.abilis.ch ([195.70.19.74]:22034 "EHLO mail.abilis.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753814Ab3JHPZP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 11:25:15 -0400
X-Greylist: delayed 1379 seconds by postgrey-1.27 at vger.kernel.org; Tue, 08 Oct 2013 11:25:11 EDT
From: Romain Baeriswyl <Romain.Baeriswyl@abilis.com>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>,
        Pierrick Hascoet <pierrick.hascoet@abilis.com>,
        Vineet Gupta <vgupta@synopsys.com>,
        Christian Ruppert <christian.ruppert@abilis.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Chiau Ee Chew <chiau.ee.chew@intel.com>,
        Shinya Kuribayashi <skuribay@pobox.com>,
        Jean Delvare <khali@linux-fr.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        Romain Baeriswyl <romainba@abilis.com>
Subject: [PATCH 1/2] i2c designware make SCL and SDA falling time configurable
Date: Tue,  8 Oct 2013 17:00:54 +0200
Message-Id: <1381244455-3836-1-git-send-email-romainba@abilis.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20130828153429.GB7066@ab42.lan>
References: <20130828153429.GB7066@ab42.lan>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch allows to set independantly SCL and SDA falling times. 
The tLOW period is computed by taking into account the SCL falling time.
The tHIGH period is computed by taking into account the SDA falling time.

For instance in case the margin on tLOW is considered too small, it can 
be increased by increasing the SCL falling time which is by default set 
at 300ns.

The same applies for tHIGH period with the help of SDA falling time.

Signed-off-by: Romain Baeriswyl <romainba@abilis.com>
Reviewed-by: Christian Ruppert <christian.ruppert@abilis.com>
---
 .../devicetree/bindings/i2c/i2c-designware.txt     |    8 +++++
 drivers/i2c/busses/i2c-designware-core.c           |   34 +++++++++++++------
 drivers/i2c/busses/i2c-designware-core.h           |    2 +
 drivers/i2c/busses/i2c-designware-platdrv.c        |    7 ++++
 4 files changed, 40 insertions(+), 11 deletions(-)

diff --git a/Documentation/devicetree/bindings/i2c/i2c-designware.txt b/Documentation/devicetree/bindings/i2c/i2c-designware.txt
index 7fd7fa2..5199b0c 100644
--- a/Documentation/devicetree/bindings/i2c/i2c-designware.txt
+++ b/Documentation/devicetree/bindings/i2c/i2c-designware.txt
@@ -14,6 +14,12 @@ Optional properties :
  - i2c-sda-hold-time-ns : should contain the SDA hold time in nanoseconds.
    This option is only supported in hardware blocks version 1.11a or newer.
 
+ - i2c-scl-falling-time : should contain the SCL falling time in nanoseconds.
+   This value which is by default 300ns is used to compute the tLOW period.
+
+ - i2c-sda-falling-time : should contain the SDA falling time in nanoseconds.
+   This value which is by default 300ns is used to compute the tHIGH period.
+
 Example :
 
 	i2c@f0000 {
@@ -34,4 +40,6 @@ Example :
 		interrupts = <12 1>;
 		clock-frequency = <400000>;
 		i2c-sda-hold-time-ns = <300>;
+		i2c-sda-falling-time-ns = <300>;
+		i2c-scl-falling-time-ns = <300>;
 	};
diff --git a/drivers/i2c/busses/i2c-designware-core.c b/drivers/i2c/busses/i2c-designware-core.c
index 3525fc7..50c35f9 100644
--- a/drivers/i2c/busses/i2c-designware-core.c
+++ b/drivers/i2c/busses/i2c-designware-core.c
@@ -217,7 +217,7 @@ i2c_dw_scl_hcnt(u32 ic_clk, u32 tSYMBOL, u32 tf, int cond, int offset)
 		 *
 		 * If your hardware is free from tHD;STA issue, try this one.
 		 */
-		return (ic_clk * tSYMBOL + 5000) / 10000 - 8 + offset;
+		return (ic_clk * tSYMBOL + 500000) / 1000000 - 8 + offset;
 	else
 		/*
 		 * Conditional expression:
@@ -233,7 +233,8 @@ i2c_dw_scl_hcnt(u32 ic_clk, u32 tSYMBOL, u32 tf, int cond, int offset)
 		 * The reason why we need to take into account "tf" here,
 		 * is the same as described in i2c_dw_scl_lcnt().
 		 */
-		return (ic_clk * (tSYMBOL + tf) + 5000) / 10000 - 3 + offset;
+		return (ic_clk * (tSYMBOL + tf) + 500000) / 1000000
+			- 3 + offset;
 }
 
 static u32 i2c_dw_scl_lcnt(u32 ic_clk, u32 tLOW, u32 tf, int offset)
@@ -249,7 +250,7 @@ static u32 i2c_dw_scl_lcnt(u32 ic_clk, u32 tLOW, u32 tf, int offset)
 	 * account the fall time of SCL signal (tf).  Default tf value
 	 * should be 0.3 us, for safety.
 	 */
-	return ((ic_clk * (tLOW + tf) + 5000) / 10000) - 1 + offset;
+	return ((ic_clk * (tLOW + tf) + 500000) / 1000000) - 1 + offset;
 }
 
 static void __i2c_dw_enable(struct dw_i2c_dev *dev, bool enable)
@@ -286,6 +287,7 @@ int i2c_dw_init(struct dw_i2c_dev *dev)
 	u32 input_clock_khz;
 	u32 hcnt, lcnt;
 	u32 reg;
+	u32 sda_falling_time, scl_falling_time;
 
 	input_clock_khz = dev->get_clk_rate_khz(dev);
 
@@ -307,15 +309,25 @@ int i2c_dw_init(struct dw_i2c_dev *dev)
 
 	/* set standard and fast speed deviders for high/low periods */
 
+	if (dev->sda_falling_time)
+		sda_falling_time = dev->sda_falling_time;
+	else
+		sda_falling_time = 300; /* ns */
+
+	if (dev->scl_falling_time)
+		scl_falling_time = dev->scl_falling_time;
+	else
+		scl_falling_time = 300; /* ns */
+
 	/* Standard-mode */
 	hcnt = i2c_dw_scl_hcnt(input_clock_khz,
-				40,	/* tHD;STA = tHIGH = 4.0 us */
-				3,	/* tf = 0.3 us */
+				4000,	/* tHD;STA = tHIGH = 4.0 us */
+				sda_falling_time,
 				0,	/* 0: DW default, 1: Ideal */
 				0);	/* No offset */
 	lcnt = i2c_dw_scl_lcnt(input_clock_khz,
-				47,	/* tLOW = 4.7 us */
-				3,	/* tf = 0.3 us */
+				4700,	/* tLOW = 4.7 us */
+				scl_falling_time,
 				0);	/* No offset */
 
 	/* Allow platforms to specify the ideal HCNT and LCNT values */
@@ -323,13 +335,13 @@ int i2c_dw_init(struct dw_i2c_dev *dev)
 
 	/* Fast-mode */
 	hcnt = i2c_dw_scl_hcnt(input_clock_khz,
-				6,	/* tHD;STA = tHIGH = 0.6 us */
-				3,	/* tf = 0.3 us */
+				600,	/* tHD;STA = tHIGH = 0.6 us */
+				sda_falling_time,
 				0,	/* 0: DW default, 1: Ideal */
 				0);	/* No offset */
 	lcnt = i2c_dw_scl_lcnt(input_clock_khz,
-				13,	/* tLOW = 1.3 us */
-				3,	/* tf = 0.3 us */
+				1300,	/* tLOW = 1.3 us */
+				scl_falling_time,
 				0);	/* No offset */
 
 	if (dev->fs_hcnt && dev->fs_lcnt) {
diff --git a/drivers/i2c/busses/i2c-designware-core.h b/drivers/i2c/busses/i2c-designware-core.h
index 912aa22..8b9397e 100644
--- a/drivers/i2c/busses/i2c-designware-core.h
+++ b/drivers/i2c/busses/i2c-designware-core.h
@@ -91,6 +91,8 @@ struct dw_i2c_dev {
 	unsigned int		rx_fifo_depth;
 	int			rx_outstanding;
 	u32			sda_hold_time;
+	u32			sda_falling_time;
+	u32			scl_falling_time;
 	u16			ss_hcnt;
 	u16			ss_lcnt;
 	u16			fs_hcnt;
diff --git a/drivers/i2c/busses/i2c-designware-platdrv.c b/drivers/i2c/busses/i2c-designware-platdrv.c
index 8b9d3f1..0d6fe47 100644
--- a/drivers/i2c/busses/i2c-designware-platdrv.c
+++ b/drivers/i2c/busses/i2c-designware-platdrv.c
@@ -129,6 +129,13 @@ static int dw_i2c_probe(struct platform_device *pdev)
 					"i2c-sda-hold-time-ns", &ht);
 		dev->sda_hold_time = div_u64((u64)ic_clk * ht + 500000,
 					     1000000);
+
+		of_property_read_u32(pdev->dev.of_node,
+				     "i2c-sda-falling-time-ns",
+				     &dev->sda_falling_time);
+		of_property_read_u32(pdev->dev.of_node,
+				     "i2c-scl-falling-time-ns",
+				     &dev->scl_falling_time);
 	}
 
 	dev->functionality =
-- 
1.7.1

