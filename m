Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752675AbaBXKXa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 05:23:30 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:60275 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752161AbaBXKXY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 05:23:24 -0500
From: Daeseok Youn <daeseok.youn@gmail.com>
To: gregkh@linuxfoundation.org
Cc: ufimtseva@gmail.com, paul.gortmaker@windriver.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        dan.carpenter@oracle.com
Subject: [PATCH v2] staging: ced401: fix double unlock bug
Date: Mon, 24 Feb 2014 19:23:15 +0900
Message-ID: <6036697.Bsd6uoTeJ1@daeseok-laptop.cloud.net>
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

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 drivers/staging/ced1401/usb1401.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/ced1401/usb1401.c b/drivers/staging/ced1401/usb1401.c
index efc310c..8195eb9 100644
--- a/drivers/staging/ced1401/usb1401.c
+++ b/drivers/staging/ced1401/usb1401.c
@@ -1053,7 +1053,6 @@ static int Handle1401Esc(DEVICE_EXTENSION *pdx, char *pCh,
 				/*  This can never happen, really */
 				dev_err(&pdx->interface->dev,
 					"ERROR: DMA setup while transfer still waiting");
-				spin_unlock(&pdx->stagedLock);
 			} else {
 				if ((wTransType == TM_EXTTOHOST)
 				    || (wTransType == TM_EXTTO1401)) {
-- 
1.7.9.5

---
