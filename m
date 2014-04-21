Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753332AbaDURmw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 13:42:52 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:32996 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753117AbaDURmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 13:42:50 -0400
Message-ID: <53555897.10409@gmail.com>
Date: Mon, 21 Apr 2014 20:42:47 +0300
From: Tair <tair.rzayev@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: gregkh@linuxfoundation.org
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] staging: keucr: smilmain.c: Fix sparse warning
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix "Should be static" sparse warning:
* Add Check_D_MediaFmt() declaration to smil.h;
* Move Check_D_MediaFmt() implementation up in smilmain.c to keep
  all the non-static functions at the top of the file;
* Include "init.h" into "smil.h", remove externs from "smil.h"
  which are no longer needed;
* SM_Init[] and SM_Rdwr[] are renamed because otherwise SM_Init[]
  collides with SM_Init() from "smil.h".

Signed-off-by: Tair Rzayev <tair.rzayev@gmail.com>
---
 drivers/staging/keucr/init.c     |  4 ++--
 drivers/staging/keucr/init.h     | 10 +++-------
 drivers/staging/keucr/smil.h     |  1 +
 drivers/staging/keucr/smilmain.c | 34 +++++++++++++++++-----------------
 4 files changed, 23 insertions(+), 26 deletions(-)

diff --git a/drivers/staging/keucr/init.c b/drivers/staging/keucr/init.c
index e611839..b0538f9 100644
--- a/drivers/staging/keucr/init.c
+++ b/drivers/staging/keucr/init.c
@@ -140,11 +140,11 @@ int ENE_LoadBinCode(struct us_data *us, u8 flag)
 	/* For SS */
 	case SM_INIT_PATTERN:
 		dev_dbg(&us->pusb_dev->dev, "SM_INIT_PATTERN\n");
-		memcpy(buf, SM_Init, 0x800);
+		memcpy(buf, SM_Init_cmd, 0x800);
 		break;
 	case SM_RW_PATTERN:
 		dev_dbg(&us->pusb_dev->dev, "SM_RW_PATTERN\n");
-		memcpy(buf, SM_Rdwr, 0x800);
+		memcpy(buf, SM_Rdwr_cmd, 0x800);
 		break;
 	}
 
diff --git a/drivers/staging/keucr/init.h b/drivers/staging/keucr/init.h
index 98d2e3b..30b30ef 100644
--- a/drivers/staging/keucr/init.h
+++ b/drivers/staging/keucr/init.h
@@ -1,11 +1,7 @@
 #include "common.h"
+#include "smil.h"
 
-extern u32 MediaChange;
-extern int Check_D_MediaFmt(struct us_data *);
-
-
-
-static u8 SM_Init[] = {
+static u8 SM_Init_cmd[] = {
 0x7B, 0x09, 0x7C, 0xF0, 0x7D, 0x10, 0x7E, 0xE9,
 0x7F, 0xCC, 0x12, 0x2F, 0x71, 0x90, 0xE9, 0xCC,
 0xE0, 0xB4, 0x07, 0x12, 0x90, 0xFF, 0x09, 0xE0,
@@ -263,7 +259,7 @@ static u8 SM_Init[] = {
 0x58, 0x44, 0x2D, 0x49, 0x6E, 0x69, 0x74, 0x20,
 0x20, 0x20, 0x20, 0x31, 0x30, 0x30, 0x30, 0x31 };
 
-static u8 SM_Rdwr[] = {
+static u8 SM_Rdwr_cmd[] = {
 0x7B, 0x0C, 0x7C, 0xF0, 0x7D, 0x10, 0x7E, 0xE9,
 0x7F, 0xCC, 0x12, 0x2F, 0x71, 0x90, 0xE9, 0xC3,
 0xE0, 0xB4, 0x73, 0x04, 0x74, 0x40, 0x80, 0x09,
diff --git a/drivers/staging/keucr/smil.h b/drivers/staging/keucr/smil.h
index 3995173..91d54ef 100644
--- a/drivers/staging/keucr/smil.h
+++ b/drivers/staging/keucr/smil.h
@@ -205,6 +205,7 @@ int         Init_D_SmartMedia(void);
 int         Pwoff_D_SmartMedia(void);
 int         Check_D_SmartMedia(void);
 int         Check_D_Parameter(struct us_data *, u16 *, u8 *, u8 *);
+int         Check_D_MediaFmt(struct us_data *us);
 int         Media_D_ReadSector(struct us_data *, u32, u16, u8 *);
 int         Media_D_WriteSector(struct us_data *, u32, u16, u8 *);
 int         Media_D_CopySector(struct us_data *, u32, u16, u8 *);
diff --git a/drivers/staging/keucr/smilmain.c b/drivers/staging/keucr/smilmain.c
index fc7cbc6..42ec8a6 100644
--- a/drivers/staging/keucr/smilmain.c
+++ b/drivers/staging/keucr/smilmain.c
@@ -141,23 +141,6 @@ int Media_D_CopySector(struct us_data *us, u32 start, u16 count, u8 *buf)
 	return NO_ERROR;
 }
 
-/* ----- Release_D_CopySector() ------------------------------------------ */
-static int Release_D_CopySector(struct us_data *us)
-{
-	Log2Phy[Media.Zone][Media.LogBlock] = WriteBlock;
-	Media.PhyBlock = ReadBlock;
-
-	if (Media.PhyBlock == NO_ASSIGN) {
-		Media.PhyBlock = WriteBlock;
-		return SMSUCCESS;
-	}
-
-	Clr_D_Bit(Assign[Media.Zone], Media.PhyBlock);
-	Media.PhyBlock = WriteBlock;
-
-	return SMSUCCESS;
-}
-
 /* SmartMedia Physical Format Test Subroutine */
 /* ----- Check_D_MediaFmt() --------------------------------------------- */
 int Check_D_MediaFmt(struct us_data *us)
@@ -184,6 +167,23 @@ int Check_D_MediaFmt(struct us_data *us)
 	return SMSUCCESS;
 }
 
+/* ----- Release_D_CopySector() ------------------------------------------ */
+static int Release_D_CopySector(struct us_data *us)
+{
+	Log2Phy[Media.Zone][Media.LogBlock] = WriteBlock;
+	Media.PhyBlock = ReadBlock;
+
+	if (Media.PhyBlock == NO_ASSIGN) {
+		Media.PhyBlock = WriteBlock;
+		return SMSUCCESS;
+	}
+
+	Clr_D_Bit(Assign[Media.Zone], Media.PhyBlock);
+	Media.PhyBlock = WriteBlock;
+
+	return SMSUCCESS;
+}
+
 /* SmartMedia Physical Address Control Subroutine */
 /* ----- Conv_D_MediaAddr() --------------------------------------------- */
 static int Conv_D_MediaAddr(struct us_data *us, u32 addr)
-- 
1.8.3.2


