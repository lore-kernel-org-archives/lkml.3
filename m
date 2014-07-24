Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935070AbaGXXIR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 19:08:17 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:60038 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934936AbaGXXIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 19:08:13 -0400
X-Originating-IP: 109.10.215.15
From: Guillaume Clement <gclement@baobob.org>
To: Forest Bond <forest@alittletooquiet.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Guillaume Clement <gclement@baobob.org>
Subject: [PATCH] staging: vt6655: tag data as __user in struct tagSCmdRequest
Date: Fri, 25 Jul 2014 01:07:40 +0200
Message-Id: <1406243260-13490-1-git-send-email-gclement@baobob.org>
X-Mailer: git-send-email 1.8.5.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sparse reported that the data from tagSCmdRequest is given by
userspace, so it should be tagged as such.

Later, we were memcomparing and dereferencing it without first copying
it, fix that as well.

Signed-off-by: Guillaume Clement <gclement@baobob.org>
---
 drivers/staging/vt6655/iocmd.h |  2 +-
 drivers/staging/vt6655/iwctl.c | 22 +++++++++++++++-------
 drivers/staging/vt6655/iwctl.h |  6 +++---
 3 files changed, 19 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/vt6655/iocmd.h b/drivers/staging/vt6655/iocmd.h
index e499f1b..dd12498 100644
--- a/drivers/staging/vt6655/iocmd.h
+++ b/drivers/staging/vt6655/iocmd.h
@@ -100,7 +100,7 @@ typedef enum tagWZONETYPE {
 #pragma pack(1)
 typedef struct tagSCmdRequest {
 	u8	    name[16];
-	void	*data;
+	void __user *data;
 	u16	    wResult;
 	u16     wCmdCode;
 } SCmdRequest, *PSCmdRequest;
diff --git a/drivers/staging/vt6655/iwctl.c b/drivers/staging/vt6655/iwctl.c
index 501cd64..9291259 100644
--- a/drivers/staging/vt6655/iwctl.c
+++ b/drivers/staging/vt6655/iwctl.c
@@ -1621,14 +1621,17 @@ int iwctl_giwauth(struct net_device *dev,
 int iwctl_siwgenie(struct net_device *dev,
 		   struct iw_request_info *info,
 		   struct iw_point *wrq,
-		   char *extra)
+		   char __user *extra)
 {
 	PSDevice			pDevice = (PSDevice)netdev_priv(dev);
 	PSMgmtObject	pMgmt = &(pDevice->sMgmtObj);
 	int ret = 0;
+	char length;
 
 	if (wrq->length) {
-		if ((wrq->length < 2) || (extra[1]+2 != wrq->length)) {
+		if (get_user(length, extra + 1))
+			return -EFAULT;
+		if ((wrq->length < 2) || (length != wrq->length)) {
 			ret = -EINVAL;
 			goto out;
 		}
@@ -1654,7 +1657,7 @@ out://not completely ...not necessary in wpa_supplicant 0.5.8
 int iwctl_giwgenie(struct net_device *dev,
 		   struct iw_request_info *info,
 		   struct iw_point *wrq,
-		   char *extra)
+		   char __user *extra)
 {
 	PSDevice			pDevice = (PSDevice)netdev_priv(dev);
 	PSMgmtObject	pMgmt = &(pDevice->sMgmtObj);
@@ -1801,18 +1804,23 @@ int iwctl_giwencodeext(struct net_device *dev,
 int iwctl_siwmlme(struct net_device *dev,
 		  struct iw_request_info *info,
 		  struct iw_point *wrq,
-		  char *extra)
+		  char __user *extra)
 {
 	PSDevice			pDevice = (PSDevice)netdev_priv(dev);
 	PSMgmtObject	pMgmt = &(pDevice->sMgmtObj);
-	struct iw_mlme *mlme = (struct iw_mlme *)extra;
+	struct iw_mlme mime;
+
 	int ret = 0;
 
-	if (memcmp(pMgmt->abyCurrBSSID, mlme->addr.sa_data, ETH_ALEN)) {
+	ret = copy_from_user(&mime, extra, sizeof(mime));
+	if (ret)
+		return -EFAULT;
+
+	if (memcmp(pMgmt->abyCurrBSSID, mime.addr.sa_data, ETH_ALEN)) {
 		ret = -EINVAL;
 		return ret;
 	}
-	switch (mlme->cmd) {
+	switch (mime.cmd) {
 	case IW_MLME_DEAUTH:
 		//this command seems to be not complete,please test it --einsnliu
 		//bScheduleCommand((void *) pDevice, WLAN_CMD_DEAUTH, (unsigned char *)&reason);
diff --git a/drivers/staging/vt6655/iwctl.h b/drivers/staging/vt6655/iwctl.h
index de0a337..7dd6310 100644
--- a/drivers/staging/vt6655/iwctl.h
+++ b/drivers/staging/vt6655/iwctl.h
@@ -176,12 +176,12 @@ int iwctl_giwauth(struct net_device *dev,
 int iwctl_siwgenie(struct net_device *dev,
 		   struct iw_request_info *info,
 		   struct iw_point *wrq,
-		   char *extra);
+		   char __user *extra);
 
 int iwctl_giwgenie(struct net_device *dev,
 		   struct iw_request_info *info,
 		   struct iw_point *wrq,
-		   char *extra);
+		   char __user *extra);
 
 int iwctl_siwencodeext(struct net_device *dev,
 		       struct iw_request_info *info,
@@ -196,7 +196,7 @@ int iwctl_giwencodeext(struct net_device *dev,
 int iwctl_siwmlme(struct net_device *dev,
 		  struct iw_request_info *info,
 		  struct iw_point *wrq,
-		  char *extra);
+		  char __user *extra);
 #endif // #ifdef WPA_SUPPLICANT_DRIVER_WEXT_SUPPORT
 //End Add -- //2008-0409-07, <Add> by Einsn Liu
 
-- 
1.8.5.5

