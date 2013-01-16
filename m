Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758198Ab3APQDf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 11:03:35 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:36101 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758181Ab3APQDd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 11:03:33 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 090/222] b43legacy: Fix firmware loading when driver is built into the kernel
Date: Wed, 16 Jan 2013 13:54:50 -0200
Message-Id: <1358351822-7675-91-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Larry Finger <Larry.Finger@lwfinger.net>

commit 576d28a7c73013717311cfcb514dbcae27c82eeb upstream.

Recent versions of udev cause synchronous firmware loading from the
probe routine to fail because the request to user space times out.
The original fix for b43legacy (commit a3ea2c7) moved the firmware
load from the probe routine to a work queue, but it still used synchronous
firmware loading. This method is OK when b43legacy is built as a module;
however, it fails when the driver is compiled into the kernel.

This version changes the code to load the initial firmware file
using request_firmware_nowait(). A completion event is used to
hold the work queue until that file is available. The remaining
firmware files are read synchronously.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/net/wireless/b43legacy/b43legacy.h |    5 ++++
 drivers/net/wireless/b43legacy/main.c      |   37 +++++++++++++++++++++++-----
 2 files changed, 36 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/b43legacy/b43legacy.h b/drivers/net/wireless/b43legacy/b43legacy.h
index a29da67..482476f 100644
--- a/drivers/net/wireless/b43legacy/b43legacy.h
+++ b/drivers/net/wireless/b43legacy/b43legacy.h
@@ -13,6 +13,7 @@
 
 #include <linux/ssb/ssb.h>
 #include <linux/ssb/ssb_driver_chipcommon.h>
+#include <linux/completion.h>
 
 #include <net/mac80211.h>
 
@@ -733,6 +734,10 @@ struct b43legacy_wldev {
 
 	/* Firmware data */
 	struct b43legacy_firmware fw;
+	const struct firmware *fwp;	/* needed to pass fw pointer */
+
+	/* completion struct for firmware loading */
+	struct completion fw_load_complete;
 
 	/* Devicelist in struct b43legacy_wl (all 802.11 cores) */
 	struct list_head list;
diff --git a/drivers/net/wireless/b43legacy/main.c b/drivers/net/wireless/b43legacy/main.c
index de1d9d5..0366dcc 100644
--- a/drivers/net/wireless/b43legacy/main.c
+++ b/drivers/net/wireless/b43legacy/main.c
@@ -1513,9 +1513,17 @@ static void b43legacy_print_fw_helptext(struct b43legacy_wl *wl)
 		     "and download the correct firmware (version 3).\n");
 }
 
+static void b43legacy_fw_cb(const struct firmware *firmware, void *context)
+{
+	struct b43legacy_wldev *dev = context;
+
+	dev->fwp = firmware;
+	complete(&dev->fw_load_complete);
+}
+
 static int do_request_fw(struct b43legacy_wldev *dev,
 			 const char *name,
-			 const struct firmware **fw)
+			 const struct firmware **fw, bool async)
 {
 	char path[sizeof(modparam_fwpostfix) + 32];
 	struct b43legacy_fw_header *hdr;
@@ -1528,7 +1536,24 @@ static int do_request_fw(struct b43legacy_wldev *dev,
 	snprintf(path, ARRAY_SIZE(path),
 		 "b43legacy%s/%s.fw",
 		 modparam_fwpostfix, name);
-	err = request_firmware(fw, path, dev->dev->dev);
+	b43legacyinfo(dev->wl, "Loading firmware %s\n", path);
+	if (async) {
+		init_completion(&dev->fw_load_complete);
+		err = request_firmware_nowait(THIS_MODULE, 1, path,
+					      dev->dev->dev, GFP_KERNEL,
+					      dev, b43legacy_fw_cb);
+		if (err) {
+			b43legacyerr(dev->wl, "Unable to load firmware\n");
+			return err;
+		}
+		/* stall here until fw ready */
+		wait_for_completion(&dev->fw_load_complete);
+		if (!dev->fwp)
+			err = -EINVAL;
+		*fw = dev->fwp;
+	} else {
+		err = request_firmware(fw, path, dev->dev->dev);
+	}
 	if (err) {
 		b43legacyerr(dev->wl, "Firmware file \"%s\" not found "
 		       "or load failed.\n", path);
@@ -1580,7 +1605,7 @@ static void b43legacy_request_firmware(struct work_struct *work)
 			filename = "ucode4";
 		else
 			filename = "ucode5";
-		err = do_request_fw(dev, filename, &fw->ucode);
+		err = do_request_fw(dev, filename, &fw->ucode, true);
 		if (err)
 			goto err_load;
 	}
@@ -1589,7 +1614,7 @@ static void b43legacy_request_firmware(struct work_struct *work)
 			filename = "pcm4";
 		else
 			filename = "pcm5";
-		err = do_request_fw(dev, filename, &fw->pcm);
+		err = do_request_fw(dev, filename, &fw->pcm, false);
 		if (err)
 			goto err_load;
 	}
@@ -1607,7 +1632,7 @@ static void b43legacy_request_firmware(struct work_struct *work)
 		default:
 			goto err_no_initvals;
 		}
-		err = do_request_fw(dev, filename, &fw->initvals);
+		err = do_request_fw(dev, filename, &fw->initvals, false);
 		if (err)
 			goto err_load;
 	}
@@ -1627,7 +1652,7 @@ static void b43legacy_request_firmware(struct work_struct *work)
 		default:
 			goto err_no_initvals;
 		}
-		err = do_request_fw(dev, filename, &fw->initvals_band);
+		err = do_request_fw(dev, filename, &fw->initvals_band, false);
 		if (err)
 			goto err_load;
 	}
-- 
1.7.9.5

