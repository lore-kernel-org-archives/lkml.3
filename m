Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755996AbaBGMoY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 07:44:24 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41947 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932346AbaBGLu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:50:28 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 117/233] b43: Fix unload oops if firmware is not available
Date: Fri,  7 Feb 2014 11:45:36 +0000
Message-Id: <1391773652-25214-118-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
References: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.4 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/wireless/b43/b43.h  |  4 ++--
 drivers/net/wireless/b43/main.c | 10 +++++-----
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/b43/b43.h b/drivers/net/wireless/b43/b43.h
index 7f3d461..54376fd 100644
--- a/drivers/net/wireless/b43/b43.h
+++ b/drivers/net/wireless/b43/b43.h
@@ -731,8 +731,6 @@ enum b43_firmware_file_type {
 struct b43_request_fw_context {
 	/* The device we are requesting the fw for. */
 	struct b43_wldev *dev;
-	/* a completion event structure needed if this call is asynchronous */
-	struct completion fw_load_complete;
 	/* a pointer to the firmware object */
 	const struct firmware *blob;
 	/* The type of firmware to request. */
@@ -809,6 +807,8 @@ enum {
 struct b43_wldev {
 	struct b43_bus_dev *dev;
 	struct b43_wl *wl;
+	/* a completion event structure needed if this call is asynchronous */
+	struct completion fw_load_complete;
 
 	/* The device initialization status.
 	 * Use b43_status() to query. */
diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index bccc6ca..13f5a3b 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -2070,6 +2070,7 @@ void b43_do_release_fw(struct b43_firmware_file *fw)
 
 static void b43_release_firmware(struct b43_wldev *dev)
 {
+	complete(&dev->fw_load_complete);
 	b43_do_release_fw(&dev->fw.ucode);
 	b43_do_release_fw(&dev->fw.pcm);
 	b43_do_release_fw(&dev->fw.initvals);
@@ -2095,7 +2096,7 @@ static void b43_fw_cb(const struct firmware *firmware, void *context)
 	struct b43_request_fw_context *ctx = context;
 
 	ctx->blob = firmware;
-	complete(&ctx->fw_load_complete);
+	complete(&ctx->dev->fw_load_complete);
 }
 
 int b43_do_request_fw(struct b43_request_fw_context *ctx,
@@ -2142,7 +2143,7 @@ int b43_do_request_fw(struct b43_request_fw_context *ctx,
 	}
 	if (async) {
 		/* do this part asynchronously */
-		init_completion(&ctx->fw_load_complete);
+		init_completion(&ctx->dev->fw_load_complete);
 		err = request_firmware_nowait(THIS_MODULE, 1, ctx->fwname,
 					      ctx->dev->dev->dev, GFP_KERNEL,
 					      ctx, b43_fw_cb);
@@ -2150,12 +2151,11 @@ int b43_do_request_fw(struct b43_request_fw_context *ctx,
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

