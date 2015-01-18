Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752302AbbARCFV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2015 21:05:21 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:47278 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751936AbbARCE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2015 21:04:59 -0500
From: mathieu.poirier@linaro.org
To: forest@alittletooquiet.net, gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        mathieu.poirier@linaro.org
Subject: [PATCH 4/4] staging: vt6655: correcting parameter related sparse error
Date: Sat, 17 Jan 2015 19:04:26 -0700
Message-Id: <1421546666-21461-5-git-send-email-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1421546666-21461-1-git-send-email-mathieu.poirier@linaro.org>
References: <1421546666-21461-1-git-send-email-mathieu.poirier@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mathieu Poirier <mathieu.poirier@linaro.org>

mpoirier@t430:~/work/kernel1$ make C=1 M=drivers/staging/vt6655/
  LD      drivers/staging/vt6655/built-in.o
  CHECK   drivers/staging/vt6655/device_main.c
drivers/staging/vt6655/device_main.c:1503:25: warning: incorrect type in argument 1 (different address spaces)
drivers/staging/vt6655/device_main.c:1503:25:    expected void [noderef] <asn:2>*<noident>
drivers/staging/vt6655/device_main.c:1503:25:    got struct vnt_private *
drivers/staging/vt6655/device_main.c:1503:25: warning: incorrect type in argument 2 (different address spaces)
drivers/staging/vt6655/device_main.c:1503:25:    expected void [noderef] <asn:2>*<noident>
drivers/staging/vt6655/device_main.c:1503:25:    got struct vnt_private *
drivers/staging/vt6655/device_main.c:1505:25: warning: incorrect type in argument 1 (different address spaces)
drivers/staging/vt6655/device_main.c:1505:25:    expected void [noderef] <asn:2>*<noident>
drivers/staging/vt6655/device_main.c:1505:25:    got struct vnt_private *
drivers/staging/vt6655/device_main.c:1505:25: warning: incorrect type in argument 2 (different address spaces)
drivers/staging/vt6655/device_main.c:1505:25:    expected void [noderef] <asn:2>*<noident>
drivers/staging/vt6655/device_main.c:1505:25:    got struct vnt_private *

In this case a pointer to "struct vnt_private" is given to macros @MACvRegBitsOn()
and @MACvRegBitsOff().  These in turn eventually call @ioread8(), which take a
"void __iomem *" as parameter.  The first field of "struct vnt_private" is a
pointer to a "struct pci_dev", whose first field is a "struct list_head".

Correcting the problem by following the trend set fort in every other calls to
the macros by passing "->PortOffset", declared as "void __iomem *".

Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
---
 drivers/staging/vt6655/device_main.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index a3f5cd84259a..951ea5321d61 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -1500,9 +1500,11 @@ static void vnt_bss_info_changed(struct ieee80211_hw *hw,
 		if (conf->enable_beacon) {
 			vnt_beacon_enable(priv, vif, conf);
 
-			MACvRegBitsOn(priv, MAC_REG_TCR, TCR_AUTOBCNTX);
+			MACvRegBitsOn(priv->PortOffset,
+				      MAC_REG_TCR, TCR_AUTOBCNTX);
 		} else {
-			MACvRegBitsOff(priv, MAC_REG_TCR, TCR_AUTOBCNTX);
+			MACvRegBitsOff(priv->PortOffset,
+				       MAC_REG_TCR, TCR_AUTOBCNTX);
 		}
 	}
 
-- 
1.9.1

