Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933179AbbA0Mwc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 07:52:32 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34828 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758125AbbA0MQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 07:16:57 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 008/126] video/fbdev: fix defio's fsync
Date: Tue, 27 Jan 2015 12:15:13 +0000
Message-Id: <1422361031-19364-9-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
References: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomi Valkeinen <tomi.valkeinen@ti.com>

commit 30ea9c5218651bc11cbdba7820be78f04e2d83bc upstream.

fb_deferred_io_fsync() returns the value of schedule_delayed_work() as
an error code, but schedule_delayed_work() does not return an error. It
returns true/false depending on whether the work was already queued.

Fix this by ignoring the return value of schedule_delayed_work().

Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/video/fbdev/core/fb_defio.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/video/fbdev/core/fb_defio.c b/drivers/video/fbdev/core/fb_defio.c
index 900aa4ecd617..d6cab1fd9a47 100644
--- a/drivers/video/fbdev/core/fb_defio.c
+++ b/drivers/video/fbdev/core/fb_defio.c
@@ -83,9 +83,10 @@ int fb_deferred_io_fsync(struct file *file, loff_t start, loff_t end, int datasy
 	cancel_delayed_work_sync(&info->deferred_work);
 
 	/* Run it immediately */
-	err = schedule_delayed_work(&info->deferred_work, 0);
+	schedule_delayed_work(&info->deferred_work, 0);
 	mutex_unlock(&inode->i_mutex);
-	return err;
+
+	return 0;
 }
 EXPORT_SYMBOL_GPL(fb_deferred_io_fsync);
 
-- 
2.1.4

