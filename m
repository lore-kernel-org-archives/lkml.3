Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757365Ab3DWQcM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 12:32:12 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:56782 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757344Ab3DWQcK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 12:32:10 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Ian Abbott <abbotti@mev.co.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 15/21] staging: comedi/dawboard2000: use mdelay for large delays
Date: Tue, 23 Apr 2013 18:30:47 +0200
Message-Id: <1366734653-488286-16-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1366734653-488286-1-git-send-email-arnd@arndb.de>
References: <1366734653-488286-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:9uDBddFN0yf8Uxitf6/Q3gj0LR5MdZiS6AgJ59hqdF0
 uR7INKV5fp3Ys8mbMH5Wyg4sQTwd3RRWBO5y6SCy0mdn0u+7HK
 49sErmBVrEsfvfxVcNfNbZEBrO1+BVdNC6mCWbeKUnHupH+/69
 pJ0pT8tOZWI+yjIARYIW80URQZAbCdLYo4suxm/eXCs+//CEcA
 GJ2bjK2MZ9KJpVqjGH4Zr42Afya7V5+Tn7TVvWcGa4KqAo7V1K
 k8HXOqjNR2fH/U/k6PIRhpI6cYqbHiLlPkcEkVxFqEb/MqzWuZ
 3OkEb2fIYsVKUmvjjOf3kngm1pSLC71udG7FLUkP4Ba40IHHoU
 EQj3JNI9hxraLs0UzchaaUTYNt2aToz2XqCnjOktH
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On ARM, it is not legal to pass values larger than 2ms into udelay(),
and mdelay() must be used instead, to avoid this build error:

ERROR: "__bad_udelay" [drivers/staging/comedi/drivers/daqboard2000.ko]
undefined!

On a related note, any use of mdelay() or large udelay() numbers should
be carefully reviewed, and replaced with msleep() or a different
implementation that does not rely on delaying the work.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/daqboard2000.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/comedi/drivers/daqboard2000.c b/drivers/staging/comedi/drivers/daqboard2000.c
index 50b450f..b213e36 100644
--- a/drivers/staging/comedi/drivers/daqboard2000.c
+++ b/drivers/staging/comedi/drivers/daqboard2000.c
@@ -462,9 +462,9 @@ static void daqboard2000_resetLocalBus(struct comedi_device *dev)
 	struct daqboard2000_private *devpriv = dev->private;
 
 	writel(DAQBOARD2000_SECRLocalBusHi, devpriv->plx + 0x6c);
-	udelay(10000);
+	mdelay(10);
 	writel(DAQBOARD2000_SECRLocalBusLo, devpriv->plx + 0x6c);
-	udelay(10000);
+	mdelay(10);
 }
 
 static void daqboard2000_reloadPLX(struct comedi_device *dev)
@@ -472,11 +472,11 @@ static void daqboard2000_reloadPLX(struct comedi_device *dev)
 	struct daqboard2000_private *devpriv = dev->private;
 
 	writel(DAQBOARD2000_SECRReloadLo, devpriv->plx + 0x6c);
-	udelay(10000);
+	mdelay(10);
 	writel(DAQBOARD2000_SECRReloadHi, devpriv->plx + 0x6c);
-	udelay(10000);
+	mdelay(10);
 	writel(DAQBOARD2000_SECRReloadLo, devpriv->plx + 0x6c);
-	udelay(10000);
+	mdelay(10);
 }
 
 static void daqboard2000_pulseProgPin(struct comedi_device *dev)
@@ -484,9 +484,9 @@ static void daqboard2000_pulseProgPin(struct comedi_device *dev)
 	struct daqboard2000_private *devpriv = dev->private;
 
 	writel(DAQBOARD2000_SECRProgPinHi, devpriv->plx + 0x6c);
-	udelay(10000);
+	mdelay(10);
 	writel(DAQBOARD2000_SECRProgPinLo, devpriv->plx + 0x6c);
-	udelay(10000);	/* Not in the original code, but I like symmetry... */
+	mdelay(10);	/* Not in the original code, but I like symmetry... */
 }
 
 static int daqboard2000_pollCPLD(struct comedi_device *dev, int mask)
-- 
1.8.1.2

