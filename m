Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752130AbaEGTxM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 15:53:12 -0400
Received: from mout.gmx.net ([212.227.17.22]:57043 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752077AbaEGTxJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 15:53:09 -0400
Date: Wed, 7 May 2014 21:32:30 +0200
From: Christian Engelmayer <cengelma@gmx.at>
To: Christian Engelmayer <cengelma@gmx.at>
Cc: devel@driverdev.osuosl.org, w-lkml@lebenslange-mailadresse.de,
        gregkh@linuxfoundation.org, peter.p.waskiewicz.jr@intel.com,
        oat.elena@gmail.com, linux-kernel@vger.kernel.org, teobaluta@gmail.com,
        dan.carpenter@oracle.com, Larry.Finger@lwfinger.net
Subject: [PATCH v2 3/5] staging: rtl8188eu: fix potential leak in
 rtw_mp_QueryDrv()
Message-ID: <20140507213230.1d0aaae7@spike>
In-Reply-To: <20140507212825.2289e00e@spike>
References: <20140507212825.2289e00e@spike>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:dfqBpGLlmuhd8SZvWIX22o/oI0gDqzL3qwx9KSMg+KL0OBHuFHo
 yKvnpfWahL/wznx6avm7HvUZ9umsCNkTSXbrrzFMOR2tjScb7VfrLt07+sr77E6VZe9iyrx
 sYyr9InFnHp/bRWep+I0PUSw6EZNl1cgFhNmwykMBNpvtdxUSW/CYKekYxzyYloFY9Z2Svp
 ITGopTAMCVXppS4q65B/Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Function rtw_mp_QueryDrv() dynamically allocates a temporary buffer that
is not freed in all error paths. Use a centralized exit path and make sure
that all memory is freed correctly. Detected by Coverity - CID 1077713.

Signed-off-by: Christian Engelmayer <cengelma@gmx.at>
---
 drivers/staging/rtl8188eu/os_dep/ioctl_linux.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c b/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c
index 1bd476d..8b1579b 100644
--- a/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c
+++ b/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c
@@ -7350,12 +7350,15 @@ static int rtw_mp_QueryDrv(struct net_device *dev,
 	char	*input = kmalloc(wrqu->data.length, GFP_KERNEL);
 	u8 qAutoLoad = 1;
 	struct eeprom_priv *pEEPROM = GET_EEPROM_EFUSE_PRIV(padapter);
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
 
 	qAutoLoad = strncmp(input, "autoload", 8); /*  strncmp true is 0 */
@@ -7369,8 +7372,10 @@ static int rtw_mp_QueryDrv(struct net_device *dev,
 		sprintf(extra, "ok");
 	}
 	wrqu->data.length = strlen(extra) + 1;
+
+exit:
 	kfree(input);
-	return 0;
+	return ret;
 }
 
 static int rtw_mp_set(struct net_device *dev,
-- 
1.9.1

