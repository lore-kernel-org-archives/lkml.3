Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752965AbaBYBNz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 20:13:55 -0500
Received: from mail-pd0-f173.google.com ([209.85.192.173]:33189 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752000AbaBYBNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 20:13:54 -0500
From: Daeseok Youn <daeseok.youn@gmail.com>
To: gregkh@linuxfoundation.org, dan.carpenter@oracle.com
Cc: paul.gortmaker@windriver.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, ufimtseva@gmail.com
Subject: [PATCH v3] staging: ced401: fix double unlock bug
Date: Tue, 25 Feb 2014 10:13:49 +0900
Message-ID: <1755294.ri4AdIA4G3@daeseok-laptop.cloud.net>
User-Agent: KMail/4.8.5 (Linux/3.2.0-58-generic; KDE/4.8.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


After spin_lock() is called, all of if-else conditions in this brace
should reach the end of else and spin_unlock() must be called.
So It doesn't need to call spin_unlock() without a return statement
for handling an error.

Also sparse says:
drivers/staging/ced1401/usb1401.c:1080:28: warning:
 context imbalance in 'Handle1401Esc' - unexpected unlock

Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 drivers/staging/ced1401/usb1401.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/ced1401/usb1401.c b/drivers/staging/ced1401/usb1401.c
index f441e33..c281fda 100644
--- a/drivers/staging/ced1401/usb1401.c
+++ b/drivers/staging/ced1401/usb1401.c
@@ -1054,7 +1054,6 @@ static int Handle1401Esc(DEVICE_EXTENSION *pdx, char *pCh,
 				/*  This can never happen, really */
 				dev_err(&pdx->interface->dev,
 					"ERROR: DMA setup while transfer still waiting\n");
-				spin_unlock(&pdx->stagedLock);
 			} else {
 				if ((wTransType == TM_EXTTOHOST)
 				    || (wTransType == TM_EXTTO1401)) {
-- 
1.7.9.5

---
