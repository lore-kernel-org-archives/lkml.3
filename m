Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752094AbaFVIXw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 04:23:52 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:59555 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752059AbaFVIXt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 04:23:49 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 16/42] staging: rtl8188eu: Use kstrtoul() for string to long conversion
Date: Sun, 22 Jun 2014 13:49:36 +0530
Message-Id: <1403425202-11942-17-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1403425202-11942-1-git-send-email-navin.patidar@gmail.com>
References: <1403425202-11942-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/include/osdep_service.h |    3 ---
 drivers/staging/rtl8188eu/os_dep/ioctl_linux.c    |   24 +++++++++++++++------
 drivers/staging/rtl8188eu/os_dep/osdep_service.c  |   17 ---------------
 3 files changed, 17 insertions(+), 27 deletions(-)

diff --git a/drivers/staging/rtl8188eu/include/osdep_service.h b/drivers/staging/rtl8188eu/include/osdep_service.h
index 7a0afab..7c2336f 100644
--- a/drivers/staging/rtl8188eu/include/osdep_service.h
+++ b/drivers/staging/rtl8188eu/include/osdep_service.h
@@ -211,9 +211,6 @@ u32  rtw_ms_to_systime(u32 ms);
 s32  rtw_get_passing_time_ms(u32 start);
 s32  rtw_get_time_interval_ms(u32 start, u32 end);
 
-
-u32  rtw_atoi(u8 *s);
-
 static inline unsigned char _cancel_timer_ex(struct timer_list *ptimer)
 {
 	return del_timer_sync(ptimer);
diff --git a/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c b/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c
index 15748a5..5cca278 100644
--- a/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c
+++ b/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c
@@ -6590,9 +6590,10 @@ static int rtw_mp_rate(struct net_device *dev,
 			struct iw_request_info *info,
 			struct iw_point *wrqu, char *extra)
 {
-	u32 rate = MPT_RATE_1M;
+	unsigned long rate = MPT_RATE_1M;
 	char	*input = kmalloc(wrqu->length, GFP_KERNEL);
 	struct adapter *padapter = rtw_netdev_priv(dev);
+	int status;
 
 	if (!input)
 		return -ENOMEM;
@@ -6600,8 +6601,12 @@ static int rtw_mp_rate(struct net_device *dev,
 		kfree(input);
 		return -EFAULT;
 	}
-	rate = rtw_atoi(input);
-	sprintf(extra, "Set data rate to %d", rate);
+
+	status = kstrtoul(input, 0, &rate);
+	if (status)
+		return status;
+
+	sprintf(extra, "Set data rate to %lu", rate);
 	kfree(input);
 	if (rate <= 0x7f)
 		rate = wifirate2_ratetbl_inx((u8)rate);
@@ -6623,8 +6628,9 @@ static int rtw_mp_channel(struct net_device *dev,
 			struct iw_point *wrqu, char *extra)
 {
 	struct adapter *padapter = rtw_netdev_priv(dev);
-	char	*input = kmalloc(wrqu->length, GFP_KERNEL);
-	u32	channel = 1;
+	char *input = kmalloc(wrqu->length, GFP_KERNEL);
+	unsigned long channel = 1;
+	int status;
 
 	if (!input)
 		return -ENOMEM;
@@ -6632,8 +6638,12 @@ static int rtw_mp_channel(struct net_device *dev,
 		kfree(input);
 		return -EFAULT;
 	}
-	channel = rtw_atoi(input);
-	sprintf(extra, "Change channel %d to channel %d", padapter->mppriv.channel, channel);
+
+	status = kstrtoul(input, 0, &channel);
+	if (status)
+		return status;
+
+	sprintf(extra, "Change channel %d to channel %lu", padapter->mppriv.channel, channel);
 
 	padapter->mppriv.channel = channel;
 	Hal_SetChannel(padapter);
diff --git a/drivers/staging/rtl8188eu/os_dep/osdep_service.c b/drivers/staging/rtl8188eu/os_dep/osdep_service.c
index f43ace2..2a4469d 100644
--- a/drivers/staging/rtl8188eu/os_dep/osdep_service.c
+++ b/drivers/staging/rtl8188eu/os_dep/osdep_service.c
@@ -39,23 +39,6 @@ inline int RTW_STATUS_CODE(int error_code)
 	return _FAIL;
 }
 
-u32 rtw_atoi(u8 *s)
-{
-	int num = 0, flag = 0;
-	int i;
-	for (i = 0; i <= strlen(s); i++) {
-		if (s[i] >= '0' && s[i] <= '9')
-			num = num * 10 + s[i] - '0';
-		else if (s[0] == '-' && i == 0)
-			flag = 1;
-		else
-			break;
-	}
-	if (flag == 1)
-		num = num * -1;
-	return num;
-}
-
 u8 *_rtw_malloc(u32 sz)
 {
 	u8	*pbuf = NULL;
-- 
1.7.10.4

