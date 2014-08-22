Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756015AbaHVKeg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 06:34:36 -0400
Received: from mail-lb0-f176.google.com ([209.85.217.176]:41307 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755819AbaHVKef (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 06:34:35 -0400
From: Miguel Oliveira <cmroliv@gmail.com>
To: gregkh@linuxfoundation.org
Cc: navin.patidar@gmail.com, Larry.Finger@lwfinger.net, davem@davemloft.net,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        cmroliv@gmail.com
Subject: [PATCH 2/4] staging: rtl8188eu: rtw_debug.c
Date: Fri, 22 Aug 2014 11:33:20 +0100
Message-Id: <1408703600-32210-1-git-send-email-cmroliv@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1408703558-32167-1-git-send-email-cmroliv@gmail.com>
References: <1408703558-32167-1-git-send-email-cmroliv@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert all rtw_proc_xxx references to rtw_sys_xxx

Code with 62 WARNING: line over 80 characters, I'll write another patch
to clean the whole file.

Signed-off-by: Miguel Oliveira <cmroliv@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_debug.c    |  640 +++++++++++++------------
 drivers/staging/rtl8188eu/include/drv_types.h |    2 +-
 2 files changed, 346 insertions(+), 296 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_debug.c b/drivers/staging/rtl8188eu/core/rtw_debug.c
index 1f72f7d..f25401e 100644
--- a/drivers/staging/rtl8188eu/core/rtw_debug.c
+++ b/drivers/staging/rtl8188eu/core/rtw_debug.c
@@ -22,30 +22,26 @@
 #include <rtw_debug.h>
 #include <usb_ops_linux.h>
 
-int proc_get_drv_version(char *page, char **start,
-			  off_t offset, int count,
-			  int *eof, void *data)
+ssize_t sys_get_drv_version(struct file *file, char __user *buffer,
+				 size_t count, loff_t *offset)
 {
 	int len = 0;
 
-	len += snprintf(page + len, count - len, "%s\n", DRIVERVERSION);
+	if (*offset != 0)
+		return 0;
+
+	len += snprintf(buffer + len, count - len, "%s\n", DRIVERVERSION);
+	*offset = len;
 
-	*eof = 1;
 	return len;
 }
 
-int proc_get_write_reg(char *page, char **start,
-			  off_t offset, int count,
-			  int *eof, void *data)
-{
-	*eof = 1;
-	return 0;
-}
 
-int proc_set_write_reg(struct file *file, const char __user *buffer,
-		unsigned long count, void *data)
+ssize_t sys_set_write_reg(struct file *file, const char __user *buffer,
+				size_t count, loff_t *offset)
 {
-	struct net_device *dev = (struct net_device *)data;
+	struct inode *inode = file_inode(file);
+	struct net_device *dev = (struct net_device *)inode->i_private;
 	struct adapter *padapter = (struct adapter *)rtw_netdev_priv(dev);
 	char tmp[32];
 	u32 addr, val, len;
@@ -80,44 +76,45 @@ int proc_set_write_reg(struct file *file, const char __user *buffer,
 	return count;
 }
 
-static u32 proc_get_read_addr = 0xeeeeeeee;
-static u32 proc_get_read_len = 0x4;
+static u32 sys_get_read_addr = 0xeeeeeeee;
+static u32 sys_get_read_len = 0x4;
 
-int proc_get_read_reg(char *page, char **start,
-			  off_t offset, int count,
-			  int *eof, void *data)
+ssize_t sys_get_read_reg(struct file *file, char __user *buffer,
+				size_t count, loff_t *offset)
 {
-	struct net_device *dev = data;
+	struct inode *inode = file_inode(file);
+	struct net_device *dev = (struct net_device *)inode->i_private;
 	struct adapter *padapter = (struct adapter *)rtw_netdev_priv(dev);
-
 	int len = 0;
 
-	if (proc_get_read_addr == 0xeeeeeeee) {
-		*eof = 1;
+	if (*offset != 0)
+		return 0;
+
+	if (sys_get_read_addr == 0xeeeeeeee)
 		return len;
 
-	switch (proc_get_read_len) {
+	switch (sys_get_read_len) {
 	case 1:
-		len += snprintf(page + len, count - len, "usb_read8(0x%x)=0x%x\n", proc_get_read_addr, usb_read8(padapter, proc_get_read_addr));
+		len += snprintf(buffer + len, count - len, "usb_read8(0x%x)=0x%x\n", sys_get_read_addr, usb_read8(padapter, sys_get_read_addr));
 		break;
 	case 2:
-		len += snprintf(page + len, count - len, "usb_read16(0x%x)=0x%x\n", proc_get_read_addr, usb_read16(padapter, proc_get_read_addr));
+		len += snprintf(buffer + len, count - len, "usb_read16(0x%x)=0x%x\n", sys_get_read_addr, usb_read16(padapter, sys_get_read_addr));
 		break;
 	case 4:
-		len += snprintf(page + len, count - len, "usb_read32(0x%x)=0x%x\n", proc_get_read_addr, usb_read32(padapter, proc_get_read_addr));
+		len += snprintf(buffer + len, count - len, "usb_read32(0x%x)=0x%x\n", sys_get_read_addr, usb_read32(padapter, sys_get_read_addr));
 		break;
 	default:
-		len += snprintf(page + len, count - len, "error read length=%d\n", proc_get_read_len);
+		len += snprintf(buffer + len, count - len, "error read length=%d\n", sys_get_read_len);
 		break;
 	}
 
-	*eof = 1;
+	*offset = len;
 	return len;
 }
 
-int proc_set_read_reg(struct file *file, const char __user *buffer,
-		unsigned long count, void *data)
+ssize_t sys_set_read_reg(struct file *file, const char __user *buffer,
+				size_t count, loff_t *offset)
 {
 	char tmp[16];
 	u32 addr, len;
@@ -135,116 +132,125 @@ int proc_set_read_reg(struct file *file, const char __user *buffer,
 			return count;
 		}
 
-		proc_get_read_addr = addr;
+		sys_get_read_addr = addr;
 
-		proc_get_read_len = len;
+		sys_get_read_len = len;
 	}
 
 	return count;
 }
 
-int proc_get_fwstate(char *page, char **start,
-			  off_t offset, int count,
-			  int *eof, void *data)
+ssize_t sys_get_fwstate(struct file *file, char __user *buffer,
+				size_t count, loff_t *offset)
 {
-	struct net_device *dev = data;
+	struct inode *inode = file_inode(file);
+	struct net_device *dev = (struct net_device *)inode->i_private;
 	struct adapter *padapter = (struct adapter *)rtw_netdev_priv(dev);
 	struct mlme_priv *pmlmepriv = &(padapter->mlmepriv);
-
 	int len = 0;
 
-	len += snprintf(page + len, count - len, "fwstate=0x%x\n", get_fwstate(pmlmepriv));
+	if (*offset != 0)
+		return 0;
+	len += snprintf(buffer + len, count - len, "fwstate=0x%x\n", get_fwstate(pmlmepriv));
 
-	*eof = 1;
+	*offset = len;
 	return len;
 }
 
-int proc_get_sec_info(char *page, char **start,
-			  off_t offset, int count,
-			  int *eof, void *data)
+ssize_t sys_get_sec_info(struct file *file, char __user *buffer,
+				size_t count, loff_t *offset)
 {
-	struct net_device *dev = data;
+	struct inode *inode = file_inode(file);
+	struct net_device *dev = (struct net_device *)inode->i_private;
 	struct adapter *padapter = (struct adapter *)rtw_netdev_priv(dev);
 	struct security_priv *psecuritypriv = &padapter->securitypriv;
-
 	int len = 0;
 
-	len += snprintf(page + len, count - len, "auth_alg=0x%x, enc_alg=0x%x, auth_type=0x%x, enc_type=0x%x\n",
+	if (*offset != 0)
+		return 0;
+	len += snprintf(buffer + len, count - len, "auth_alg=0x%x, enc_alg=0x%x, auth_type=0x%x, enc_type=0x%x\n",
 						psecuritypriv->dot11AuthAlgrthm, psecuritypriv->dot11PrivacyAlgrthm,
 						psecuritypriv->ndisauthtype, psecuritypriv->ndisencryptstatus);
 
-	*eof = 1;
+	*offset = len;
 	return len;
 }
 
-int proc_get_mlmext_state(char *page, char **start,
-			  off_t offset, int count,
-			  int *eof, void *data)
+ssize_t sys_get_mlmext_state(struct file *file, char __user *buffer,
+				size_t count, loff_t *offset)
 {
-	struct net_device *dev = data;
+	struct inode *inode = file_inode(file);
+	struct net_device *dev = (struct net_device *)inode->i_private;
 	struct adapter *padapter = (struct adapter *)rtw_netdev_priv(dev);
 	struct mlme_ext_priv	*pmlmeext = &padapter->mlmeextpriv;
 	struct mlme_ext_info	*pmlmeinfo = &(pmlmeext->mlmext_info);
-
 	int len = 0;
 
-	len += snprintf(page + len, count - len, "pmlmeinfo->state=0x%x\n", pmlmeinfo->state);
+	if (*offset != 0)
+		return 0;
+	len += snprintf(buffer + len, count - len, "pmlmeinfo->state=0x%x\n", pmlmeinfo->state);
 
-	*eof = 1;
+	*offset = len;
 	return len;
 }
 
-int proc_get_qos_option(char *page, char **start,
-			  off_t offset, int count,
-			  int *eof, void *data)
+ssize_t sys_get_qos_option(struct file *file, char __user *buffer,
+				size_t count, loff_t *offset)
 {
-	struct net_device *dev = data;
+	struct inode *inode = file_inode(file);
+	struct net_device *dev = (struct net_device *)inode->i_private;
 	struct adapter *padapter = (struct adapter *)rtw_netdev_priv(dev);
 	struct mlme_priv *pmlmepriv = &(padapter->mlmepriv);
-
 	int len = 0;
 
-	len += snprintf(page + len, count - len, "qos_option=%d\n", pmlmepriv->qospriv.qos_option);
+	if (*offset != 0)
+		return 0;
+	len += snprintf(buffer + len, count - len, "qos_option=%d\n", pmlmepriv->qospriv.qos_option);

-	*eof = 1;
+	*offset = len;
 	return len;
 }
 
-int proc_get_ht_option(char *page, char **start,
-			  off_t offset, int count,
-			  int *eof, void *data)
+ssize_t sys_get_ht_option(struct file *file, char __user *buffer,
+				size_t count, loff_t *offset)
 {
-	struct net_device *dev = data;
+	struct inode *inode = file_inode(file);
+	struct net_device *dev = (struct net_device *)inode->i_private;
 	struct adapter *padapter = (struct adapter *)rtw_netdev_priv(dev);
 	struct mlme_priv *pmlmepriv = &(padapter->mlmepriv);
-
 	int len = 0;
-	len += snprintf(page + len, count - len, "ht_option=%d\n", pmlmepriv->htpriv.ht_option);
-	*eof = 1;
+
+	if (*offset != 0)
+		return 0;
+	len += snprintf(buffer + len, count - len, "ht_option=%d\n", pmlmepriv->htpriv.ht_option);
+
+	*offset = len;
 	return len;
 }
 
-int proc_get_rf_info(char *page, char **start,
-			  off_t offset, int count,
-			  int *eof, void *data)
+ssize_t sys_get_rf_info(struct file *file, char __user *buffer,
+			size_t count, loff_t *offset)
 {
-	struct net_device *dev = data;
+	struct inode *inode = file_inode(file);
+	struct net_device *dev = (struct net_device *)inode->i_private;
 	struct adapter *padapter = (struct adapter *)rtw_netdev_priv(dev);
 	struct mlme_ext_priv	*pmlmeext = &padapter->mlmeextpriv;
 	int len = 0;
 
-	len += snprintf(page + len, count - len, "cur_ch=%d, cur_bw=%d, cur_ch_offset=%d\n",
+	if (*offset != 0)
+		return 0;
+	len += snprintf(buffer + len, count - len, "cur_ch=%d, cur_bw=%d, cur_ch_offset=%d\n",
 					pmlmeext->cur_channel, pmlmeext->cur_bwmode, pmlmeext->cur_ch_offset);
-	*eof = 1;
+	*offset = len;
 	return len;
 }
 
-int proc_get_ap_info(char *page, char **start,
-			  off_t offset, int count,
-			  int *eof, void *data)
+ssize_t sys_get_ap_info(struct file *file, char __user *buffer,
+				size_t count, loff_t *offset)
 {
 	struct sta_info *psta;
-	struct net_device *dev = data;
+	struct inode *inode = file_inode(file);
+	struct net_device *dev = (struct net_device *)inode->i_private;
 	struct adapter *padapter = (struct adapter *)rtw_netdev_priv(dev);
 	struct mlme_priv *pmlmepriv = &(padapter->mlmepriv);
 	struct mlme_ext_priv *pmlmeext = &padapter->mlmeextpriv;
@@ -252,312 +258,347 @@ int proc_get_ap_info(char *page, char **start,
 	struct sta_priv *pstapriv = &padapter->stapriv;
 	int len = 0;
 
+	if (*offset != 0)
+		return 0;
 	psta = rtw_get_stainfo(pstapriv, cur_network->network.MacAddress);
 	if (psta) {
 		int i;
 		struct recv_reorder_ctrl *preorder_ctrl;
 
-		len += snprintf(page + len, count - len, "SSID=%s\n", cur_network->network.Ssid.Ssid);
-		len += snprintf(page + len, count - len, "sta's macaddr:%pM\n", psta->hwaddr);
-		len += snprintf(page + len, count - len, "cur_channel=%d, cur_bwmode=%d, cur_ch_offset=%d\n", pmlmeext->cur_channel, pmlmeext->cur_bwmode, pmlmeext->cur_ch_offset);
-		len += snprintf(page + len, count - len, "rtsen=%d, cts2slef=%d\n", psta->rtsen, psta->cts2self);
-		len += snprintf(page + len, count - len, "state=0x%x, aid=%d, macid=%d, raid=%d\n", psta->state, psta->aid, psta->mac_id, psta->raid);
-		len += snprintf(page + len, count - len, "qos_en=%d, ht_en=%d, init_rate=%d\n", psta->qos_option, psta->htpriv.ht_option, psta->init_rate);
-		len += snprintf(page + len, count - len, "bwmode=%d, ch_offset=%d, sgi=%d\n", psta->htpriv.bwmode, psta->htpriv.ch_offset, psta->htpriv.sgi);
-		len += snprintf(page + len, count - len, "ampdu_enable = %d\n", psta->htpriv.ampdu_enable);
-		len += snprintf(page + len, count - len, "agg_enable_bitmap=%x, candidate_tid_bitmap=%x\n", psta->htpriv.agg_enable_bitmap, psta->htpriv.candidate_tid_bitmap);
+		len += snprintf(buffer + len, count - len, "SSID=%s\n", cur_network->network.Ssid.Ssid);
+		len += snprintf(buffer + len, count - len, "sta's macaddr:%pM\n", psta->hwaddr);
+		len += snprintf(buffer + len, count - len, "cur_channel=%d, cur_bwmode=%d, cur_ch_offset=%d\n", pmlmeext->cur_channel, pmlmeext->cur_bwmode, pmlmeext->cur_ch_offset);
+		len += snprintf(buffer + len, count - len, "rtsen=%d, cts2slef=%d\n", psta->rtsen, psta->cts2self);
+		len += snprintf(buffer + len, count - len, "state=0x%x, aid=%d, macid=%d, raid=%d\n", psta->state, psta->aid, psta->mac_id, psta->raid);
+		len += snprintf(buffer + len, count - len, "qos_en=%d, ht_en=%d, init_rate=%d\n", psta->qos_option, psta->htpriv.ht_option, psta->init_rate);
+		len += snprintf(buffer + len, count - len, "bwmode=%d, ch_offset=%d, sgi=%d\n", psta->htpriv.bwmode, psta->htpriv.ch_offset, psta->htpriv.sgi);
+		len += snprintf(buffer + len, count - len, "ampdu_enable = %d\n", psta->htpriv.ampdu_enable);
+		len += snprintf(buffer + len, count - len, "agg_enable_bitmap=%x, candidate_tid_bitmap=%x\n", psta->htpriv.agg_enable_bitmap, psta->htpriv.candidate_tid_bitmap);
 
 		for (i = 0; i < 16; i++) {
 			preorder_ctrl = &psta->recvreorder_ctrl[i];
 			if (preorder_ctrl->enable)
-				len += snprintf(page + len, count - len, "tid=%d, indicate_seq=%d\n", i, preorder_ctrl->indicate_seq);
+				len += snprintf(buffer + len, count - len, "tid=%d, indicate_seq=%d\n", i, preorder_ctrl->indicate_seq);
 		}
 	} else {
-		len += snprintf(page + len, count - len, "can't get sta's macaddr, cur_network's macaddr: %pM\n", cur_network->network.MacAddress);
+		len += snprintf(buffer + len, count - len, "can't get sta's macaddr, cur_network's macaddr: %pM\n", cur_network->network.MacAddress);
 	}
 
-	*eof = 1;
+	*offset = len;
 	return len;
 }
 
-int proc_get_adapter_state(char *page, char **start,
-			  off_t offset, int count,
-			  int *eof, void *data)
+ssize_t sys_get_adapter_state(struct file *file, char __user *buffer,
+				size_t count, loff_t *offset)
 {
-	struct net_device *dev = data;
+	struct inode *inode = file_inode(file);
+	struct net_device *dev = (struct net_device *)inode->i_private;
 	struct adapter *padapter = (struct adapter *)rtw_netdev_priv(dev);
 	int len = 0;
 
-	len += snprintf(page + len, count - len, "bSurpriseRemoved=%d, bDriverStopped=%d\n",
+	if (*offset != 0)
+		return 0;
+	len += snprintf(buffer + len, count - len, "bSurpriseRemoved=%d, bDriverStopped=%d\n",
 						padapter->bSurpriseRemoved, padapter->bDriverStopped);
 
-	*eof = 1;
+	*offset = len;
 	return len;
 }
 
-int proc_get_trx_info(char *page, char **start,
-			  off_t offset, int count,
-			  int *eof, void *data)
+ssize_t sys_get_trx_info(struct file *file, char __user *buffer,
+			size_t count, loff_t *offset)
 {
-	struct net_device *dev = data;
+	struct inode *inode = file_inode(file);
+	struct net_device *dev = (struct net_device *)inode->i_private;
 	struct adapter *padapter = (struct adapter *)rtw_netdev_priv(dev);
 	struct xmit_priv *pxmitpriv = &padapter->xmitpriv;
 	struct recv_priv  *precvpriv = &padapter->recvpriv;
 	int len = 0;
 
-	len += snprintf(page + len, count - len, "free_xmitbuf_cnt=%d, free_xmitframe_cnt=%d, free_ext_xmitbuf_cnt=%d, free_recvframe_cnt=%d\n",
+	if (*offset != 0)
+		return 0;
+	len += snprintf(buffer + len, count - len, "free_xmitbuf_cnt=%d, free_xmitframe_cnt=%d, free_ext_xmitbuf_cnt=%d, free_recvframe_cnt=%d\n",
 				pxmitpriv->free_xmitbuf_cnt, pxmitpriv->free_xmitframe_cnt, pxmitpriv->free_xmit_extbuf_cnt, precvpriv->free_recvframe_cnt);
-	len += snprintf(page + len, count - len, "rx_urb_pending_cn=%d\n", precvpriv->rx_pending_cnt);
+	len += snprintf(buffer + len, count - len, "rx_urb_pending_cn=%d\n", precvpriv->rx_pending_cnt);
 
-	*eof = 1;
+	*offset = len;
 	return len;
 }
 
-int proc_get_mac_reg_dump1(char *page, char **start,
-			  off_t offset, int count,
-			  int *eof, void *data)
+ssize_t sys_get_mac_reg_dump1(struct file *file, char __user *buffer,
+				size_t count, loff_t *offset)
 {
-	struct net_device *dev = data;
+	struct inode *inode = file_inode(file);
+	struct net_device *dev = (struct net_device *)inode->i_private;
 	struct adapter *padapter = (struct adapter *)rtw_netdev_priv(dev);
 	int len = 0;
 	int i, j = 1;
 
-	len += snprintf(page + len, count - len, "\n======= MAC REG =======\n");
+	if (*offset != 0)
+		return 0;
+	len += snprintf(buffer + len, count - len, "\n======= MAC REG =======\n");
 
 	for (i = 0x0; i < 0x300; i += 4) {
 		if (j%4 == 1)
-			len += snprintf(page + len, count - len, "0x%02x", i);
-		len += snprintf(page + len, count - len, " 0x%08x ", usb_read32(padapter, i));
+			len += snprintf(buffer + len, count - len, "0x%02x", i);
+		len += snprintf(buffer + len, count - len, " 0x%08x ", usb_read32(padapter, i));
 		if ((j++)%4 == 0)
-			len += snprintf(page + len, count - len, "\n");
+			len += snprintf(buffer + len, count - len, "\n");
 	}
 
-	*eof = 1;
+	*offset = len;
 	return len;
 }
 
-int proc_get_mac_reg_dump2(char *page, char **start,
-			  off_t offset, int count,
-			  int *eof, void *data)
+ssize_t sys_get_mac_reg_dump2(struct file *file, char __user *buffer,
+				size_t count, loff_t *offset)
 {
-	struct net_device *dev = data;
+	struct inode *inode = file_inode(file);
+	struct net_device *dev = (struct net_device *)inode->i_private;
 	struct adapter *padapter = (struct adapter *)rtw_netdev_priv(dev);
 	int len = 0;
 	int i, j = 1;
 
-	len += snprintf(page + len, count - len, "\n======= MAC REG =======\n");
-	memset(page, 0, count);
+	if (*offset != 0)
+		return 0;
+	len += snprintf(buffer + len, count - len, "\n======= MAC REG =======\n");
+	memset(buffer, 0, count);
 	for (i = 0x300; i < 0x600; i += 4) {
 		if (j%4 == 1)
-			len += snprintf(page + len, count - len, "0x%02x", i);
-		len += snprintf(page + len, count - len, " 0x%08x ", usb_read32(padapter, i));
+			len += snprintf(buffer + len, count - len, "0x%02x", i);
+		len += snprintf(buffer + len, count - len, " 0x%08x ", usb_read32(padapter, i));
 		if ((j++)%4 == 0)
-			len += snprintf(page + len, count - len, "\n");
+			len += snprintf(buffer + len, count - len, "\n");
 	}
 
-	*eof = 1;
+	*offset = len;
 	return len;
 }
 
-int proc_get_mac_reg_dump3(char *page, char **start,
-			  off_t offset, int count,
-			  int *eof, void *data)
+ssize_t sys_get_mac_reg_dump3(struct file *file, char __user *buffer,
+				size_t count, loff_t *offset)
 {
-	struct net_device *dev = data;
+	struct inode *inode = file_inode(file);
+	struct net_device *dev = (struct net_device *)inode->i_private;
 	struct adapter *padapter = (struct adapter *)rtw_netdev_priv(dev);
 	int len = 0;
 	int i, j = 1;
 
-	len += snprintf(page + len, count - len, "\n======= MAC REG =======\n");
+	if (*offset != 0)
+		return 0;
+	len += snprintf(buffer + len, count - len, "\n======= MAC REG =======\n");
 
 	for (i = 0x600; i < 0x800; i += 4) {
 		if (j%4 == 1)
-			len += snprintf(page + len, count - len, "0x%02x", i);
-		len += snprintf(page + len, count - len, " 0x%08x ", usb_read32(padapter, i));
+			len += snprintf(buffer + len, count - len, "0x%02x", i);
+		len += snprintf(buffer + len, count - len, " 0x%08x ", usb_read32(padapter, i));
 		if ((j++)%4 == 0)
-			len += snprintf(page + len, count - len, "\n");
+			len += snprintf(buffer + len, count - len, "\n");
 	}
 
-	*eof = 1;
+	*offset = len;
 	return len;
 }
 
-int proc_get_bb_reg_dump1(char *page, char **start,
-			  off_t offset, int count,
-			  int *eof, void *data)
+ssize_t sys_get_bb_reg_dump1(struct file *file, char __user *buffer,
+				size_t count, loff_t *offset)
 {
-	struct net_device *dev = data;
+	struct inode *inode = file_inode(file);
+	struct net_device *dev = (struct net_device *)inode->i_private;
 	struct adapter *padapter = (struct adapter *)rtw_netdev_priv(dev);
 	int len = 0;
 	int i, j = 1;
 
-	len += snprintf(page + len, count - len, "\n======= BB REG =======\n");
+	if (*offset != 0)
+		return 0;
+	len += snprintf(buffer + len, count - len, "\n======= BB REG =======\n");
 	for (i = 0x800; i < 0xB00; i += 4) {
 		if (j%4 == 1)
-			len += snprintf(page + len, count - len, "0x%02x", i);
-		len += snprintf(page + len, count - len, " 0x%08x ", usb_read32(padapter, i));
+			len += snprintf(buffer + len, count - len, "0x%02x", i);
+		len += snprintf(buffer + len, count - len, " 0x%08x ", usb_read32(padapter, i));
 		if ((j++)%4 == 0)
-			len += snprintf(page + len, count - len, "\n");
+			len += snprintf(buffer + len, count - len, "\n");
 	}
-	*eof = 1;
+
+	*offset = len;
 	return len;
 }
 
-int proc_get_bb_reg_dump2(char *page, char **start,
-			  off_t offset, int count,
-			  int *eof, void *data)
+ssize_t sys_get_bb_reg_dump2(struct file *file, char __user *buffer,
+				size_t count, loff_t *offset)
 {
-	struct net_device *dev = data;
+	struct inode *inode = file_inode(file);
+	struct net_device *dev = (struct net_device *)inode->i_private;
 	struct adapter *padapter = (struct adapter *)rtw_netdev_priv(dev);
 	int len = 0;
 	int i, j = 1;
 
-	len += snprintf(page + len, count - len, "\n======= BB REG =======\n");
+	if (*offset != 0)
+		return 0;
+	len += snprintf(buffer + len, count - len, "\n======= BB REG =======\n");
 	for (i = 0xB00; i < 0xE00; i += 4) {
 		if (j%4 == 1)
-			len += snprintf(page + len, count - len, "0x%02x", i);
-		len += snprintf(page + len, count - len, " 0x%08x ", usb_read32(padapter, i));
+			len += snprintf(buffer + len, count - len, "0x%02x", i);
+		len += snprintf(buffer + len, count - len, " 0x%08x ", usb_read32(padapter, i));
 		if ((j++)%4 == 0)
-			len += snprintf(page + len, count - len, "\n");
+			len += snprintf(buffer + len, count - len, "\n");
 	}
-	*eof = 1;
+
+	*offset = len;
 	return len;
 }
 
-int proc_get_bb_reg_dump3(char *page, char **start,
-			  off_t offset, int count,
-			  int *eof, void *data)
+ssize_t sys_get_bb_reg_dump3(struct file *file, char __user *buffer,
+				size_t count, loff_t *offset)
 {
-	struct net_device *dev = data;
+	struct inode *inode = file_inode(file);
+	struct net_device *dev = (struct net_device *)inode->i_private;
 	struct adapter *padapter = (struct adapter *)rtw_netdev_priv(dev);
 	int len = 0;
 	int i, j = 1;
 
-	len += snprintf(page + len, count - len, "\n======= BB REG =======\n");
+	if (*offset != 0)
+		return 0;
+	len += snprintf(buffer + len, count - len, "\n======= BB REG =======\n");
 	for (i = 0xE00; i < 0x1000; i += 4) {
 		if (j%4 == 1)
-			len += snprintf(page + len, count - len, "0x%02x", i);
-		len += snprintf(page + len, count - len, " 0x%08x ", usb_read32(padapter, i));
+			len += snprintf(buffer + len, count - len, "0x%02x", i);
+		len += snprintf(buffer + len, count - len, " 0x%08x ", usb_read32(padapter, i));
 		if ((j++)%4 == 0)
-			len += snprintf(page + len, count - len, "\n");
+			len += snprintf(buffer + len, count - len, "\n");
 	}
-	*eof = 1;
+
+	*offset = len;
 	return len;
 }
 
-int proc_get_rf_reg_dump1(char *page, char **start,
-			  off_t offset, int count,
-			  int *eof, void *data)
+ssize_t sys_get_rf_reg_dump1(struct file *file, char __user *buffer,
+				size_t count, loff_t *offset)
 {
-	struct net_device *dev = data;
+	struct inode *inode = file_inode(file);
+	struct net_device *dev = (struct net_device *)inode->i_private;
 	struct adapter *padapter = (struct adapter *)rtw_netdev_priv(dev);
 	int len = 0;
 	int i, j = 1, path;
 	u32 value;
 
-	len += snprintf(page + len, count - len, "\n======= RF REG =======\n");
+	if (*offset != 0)
+		return 0;
+	len += snprintf(buffer + len, count - len, "\n======= RF REG =======\n");
 	path = 1;
-	len += snprintf(page + len, count - len, "\nRF_Path(%x)\n", path);
+	len += snprintf(buffer + len, count - len, "\nRF_Path(%x)\n", path);
 	for (i = 0; i < 0xC0; i++) {
 		value = rtw_hal_read_rfreg(padapter, path, i, 0xffffffff);
 		if (j%4 == 1)
-			len += snprintf(page + len, count - len, "0x%02x ", i);
-		len += snprintf(page + len, count - len, " 0x%08x ", value);
+			len += snprintf(buffer + len, count - len, "0x%02x ", i);
+		len += snprintf(buffer + len, count - len, " 0x%08x ", value);
 		if ((j++)%4 == 0)
-			len += snprintf(page + len, count - len, "\n");
+			len += snprintf(buffer + len, count - len, "\n");
 	}
-	*eof = 1;
+
+	*offset = len;
 	return len;
 }
 
-int proc_get_rf_reg_dump2(char *page, char **start,
-			  off_t offset, int count,
-			  int *eof, void *data)
+ssize_t sys_get_rf_reg_dump2(struct file *file, char __user *buffer,
+				size_t count, loff_t *offset)
 {
-	struct net_device *dev = data;
+	struct inode *inode = file_inode(file);
+	struct net_device *dev = (struct net_device *)inode->i_private;
 	struct adapter *padapter = (struct adapter *)rtw_netdev_priv(dev);
 	int len = 0;
 	int i, j = 1, path;
 	u32 value;
 
-	len += snprintf(page + len, count - len, "\n======= RF REG =======\n");
+	if (*offset != 0)
+		return 0;
+	len += snprintf(buffer + len, count - len, "\n======= RF REG =======\n");
 	path = 1;
-	len += snprintf(page + len, count - len, "\nRF_Path(%x)\n", path);
+	len += snprintf(buffer + len, count - len, "\nRF_Path(%x)\n", path);
 	for (i = 0xC0; i < 0x100; i++) {
 		value = rtw_hal_read_rfreg(padapter, path, i, 0xffffffff);
 		if (j%4 == 1)
-			len += snprintf(page + len, count - len, "0x%02x ", i);
-		len += snprintf(page + len, count - len, " 0x%08x ", value);
+			len += snprintf(buffer + len, count - len, "0x%02x ", i);
+		len += snprintf(buffer + len, count - len, " 0x%08x ", value);
 		if ((j++)%4 == 0)
-			len += snprintf(page + len, count - len, "\n");
+			len += snprintf(buffer + len, count - len, "\n");
 	}
-	*eof = 1;
+
+	*offset = len;
 	return len;
 }
 
-int proc_get_rf_reg_dump3(char *page, char **start,
-			  off_t offset, int count,
-			  int *eof, void *data)
+ssize_t sys_get_rf_reg_dump3(struct file *file, char __user *buffer,
+				size_t count, loff_t *offset)
 {
-	struct net_device *dev = data;
+	struct inode *inode = file_inode(file);
+	struct net_device *dev = (struct net_device *)inode->i_private;
 	struct adapter *padapter = (struct adapter *)rtw_netdev_priv(dev);
 	int len = 0;
 	int i, j = 1, path;
 	u32 value;
 
-	len += snprintf(page + len, count - len, "\n======= RF REG =======\n");
+	if (*offset != 0)
+		return 0;
+	len += snprintf(buffer + len, count - len, "\n======= RF REG =======\n");
 	path = 2;
-	len += snprintf(page + len, count - len, "\nRF_Path(%x)\n", path);
+	len += snprintf(buffer + len, count - len, "\nRF_Path(%x)\n", path);
 	for (i = 0; i < 0xC0; i++) {
 		value = rtw_hal_read_rfreg(padapter, path, i, 0xffffffff);
 		if (j%4 == 1)
-			len += snprintf(page + len, count - len, "0x%02x ", i);
-		len += snprintf(page + len, count - len, " 0x%08x ", value);
+			len += snprintf(buffer + len, count - len, "0x%02x ", i);
+		len += snprintf(buffer + len, count - len, " 0x%08x ", value);
 		if ((j++)%4 == 0)
-			len += snprintf(page + len, count - len, "\n");
+			len += snprintf(buffer + len, count - len, "\n");
 	}
 
-	*eof = 1;
+	*offset = len;
 	return len;
 }
 
 
-int proc_get_rf_reg_dump4(char *page, char **start,
-			  off_t offset, int count,
-			  int *eof, void *data)
+ssize_t sys_get_rf_reg_dump4(struct file *file, char __user *buffer,
+				size_t count, loff_t *offset)
 {
-	struct net_device *dev = data;
+	struct inode *inode = file_inode(file);
+	struct net_device *dev = (struct net_device *)inode->i_private;
 	struct adapter *padapter = (struct adapter *)rtw_netdev_priv(dev);
 	int len = 0;
 	int i, j = 1, path;
 	u32 value;
 
-	len += snprintf(page + len, count - len, "\n======= RF REG =======\n");
+	if (*offset != 0)
+		return 0;
+	len += snprintf(buffer + len, count - len, "\n======= RF REG =======\n");
 	path = 2;
-	len += snprintf(page + len, count - len, "\nRF_Path(%x)\n", path);
+	len += snprintf(buffer + len, count - len, "\nRF_Path(%x)\n", path);
 	for (i = 0xC0; i < 0x100; i++) {
 		value = rtw_hal_read_rfreg(padapter, path, i, 0xffffffff);
 		if (j%4 == 1)
-			len += snprintf(page + len, count - len, "0x%02x ", i);
-		len += snprintf(page + len, count - len, " 0x%08x ", value);
+			len += snprintf(buffer + len, count - len, "0x%02x ", i);
+		len += snprintf(buffer + len, count - len, " 0x%08x ", value);
 		if ((j++)%4 == 0)
-			len += snprintf(page + len, count - len, "\n");
+			len += snprintf(buffer + len, count - len, "\n");
 	}
-	*eof = 1;
+
+	*offset = len;
 	return len;
 }
 
 
 
-int proc_get_rx_signal(char *page, char **start,
-			  off_t offset, int count,
-			  int *eof, void *data)
+ssize_t sys_get_rx_signal(struct file *file, char __user *buffer,
+				size_t count, loff_t *offset)
 {
-	struct net_device *dev = data;
+
+	struct inode *inode = file_inode(file);
+	struct net_device *dev = (struct net_device *)inode->i_private;
 	struct adapter *padapter = (struct adapter *)rtw_netdev_priv(dev);
 	int len = 0;
 
-	len = snprintf(page + len, count,
+	if (*offset != 0)
+		return 0;
+	len = snprintf(buffer + len, count,
 		"rssi:%d\n"
 		"rxpwdb:%d\n"
 		"signal_strength:%u\n"
@@ -570,14 +611,15 @@ int proc_get_rx_signal(char *page, char **start,
 		padapter->recvpriv.noise
 		);
 
-	*eof = 1;
+	*offset = len;
 	return len;
 }
 
-int proc_set_rx_signal(struct file *file, const char __user *buffer,
-		unsigned long count, void *data)
+ssize_t sys_set_rx_signal(struct file *file, const char __user *buffer,
+				size_t count, loff_t *offset)
 {
-	struct net_device *dev = (struct net_device *)data;
+	struct inode *inode = file_inode(file);
+	struct net_device *dev = (struct net_device *)inode->i_private;
 	struct adapter *padapter = (struct adapter *)rtw_netdev_priv(dev);
 	char tmp[32];
 	u32 is_signal_dbg;
@@ -606,28 +648,31 @@ int proc_set_rx_signal(struct file *file, const char __user *buffer,
 	return count;
 }
 
-int proc_get_ht_enable(char *page, char **start,
-			  off_t offset, int count,
-			  int *eof, void *data)
+ssize_t sys_get_ht_enable(struct file *file, char __user *buffer,
+				size_t count, loff_t *offset)
 {
-	struct net_device *dev = data;
+	struct inode *inode = file_inode(file);
+	struct net_device *dev = (struct net_device *)inode->i_private;
 	struct adapter *padapter = (struct adapter *)rtw_netdev_priv(dev);
 	struct registry_priv	*pregpriv = &padapter->registrypriv;
 	int len = 0;
 
+	if (*offset != 0)
+		return 0;
 	if (pregpriv)
-		len += snprintf(page + len, count - len,
+		len += snprintf(buffer + len, count - len,
 			"%d\n",
 			pregpriv->ht_enable
 			);
-	*eof = 1;
+	*offset = len;
 	return len;
 }
 
-int proc_set_ht_enable(struct file *file, const char __user *buffer,
-		unsigned long count, void *data)
+ssize_t sys_set_ht_enable(struct file *file, const char __user *buffer,
+				size_t count, loff_t *offset)
 {
-	struct net_device *dev = (struct net_device *)data;
+	struct inode *inode = file_inode(file);
+	struct net_device *dev = (struct net_device *)inode->i_private;
 	struct adapter *padapter = (struct adapter *)rtw_netdev_priv(dev);
 	struct registry_priv	*pregpriv = &padapter->registrypriv;
 	char tmp[32];
@@ -646,30 +691,32 @@ int proc_set_ht_enable(struct file *file, const char __user *buffer,
 	return count;
 }
 
-int proc_get_cbw40_enable(char *page, char **start,
-			  off_t offset, int count,
-			  int *eof, void *data)
+ssize_t sys_get_cbw40_enable(struct file *file, char __user *buffer,
+				size_t count, loff_t *offset)
 {
-	struct net_device *dev = data;
+	struct inode *inode = file_inode(file);
+	struct net_device *dev = (struct net_device *)inode->i_private;
 	struct adapter *padapter = (struct adapter *)rtw_netdev_priv(dev);
 	struct registry_priv	*pregpriv = &padapter->registrypriv;
-
 	int len = 0;
 
+	if (*offset != 0)
+		return 0;
 	if (pregpriv)
-		len += snprintf(page + len, count - len,
+		len += snprintf(buffer + len, count - len,
 			"%d\n",
 			pregpriv->cbw40_enable
 			);
 
-	*eof = 1;
+	*offset = len;
 	return len;
 }
 
-int proc_set_cbw40_enable(struct file *file, const char __user *buffer,
-		unsigned long count, void *data)
+ssize_t sys_set_cbw40_enable(struct file *file, const char __user *buffer,
+				size_t count, loff_t *offset)
 {
-	struct net_device *dev = (struct net_device *)data;
+	struct inode *inode = file_inode(file);
+	struct net_device *dev = (struct net_device *)inode->i_private;
 	struct adapter *padapter = (struct adapter *)rtw_netdev_priv(dev);
 	struct registry_priv	*pregpriv = &padapter->registrypriv;
 	char tmp[32];
@@ -687,30 +734,32 @@ int proc_set_cbw40_enable(struct file *file, const char __user *buffer,
 	return count;
 }
 
-int proc_get_ampdu_enable(char *page, char **start,
-			  off_t offset, int count,
-			  int *eof, void *data)
+ssize_t sys_get_ampdu_enable(struct file *file, char __user *buffer,
+				size_t count, loff_t *offset)
 {
-	struct net_device *dev = data;
+	struct inode *inode = file_inode(file);
+	struct net_device *dev = (struct net_device *)inode->i_private;
 	struct adapter *padapter = (struct adapter *)rtw_netdev_priv(dev);
 	struct registry_priv	*pregpriv = &padapter->registrypriv;
-
 	int len = 0;
 
+	if (*offset != 0)
+		return 0;
 	if (pregpriv)
-		len += snprintf(page + len, count - len,
+		len += snprintf(buffer + len, count - len,
 			"%d\n",
 			pregpriv->ampdu_enable
 			);
 
-	*eof = 1;
+	*offset = len;
 	return len;
 }
 
-int proc_set_ampdu_enable(struct file *file, const char __user *buffer,
-		unsigned long count, void *data)
+ssize_t sys_set_ampdu_enable(struct file *file, const char __user *buffer,
+				size_t count, loff_t *offset)
 {
-	struct net_device *dev = (struct net_device *)data;
+	struct inode *inode = file_inode(file);
+	struct net_device *dev = (struct net_device *)inode->i_private;
 	struct adapter *padapter = (struct adapter *)rtw_netdev_priv(dev);
 	struct registry_priv	*pregpriv = &padapter->registrypriv;
 	char tmp[32];
@@ -728,50 +777,53 @@ int proc_set_ampdu_enable(struct file *file, const char __user *buffer,
 	return count;
 }
 
-int proc_get_two_path_rssi(char *page, char **start,
-			  off_t offset, int count,
-			  int *eof, void *data)
+ssize_t sys_get_two_path_rssi(struct file *file, char __user *buffer,
+				size_t count, loff_t *offset)
 {
-	struct net_device *dev = data;
+	struct inode *inode = file_inode(file);
+	struct net_device *dev = (struct net_device *)inode->i_private;
 	struct adapter *padapter = (struct adapter *)rtw_netdev_priv(dev);
-
 	int len = 0;
 
+	if (*offset != 0)
+		return 0;
 	if (padapter)
-		len += snprintf(page + len, count - len,
+		len += snprintf(buffer + len, count - len,
 			"%d %d\n",
 			padapter->recvpriv.RxRssi[0],
 			padapter->recvpriv.RxRssi[1]
 			);
 
-	*eof = 1;
+	*offset = len;
 	return len;
 }
 
-int proc_get_rx_stbc(char *page, char **start,
-			  off_t offset, int count,
-			  int *eof, void *data)
+ssize_t sys_get_rx_stbc(struct file *file, char __user *buffer,
+			size_t count, loff_t *offset)
 {
-	struct net_device *dev = data;
+	struct inode *inode = file_inode(file);
+	struct net_device *dev = (struct net_device *)inode->i_private;
 	struct adapter *padapter = (struct adapter *)rtw_netdev_priv(dev);
 	struct registry_priv	*pregpriv = &padapter->registrypriv;
-
 	int len = 0;
 
+	if (*offset != 0)
+		return 0;
 	if (pregpriv)
-		len += snprintf(page + len, count - len,
+		len += snprintf(buffer + len, count - len,
 			"%d\n",
 			pregpriv->rx_stbc
 			);
 
-	*eof = 1;
+	*offset = len;
 	return len;
 }
 
-int proc_set_rx_stbc(struct file *file, const char __user *buffer,
-		unsigned long count, void *data)
+ssize_t sys_set_rx_stbc(struct file *file, const char __user *buffer,
+			size_t count, loff_t *offset)
 {
-	struct net_device *dev = (struct net_device *)data;
+	struct inode *inode = file_inode(file);
+	struct net_device *dev = (struct net_device *)inode->i_private;
 	struct adapter *padapter = (struct adapter *)rtw_netdev_priv(dev);
 	struct registry_priv	*pregpriv = &padapter->registrypriv;
 	char tmp[32];
@@ -789,18 +841,12 @@ int proc_set_rx_stbc(struct file *file, const char __user *buffer,
 	return count;
 }
 
-int proc_get_rssi_disp(char *page, char **start,
-			  off_t offset, int count,
-			  int *eof, void *data)
-{
-	*eof = 1;
-	return 0;
-}
 
-int proc_set_rssi_disp(struct file *file, const char __user *buffer,
-		unsigned long count, void *data)
+ssize_t sys_set_rssi_disp(struct file *file, const char __user *buffer,
+				size_t count, loff_t *offset)
 {
-	struct net_device *dev = (struct net_device *)data;
+	struct inode *inode = file_inode(file);
+	struct net_device *dev = (struct net_device *)inode->i_private;
 	struct adapter *padapter = (struct adapter *)rtw_netdev_priv(dev);
 	char tmp[32];
 	u32 enable = 0;
@@ -831,12 +877,12 @@ int proc_set_rssi_disp(struct file *file, const char __user *buffer,
 
 #ifdef CONFIG_88EU_AP_MODE
 
-int proc_get_all_sta_info(char *page, char **start,
-			  off_t offset, int count,
-			  int *eof, void *data)
+ssize_t sys_get_all_sta_info(struct file *file, char __user *buffer,
+				size_t count, loff_t *offset)
 {
 	struct sta_info *psta;
-	struct net_device *dev = data;
+	struct inode *inode = file_inode(file);
+	struct net_device *dev = (struct net_device *)inode->i_private;
 	struct adapter *padapter = (struct adapter *)rtw_netdev_priv(dev);
 	struct sta_priv *pstapriv = &padapter->stapriv;
 	int i, j;
@@ -844,8 +890,10 @@ int proc_get_all_sta_info(char *page, char **start,
 	struct recv_reorder_ctrl *preorder_ctrl;
 	int len = 0;
 
-
-	len += snprintf(page + len, count - len, "sta_dz_bitmap=0x%x, tim_bitmap=0x%x\n", pstapriv->sta_dz_bitmap, pstapriv->tim_bitmap);
+
+	if (*offset != 0)
+		return 0;
+	len += snprintf(buffer + len, count - len, "sta_dz_bitmap=0x%x, tim_bitmap=0x%x\n", pstapriv->sta_dz_bitmap, pstapriv->tim_bitmap);
 
 	spin_lock_bh(&pstapriv->sta_hash_lock);
 
@@ -858,46 +906,48 @@ int proc_get_all_sta_info(char *page, char **start,
 
 			plist = plist->next;
 
-			len += snprintf(page + len, count - len, "sta's macaddr: %pM\n", psta->hwaddr);
-			len += snprintf(page + len, count - len, "rtsen=%d, cts2slef=%d\n", psta->rtsen, psta->cts2self);
-			len += snprintf(page + len, count - len, "state=0x%x, aid=%d, macid=%d, raid=%d\n", psta->state, psta->aid, psta->mac_id, psta->raid);
-			len += snprintf(page + len, count - len, "qos_en=%d, ht_en=%d, init_rate=%d\n", psta->qos_option, psta->htpriv.ht_option, psta->init_rate);
-			len += snprintf(page + len, count - len, "bwmode=%d, ch_offset=%d, sgi=%d\n", psta->htpriv.bwmode, psta->htpriv.ch_offset, psta->htpriv.sgi);
-			len += snprintf(page + len, count - len, "ampdu_enable = %d\n", psta->htpriv.ampdu_enable);
-			len += snprintf(page + len, count - len, "agg_enable_bitmap=%x, candidate_tid_bitmap=%x\n", psta->htpriv.agg_enable_bitmap, psta->htpriv.candidate_tid_bitmap);
-			len += snprintf(page + len, count - len, "sleepq_len=%d\n", psta->sleepq_len);
-			len += snprintf(page + len, count - len, "capability=0x%x\n", psta->capability);
-			len += snprintf(page + len, count - len, "flags=0x%x\n", psta->flags);
-			len += snprintf(page + len, count - len, "wpa_psk=0x%x\n", psta->wpa_psk);
-			len += snprintf(page + len, count - len, "wpa2_group_cipher=0x%x\n", psta->wpa2_group_cipher);
-			len += snprintf(page + len, count - len, "wpa2_pairwise_cipher=0x%x\n", psta->wpa2_pairwise_cipher);
-			len += snprintf(page + len, count - len, "qos_info=0x%x\n", psta->qos_info);
-			len += snprintf(page + len, count - len, "dot118021XPrivacy=0x%x\n", psta->dot118021XPrivacy);
+			len += snprintf(buffer + len, count - len, "sta's macaddr: %pM\n", psta->hwaddr);
+			len += snprintf(buffer + len, count - len, "rtsen=%d, cts2slef=%d\n", psta->rtsen, psta->cts2self);
+			len += snprintf(buffer + len, count - len, "state=0x%x, aid=%d, macid=%d, raid=%d\n", psta->state, psta->aid, psta->mac_id, psta->raid);
+			len += snprintf(buffer + len, count - len, "qos_en=%d, ht_en=%d, init_rate=%d\n", psta->qos_option, psta->htpriv.ht_option, psta->init_rate);
+			len += snprintf(buffer + len, count - len, "bwmode=%d, ch_offset=%d, sgi=%d\n", psta->htpriv.bwmode, psta->htpriv.ch_offset, psta->htpriv.sgi);
+			len += snprintf(buffer + len, count - len, "ampdu_enable = %d\n", psta->htpriv.ampdu_enable);
+			len += snprintf(buffer + len, count - len, "agg_enable_bitmap=%x, candidate_tid_bitmap=%x\n", psta->htpriv.agg_enable_bitmap, psta->htpriv.candidate_tid_bitmap);
+			len += snprintf(buffer + len, count - len, "sleepq_len=%d\n", psta->sleepq_len);
+			len += snprintf(buffer + len, count - len, "capability=0x%x\n", psta->capability);
+			len += snprintf(buffer + len, count - len, "flags=0x%x\n", psta->flags);
+			len += snprintf(buffer + len, count - len, "wpa_psk=0x%x\n", psta->wpa_psk);
+			len += snprintf(buffer + len, count - len, "wpa2_group_cipher=0x%x\n", psta->wpa2_group_cipher);
+			len += snprintf(buffer + len, count - len, "wpa2_pairwise_cipher=0x%x\n", psta->wpa2_pairwise_cipher);
+			len += snprintf(buffer + len, count - len, "qos_info=0x%x\n", psta->qos_info);
+			len += snprintf(buffer + len, count - len, "dot118021XPrivacy=0x%x\n", psta->dot118021XPrivacy);
 
 			for (j = 0; j < 16; j++) {
 				preorder_ctrl = &psta->recvreorder_ctrl[j];
 				if (preorder_ctrl->enable)
-					len += snprintf(page + len, count - len, "tid=%d, indicate_seq=%d\n", j, preorder_ctrl->indicate_seq);
+					len += snprintf(buffer + len, count - len, "tid=%d, indicate_seq=%d\n", j, preorder_ctrl->indicate_seq);
 			}
 		}
 	}
 	spin_unlock_bh(&pstapriv->sta_hash_lock);
 
-	*eof = 1;
+	*offset = len;
 	return len;
 }
 #endif
 
-int proc_get_best_channel(char *page, char **start,
-			  off_t offset, int count,
-			  int *eof, void *data)
+ssize_t sys_get_best_channel(struct file *file, char __user *buffer,
+				size_t count, loff_t *offset)
 {
-	struct net_device *dev = data;
+	struct inode *inode = file_inode(file);
+	struct net_device *dev = (struct net_device *)inode->i_private;
 	struct adapter *padapter = (struct adapter *)rtw_netdev_priv(dev);
 	struct mlme_ext_priv *pmlmeext = &padapter->mlmeextpriv;
 	int len = 0;
 	u32 i, best_channel_24G = 1, best_channel_5G = 36, index_24G = 0, index_5G = 0;
 
+	if (*offset != 0)
+		return 0;
 	for (i = 0; pmlmeext->channel_set[i].ChannelNum != 0; i++) {
 		if (pmlmeext->channel_set[i].ChannelNum == 1)
 			index_24G = i;
@@ -935,13 +985,13 @@ int proc_get_best_channel(char *page, char **start,
 			}
 		}
 		/*  debug */
-		len += snprintf(page + len, count - len, "The rx cnt of channel %3d = %d\n",
+		len += snprintf(buffer + len, count - len, "The rx cnt of channel %3d = %d\n",
 					pmlmeext->channel_set[i].ChannelNum, pmlmeext->channel_set[i].rx_count);
 	}
 
-	len += snprintf(page + len, count - len, "best_channel_5G = %d\n", best_channel_5G);
-	len += snprintf(page + len, count - len, "best_channel_24G = %d\n", best_channel_24G);
+	len += snprintf(buffer + len, count - len,
+				"best_channel_5G = %d\n", best_channel_5G);
+	len += snprintf(buffer + len, count - len,
+				"best_channel_24G = %d\n", best_channel_24G);
 
-	*eof = 1;
+	*offset = len;
 	return len;
 }
diff --git a/drivers/staging/rtl8188eu/include/drv_types.h b/drivers/staging/rtl8188eu/include/drv_types.h
index 8f42d48..dbf449f 100644
--- a/drivers/staging/rtl8188eu/include/drv_types.h
+++ b/drivers/staging/rtl8188eu/include/drv_types.h
@@ -229,7 +229,7 @@ struct adapter {
 	int bup;
 	struct net_device_stats stats;
 	struct iw_statistics iwstats;
-	struct proc_dir_entry *dir_dev;/*  for proc directory */
+	struct dentry *dir_dev;/*  for sys directory replacing proc_dir_entry*/
 
 	int net_closed;
 	u8 bFWReady;
-- 
1.7.10.4

