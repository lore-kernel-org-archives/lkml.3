Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759968Ab3EGEeg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 00:34:36 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:25931 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932546Ab3EGEZw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 00:25:52 -0400
X-Authority-Analysis: v=2.0 cv=cOZiQyiN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=Cg3-EDHf5uMA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=cqf7y_m11HUA:10 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8 a=vmLDa1wCAAAA:8 a=XQdqHUosmfpxsHrtSzgA:9 a=MSl-tDqOz04A:10 a=p2_iZCu7nSUA:10 a=gv_BBZfBKR8A:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130507035854.304600553@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 06 May 2013 23:58:32 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: =?UTF-8?q?Stefan=20Br=C3=BCns?= <stefan.bruens@rwth-aachen.de>,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [080/126] ssb: implement spurious tone avoidance
References: <20130507035712.909872333@goodmis.org>
Content-Disposition: inline; filename=0080-ssb-implement-spurious-tone-avoidance.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.3 stable review patch.
If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>

[ Upstream commit 46fc4c909339f5a84d1679045297d9d2fb596987 ]

And make use of it in b43. This fixes a regression introduced with
49d55cef5b1925a5c1efb6aaddaa40fc7c693335
b43: N-PHY: implement spurious tone avoidance
This commit made BCM4322 use only MCS 0 on channel 13, which of course
resulted in performance drop (down to 0.7Mb/s).

Reported-by: Stefan Brüns <stefan.bruens@rwth-aachen.de>
Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
Cc: Stable <stable@vger.kernel.org>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/net/wireless/b43/phy_n.c          |    3 ++-
 drivers/ssb/driver_chipcommon_pmu.c       |   29 +++++++++++++++++++++++++++++
 include/linux/ssb/ssb_driver_chipcommon.h |    2 ++
 3 files changed, 33 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index 914718a..df4a82b 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -4583,7 +4583,8 @@ static void b43_nphy_pmu_spur_avoid(struct b43_wldev *dev, bool avoid)
 #endif
 #ifdef CONFIG_B43_SSB
 	case B43_BUS_SSB:
-		/* FIXME */
+		ssb_pmu_spuravoid_pllupdate(&dev->dev->sdev->bus->chipco,
+					    avoid);
 		break;
 #endif
 	}
diff --git a/drivers/ssb/driver_chipcommon_pmu.c b/drivers/ssb/driver_chipcommon_pmu.c
index b58fef7..1fb9b22 100644
--- a/drivers/ssb/driver_chipcommon_pmu.c
+++ b/drivers/ssb/driver_chipcommon_pmu.c
@@ -645,3 +645,32 @@ u32 ssb_pmu_get_controlclock(struct ssb_chipcommon *cc)
 		return 0;
 	}
 }
+
+void ssb_pmu_spuravoid_pllupdate(struct ssb_chipcommon *cc, int spuravoid)
+{
+	u32 pmu_ctl = 0;
+
+	switch (cc->dev->bus->chip_id) {
+	case 0x4322:
+		ssb_chipco_pll_write(cc, SSB_PMU1_PLLCTL0, 0x11100070);
+		ssb_chipco_pll_write(cc, SSB_PMU1_PLLCTL1, 0x1014140a);
+		ssb_chipco_pll_write(cc, SSB_PMU1_PLLCTL5, 0x88888854);
+		if (spuravoid == 1)
+			ssb_chipco_pll_write(cc, SSB_PMU1_PLLCTL2, 0x05201828);
+		else
+			ssb_chipco_pll_write(cc, SSB_PMU1_PLLCTL2, 0x05001828);
+		pmu_ctl = SSB_CHIPCO_PMU_CTL_PLL_UPD;
+		break;
+	case 43222:
+		/* TODO: BCM43222 requires updating PLLs too */
+		return;
+	default:
+		ssb_printk(KERN_ERR PFX
+			   "Unknown spuravoidance settings for chip 0x%04X, not changing PLL\n",
+			   cc->dev->bus->chip_id);
+		return;
+	}
+
+	chipco_set32(cc, SSB_CHIPCO_PMU_CTL, pmu_ctl);
+}
+EXPORT_SYMBOL_GPL(ssb_pmu_spuravoid_pllupdate);
diff --git a/include/linux/ssb/ssb_driver_chipcommon.h b/include/linux/ssb/ssb_driver_chipcommon.h
index 1a6b004..29ce7e4 100644
--- a/include/linux/ssb/ssb_driver_chipcommon.h
+++ b/include/linux/ssb/ssb_driver_chipcommon.h
@@ -219,6 +219,7 @@
 #define SSB_CHIPCO_PMU_CTL			0x0600 /* PMU control */
 #define  SSB_CHIPCO_PMU_CTL_ILP_DIV		0xFFFF0000 /* ILP div mask */
 #define  SSB_CHIPCO_PMU_CTL_ILP_DIV_SHIFT	16
+#define  SSB_CHIPCO_PMU_CTL_PLL_UPD		0x00000400
 #define  SSB_CHIPCO_PMU_CTL_NOILPONW		0x00000200 /* No ILP on wait */
 #define  SSB_CHIPCO_PMU_CTL_HTREQEN		0x00000100 /* HT req enable */
 #define  SSB_CHIPCO_PMU_CTL_ALPREQEN		0x00000080 /* ALP req enable */
@@ -661,5 +662,6 @@ enum ssb_pmu_ldo_volt_id {
 void ssb_pmu_set_ldo_voltage(struct ssb_chipcommon *cc,
 			     enum ssb_pmu_ldo_volt_id id, u32 voltage);
 void ssb_pmu_set_ldo_paref(struct ssb_chipcommon *cc, bool on);
+void ssb_pmu_spuravoid_pllupdate(struct ssb_chipcommon *cc, int spuravoid);
 
 #endif /* LINUX_SSB_CHIPCO_H_ */
-- 
1.7.10.4


