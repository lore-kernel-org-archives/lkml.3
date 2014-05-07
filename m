Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752772AbaEGT6V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 15:58:21 -0400
Received: from mout.gmx.net ([212.227.17.22]:63116 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752011AbaEGTxH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 15:53:07 -0400
Date: Wed, 7 May 2014 21:31:20 +0200
From: Christian Engelmayer <cengelma@gmx.at>
To: Christian Engelmayer <cengelma@gmx.at>
Cc: devel@driverdev.osuosl.org, w-lkml@lebenslange-mailadresse.de,
        gregkh@linuxfoundation.org, peter.p.waskiewicz.jr@intel.com,
        oat.elena@gmail.com, linux-kernel@vger.kernel.org, teobaluta@gmail.com,
        dan.carpenter@oracle.com, Larry.Finger@lwfinger.net
Subject: [PATCH v2 2/5] staging: rtl8188eu: fix potential leak in
 rtw_wx_set_enc_ext()
Message-ID: <20140507213120.27fc914f@spike>
In-Reply-To: <20140507212825.2289e00e@spike>
References: <20140507212825.2289e00e@spike>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:iWNlHSHSW3QFCNh+lW7ybTZ45PlmAMhrVJ8/e2rv3PNKln/1df5
 2KvdqyS+iRCmAAoqKTwmkO5sKs86aSt8sIMfDTVNySI6BF9axK5dGwfB/ypdd2dGJIBfquT
 /MrcT72XKCBzXsBdHr4H3hkrATKN7eKISyATjrveO5K5a4uPaWxwU6gIJ10QXcei5ebdIgu
 1gK1YjY1Fqga2PP3ORWyg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Function rtw_wx_set_enc_ext() dynamically allocates a temporary buffer that
is not freed in all error paths. Use a centralized exit path and make sure
that all memory is freed correctly. Detected by Coverity - CID 1077712.

Signed-off-by: Christian Engelmayer <cengelma@gmx.at>
---
 drivers/staging/rtl8188eu/os_dep/ioctl_linux.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c b/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c
index 45b47e2..1bd476d 100644
--- a/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c
+++ b/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c
@@ -2097,7 +2097,8 @@ static int rtw_wx_set_enc_ext(struct net_device *dev,
 		alg_name = "CCMP";
 		break;
 	default:
-		return -1;
+		ret = -1;
+		goto exit;
 	}
 
 	strncpy((char *)param->u.crypt.alg, alg_name, IEEE_CRYPT_ALG_NAME_LEN);
@@ -2124,6 +2125,7 @@ static int rtw_wx_set_enc_ext(struct net_device *dev,
 
 	ret =  wpa_set_encryption(dev, param, param_len);
 
+exit:
 	kfree(param);
 	return ret;
 }
-- 
1.9.1

