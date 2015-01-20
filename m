Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752140AbbATFfz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 00:35:55 -0500
Received: from www.osadl.org ([62.245.132.105]:50654 "EHLO www.osadl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750745AbbATFfx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 00:35:53 -0500
From: Nicholas Mc Guire <der.herr@hofr.at>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Gigi Joseph <gigi.joseph@gmail.com>, Eyal Reizer <eyalr@ti.com>,
        Robin van der Gracht <robin@protonic.nl>, Sekhar Nori <nsekhar@ti.com>,
        Enric Balletbo i Serra <eballetbo@iseebcn.com>,
        Wolfram Sang <wsa@the-dreams.de>, linux-kernel@vger.kernel.org,
        Nicholas Mc Guire <der.herr@hofr.at>
Subject: [PATCH] misc: ti-st: add handling of the signal case
Date: Tue, 20 Jan 2015 06:27:45 +0100
Message-Id: <1421731665-13386-1-git-send-email-der.herr@hofr.at>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

if(!wait_for_completion_interruptible_timeout(...))
only handles the timeout case - this patch adds handling the
signal case the same as timeout.

Signed-off-by: Nicholas Mc Guire <der.herr@hofr.at>
---

Only the timeout case was being handled, the signal case
(-ERESTARTSYS) was treated just like the case of successful
completion, which is most likely not reasonable.

read_local_version() is called from download_firmware() where
it checks for !=0 return, so the error handling logic should be
preserved correctly.

download_firmware() is called from st_kim_start() which is
checking for !=0 return, so the error handling logic should be
preserved correctly

This patch was only compile tested for i368_defconfig + 
CONFIG_X86_32_NON_STANDARD=y CONFIG_STA2X11=y CONFIG_TI_ST=m

This patch is against 3.19.0-rc5 -next-20150119

 drivers/misc/ti-st/st_kim.c |   19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/misc/ti-st/st_kim.c b/drivers/misc/ti-st/st_kim.c
index 7109d28..623071c 100644
--- a/drivers/misc/ti-st/st_kim.c
+++ b/drivers/misc/ti-st/st_kim.c
@@ -219,6 +219,7 @@ static long read_local_version(struct kim_data_s *kim_gdata, char *bts_scr_name)
 {
 	unsigned short version = 0, chip = 0, min_ver = 0, maj_ver = 0;
 	const char read_ver_cmd[] = { 0x01, 0x01, 0x10, 0x00 };
+	long timeout;
 
 	pr_debug("%s", __func__);
 
@@ -228,10 +229,11 @@ static long read_local_version(struct kim_data_s *kim_gdata, char *bts_scr_name)
 		return -EIO;
 	}
 
-	if (!wait_for_completion_interruptible_timeout(
-		&kim_gdata->kim_rcvd, msecs_to_jiffies(CMD_RESP_TIME))) {
-		pr_err(" waiting for ver info- timed out ");
-		return -ETIMEDOUT;
+	timeout = wait_for_completion_interruptible_timeout(
+		&kim_gdata->kim_rcvd, msecs_to_jiffies(CMD_RESP_TIME));
+	if (timeout <= 0) {
+		pr_err(" waiting for ver info- timed out or received signal");
+		return timeout ? -ERESTARTSYS : -ETIMEDOUT;
 	}
 	reinit_completion(&kim_gdata->kim_rcvd);
 	/* the positions 12 & 13 in the response buffer provide with the
@@ -395,13 +397,14 @@ static long download_firmware(struct kim_data_s *kim_gdata)
 			break;
 		case ACTION_WAIT_EVENT:  /* wait */
 			pr_debug("W");
-			if (!wait_for_completion_interruptible_timeout(
+			err = wait_for_completion_interruptible_timeout(
 					&kim_gdata->kim_rcvd,
-					msecs_to_jiffies(CMD_RESP_TIME))) {
-				pr_err("response timeout during fw download ");
+					msecs_to_jiffies(CMD_RESP_TIME));
+			if (err <= 0) {
+				pr_err("response timeout/signaled during fw download ");
 				/* timed out */
 				release_firmware(kim_gdata->fw_entry);
-				return -ETIMEDOUT;
+				return err ? -ERESTARTSYS : -ETIMEDOUT;
 			}
 			reinit_completion(&kim_gdata->kim_rcvd);
 			break;
-- 
1.7.10.4

