Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752481AbaEGTyJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 15:54:09 -0400
Received: from mout.gmx.net ([212.227.17.22]:60433 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752402AbaEGTyB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 15:54:01 -0400
Date: Wed, 7 May 2014 21:34:37 +0200
From: Christian Engelmayer <cengelma@gmx.at>
To: Christian Engelmayer <cengelma@gmx.at>
Cc: devel@driverdev.osuosl.org, w-lkml@lebenslange-mailadresse.de,
        gregkh@linuxfoundation.org, peter.p.waskiewicz.jr@intel.com,
        oat.elena@gmail.com, linux-kernel@vger.kernel.org, teobaluta@gmail.com,
        dan.carpenter@oracle.com, Larry.Finger@lwfinger.net
Subject: [PATCH v2 5/5] staging: rtl8188eu: fix potential leak in
 rtw_mp_pwrtrk()
Message-ID: <20140507213437.31eb535d@spike>
In-Reply-To: <20140507212825.2289e00e@spike>
References: <20140507212825.2289e00e@spike>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:r746hk/DKGI9u0ApvJrlXequyB942OV+kOynsP0ocXA93v6fPUM
 cT6M1wJG8ck4o93R3k+6dFTgjuUMXquOwA1BIp0jQ7spdAUjKN44I4sF7/holV9QwqJ8cPp
 hFD8nFtzvJ6ac6FOwlhlogrA5T1x1de0t7iAlQVzdKMt59qKq0hhq1UsIoiXll427tkEZIl
 Tct/bCGxc2HmqMCTFnHGw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Function rtw_mp_pwrtrk() dynamically allocates a temporary buffer that
is not freed in all error paths. Use a centralized exit path and make sure
that all memory is freed correctly. Detected by Coverity - 1077715.

Signed-off-by: Christian Engelmayer <cengelma@gmx.at>
---
 drivers/staging/rtl8188eu/os_dep/ioctl_linux.c | 28 ++++++++++++++++----------
 1 file changed, 17 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c b/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c
index ea5e1f8..f04aaa3 100644
--- a/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c
+++ b/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c
@@ -7119,15 +7119,15 @@ static int rtw_mp_pwrtrk(struct net_device *dev,
 {
 	u8 enable;
 	u32 thermal;
-	s32 ret;
 	struct adapter *padapter = rtw_netdev_priv(dev);
 	char	*input = kmalloc(wrqu->length, GFP_KERNEL);
+	int ret = 0;
 
 	if (!input)
 		return -ENOMEM;
 	if (copy_from_user(input, wrqu->pointer, wrqu->length)) {
-		kfree(input);
-		return -EFAULT;
+		ret = -EFAULT;
+		goto exit;
 	}
 	_rtw_memset(extra, 0, wrqu->length);
 
@@ -7138,22 +7138,28 @@ static int rtw_mp_pwrtrk(struct net_device *dev,
 			sprintf(extra, "mp tx power tracking stop");
 		} else if (sscanf(input, "ther =%d", &thermal)) {
 				ret = Hal_SetThermalMeter(padapter, (u8)thermal);
-				if (ret == _FAIL)
-					return -EPERM;
+				if (ret == _FAIL) {
+					ret = -EPERM;
+					goto exit;
+				}
 				sprintf(extra, "mp tx power tracking start, target value =%d ok ", thermal);
 		} else {
-			kfree(input);
-			return -EINVAL;
+			ret = -EINVAL;
+			goto exit;
 		}
 	}
 
-	kfree(input);
 	ret = Hal_SetPowerTracking(padapter, enable);
-	if (ret == _FAIL)
-		return -EPERM;
+	if (ret == _FAIL) {
+		ret = -EPERM;
+		goto exit;
+	}
 
 	wrqu->length = strlen(extra);
-	return 0;
+
+exit:
+	kfree(input);
+	return ret;
 }
 
 static int rtw_mp_psd(struct net_device *dev,
-- 
1.9.1

