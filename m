Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752264AbaAMXbs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 18:31:48 -0500
Received: from p3plsmtps2ded04.prod.phx3.secureserver.net ([208.109.80.198]:34253
	"EHLO p3plsmtps2ded04.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751473AbaAMXbp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 18:31:45 -0500
x-originating-ip: 72.167.245.219
From: Haiyang Zhang <haiyangz@microsoft.com>
To: FlorianSchandinat@gmx.de, akpm@linux-foundation.org,
        linux-fbdev@vger.kernel.org
Cc: haiyangz@microsoft.com, kys@microsoft.com, olaf@aepfle.de,
        jasowang@redhat.com, linux-kernel@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org
Subject: [PATCH] hyperv_fb: Add screen refresh after pause/resume operation
Date: Mon, 13 Jan 2014 16:20:38 -0800
Message-Id: <1389658838-15765-1-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is necessary because after VM is pause/resumed, some portion of
the screen may need refresh.

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Reviewed-by: K. Y. Srinivasan <kys@microsoft.com>
---
 drivers/video/hyperv_fb.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/drivers/video/hyperv_fb.c b/drivers/video/hyperv_fb.c
index 130708f..bbcc8c0 100644
--- a/drivers/video/hyperv_fb.c
+++ b/drivers/video/hyperv_fb.c
@@ -218,6 +218,7 @@ struct hvfb_par {
 
 	struct delayed_work dwork;
 	bool update;
+	bool xrefresh;
 
 	u32 pseudo_palette[16];
 	u8 init_buf[MAX_VMBUS_PKT_SIZE];
@@ -369,7 +370,7 @@ static void synthvid_recv_sub(struct hv_device *hdev)
 			synthvid_send_situ(hdev);
 		}
 
-		par->update = msg->feature_chg.is_dirt_needed;
+		par->xrefresh = par->update = msg->feature_chg.is_dirt_needed;
 		if (par->update)
 			schedule_delayed_work(&par->dwork, HVFB_UPDATE_DELAY);
 	}
@@ -522,6 +523,13 @@ static void hvfb_update_work(struct work_struct *w)
 {
 	struct hvfb_par *par = container_of(w, struct hvfb_par, dwork.work);
 	struct fb_info *info = par->info;
+	char *argv[] = {"/usr/bin/xrefresh", "-display", ":0.0", NULL};
+	char *envp[] = {"HOME=/", "PATH=/sbin:/usr/sbin:/bin:/usr/bin", NULL };
+
+	if (par->xrefresh) {
+		par->xrefresh = false;
+		call_usermodehelper(argv[0], argv, envp, UMH_NO_WAIT);
+	}
 
 	if (par->fb_ready)
 		synthvid_update(info);
-- 
1.7.4.1

