Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755318AbaHVKdx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 06:33:53 -0400
Received: from mail-la0-f51.google.com ([209.85.215.51]:50495 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751556AbaHVKdw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 06:33:52 -0400
From: Miguel Oliveira <cmroliv@gmail.com>
To: gregkh@linuxfoundation.org
Cc: navin.patidar@gmail.com, Larry.Finger@lwfinger.net, davem@davemloft.net,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        cmroliv@gmail.com
Subject: [PATCH 1/4] staging: rtl8188eu: os_intfs.c
Date: Fri, 22 Aug 2014 11:32:38 +0100
Message-Id: <1408703558-32167-1-git-send-email-cmroliv@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

void rtw_proc_remove_one(struct net_device *dev)
{
}
void rtw_proc_init_one(struct net_device *dev)
  /* TODO: Convert these to /sys */

Converting the above from proc into debugfs.
Convert all rtw_proc_xxx references to rtw_sys_xxx

Signed-off-by: Miguel Oliveira <cmroliv@gmail.com>
---
 drivers/staging/rtl8188eu/os_dep/os_intfs.c |  517 +++++++++++++++++----------
 1 file changed, 326 insertions(+), 191 deletions(-)

diff --git a/drivers/staging/rtl8188eu/os_dep/os_intfs.c b/drivers/staging/rtl8188eu/os_dep/os_intfs.c
index c7a44ab..49b441a 100644
--- a/drivers/staging/rtl8188eu/os_dep/os_intfs.c
+++ b/drivers/staging/rtl8188eu/os_dep/os_intfs.c
@@ -29,6 +29,8 @@
 
 #include <usb_hal.h>
 
+#include <linux/debugfs.h>
+
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Realtek Wireless Lan Driver");
 MODULE_AUTHOR("Realtek Semiconductor Corp.");
@@ -166,50 +168,254 @@ MODULE_PARM_DESC(rtw_notch_filter, "0:Disable, 1:Enable, 2:Enable only for P2P")
 module_param_named(debug, rtw_debug, int, 0444);
 MODULE_PARM_DESC(debug, "Set debug level (1-9) (default 1)");
 
-/* dummy routines */
-void rtw_proc_remove_one(struct net_device *dev)
-{
-}
+static const struct file_operations drv_version = {
+	.owner =	THIS_MODULE,
+	.read =		sys_get_drv_version,
+	.llseek =	default_llseek,
+};
+
+static const struct file_operations write_reg = {
+	.owner =	THIS_MODULE,
+	.write =	sys_set_write_reg,
+	.llseek =	default_llseek,
+};
+
+static const struct file_operations read_reg = {
+	.owner =	THIS_MODULE,
+	.read =		sys_get_read_reg,
+	.write =	sys_set_read_reg,
+	.llseek =	default_llseek,
+};
+
+static const struct file_operations fwstate = {
+	.owner =	THIS_MODULE,
+	.read =		sys_get_fwstate,
+	.llseek =	default_llseek,
+};
+
+static const struct file_operations sec_info = {
+	.owner =	THIS_MODULE,
+	.read =		sys_get_sec_info,
+	.llseek =	default_llseek,
+};
+
+static const struct file_operations mlmext_state = {
+	.owner =	THIS_MODULE,
+	.read =		sys_get_mlmext_state,
+	.llseek =	default_llseek,
+};
+
+static const struct file_operations qos_option = {
+	.owner =	THIS_MODULE,
+	.read =		sys_get_qos_option,
+	.llseek =	default_llseek,
+};
+
+static const struct file_operations ht_option = {
+	.owner =	THIS_MODULE,
+	.read =		sys_get_ht_option,
+	.llseek =	default_llseek,
+};
+
+static const struct file_operations rf_info = {
+	.owner =	THIS_MODULE,
+	.read =		sys_get_rf_info,
+	.llseek =	default_llseek,
+};
+
+static const struct file_operations ap_info = {
+	.owner =	THIS_MODULE,
+	.read =		sys_get_ap_info,
+	.llseek =	default_llseek,
+};
+
+static const struct file_operations adapter_state = {
+	.owner =	THIS_MODULE,
+	.read =		sys_get_adapter_state,
+	.llseek =	default_llseek,
+};
+
+static const struct file_operations trx_info = {
+	.owner =	THIS_MODULE,
+	.read =		sys_get_trx_info,
+	.llseek =	default_llseek,
+};
+
+static const struct file_operations mac_reg_dump1 = {
+	.owner =	THIS_MODULE,
+	.read =		sys_get_mac_reg_dump1,
+	.llseek =	default_llseek,
+};
+
+static const struct file_operations mac_reg_dump2 = {
+	.owner =	THIS_MODULE,
+	.read =		sys_get_mac_reg_dump2,
+	.llseek =	default_llseek,
+};
+
+static const struct file_operations mac_reg_dump3 = {
+	.owner =	THIS_MODULE,
+	.read =		sys_get_mac_reg_dump3,
+	.llseek =	default_llseek,
+};
+
+static const struct file_operations bb_reg_dump1 = {
+	.owner =	THIS_MODULE,
+	.read =		sys_get_bb_reg_dump1,
+	.llseek =	default_llseek,
+};
+
+static const struct file_operations bb_reg_dump2 = {
+	.owner =	THIS_MODULE,
+	.read =		sys_get_bb_reg_dump2,
+	.llseek =	default_llseek,
+};
+
+static const struct file_operations bb_reg_dump3 = {
+	.owner =	THIS_MODULE,
+	.read =		sys_get_bb_reg_dump3,
+	.llseek =	default_llseek,
+};
+
+static const struct file_operations rf_reg_dump1 = {
+	.owner =	THIS_MODULE,
+	.read =		sys_get_rf_reg_dump1,
+	.llseek =	default_llseek,
+};
+
+static const struct file_operations rf_reg_dump2 = {
+	.owner =	THIS_MODULE,
+	.read =		sys_get_rf_reg_dump2,
+	.llseek =	default_llseek,
+};
+
+static const struct file_operations rf_reg_dump3 = {
+	.owner =	THIS_MODULE,
+	.read =		sys_get_rf_reg_dump3,
+	.llseek =	default_llseek,
+};
+
+static const struct file_operations rf_reg_dump4 = {
+	.owner =	THIS_MODULE,
+	.read =		sys_get_rf_reg_dump4,
+	.llseek =	default_llseek,
+};
+
+#ifdef CONFIG_88EU_AP_MODE
+
+static const struct file_operations all_sta_info = {
+	.owner =	THIS_MODULE,
+	.read =		sys_get_all_sta_info,
+	.llseek =	default_llseek,
+};
+
+#endif
+
+static const struct file_operations best_channel = {
+	.owner =	THIS_MODULE,
+	.read =		sys_get_best_channel,
+	.llseek =	default_llseek,
+};
+
+static const struct file_operations rx_signal = {
+	.owner =	THIS_MODULE,
+	.read =		sys_get_rx_signal,
+	.write =	sys_set_rx_signal,
+	.llseek =	default_llseek,
+};
+
+static const struct file_operations ht_enable = {
+	.owner =	THIS_MODULE,
+	.read =		sys_get_ht_enable,
+	.write =	sys_set_ht_enable,
+	.llseek =	default_llseek,
+};
+
+static const struct file_operations cbw40_enable = {
+	.owner =	THIS_MODULE,
+	.read =		sys_get_cbw40_enable,
+	.write =	sys_set_cbw40_enable,
+	.llseek =	default_llseek,
+};
+
+static const struct file_operations ampdu_enable = {
+	.owner =	THIS_MODULE,
+	.read =		sys_get_ampdu_enable,
+	.write =	sys_set_ampdu_enable,
+	.llseek =	default_llseek,
+};
+
+static const struct file_operations rx_stbc = {
+	.owner =	THIS_MODULE,
+	.read =		sys_get_rx_stbc,
+	.write =	sys_set_rx_stbc,
+	.llseek =	default_llseek,
+};
+
+static const struct file_operations two_path_rssi = {
+	.owner =	THIS_MODULE,
+	.read =		sys_get_two_path_rssi,
+	.llseek =	default_llseek,
+};
 
-void rtw_proc_init_one(struct net_device *dev)
+static const struct file_operations rssi_disp = {
+	.owner =	THIS_MODULE,
+	.write =	sys_set_rssi_disp,
+	.llseek =	default_llseek,
+};
+
+
+static struct dentry *rtw_sys;
+static int rtw_sys_cnt;
+
+void rtw_sys_remove_one(struct net_device *dev)
 {
+	struct dentry *dir_dev;
+	struct adapter *padapter = rtw_netdev_priv(dev);
+
+	dir_dev = padapter->dir_dev;
+	padapter->dir_dev = NULL;
+
+	debugfs_remove_recursive(dir_dev);
+
+	rtw_sys_cnt--;
+	if (rtw_sys_cnt == 0) {
+		debugfs_remove_recursive(rtw_sys);
+		rtw_sys = NULL;
+	}
+
 }
 
-#if 0	/* TODO: Convert these to /sys */
-void rtw_proc_init_one(struct net_device *dev)
+void rtw_sys_init_one(struct net_device *dev)
 {
-	struct proc_dir_entry *dir_dev = NULL;
-	struct proc_dir_entry *entry = NULL;
-	struct adapter	*padapter = rtw_netdev_priv(dev);
+	struct dentry *entry;
+	struct dentry *dir_dev;
+	struct adapter *padapter = rtw_netdev_priv(dev);
 	u8 rf_type;
 
-	if (rtw_proc == NULL) {
-		memcpy(rtw_proc_name, DRV_NAME, sizeof(DRV_NAME));
-
-		rtw_proc = create_proc_entry(rtw_proc_name, S_IFDIR, init_net.proc_net);
-		if (rtw_proc == NULL) {
-			DBG_88E(KERN_ERR "Unable to create rtw_proc directory\n");
+	if (rtw_sys == NULL) {
+		rtw_sys = debugfs_create_dir(DRV_NAME, NULL);
+		if (rtw_sys == NULL) {
+			DBG_88E(KERN_ERR
+				 "Unable to create rtw_sys directory\n");
 			return;
 		}
 
-		entry = create_proc_read_entry("ver_info", S_IFREG | S_IRUGO, rtw_proc, proc_get_drv_version, dev);
+		entry = debugfs_create_file("ver_info", S_IFREG | S_IRUGO,
+						rtw_sys, dev, &drv_version);
 		if (!entry) {
-			pr_info("Unable to create_proc_read_entry!\n");
+			pr_info("Unable to create_sys_entry!\n");
 			return;
 		}
 	}
 
 	if (padapter->dir_dev == NULL) {
-		padapter->dir_dev = create_proc_entry(dev->name,
-					  S_IFDIR | S_IRUGO | S_IXUGO,
-					  rtw_proc);
+		padapter->dir_dev = debugfs_create_dir(dev->name, rtw_sys);
 		dir_dev = padapter->dir_dev;
 		if (dir_dev == NULL) {
-			if (rtw_proc_cnt == 0) {
-				if (rtw_proc) {
-					remove_proc_entry(rtw_proc_name, init_net.proc_net);
-					rtw_proc = NULL;
-				}
+			if (rtw_sys_cnt == 0) {
+				debugfs_remove_recursive(rtw_sys);
+				rtw_sys = NULL;
 			}
 
 			pr_info("Unable to create dir_dev directory\n");
@@ -219,295 +425,224 @@ void rtw_proc_init_one(struct net_device *dev)
 		return;
 	}
 
-	rtw_proc_cnt++;
+	rtw_sys_cnt++;
 
-	entry = create_proc_read_entry("write_reg", S_IFREG | S_IRUGO,
-				   dir_dev, proc_get_write_reg, dev);
+	entry = debugfs_create_file("write_reg", S_IFREG | S_IWUSR,
+					dir_dev, dev, &write_reg);
 	if (!entry) {
-		pr_info("Unable to create_proc_read_entry!\n");
+		pr_info("Unable to create_sys_entry!\n");
 		return;
 	}
-	entry->write_proc = proc_set_write_reg;
 
-	entry = create_proc_read_entry("read_reg", S_IFREG | S_IRUGO,
-				   dir_dev, proc_get_read_reg, dev);
+	entry = debugfs_create_file("read_reg", S_IFREG | S_IWUSR | S_IRUGO,
+					dir_dev, dev, &read_reg);
 	if (!entry) {
-		pr_info("Unable to create_proc_read_entry!\n");
+		pr_info("Unable to create_sys_entry!\n");
 		return;
 	}
-	entry->write_proc = proc_set_read_reg;
 
-
-	entry = create_proc_read_entry("fwstate", S_IFREG | S_IRUGO,
-				   dir_dev, proc_get_fwstate, dev);
+	entry = debugfs_create_file("fwstate", S_IFREG | S_IRUGO,
+					dir_dev, dev, &fwstate);
 	if (!entry) {
-		pr_info("Unable to create_proc_read_entry!\n");
+		pr_info("Unable to create_sys_entry!\n");
 		return;
 	}
 
-	entry = create_proc_read_entry("sec_info", S_IFREG | S_IRUGO,
-				   dir_dev, proc_get_sec_info, dev);
+	entry = debugfs_create_file("sec_info", S_IFREG | S_IRUGO,
+					dir_dev, dev, &sec_info);
 	if (!entry) {
-		pr_info("Unable to create_proc_read_entry!\n");
+		pr_info("Unable to create_proc_entry!\n");
 		return;
 	}
 
-	entry = create_proc_read_entry("mlmext_state", S_IFREG | S_IRUGO,
-				   dir_dev, proc_get_mlmext_state, dev);
+	entry = debugfs_create_file("mlmext_state", S_IFREG | S_IRUGO,
+					dir_dev, dev, &mlmext_state);
 	if (!entry) {
-		pr_info("Unable to create_proc_read_entry!\n");
+		pr_info("Unable to create_sys_entry!\n");
 		return;
 	}
 
-	entry = create_proc_read_entry("qos_option", S_IFREG | S_IRUGO,
-				   dir_dev, proc_get_qos_option, dev);
+	entry = debugfs_create_file("qos_option", S_IFREG | S_IRUGO,
+					dir_dev, dev, &qos_option);
 	if (!entry) {
-		pr_info("Unable to create_proc_read_entry!\n");
+		pr_info("Unable to create_sys_entry!\n");
 		return;
 	}
 
-	entry = create_proc_read_entry("ht_option", S_IFREG | S_IRUGO,
-				   dir_dev, proc_get_ht_option, dev);
+	entry = debugfs_create_file("ht_option", S_IFREG | S_IRUGO,
+					dir_dev, dev, &ht_option);
 	if (!entry) {
-		pr_info("Unable to create_proc_read_entry!\n");
+		pr_info("Unable to create_sys_entry!\n");
 		return;
 	}
 
-	entry = create_proc_read_entry("rf_info", S_IFREG | S_IRUGO,
-				   dir_dev, proc_get_rf_info, dev);
+	entry = debugfs_create_file("rf_info", S_IFREG | S_IRUGO,
+					dir_dev, dev, &rf_info);
 	if (!entry) {
-		pr_info("Unable to create_proc_read_entry!\n");
+		pr_info("Unable to create_sys_entry!\n");
 		return;
 	}
 
-	entry = create_proc_read_entry("ap_info", S_IFREG | S_IRUGO,
-				   dir_dev, proc_get_ap_info, dev);
+	 entry = debugfs_create_file("ap_info", S_IFREG | S_IRUGO,
+					dir_dev, dev, &ap_info);
 	if (!entry) {
-		pr_info("Unable to create_proc_read_entry!\n");
+		pr_info("Unable to create_sys_entry!\n");
 		return;
 	}
 
-	entry = create_proc_read_entry("adapter_state", S_IFREG | S_IRUGO,
-				   dir_dev, proc_getstruct adapter_state, dev);
+	entry = debugfs_create_file("adapter_state", S_IFREG | S_IRUGO,
+					dir_dev, dev, &adapter_state);
 	if (!entry) {
-		pr_info("Unable to create_proc_read_entry!\n");
+		pr_info("Unable to create_sys_entry!\n");
 		return;
 	}
 
-	entry = create_proc_read_entry("trx_info", S_IFREG | S_IRUGO,
-				   dir_dev, proc_get_trx_info, dev);
+	entry = debugfs_create_file("trx_info", S_IFREG | S_IRUGO,
+					dir_dev, dev, &trx_info);
 	if (!entry) {
-		pr_info("Unable to create_proc_read_entry!\n");
+		pr_info("Unable to create_sys_entry!\n");
 		return;
 	}
 
-	entry = create_proc_read_entry("mac_reg_dump1", S_IFREG | S_IRUGO,
-				   dir_dev, proc_get_mac_reg_dump1, dev);
+	entry = debugfs_create_file("mac_reg_dump1", S_IFREG | S_IRUGO,
+					dir_dev, dev, &mac_reg_dump1);
 	if (!entry) {
-		pr_info("Unable to create_proc_read_entry!\n");
+		pr_info("Unable to create_sys_entry!\n");
 		return;
 	}
 
-	entry = create_proc_read_entry("mac_reg_dump2", S_IFREG | S_IRUGO,
-				   dir_dev, proc_get_mac_reg_dump2, dev);
+	entry = debugfs_create_file("mac_reg_dump2", S_IFREG | S_IRUGO,
+					dir_dev, dev, &mac_reg_dump2);
 	if (!entry) {
-		pr_info("Unable to create_proc_read_entry!\n");
+		pr_info("Unable to create_sys_entry!\n");
 		return;
 	}
 
-	entry = create_proc_read_entry("mac_reg_dump3", S_IFREG | S_IRUGO,
-				   dir_dev, proc_get_mac_reg_dump3, dev);
+	entry = debugfs_create_file("mac_reg_dump3", S_IFREG | S_IRUGO,
+					dir_dev, dev, &mac_reg_dump3);
 	if (!entry) {
-		pr_info("Unable to create_proc_read_entry!\n");
+		pr_info("Unable to create_sys_entry!\n");
 		return;
 	}
 
-	entry = create_proc_read_entry("bb_reg_dump1", S_IFREG | S_IRUGO,
-				   dir_dev, proc_get_bb_reg_dump1, dev);
+	entry = debugfs_create_file("bb_reg_dump1", S_IFREG | S_IRUGO,
+					dir_dev, dev, &bb_reg_dump1);
 	if (!entry) {
-		pr_info("Unable to create_proc_read_entry!\n");
+		pr_info("Unable to create_sys_entry!\n");
 		return;
 	}
 
-	entry = create_proc_read_entry("bb_reg_dump2", S_IFREG | S_IRUGO,
-				   dir_dev, proc_get_bb_reg_dump2, dev);
+	entry = debugfs_create_file("bb_reg_dump2", S_IFREG | S_IRUGO,
+					dir_dev, dev,  &bb_reg_dump2);
 	if (!entry) {
-		pr_info("Unable to create_proc_read_entry!\n");
+		pr_info("Unable to create_sys_entry!\n");
 		return;
 	}
 
-	entry = create_proc_read_entry("bb_reg_dump3", S_IFREG | S_IRUGO,
-				   dir_dev, proc_get_bb_reg_dump3, dev);
+	entry = debugfs_create_file("bb_reg_dump3", S_IFREG | S_IRUGO,
+					dir_dev, dev, &bb_reg_dump3);
 	if (!entry) {
-		pr_info("Unable to create_proc_read_entry!\n");
+		pr_info("Unable to create_sys_entry!\n");
 		return;
 	}
 
-	entry = create_proc_read_entry("rf_reg_dump1", S_IFREG | S_IRUGO,
-				   dir_dev, proc_get_rf_reg_dump1, dev);
+	entry = debugfs_create_file("rf_reg_dump1", S_IFREG | S_IRUGO,
+					dir_dev, dev, &rf_reg_dump1);
 	if (!entry) {
-		pr_info("Unable to create_proc_read_entry!\n");
+		pr_info("Unable to create_sys_entry!\n");
 		return;
 	}
 
-	entry = create_proc_read_entry("rf_reg_dump2", S_IFREG | S_IRUGO,
-				   dir_dev, proc_get_rf_reg_dump2, dev);
+	entry = debugfs_create_file("rf_reg_dump2", S_IFREG | S_IRUGO,
+					dir_dev, dev, &rf_reg_dump2);
 	if (!entry) {
-		pr_info("Unable to create_proc_read_entry!\n");
+		pr_info("Unable to create_sys_entry!\n");
 		return;
 	}
 
 	rtw_hal_get_hwreg(padapter, HW_VAR_RF_TYPE, (u8 *)(&rf_type));
 	if ((RF_1T2R == rf_type) || (RF_1T1R == rf_type)) {
-		entry = create_proc_read_entry("rf_reg_dump3", S_IFREG | S_IRUGO,
-					   dir_dev, proc_get_rf_reg_dump3, dev);
+		entry = debugfs_create_file("rf_reg_dump3", S_IFREG | S_IRUGO,
+						dir_dev, dev, &rf_reg_dump3);
 		if (!entry) {
-			pr_info("Unable to create_proc_read_entry!\n");
+			pr_info("Unable to create_sys_entry!\n");
 			return;
 		}
 
-		entry = create_proc_read_entry("rf_reg_dump4", S_IFREG | S_IRUGO,
-					   dir_dev, proc_get_rf_reg_dump4, dev);
+		entry = debugfs_create_file("rf_reg_dump4", S_IFREG | S_IRUGO,
+						dir_dev, dev, &rf_reg_dump4);
 		if (!entry) {
-			pr_info("Unable to create_proc_read_entry!\n");
+			pr_info("Unable to create_sys_entry!\n");
 			return;
 		}
 	}
 
 #ifdef CONFIG_88EU_AP_MODE
 
-	entry = create_proc_read_entry("all_sta_info", S_IFREG | S_IRUGO,
-				   dir_dev, proc_get_all_sta_info, dev);
+	entry = debugfs_create_file("all_sta_info", S_IFREG | S_IRUGO,
+					dir_dev, dev, &all_sta_info);
 	if (!entry) {
 		pr_info("Unable to create_proc_read_entry!\n");
 		return;
 	}
 #endif
 
-	entry = create_proc_read_entry("best_channel", S_IFREG | S_IRUGO,
-				   dir_dev, proc_get_best_channel, dev);
+	entry = debugfs_create_file("best_channel", S_IFREG | S_IRUGO,
+					dir_dev, dev, &best_channel);
 	if (!entry) {
-		pr_info("Unable to create_proc_read_entry!\n");
+		pr_info("Unable to create_sys_entry!\n");
 		return;
 	}
 
-	entry = create_proc_read_entry("rx_signal", S_IFREG | S_IRUGO,
-				   dir_dev, proc_get_rx_signal, dev);
-	if (!entry) {
-		pr_info("Unable to create_proc_read_entry!\n");
-		return;
-	}
-	entry->write_proc = proc_set_rx_signal;
-	entry = create_proc_read_entry("ht_enable", S_IFREG | S_IRUGO,
-				   dir_dev, proc_get_ht_enable, dev);
+	entry = debugfs_create_file("rx_signal", S_IFREG | S_IWUSR | S_IRUGO,
+					dir_dev, dev, &rx_signal);
 	if (!entry) {
-		pr_info("Unable to create_proc_read_entry!\n");
+		pr_info("Unable to create_sys_entry!\n");
 		return;
 	}
-	entry->write_proc = proc_set_ht_enable;
 
-	entry = create_proc_read_entry("cbw40_enable", S_IFREG | S_IRUGO,
-				   dir_dev, proc_get_cbw40_enable, dev);
+	entry = debugfs_create_file("ht_enable", S_IFREG | S_IWUSR | S_IRUGO,
+					dir_dev, dev, &ht_enable);
 	if (!entry) {
-		pr_info("Unable to create_proc_read_entry!\n");
+		pr_info("Unable to create_sys_entry!\n");
 		return;
 	}
-	entry->write_proc = proc_set_cbw40_enable;
 
-	entry = create_proc_read_entry("ampdu_enable", S_IFREG | S_IRUGO,
-				   dir_dev, proc_get_ampdu_enable, dev);
+	entry = debugfs_create_file("cbw40_enable", S_IFREG | S_IWUSR | S_IRUGO,
+					dir_dev, dev, &cbw40_enable);
 	if (!entry) {
-		pr_info("Unable to create_proc_read_entry!\n");
+		pr_info("Unable to create_sys_entry!\n");
 		return;
 	}
-	entry->write_proc = proc_set_ampdu_enable;
 
-	entry = create_proc_read_entry("rx_stbc", S_IFREG | S_IRUGO,
-				   dir_dev, proc_get_rx_stbc, dev);
+	entry = debugfs_create_file("ampdu_enable", S_IFREG | S_IWUSR | S_IRUGO,
+					dir_dev, dev, &ampdu_enable);
 	if (!entry) {
-		pr_info("Unable to create_proc_read_entry!\n");
+		pr_info("Unable to create_sys_entry!\n");
 		return;
 	}
-	entry->write_proc = proc_set_rx_stbc;
 
-	entry = create_proc_read_entry("path_rssi", S_IFREG | S_IRUGO,
-					dir_dev, proc_get_two_path_rssi, dev);
+	entry = debugfs_create_file("rx_stbc", S_IFREG | S_IWUSR | S_IRUGO,
+					dir_dev, dev, &rx_stbc);
 	if (!entry) {
-		pr_info("Unable to create_proc_read_entry!\n");
-		return;
+		pr_info("Unable to create_sys_entry!\n");
+		 return;
 	}
-	entry = create_proc_read_entry("rssi_disp", S_IFREG | S_IRUGO,
-				   dir_dev, proc_get_rssi_disp, dev);
+
+	entry = debugfs_create_file("path_rssi", S_IFREG | S_IRUGO,
+					dir_dev, dev, &two_path_rssi);
 	if (!entry) {
-		pr_info("Unable to create_proc_read_entry!\n");
+		pr_info("Unable to create_sys_entry!\n");
 		return;
 	}
-	entry->write_proc = proc_set_rssi_disp;
-}
-
-void rtw_proc_remove_one(struct net_device *dev)
-{
-	struct proc_dir_entry *dir_dev = NULL;
-	struct adapter	*padapter = rtw_netdev_priv(dev);
-	u8 rf_type;
-
-	dir_dev = padapter->dir_dev;
-	padapter->dir_dev = NULL;
-
-	if (dir_dev) {
-		remove_proc_entry("write_reg", dir_dev);
-		remove_proc_entry("read_reg", dir_dev);
-		remove_proc_entry("fwstate", dir_dev);
-		remove_proc_entry("sec_info", dir_dev);
-		remove_proc_entry("mlmext_state", dir_dev);
-		remove_proc_entry("qos_option", dir_dev);
-		remove_proc_entry("ht_option", dir_dev);
-		remove_proc_entry("rf_info", dir_dev);
-		remove_proc_entry("ap_info", dir_dev);
-		remove_proc_entry("adapter_state", dir_dev);
-		remove_proc_entry("trx_info", dir_dev);
-		remove_proc_entry("mac_reg_dump1", dir_dev);
-		remove_proc_entry("mac_reg_dump2", dir_dev);
-		remove_proc_entry("mac_reg_dump3", dir_dev);
-		remove_proc_entry("bb_reg_dump1", dir_dev);
-		remove_proc_entry("bb_reg_dump2", dir_dev);
-		remove_proc_entry("bb_reg_dump3", dir_dev);
-		remove_proc_entry("rf_reg_dump1", dir_dev);
-		remove_proc_entry("rf_reg_dump2", dir_dev);
-		rtw_hal_get_hwreg(padapter, HW_VAR_RF_TYPE, (u8 *)(&rf_type));
-		if ((RF_1T2R == rf_type) || (RF_1T1R == rf_type)) {
-			remove_proc_entry("rf_reg_dump3", dir_dev);
-			remove_proc_entry("rf_reg_dump4", dir_dev);
-		}
-#ifdef CONFIG_88EU_AP_MODE
-		remove_proc_entry("all_sta_info", dir_dev);
-#endif
 
-		remove_proc_entry("best_channel", dir_dev);
-		remove_proc_entry("rx_signal", dir_dev);
-		remove_proc_entry("cbw40_enable", dir_dev);
-		remove_proc_entry("ht_enable", dir_dev);
-		remove_proc_entry("ampdu_enable", dir_dev);
-		remove_proc_entry("rx_stbc", dir_dev);
-		remove_proc_entry("path_rssi", dir_dev);
-		remove_proc_entry("rssi_disp", dir_dev);
-		remove_proc_entry(dev->name, rtw_proc);
-		dir_dev = NULL;
-	} else {
+	 entry = debugfs_create_file("rssi_disp", S_IFREG | S_IWUSR,
+					dir_dev, dev, &rssi_disp);
+	if (!entry) {
+		pr_info("Unable to create_sys_entry!\n");
 		return;
 	}
-	rtw_proc_cnt--;
-
-	if (rtw_proc_cnt == 0) {
-		if (rtw_proc) {
-			remove_proc_entry("ver_info", rtw_proc);
-
-			remove_proc_entry(rtw_proc_name, init_net.proc_net);
-			rtw_proc = NULL;
-		}
-	}
 }
-#endif
 
 static uint loadparam(struct adapter *padapter,  struct  net_device *pnetdev)
 {
@@ -992,7 +1127,7 @@ int _netdev_open(struct net_device *pnetdev)
 		}
 		if (padapter->intf_start)
 			padapter->intf_start(padapter);
-		rtw_proc_init_one(pnetdev);
+		rtw_sys_init_one(pnetdev);
 
 		rtw_led_control(padapter, LED_CTL_NO_LINK);
 
-- 
1.7.10.4

