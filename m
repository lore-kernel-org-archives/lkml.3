Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754773Ab3LTIQq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 03:16:46 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:21597 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753088Ab3LTIQp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 03:16:45 -0500
Date: Fri, 20 Dec 2013 11:16:33 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Wenliang Fan <fanwlexca@gmail.com>
Cc: gregkh@linuxfoundation.org, klmckinney1@gmail.com, tulinizer@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/staging/bcm: Integer overflow
Message-ID: <20131220081633.GL28413@mwanda>
References: <1387523596-29543-1-git-send-email-fanwlexca@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387523596-29543-1-git-send-email-fanwlexca@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 20, 2013 at 03:13:16PM +0800, Wenliang Fan wrote:
> The checking condition in 'validateFlash2xReadWrite()' is not sufficient.
> A large number invalid would cause an integer overflow and pass
> the condition, which could cause further integer overflows in
> 'Bcmchar.c:bcm_char_ioctl()'.
> 

This patch has a couple typos and it breaks the build.

On the other hand it's a real bug because uiNumOfBytes comes from the
user in bcm_char_ioctl().  This function doesn't seem to be restricted
to privaleged users, which is terrifying.

I think it would be cleaner to fix it in the caller instead of here.

Please look over this totally untested patch and send something like
that, if that's ok.

diff --git a/drivers/staging/bcm/Bcmchar.c b/drivers/staging/bcm/Bcmchar.c
index 62415342ee28..2ea885e36077 100644
--- a/drivers/staging/bcm/Bcmchar.c
+++ b/drivers/staging/bcm/Bcmchar.c
@@ -1456,8 +1456,7 @@ cntrlEnd:
 	case IOCTL_BCM_FLASH2X_SECTION_READ: {
 		struct bcm_flash2x_readwrite sFlash2xRead = {0};
 		PUCHAR pReadBuff = NULL;
-		UINT NOB = 0;
-		UINT BuffSize = 0;
+		UINT NOB;
 		UINT ReadBytes = 0;
 		UINT ReadOffset = 0;
 		void __user *OutPutBuff;
@@ -1480,19 +1479,17 @@ cntrlEnd:
 		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, "\nsFlash2xRead.numOfBytes :%x", sFlash2xRead.numOfBytes);
 		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, "\nsFlash2xRead.bVerify :%x\n", sFlash2xRead.bVerify);
 
+		if (sFlash2xRead.numOfBytes > Adapter->uiSectorSize)
+			sFlash2xRead.numOfBytes = Adapter->uiSectorSize;
+		NOB = sFlash2xRead.numOfBytes;
+
 		/* This was internal to driver for raw read. now it has ben exposed to user space app. */
 		if (validateFlash2xReadWrite(Adapter, &sFlash2xRead) == false)
 			return STATUS_FAILURE;
 
-		NOB = sFlash2xRead.numOfBytes;
-		if (NOB > Adapter->uiSectorSize)
-			BuffSize = Adapter->uiSectorSize;
-		else
-			BuffSize = NOB;
-
 		ReadOffset = sFlash2xRead.offset;
 		OutPutBuff = IoBuffer.OutputBuffer;
-		pReadBuff = (PCHAR)kzalloc(BuffSize , GFP_KERNEL);
+		pReadBuff = (PCHAR)kzalloc(sFlash2xRead.numOfBytes, GFP_KERNEL);
 
 		if (pReadBuff == NULL) {
 			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "Memory allocation failed for Flash 2.x Read Structure");
@@ -1548,8 +1545,7 @@ cntrlEnd:
 		struct bcm_flash2x_readwrite sFlash2xWrite = {0};
 		PUCHAR pWriteBuff;
 		void __user *InputAddr;
-		UINT NOB = 0;
-		UINT BuffSize = 0;
+		UINT NOB;
 		UINT WriteOffset = 0;
 		UINT WriteBytes = 0;
 
@@ -1580,19 +1576,17 @@ cntrlEnd:
 			return -EINVAL;
 		}
 
+		if (sFlash2xWrite.numOfBytes > Adapter->uiSectorSize)
+			sFlash2xWrite.numOfBytes = Adapter->uiSectorSize;
+		NOB = sFlash2xWrite.numOfBytes;
+
 		if (validateFlash2xReadWrite(Adapter, &sFlash2xWrite) == false)
 			return STATUS_FAILURE;
 
 		InputAddr = sFlash2xWrite.pDataBuff;
 		WriteOffset = sFlash2xWrite.offset;
-		NOB = sFlash2xWrite.numOfBytes;
-
-		if (NOB > Adapter->uiSectorSize)
-			BuffSize = Adapter->uiSectorSize;
-		else
-			BuffSize = NOB;
 
-		pWriteBuff = kmalloc(BuffSize, GFP_KERNEL);
+		pWriteBuff = kmalloc(sFlash2xWrite.numOfBytes, GFP_KERNEL);
 
 		if (pWriteBuff == NULL)
 			return -ENOMEM;
