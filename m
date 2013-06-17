Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753052Ab3FQTPw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 15:15:52 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:44736 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752957Ab3FQTPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 15:15:50 -0400
From: Lorenz Haspel <lorenz@badgers.com>
To: devel@linuxdriverproject.org
Cc: gregkh@linuxfoundation.org, puff65537@bansheeslibrary.com,
        viro@zeniv.linux.org.uk, michael.banken@mathe.stud.uni-erlangen.de,
        dan.carpenter@oracle.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        linux-kernel@i4.informatik.uni-erlangen.de, lorenz@badgers.com
Subject: [PATCH 1/4 v2] silicom: checkpatch: assignments in if conditions
Date: Mon, 17 Jun 2013 21:15:39 +0200
Message-Id: <1371496539-25461-1-git-send-email-lorenz@badgers.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1371486386-8043-1-git-send-email-lorenz@badgers.com>
References: <1371486386-8043-1-git-send-email-lorenz@badgers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes checkpatch error:
There were assignments in if conditions, so I extracted them.

Signed-off-by: Lorenz Haspel <lorenz@badgers.com>
Signed-off-by: Michael Banken <michael.banken@mathe.stud.uni-erlangen.de>
---
v2: removed some buggy extra lines and fixed white space issues
---
 drivers/staging/silicom/bpctl_mod.c |  182 +++++++++++++++++++++++------------
 1 file changed, 119 insertions(+), 63 deletions(-)

diff --git a/drivers/staging/silicom/bpctl_mod.c b/drivers/staging/silicom/bpctl_mod.c
index a3b974b..82b4dbb 100644
--- a/drivers/staging/silicom/bpctl_mod.c
+++ b/drivers/staging/silicom/bpctl_mod.c
@@ -245,9 +245,14 @@ static int bp_device_event(struct notifier_block *unused,
 	case NETDEV_CHANGE:{
 			if (netif_carrier_ok(dev))
 				return NOTIFY_DONE;
+			dev_num = get_dev_idx(dev->ifindex);
 
-			if (((dev_num = get_dev_idx(dev->ifindex)) == -1) ||
-			    (!(pbpctl_dev = &bpctl_dev_arr[dev_num])))
+			if (dev_num == -1)
+				return NOTIFY_DONE;
+
+			pbpctl_dev = &bpctl_dev_arr[dev_num];
+
+			if (!pbpctl_dev)
 				return NOTIFY_DONE;
 
 			if ((is_bypass_fn(pbpctl_dev)) == 1)
@@ -306,7 +311,9 @@ static void write_pulse(bpctl_dev_t *pbpctl_dev,
 		ctrl = BP10G_READ_REG(pbpctl_dev, ESDP);
 
 	if (pbpctl_dev->bp_10g9) {
-		if (!(pbpctl_dev_c = get_status_port_fn(pbpctl_dev)))
+		pbpctl_dev_c = get_status_port_fn(pbpctl_dev);
+
+		if (!pbpctl_dev_c)
 			return;
 		ctrl = BP10G_READ_REG(pbpctl_dev_c, ESDP);
 	}
@@ -606,7 +613,9 @@ static int read_pulse(bpctl_dev_t *pbpctl_dev, unsigned int ctrl_ext,
 	if (pbpctl_dev->bp_540)
 		ctrl = BP10G_READ_REG(pbpctl_dev, ESDP);
 	if (pbpctl_dev->bp_10g9) {
-		if (!(pbpctl_dev_c = get_status_port_fn(pbpctl_dev)))
+		pbpctl_dev_c = get_status_port_fn(pbpctl_dev);
+
+		if (!pbpctl_dev_c)
 			return -1;
 		ctrl = BP10G_READ_REG(pbpctl_dev_c, ESDP);
 	}
@@ -775,7 +784,9 @@ static void write_reg(bpctl_dev_t *pbpctl_dev, unsigned char value,
 	bpctl_dev_t *pbpctl_dev_c = NULL;
 	unsigned long flags;
 	if (pbpctl_dev->bp_10g9) {
-		if (!(pbpctl_dev_c = get_status_port_fn(pbpctl_dev)))
+		pbpctl_dev_c = get_status_port_fn(pbpctl_dev);
+
+		if (!pbpctl_dev_c)
 			return;
 	}
 	if ((pbpctl_dev->wdt_status == WDT_STATUS_EN) &&
@@ -953,7 +964,9 @@ static int read_reg(bpctl_dev_t *pbpctl_dev, unsigned char addr)
 	atomic_set(&pbpctl_dev->wdt_busy, 1);
 #endif
 	if (pbpctl_dev->bp_10g9) {
-		if (!(pbpctl_dev_c = get_status_port_fn(pbpctl_dev)))
+		pbpctl_dev_c = get_status_port_fn(pbpctl_dev);
+
+		if (!pbpctl_dev_c)
 			return -1;
 	}
 
@@ -1224,7 +1237,9 @@ static int wdt_pulse(bpctl_dev_t *pbpctl_dev)
 		return -1;
 #endif
 	if (pbpctl_dev->bp_10g9) {
-		if (!(pbpctl_dev_c = get_status_port_fn(pbpctl_dev)))
+		pbpctl_dev_c = get_status_port_fn(pbpctl_dev);
+
+		if (!pbpctl_dev_c)
 			return -1;
 	}
 
@@ -1742,9 +1757,9 @@ static void write_data_port_int(bpctl_dev_t *pbpctl_dev,
 
 static int write_data_int(bpctl_dev_t *pbpctl_dev, unsigned char value)
 {
-	bpctl_dev_t *pbpctl_dev_b = NULL;
+	bpctl_dev_t *pbpctl_dev_b = get_status_port_fn(pbpctl_dev);
 
-	if (!(pbpctl_dev_b = get_status_port_fn(pbpctl_dev)))
+	if (!pbpctl_dev_b)
 		return -1;
 	atomic_set(&pbpctl_dev->wdt_busy, 1);
 	write_data_port_int(pbpctl_dev, value & 0x3);
@@ -1963,9 +1978,9 @@ int disc_port_off(bpctl_dev_t *pbpctl_dev)
 int tpl_hw_on(bpctl_dev_t *pbpctl_dev)
 {
 	int ret = 0, ctrl = 0;
-	bpctl_dev_t *pbpctl_dev_b = NULL;
+	bpctl_dev_t *pbpctl_dev_b = get_status_port_fn(pbpctl_dev);
 
-	if (!(pbpctl_dev_b = get_status_port_fn(pbpctl_dev)))
+	if (!pbpctl_dev_b)
 		return BP_NOT_CAP;
 
 	if (pbpctl_dev->bp_caps_ex & TPL2_CAP_EX) {
@@ -1990,9 +2005,9 @@ int tpl_hw_on(bpctl_dev_t *pbpctl_dev)
 int tpl_hw_off(bpctl_dev_t *pbpctl_dev)
 {
 	int ret = 0, ctrl = 0;
-	bpctl_dev_t *pbpctl_dev_b = NULL;
+	bpctl_dev_t *pbpctl_dev_b = get_status_port_fn(pbpctl_dev);
 
-	if (!(pbpctl_dev_b = get_status_port_fn(pbpctl_dev)))
+	if (!pbpctl_dev_b)
 		return BP_NOT_CAP;
 	if (pbpctl_dev->bp_caps_ex & TPL2_CAP_EX) {
 		cmnd_on(pbpctl_dev);
@@ -2373,11 +2388,11 @@ static int set_tx(bpctl_dev_t *pbpctl_dev, int tx_state)
 		if (PEG5_IF_SERIES(pbpctl_dev->subdevice)) {
 			if (tx_state) {
 				uint16_t mii_reg;
-				if (!
-				    (ret =
-				     bp75_read_phy_reg(pbpctl_dev,
+				ret = bp75_read_phy_reg(pbpctl_dev,
 						       BPCTLI_PHY_CONTROL,
-						       &mii_reg))) {
+						       &mii_reg);
+
+				if (!ret) {
 					if (mii_reg & BPCTLI_MII_CR_POWER_DOWN) {
 						ret =
 						    bp75_write_phy_reg
@@ -2389,12 +2404,11 @@ static int set_tx(bpctl_dev_t *pbpctl_dev, int tx_state)
 				}
 			} else {
 				uint16_t mii_reg;
-				if (!
-				    (ret =
-				     bp75_read_phy_reg(pbpctl_dev,
+				ret = bp75_read_phy_reg(pbpctl_dev,
 						       BPCTLI_PHY_CONTROL,
-						       &mii_reg))) {
+						       &mii_reg);
 
+				if (!ret) {
 					mii_reg |= BPCTLI_MII_CR_POWER_DOWN;
 					ret =
 					    bp75_write_phy_reg(pbpctl_dev,
@@ -3237,30 +3251,36 @@ int bypass_from_last_read(bpctl_dev_t *pbpctl_dev)
 	uint32_t ctrl_ext = 0;
 	bpctl_dev_t *pbpctl_dev_b = NULL;
 
-	if ((pbpctl_dev->bp_caps & SW_CTL_CAP)
-	    && (pbpctl_dev_b = get_status_port_fn(pbpctl_dev))) {
-		ctrl_ext = BPCTL_READ_REG(pbpctl_dev_b, CTRL_EXT);
-		BPCTL_BP_WRITE_REG(pbpctl_dev_b, CTRL_EXT,
+	if (pbpctl_dev->bp_caps & SW_CTL_CAP) {
+		pbpctl_dev_b = get_status_port_fn(pbpctl_dev);
+
+		if (pbpctl_dev_b) {
+			ctrl_ext = BPCTL_READ_REG(pbpctl_dev_b, CTRL_EXT);
+			BPCTL_BP_WRITE_REG(pbpctl_dev_b, CTRL_EXT,
 				   (ctrl_ext & ~BPCTLI_CTRL_EXT_SDP7_DIR));
-		ctrl_ext = BPCTL_READ_REG(pbpctl_dev_b, CTRL_EXT);
-		if (ctrl_ext & BPCTLI_CTRL_EXT_SDP7_DATA)
-			return 0;
-		return 1;
-	} else
-		return BP_NOT_CAP;
+			ctrl_ext = BPCTL_READ_REG(pbpctl_dev_b, CTRL_EXT);
+
+			if (ctrl_ext & BPCTLI_CTRL_EXT_SDP7_DATA)
+				return 0;
+			return 1;
+		}
+	}
+	return BP_NOT_CAP;
 }
 
 int bypass_status_clear(bpctl_dev_t *pbpctl_dev)
 {
 	bpctl_dev_t *pbpctl_dev_b = NULL;
 
-	if ((pbpctl_dev->bp_caps & SW_CTL_CAP)
-	    && (pbpctl_dev_b = get_status_port_fn(pbpctl_dev))) {
+	if (pbpctl_dev->bp_caps & SW_CTL_CAP) {
+		pbpctl_dev_b = get_status_port_fn(pbpctl_dev);
 
-		send_bypass_clear_pulse(pbpctl_dev_b, 1);
-		return 0;
-	} else
-		return BP_NOT_CAP;
+		if (pbpctl_dev_b) {
+			send_bypass_clear_pulse(pbpctl_dev_b, 1);
+			return 0;
+		}
+	}
+	return BP_NOT_CAP;
 }
 
 int bypass_flag_status(bpctl_dev_t *pbpctl_dev)
@@ -3327,9 +3347,9 @@ static int bypass_status(bpctl_dev_t *pbpctl_dev)
 	u32 ctrl_ext = 0;
 	if (pbpctl_dev->bp_caps & BP_CAP) {
 
-		bpctl_dev_t *pbpctl_dev_b = NULL;
+		bpctl_dev_t *pbpctl_dev_b = get_status_port_fn(pbpctl_dev);
 
-		if (!(pbpctl_dev_b = get_status_port_fn(pbpctl_dev)))
+		if (!pbpctl_dev_b)
 			return BP_NOT_CAP;
 
 		if (INTEL_IF_SERIES(pbpctl_dev->subdevice)) {
@@ -3615,9 +3635,9 @@ int tap_status(bpctl_dev_t *pbpctl_dev)
 	u32 ctrl_ext = 0;
 
 	if (pbpctl_dev->bp_caps & TAP_CAP) {
-		bpctl_dev_t *pbpctl_dev_b = NULL;
+		bpctl_dev_t *pbpctl_dev_b = get_status_port_fn(pbpctl_dev);
 
-		if (!(pbpctl_dev_b = get_status_port_fn(pbpctl_dev)))
+		if (!pbpctl_dev_b)
 			return BP_NOT_CAP;
 
 		if (pbpctl_dev->bp_ext_ver >= 0x8) {
@@ -3713,7 +3733,9 @@ int disc_off_status(bpctl_dev_t *pbpctl_dev)
 	u32 ctrl_ext = 0;
 
 	if (pbpctl_dev->bp_caps & DISC_CAP) {
-		if (!(pbpctl_dev_b = get_status_port_fn(pbpctl_dev)))
+		pbpctl_dev_b = get_status_port_fn(pbpctl_dev);
+
+		if (!pbpctl_dev_b)
 			return BP_NOT_CAP;
 		if (DISCF_IF_SERIES(pbpctl_dev->subdevice))
 			return ((((read_reg(pbpctl_dev, STATUS_DISC_REG_ADDR)) &
@@ -3794,8 +3816,9 @@ static int disc_status(bpctl_dev_t *pbpctl_dev)
 {
 	int ctrl = 0;
 	if (pbpctl_dev->bp_caps & DISC_CAP) {
+		ctrl = disc_off_status(pbpctl_dev);
 
-		if ((ctrl = disc_off_status(pbpctl_dev)) < 0)
+		if (ctrl < 0)
 			return ctrl;
 		return ((ctrl == 0) ? 1 : 0);
 
@@ -3909,9 +3932,9 @@ int tpl2_flag_status(bpctl_dev_t *pbpctl_dev)
 
 int tpl_hw_status(bpctl_dev_t *pbpctl_dev)
 {
-	bpctl_dev_t *pbpctl_dev_b = NULL;
+	bpctl_dev_t *pbpctl_dev_b = get_status_port_fn(pbpctl_dev);
 
-	if (!(pbpctl_dev_b = get_status_port_fn(pbpctl_dev)))
+	if (!pbpctl_dev_b)
 		return BP_NOT_CAP;
 
 	if (TPL_IF_SERIES(pbpctl_dev->subdevice))
@@ -4215,9 +4238,9 @@ void bypass_caps_init(bpctl_dev_t *pbpctl_dev)
 
 int bypass_off_init(bpctl_dev_t *pbpctl_dev)
 {
-	int ret = 0;
+	int ret = cmnd_on(pbpctl_dev);
 
-	if ((ret = cmnd_on(pbpctl_dev)) < 0)
+	if (ret < 0)
 		return ret;
 	if (INTEL_IF_SERIES(pbpctl_dev->subdevice))
 		return dis_bypass_cap(pbpctl_dev);
@@ -4403,7 +4426,10 @@ int set_bypass_fn(bpctl_dev_t *pbpctl_dev, int bypass_mode)
 
 	if (!(pbpctl_dev->bp_caps & BP_CAP))
 		return BP_NOT_CAP;
-	if ((ret = cmnd_on(pbpctl_dev)) < 0)
+
+	ret = cmnd_on(pbpctl_dev);
+
+	if (ret < 0)
 		return ret;
 	if (!bypass_mode)
 		ret = bypass_off(pbpctl_dev);
@@ -4435,7 +4461,10 @@ int set_dis_bypass_fn(bpctl_dev_t *pbpctl_dev, int dis_param)
 
 	if (!(pbpctl_dev->bp_caps & BP_DIS_CAP))
 		return BP_NOT_CAP;
-	if ((ret = cmnd_on(pbpctl_dev)) < 0)
+
+	ret = cmnd_on(pbpctl_dev);
+
+	if (ret < 0)
 		return ret;
 	if (dis_param)
 		ret = dis_bypass_cap(pbpctl_dev);
@@ -4461,7 +4490,10 @@ int set_bypass_pwoff_fn(bpctl_dev_t *pbpctl_dev, int bypass_mode)
 
 	if (!(pbpctl_dev->bp_caps & BP_PWOFF_CTL_CAP))
 		return BP_NOT_CAP;
-	if ((ret = cmnd_on(pbpctl_dev)) < 0)
+
+	ret = cmnd_on(pbpctl_dev);
+
+	if (ret < 0)
 		return ret;
 	if (bypass_mode)
 		ret = bypass_state_pwroff(pbpctl_dev);
@@ -4487,7 +4519,10 @@ int set_bypass_pwup_fn(bpctl_dev_t *pbpctl_dev, int bypass_mode)
 
 	if (!(pbpctl_dev->bp_caps & BP_PWUP_CTL_CAP))
 		return BP_NOT_CAP;
-	if ((ret = cmnd_on(pbpctl_dev)) < 0)
+
+	ret = cmnd_on(pbpctl_dev);
+
+	if (ret < 0)
 		return ret;
 	if (bypass_mode)
 		ret = bypass_state_pwron(pbpctl_dev);
@@ -4514,7 +4549,9 @@ int set_bypass_wd_fn(bpctl_dev_t *pbpctl_dev, int timeout)
 	if (!(pbpctl_dev->bp_caps & WD_CTL_CAP))
 		return BP_NOT_CAP;
 
-	if ((ret = cmnd_on(pbpctl_dev)) < 0)
+	ret = cmnd_on(pbpctl_dev);
+
+	if (ret < 0)
 		return ret;
 	if (!timeout)
 		ret = wdt_off(pbpctl_dev);
@@ -4583,7 +4620,9 @@ int set_std_nic_fn(bpctl_dev_t *pbpctl_dev, int nic_mode)
 	if (!(pbpctl_dev->bp_caps & STD_NIC_CAP))
 		return BP_NOT_CAP;
 
-	if ((ret = cmnd_on(pbpctl_dev)) < 0)
+	ret = cmnd_on(pbpctl_dev);
+
+	if (ret < 0)
 		return ret;
 	if (nic_mode)
 		ret = std_nic_on(pbpctl_dev);
@@ -4649,7 +4688,9 @@ int get_tap_pwup_fn(bpctl_dev_t *pbpctl_dev)
 	if (!pbpctl_dev)
 		return -1;
 
-	if ((ret = default_pwron_tap_status(pbpctl_dev)) < 0)
+	ret = default_pwron_tap_status(pbpctl_dev);
+
+	if (ret < 0)
 		return ret;
 	return ((ret == 0) ? 1 : 0);
 }
@@ -4824,7 +4865,9 @@ int get_disc_port_pwup_fn(bpctl_dev_t *pbpctl_dev)
 	if (!pbpctl_dev)
 		return -1;
 
-	if ((ret = default_pwron_disc_port_status(pbpctl_dev)) < 0)
+	ret = default_pwron_disc_port_status(pbpctl_dev);
+
+	if (ret < 0)
 		return ret;
 	return ((ret == 0) ? 1 : 0);
 }
@@ -4851,7 +4894,9 @@ int reset_cont_fn(bpctl_dev_t *pbpctl_dev)
 	if (!pbpctl_dev)
 		return -1;
 
-	if ((ret = cmnd_on(pbpctl_dev)) < 0)
+	ret = cmnd_on(pbpctl_dev);
+
+	if (ret < 0)
 		return ret;
 	return reset_cont(pbpctl_dev);
 }
@@ -4867,8 +4912,11 @@ int set_tx_fn(bpctl_dev_t *pbpctl_dev, int tx_state)
 	    (pbpctl_dev->bp_caps & SW_CTL_CAP)) {
 		if ((pbpctl_dev->bp_tpl_flag))
 			return BP_NOT_CAP;
-	} else if ((pbpctl_dev_b = get_master_port_fn(pbpctl_dev))) {
-		if ((pbpctl_dev_b->bp_caps & TPL_CAP) &&
+	} else {
+		pbpctl_dev_b = get_status_port_fn(pbpctl_dev);
+
+		if ((pbpctl_dev_b) &&
+		    (pbpctl_dev_b->bp_caps & TPL_CAP) &&
 		    (pbpctl_dev_b->bp_tpl_flag))
 			return BP_NOT_CAP;
 	}
@@ -4984,8 +5032,11 @@ int get_tx_fn(bpctl_dev_t *pbpctl_dev)
 	    (pbpctl_dev->bp_caps & SW_CTL_CAP)) {
 		if ((pbpctl_dev->bp_tpl_flag))
 			return BP_NOT_CAP;
-	} else if ((pbpctl_dev_b = get_master_port_fn(pbpctl_dev))) {
-		if ((pbpctl_dev_b->bp_caps & TPL_CAP) &&
+	} else{
+		pbpctl_dev_b = get_master_port_fn(pbpctl_dev);
+
+		if ((pbpctl_dev_b) &&
+		    (pbpctl_dev_b->bp_caps & TPL_CAP) &&
 		    (pbpctl_dev_b->bp_tpl_flag))
 			return BP_NOT_CAP;
 	}
@@ -5023,8 +5074,9 @@ static void bp_tpl_timer_fn(unsigned long param)
 	bpctl_dev_t *pbpctl_dev = (bpctl_dev_t *) param;
 	uint32_t link1, link2;
 	bpctl_dev_t *pbpctl_dev_b = NULL;
+	pbpctl_dev_b = get_status_port_fn(pbpctl_dev);
 
-	if (!(pbpctl_dev_b = get_status_port_fn(pbpctl_dev)))
+	if (!pbpctl_dev_b)
 		return;
 
 	if (!pbpctl_dev->bp_tpl_flag) {
@@ -5128,7 +5180,9 @@ int set_tpl_fn(bpctl_dev_t *pbpctl_dev, int tpl_mode)
 
 	if (pbpctl_dev->bp_caps & TPL_CAP) {
 		if (tpl_mode) {
-			if ((pbpctl_dev_b = get_status_port_fn(pbpctl_dev)))
+			pbpctl_dev_b = get_status_port_fn(pbpctl_dev);
+
+			if (pbpctl_dev_b)
 				set_tx(pbpctl_dev_b, 1);
 			set_tx(pbpctl_dev, 1);
 		}
@@ -6708,7 +6762,9 @@ static int init_one(bpctl_dev_t *dev, bpmod_info_t *info, struct pci_dev *pdev1)
 			reset_cont(dev);
 	}
 #ifdef BP_SELF_TEST
-	if ((dev->bp_tx_data = kzalloc(BPTEST_DATA_LEN, GFP_KERNEL))) {
+	dev->bp_tx_data = kzalloc(BPTEST_DATA_LEN, GFP_KERNEL);
+
+	if (dev->bp_tx_data) {
 		memset(dev->bp_tx_data, 0xff, 6);
 		memset(dev->bp_tx_data + 6, 0x0, 1);
 		memset(dev->bp_tx_data + 7, 0xaa, 5);
-- 
1.7.10.4

