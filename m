Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754960Ab3AKJCZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 04:02:25 -0500
Received: from mail.ispras.ru ([83.149.199.43]:36361 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753213Ab3AKJCX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 04:02:23 -0500
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>,
        =?UTF-8?q?Alois=20Schl=C3=B6gl?= <alois.schloegl@ist.ac.at>,
        linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
Subject: [PATCH] staging: ced1401: fix GFP_KERNEL in spinlock context
Date: Fri, 11 Jan 2013 13:01:39 +0400
Message-Id: <1357894899-27695-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allowi() calls usb_submit_urb(pdx->pUrbCharIn, bInCallback ? GFP_ATOMIC : GFP_KERNEL)
under spin_lock_irqsave(&pdx->charInLock, flags). That means it should use GFP_ATOMIC anyway.
As soon as it is the only usage of bInCallback argument, the patch removes it at all.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/staging/ced1401/ced_ioc.c |   18 +++++++++---------
 drivers/staging/ced1401/usb1401.c |   10 ++++------
 drivers/staging/ced1401/usb1401.h |    2 +-
 3 files changed, 14 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/ced1401/ced_ioc.c b/drivers/staging/ced1401/ced_ioc.c
index d043471..82a333f 100644
--- a/drivers/staging/ced1401/ced_ioc.c
+++ b/drivers/staging/ced1401/ced_ioc.c
@@ -123,7 +123,7 @@ int SendString(DEVICE_EXTENSION * pdx, const char __user * pData,
 		iReturn = PutChars(pdx, buffer, n);
 	}
 
-	Allowi(pdx, false);	// make sure we have input int
+	Allowi(pdx);		// make sure we have input int
 	mutex_unlock(&pdx->io_mutex);
 
 	return iReturn;
@@ -140,7 +140,7 @@ int SendChar(DEVICE_EXTENSION * pdx, char c)
 	mutex_lock(&pdx->io_mutex);	// Protect disconnect from new i/o
 	iReturn = PutChars(pdx, &c, 1);
 	dev_dbg(&pdx->interface->dev, "SendChar >%c< (0x%02x)", c, c);
-	Allowi(pdx, false);	// Make sure char reads are running
+	Allowi(pdx);	// Make sure char reads are running
 	mutex_unlock(&pdx->io_mutex);
 	return iReturn;
 }
@@ -433,8 +433,8 @@ int GetChar(DEVICE_EXTENSION * pdx)
 
 	dev_dbg(&pdx->interface->dev, "GetChar");
 
-	Allowi(pdx, false);	// Make sure char reads are running
-	SendChars(pdx);		// and send any buffered chars
+	Allowi(pdx);	// Make sure char reads are running
+	SendChars(pdx);	// and send any buffered chars
 
 	spin_lock_irq(&pdx->charInLock);
 	if (pdx->dwNumInput > 0)	// worth looking
@@ -447,7 +447,7 @@ int GetChar(DEVICE_EXTENSION * pdx)
 		iReturn = U14ERR_NOIN;	// no input data to read
 	spin_unlock_irq(&pdx->charInLock);
 
-	Allowi(pdx, false);	// Make sure char reads are running
+	Allowi(pdx);	// Make sure char reads are running
 
 	mutex_unlock(&pdx->io_mutex);	// Protect disconnect from new i/o
 	return iReturn;
@@ -472,7 +472,7 @@ int GetString(DEVICE_EXTENSION * pdx, char __user * pUser, int n)
 		return -ENOMEM;
 
 	mutex_lock(&pdx->io_mutex);	// Protect disconnect from new i/o
-	Allowi(pdx, false);	// Make sure char reads are running
+	Allowi(pdx);	// Make sure char reads are running
 	SendChars(pdx);		// and send any buffered chars
 
 	spin_lock_irq(&pdx->charInLock);
@@ -518,7 +518,7 @@ int GetString(DEVICE_EXTENSION * pdx, char __user * pUser, int n)
 	} else
 		spin_unlock_irq(&pdx->charInLock);
 
-	Allowi(pdx, false);	// Make sure char reads are running
+	Allowi(pdx);	// Make sure char reads are running
 	mutex_unlock(&pdx->io_mutex);	// Protect disconnect from new i/o
 
 	return iReturn;
@@ -531,7 +531,7 @@ int Stat1401(DEVICE_EXTENSION * pdx)
 {
 	int iReturn;
 	mutex_lock(&pdx->io_mutex);	// Protect disconnect from new i/o
-	Allowi(pdx, false);	// make sure we allow pending chars
+	Allowi(pdx);		// make sure we allow pending chars
 	SendChars(pdx);		// in both directions
 	iReturn = pdx->dwNumInput;	// no lock as single read
 	mutex_unlock(&pdx->io_mutex);	// Protect disconnect from new i/o
@@ -550,7 +550,7 @@ int LineCount(DEVICE_EXTENSION * pdx)
 	int iReturn = 0;	// will be count of line ends
 
 	mutex_lock(&pdx->io_mutex);	// Protect disconnect from new i/o
-	Allowi(pdx, false);	// Make sure char reads are running
+	Allowi(pdx);		// Make sure char reads are running
 	SendChars(pdx);		// and send any buffered chars
 	spin_lock_irq(&pdx->charInLock);	// Get protection
 
diff --git a/drivers/staging/ced1401/usb1401.c b/drivers/staging/ced1401/usb1401.c
index a27043a..60bed3e 100644
--- a/drivers/staging/ced1401/usb1401.c
+++ b/drivers/staging/ced1401/usb1401.c
@@ -697,7 +697,7 @@ static void staged_callback(struct urb *pUrb)
 	// in Allowi as if it were protected by the char lock. In any case, most systems will
 	// not be upset by char input during DMA... sigh. Needs sorting out.
 	if (bRestartCharInput)	// may be out of date, but...
-		Allowi(pdx, true);	// ...Allowi tests a lock too.
+		Allowi(pdx);	// ...Allowi tests a lock too.
 	dev_dbg(&pdx->interface->dev, "%s done", __func__);
 }
 
@@ -1172,7 +1172,7 @@ static void ced_readchar_callback(struct urb *pUrb)
 	pdx->bReadCharsPending = false;	// No longer have a pending read
 	spin_unlock(&pdx->charInLock);	// already at irq level
 
-	Allowi(pdx, true);	// see if we can do the next one
+	Allowi(pdx);	// see if we can do the next one
 }
 
 /****************************************************************************
@@ -1182,7 +1182,7 @@ static void ced_readchar_callback(struct urb *pUrb)
 ** we can pick up any inward transfers. This can be called in multiple contexts
 ** so we use the irqsave version of the spinlock.
 ****************************************************************************/
-int Allowi(DEVICE_EXTENSION * pdx, bool bInCallback)
+int Allowi(DEVICE_EXTENSION * pdx)
 {
 	int iReturn = U14ERR_NOERROR;
 	unsigned long flags;
@@ -1211,9 +1211,7 @@ int Allowi(DEVICE_EXTENSION * pdx, bool bInCallback)
 				 pdx, pdx->bInterval);
 		pdx->pUrbCharIn->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;	// short xfers are OK by default
 		usb_anchor_urb(pdx->pUrbCharIn, &pdx->submitted);	// in case we need to kill it
-		iReturn =
-		    usb_submit_urb(pdx->pUrbCharIn,
-				   bInCallback ? GFP_ATOMIC : GFP_KERNEL);
+		iReturn = usb_submit_urb(pdx->pUrbCharIn, GFP_ATOMIC);
 		if (iReturn) {
 			usb_unanchor_urb(pdx->pUrbCharIn);	// remove from list of active Urbs
 			pdx->bPipeError[nPipe] = 1;	// Flag an error to be handled later
diff --git a/drivers/staging/ced1401/usb1401.h b/drivers/staging/ced1401/usb1401.h
index adb5fa4..8fc6958 100644
--- a/drivers/staging/ced1401/usb1401.h
+++ b/drivers/staging/ced1401/usb1401.h
@@ -204,7 +204,7 @@ typedef struct _DEVICE_EXTENSION
 
 /// Definitions of routimes used between compilation object files
 // in usb1401.c
-extern int Allowi(DEVICE_EXTENSION* pdx, bool bInCallback);
+extern int Allowi(DEVICE_EXTENSION* pdx);
 extern int SendChars(DEVICE_EXTENSION* pdx);
 extern void ced_draw_down(DEVICE_EXTENSION *pdx);
 extern int ReadWriteMem(DEVICE_EXTENSION *pdx, bool Read, unsigned short wIdent,
-- 
1.7.9.5

