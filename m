Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753466AbaBJTnY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 14:43:24 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34669 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753409AbaBJTnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 14:43:20 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 056/124] b43: Fix unload oops if firmware is not available
Date: Mon, 10 Feb 2014 11:39:56 -0800
Message-Id: <1392061264-28124-57-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1392061264-28124-1-git-send-email-kamal@canonical.com>
References: <1392061264-28124-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.18 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Larry Finger <Larry.Finger@lwfinger.net>

commit 0673effd41dba323d6a280ef37b5ef29f3f5a653 upstream.

The asyncronous firmware load uses a completion struct to hold firmware
processing until the user-space routines are up and running. There is.
however, a problem in that the waiter is nevered canceled during teardown.
As a result, unloading the driver when firmware is not available causes an oops.

To be able to access the completion structure at teardown, it had to be moved
into the b43_wldev structure.

This patch also fixes a typo in a comment.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/wireless/b43/b43.h  |  4 ++--
 drivers/net/wireless/b43/main.c | 10 +++++-----
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/b43/b43.h b/drivers/net/wireless/b43/b43.h
index 10e288d..fdb900c 100644
--- a/drivers/net/wireless/b43/b43.h
+++ b/drivers/net/wireless/b43/b43.h
@@ -723,8 +723,6 @@ enum b43_firmware_file_type {
 struct b43_request_fw_context {
 	/* The device we are requesting the fw for. */
 	struct b43_wldev *dev;
-	/* a completion event structure needed if this call is asynchronous */
-	struct completion fw_load_complete;
 	/* a pointer to the firmware object */
 	const struct firmware *blob;
 	/* The type of firmware to request. */
@@ -801,6 +799,8 @@ enum {
 struct b43_wldev {
 	struct b43_bus_dev *dev;
 	struct b43_wl *wl;
+	/* a completion event structure needed if this call is asynchronous */
+	struct completion fw_load_complete;
 
 	/* The device initialization status.
 	 * Use b43_status() to query. */
diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index bb421be..3f4b3bd 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -2061,6 +2061,7 @@ void b43_do_release_fw(struct b43_firmware_file *fw)
 
 static void b43_release_firmware(struct b43_wldev *dev)
 {
+	complete(&dev->fw_load_complete);
 	b43_do_release_fw(&dev->fw.ucode);
 	b43_do_release_fw(&dev->fw.pcm);
 	b43_do_release_fw(&dev->fw.initvals);
@@ -2086,7 +2087,7 @@ static void b43_fw_cb(const struct firmware *firmware, void *context)
 	struct b43_request_fw_context *ctx = context;
 
 	ctx->blob = firmware;
-	complete(&ctx->fw_load_complete);
+	complete(&ctx->dev->fw_load_complete);
 }
 
 int b43_do_request_fw(struct b43_request_fw_context *ctx,
@@ -2133,7 +2134,7 @@ int b43_do_request_fw(struct b43_request_fw_context *ctx,
 	}
 	if (async) {
 		/* do this part asynchronously */
-		init_completion(&ctx->fw_load_complete);
+		init_completion(&ctx->dev->fw_load_complete);
 		err = request_firmware_nowait(THIS_MODULE, 1, ctx->fwname,
 					      ctx->dev->dev->dev, GFP_KERNEL,
 					      ctx, b43_fw_cb);
@@ -2141,12 +2142,11 @@ int b43_do_request_fw(struct b43_request_fw_context *ctx,
 			pr_err("Unable to load firmware\n");
 			return err;
 		}
-		/* stall here until fw ready */
-		wait_for_completion(&ctx->fw_load_complete);
+		wait_for_completion(&ctx->dev->fw_load_complete);
 		if (ctx->blob)
 			goto fw_ready;
 	/* On some ARM systems, the async request will fail, but the next sync
-	 * request works. For this reason, we dall through here
+	 * request works. For this reason, we fall through here
 	 */
 	}
 	err = request_firmware(&ctx->blob, ctx->fwname,
-- 
1.8.3.2

