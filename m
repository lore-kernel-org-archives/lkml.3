Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752373AbaEGTxg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 15:53:36 -0400
Received: from mout.gmx.net ([212.227.17.21]:63736 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752328AbaEGTxc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 15:53:32 -0400
Date: Wed, 7 May 2014 21:33:20 +0200
From: Christian Engelmayer <cengelma@gmx.at>
To: Christian Engelmayer <cengelma@gmx.at>
Cc: devel@driverdev.osuosl.org, w-lkml@lebenslange-mailadresse.de,
        gregkh@linuxfoundation.org, peter.p.waskiewicz.jr@intel.com,
        oat.elena@gmail.com, linux-kernel@vger.kernel.org, teobaluta@gmail.com,
        dan.carpenter@oracle.com, Larry.Finger@lwfinger.net
Subject: [PATCH v2 4/5] staging: rtl8188eu: fix potential leak in
 rtw_mp_SetRFPath()
Message-ID: <20140507213320.406d9958@spike>
In-Reply-To: <20140507212825.2289e00e@spike>
References: <20140507212825.2289e00e@spike>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:FOcg5EWahNabU/vxkUGdWJiyDLferkS4h00jneY2nsaZCcnqzVh
 z1UjNXvzYDs9uts2/QUjGUaCmdgFGn2CeauI+8cW1J0jJCwhkhSGTq4yWGEB2nRgM97xgfx
 MhBESGO8p/rsh6Mp/P9vdCf1hEPXnJx+xnVmdCXlPd4ZUgBQIWmL4KxeQt0llaiIt309qMe
 eW2nBBesEwfnrduW5zLQw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Function rtw_mp_SetRFPath() dynamically allocates a temporary buffer that
is not freed in all error paths. Use a centralized exit path and make sure
that all memory is freed correctly. Detected by Coverity - CID 1077714.

Signed-off-by: Christian Engelmayer <cengelma@gmx.at>
---
 drivers/staging/rtl8188eu/os_dep/ioctl_linux.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c b/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c
index 8b1579b..ea5e1f8 100644
--- a/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c
+++ b/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c
@@ -7321,11 +7321,14 @@ static int rtw_mp_SetRFPath(struct net_device *dev,
 	struct adapter *padapter = rtw_netdev_priv(dev);
 	char	*input = kmalloc(wrqu->data.length, GFP_KERNEL);
 	u8 bMain = 1, bTurnoff = 1;
+	int ret = 0;
 
 	if (!input)
 		return -ENOMEM;
-	if (copy_from_user(input, wrqu->data.pointer, wrqu->data.length))
-			return -EFAULT;
+	if (copy_from_user(input, wrqu->data.pointer, wrqu->data.length)) {
+		ret = -EFAULT;
+		goto exit;
+	}
 	DBG_88E("%s:iwpriv in =%s\n", __func__, input);
 
 	bMain = strncmp(input, "1", 2); /*  strncmp true is 0 */
@@ -7338,8 +7341,10 @@ static int rtw_mp_SetRFPath(struct net_device *dev,
 		MP_PHY_SetRFPathSwitch(padapter, false);
 		DBG_88E("%s:PHY_SetRFPathSwitch = false\n", __func__);
 	}
+
+exit:
 	kfree(input);
-	return 0;
+	return ret;
 }
 
 static int rtw_mp_QueryDrv(struct net_device *dev,
-- 
1.9.1

