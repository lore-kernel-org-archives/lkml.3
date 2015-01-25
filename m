Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757160AbbAYSiL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 13:38:11 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57901 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755922AbbAYSKS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 13:10:18 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
Subject: [PATCH 3.18 103/183] video/fbdev: fix defios fsync
Date: Sun, 25 Jan 2015 10:07:05 -0800
Message-Id: <20150125180814.694268189@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150125180810.160428929@linuxfoundation.org>
References: <20150125180810.160428929@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomi Valkeinen <tomi.valkeinen@ti.com>

commit 30ea9c5218651bc11cbdba7820be78f04e2d83bc upstream.

fb_deferred_io_fsync() returns the value of schedule_delayed_work() as
an error code, but schedule_delayed_work() does not return an error. It
returns true/false depending on whether the work was already queued.

Fix this by ignoring the return value of schedule_delayed_work().

Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/video/fbdev/core/fb_defio.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/video/fbdev/core/fb_defio.c
+++ b/drivers/video/fbdev/core/fb_defio.c
@@ -83,9 +83,10 @@ int fb_deferred_io_fsync(struct file *fi
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
 


