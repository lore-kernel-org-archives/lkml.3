Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754424Ab3AXD3h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 22:29:37 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44217 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753248Ab3AXD3L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 22:29:11 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 24/74] b43: Fix firmware loading when driver is built into the kernel
Date: Thu, 24 Jan 2013 01:26:36 -0200
Message-Id: <1358998046-613-25-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358998046-613-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358998046-613-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Larry Finger <Larry.Finger@lwfinger.net>

commit 5e20a4b53094651d80f856ff55a916b999dbb57a upstream.

Recent versions of udev cause synchronous firmware loading from the
probe routine to fail because the request to user space would time
out. The original fix for b43 (commit 6b6fa58) moved the firmware
load from the probe routine to a work queue, but it still used synchronous
firmware loading. This method is OK when b43 is built as a module;
however, it fails when the driver is compiled into the kernel.

This version changes the code to load the initial firmware file
using request_firmware_nowait(). A completion event is used to
hold the work queue until that file is available. This driver
reads several firmware files - the remainder can be read synchronously.
On some test systems, the async read fails; however, a following synch
read works, thus the async failure falls through to the sync try.

Reported-and-Tested by: Felix Janda <felix.janda@posteo.de>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/net/wireless/b43/b43.h  |    5 ++++
 drivers/net/wireless/b43/main.c |   54 +++++++++++++++++++++++++++++----------
 drivers/net/wireless/b43/main.h |    5 ++--
 3 files changed, 48 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/b43/b43.h b/drivers/net/wireless/b43/b43.h
index 7c899fc..ac593ab 100644
--- a/drivers/net/wireless/b43/b43.h
+++ b/drivers/net/wireless/b43/b43.h
@@ -7,6 +7,7 @@
 #include <linux/hw_random.h>
 #include <linux/bcma/bcma.h>
 #include <linux/ssb/ssb.h>
+#include <linux/completion.h>
 #include <net/mac80211.h>
 
 #include "debugfs.h"
@@ -718,6 +719,10 @@ enum b43_firmware_file_type {
 struct b43_request_fw_context {
 	/* The device we are requesting the fw for. */
 	struct b43_wldev *dev;
+	/* a completion event structure needed if this call is asynchronous */
+	struct completion fw_load_complete;
+	/* a pointer to the firmware object */
+	const struct firmware *blob;
 	/* The type of firmware to request. */
 	enum b43_firmware_file_type req_type;
 	/* Error messages for each firmware type. */
diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index a4e020a..823943b 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -2088,11 +2088,18 @@ static void b43_print_fw_helptext(struct b43_wl *wl, bool error)
 		b43warn(wl, text);
 }
 
+static void b43_fw_cb(const struct firmware *firmware, void *context)
+{
+	struct b43_request_fw_context *ctx = context;
+
+	ctx->blob = firmware;
+	complete(&ctx->fw_load_complete);
+}
+
 int b43_do_request_fw(struct b43_request_fw_context *ctx,
 		      const char *name,
-		      struct b43_firmware_file *fw)
+		      struct b43_firmware_file *fw, bool async)
 {
-	const struct firmware *blob;
 	struct b43_fw_header *hdr;
 	u32 size;
 	int err;
@@ -2131,11 +2138,31 @@ int b43_do_request_fw(struct b43_request_fw_context *ctx,
 		B43_WARN_ON(1);
 		return -ENOSYS;
 	}
-	err = request_firmware(&blob, ctx->fwname, ctx->dev->dev->dev);
+	if (async) {
+		/* do this part asynchronously */
+		init_completion(&ctx->fw_load_complete);
+		err = request_firmware_nowait(THIS_MODULE, 1, ctx->fwname,
+					      ctx->dev->dev->dev, GFP_KERNEL,
+					      ctx, b43_fw_cb);
+		if (err < 0) {
+			pr_err("Unable to load firmware\n");
+			return err;
+		}
+		/* stall here until fw ready */
+		wait_for_completion(&ctx->fw_load_complete);
+		if (ctx->blob)
+			goto fw_ready;
+	/* On some ARM systems, the async request will fail, but the next sync
+	 * request works. For this reason, we dall through here
+	 */
+	}
+	err = request_firmware(&ctx->blob, ctx->fwname,
+			       ctx->dev->dev->dev);
 	if (err == -ENOENT) {
 		snprintf(ctx->errors[ctx->req_type],
 			 sizeof(ctx->errors[ctx->req_type]),
-			 "Firmware file \"%s\" not found\n", ctx->fwname);
+			 "Firmware file \"%s\" not found\n",
+			 ctx->fwname);
 		return err;
 	} else if (err) {
 		snprintf(ctx->errors[ctx->req_type],
@@ -2144,14 +2171,15 @@ int b43_do_request_fw(struct b43_request_fw_context *ctx,
 			 ctx->fwname, err);
 		return err;
 	}
-	if (blob->size < sizeof(struct b43_fw_header))
+fw_ready:
+	if (ctx->blob->size < sizeof(struct b43_fw_header))
 		goto err_format;
-	hdr = (struct b43_fw_header *)(blob->data);
+	hdr = (struct b43_fw_header *)(ctx->blob->data);
 	switch (hdr->type) {
 	case B43_FW_TYPE_UCODE:
 	case B43_FW_TYPE_PCM:
 		size = be32_to_cpu(hdr->size);
-		if (size != blob->size - sizeof(struct b43_fw_header))
+		if (size != ctx->blob->size - sizeof(struct b43_fw_header))
 			goto err_format;
 		/* fallthrough */
 	case B43_FW_TYPE_IV:
@@ -2162,7 +2190,7 @@ int b43_do_request_fw(struct b43_request_fw_context *ctx,
 		goto err_format;
 	}
 
-	fw->data = blob;
+	fw->data = ctx->blob;
 	fw->filename = name;
 	fw->type = ctx->req_type;
 
@@ -2172,7 +2200,7 @@ err_format:
 	snprintf(ctx->errors[ctx->req_type],
 		 sizeof(ctx->errors[ctx->req_type]),
 		 "Firmware file \"%s\" format error.\n", ctx->fwname);
-	release_firmware(blob);
+	release_firmware(ctx->blob);
 
 	return -EPROTO;
 }
@@ -2223,7 +2251,7 @@ static int b43_try_request_fw(struct b43_request_fw_context *ctx)
 			goto err_no_ucode;
 		}
 	}
-	err = b43_do_request_fw(ctx, filename, &fw->ucode);
+	err = b43_do_request_fw(ctx, filename, &fw->ucode, true);
 	if (err)
 		goto err_load;
 
@@ -2235,7 +2263,7 @@ static int b43_try_request_fw(struct b43_request_fw_context *ctx)
 	else
 		goto err_no_pcm;
 	fw->pcm_request_failed = false;
-	err = b43_do_request_fw(ctx, filename, &fw->pcm);
+	err = b43_do_request_fw(ctx, filename, &fw->pcm, false);
 	if (err == -ENOENT) {
 		/* We did not find a PCM file? Not fatal, but
 		 * core rev <= 10 must do without hwcrypto then. */
@@ -2296,7 +2324,7 @@ static int b43_try_request_fw(struct b43_request_fw_context *ctx)
 	default:
 		goto err_no_initvals;
 	}
-	err = b43_do_request_fw(ctx, filename, &fw->initvals);
+	err = b43_do_request_fw(ctx, filename, &fw->initvals, false);
 	if (err)
 		goto err_load;
 
@@ -2355,7 +2383,7 @@ static int b43_try_request_fw(struct b43_request_fw_context *ctx)
 	default:
 		goto err_no_initvals;
 	}
-	err = b43_do_request_fw(ctx, filename, &fw->initvals_band);
+	err = b43_do_request_fw(ctx, filename, &fw->initvals_band, false);
 	if (err)
 		goto err_load;
 
diff --git a/drivers/net/wireless/b43/main.h b/drivers/net/wireless/b43/main.h
index 8c684cd..abac25e 100644
--- a/drivers/net/wireless/b43/main.h
+++ b/drivers/net/wireless/b43/main.h
@@ -137,9 +137,8 @@ void b43_mac_phy_clock_set(struct b43_wldev *dev, bool on);
 
 
 struct b43_request_fw_context;
-int b43_do_request_fw(struct b43_request_fw_context *ctx,
-		      const char *name,
-		      struct b43_firmware_file *fw);
+int b43_do_request_fw(struct b43_request_fw_context *ctx, const char *name,
+		      struct b43_firmware_file *fw, bool async);
 void b43_do_release_fw(struct b43_firmware_file *fw);
 
 #endif /* B43_MAIN_H_ */
-- 
1.7.9.5

