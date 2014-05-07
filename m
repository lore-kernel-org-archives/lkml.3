Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752187AbaEGTxP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 15:53:15 -0400
Received: from mout.gmx.net ([212.227.17.22]:64674 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752062AbaEGTxJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 15:53:09 -0400
Date: Wed, 7 May 2014 21:30:23 +0200
From: Christian Engelmayer <cengelma@gmx.at>
To: Christian Engelmayer <cengelma@gmx.at>
Cc: devel@driverdev.osuosl.org, w-lkml@lebenslange-mailadresse.de,
        gregkh@linuxfoundation.org, peter.p.waskiewicz.jr@intel.com,
        oat.elena@gmail.com, linux-kernel@vger.kernel.org, teobaluta@gmail.com,
        dan.carpenter@oracle.com, Larry.Finger@lwfinger.net
Subject: [PATCH v2 1/5] staging: rtl8188eu: fix potential leak in
 rtw_wx_read32()
Message-ID: <20140507213023.0efacc80@spike>
In-Reply-To: <20140507212825.2289e00e@spike>
References: <20140507212825.2289e00e@spike>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:qp+wBbwpI489UFV2GagGaLC5h/2rNwYwIuZuHNL2nDqY+WDVVRF
 Y6uh/w11Is7kgHH3pVMqJ5vjhGnxt2RTpFcFZ2OmDxWbL/XwhtyMbMrKrDIDOXb201ftTkq
 9GO1fv136kmAIyd3yD4ZJ4uR4O0/bjE+y0AwhG2dHlBQpvrLbR2F+ZVz6c4wJ8nN/+4Eqrg
 RfKJKKIKftHSEWDLe0x5A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Function rtw_wx_read32() dynamically allocates a temporary buffer that is not
freed in all error paths. Use a centralized exit path and make sure that all
memory is freed correctly. Detected by Coverity - CID 1077711.

Signed-off-by: Christian Engelmayer <cengelma@gmx.at>
---
 drivers/staging/rtl8188eu/os_dep/ioctl_linux.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c b/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c
index cf30a08..45b47e2 100644
--- a/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c
+++ b/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c
@@ -2154,6 +2154,7 @@ static int rtw_wx_read32(struct net_device *dev,
 	u32 bytes;
 	u8 *ptmp;
 	int rv;
+	int ret = 0;
 
 	padapter = (struct adapter *)rtw_netdev_priv(dev);
 	p = &wrqu->data;
@@ -2163,16 +2164,16 @@ static int rtw_wx_read32(struct net_device *dev,
 		return -ENOMEM;
 
 	if (copy_from_user(ptmp, p->pointer, len)) {
-		kfree(ptmp);
-		return -EFAULT;
+		ret = -EFAULT;
+		goto exit;
 	}
 
 	bytes = 0;
 	addr = 0;
 	rv = sscanf(ptmp, "%d,%x", &bytes, &addr);
 	if (rv != 2) {
-		kfree(ptmp);
-		return -EINVAL;
+		ret = -EINVAL;
+		goto exit;
 	}
 
 	switch (bytes) {
@@ -2190,12 +2191,14 @@ static int rtw_wx_read32(struct net_device *dev,
 		break;
 	default:
 		DBG_88E(KERN_INFO "%s: usage> read [bytes],[address(hex)]\n", __func__);
-		return -EINVAL;
+		ret = -EINVAL;
+		goto exit;
 	}
 	DBG_88E(KERN_INFO "%s: addr = 0x%08X data =%s\n", __func__, addr, extra);
 
+exit:
 	kfree(ptmp);
-	return 0;
+	return ret;
 }
 
 static int rtw_wx_write32(struct net_device *dev,
-- 
1.9.1

