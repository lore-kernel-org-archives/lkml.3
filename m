Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758254Ab3EHSOv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 14:14:51 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:49722 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757655Ab3EHSOs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 14:14:48 -0400
Date: Thu, 9 May 2013 02:14:39 +0800
From: Wang YanQing <udknight@gmail.com>
To: gregkh@linuxfoundation.org
Cc: jslaby@suse.cz, alan@linux.intel.com, airlied@redhat.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 8/9] fbcon: convert last two unregister_con_driver call to
 do_unregister_con_driver
Message-ID: <20130508181439.GI12344@udknight>
Mail-Followup-To: Wang YanQing <udknight@gmail.com>,
	gregkh@linuxfoundation.org, jslaby@suse.cz, alan@linux.intel.com,
	airlied@redhat.com, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


There are only two place use unregister_con_driver now, this patch
convert them to do_unregister_con_driver too, then we can delete
unregister_con_driver whos function can be achieved with do_unregister_con_driver
easily to reduce code size and duplication.

Signed-off-by: Wang YanQing <udknight@gmail.com>
---
 drivers/tty/vt/vt.c           | 4 +++-
 drivers/video/console/fbcon.c | 2 +-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
index d5bfa86..8f4a71a 100644
--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -3631,7 +3631,9 @@ EXPORT_SYMBOL_GPL(do_take_over_console);
  */
 void give_up_console(const struct consw *csw)
 {
-	unregister_con_driver(csw);
+	console_lock();
+	do_unregister_con_driver(csw);
+	console_unlock();
 }
 
 static int __init vtconsole_class_init(void)
diff --git a/drivers/video/console/fbcon.c b/drivers/video/console/fbcon.c
index 47b9353..e0dd275 100644
--- a/drivers/video/console/fbcon.c
+++ b/drivers/video/console/fbcon.c
@@ -3619,8 +3619,8 @@ static void __exit fb_console_exit(void)
 	fbcon_deinit_device();
 	device_destroy(fb_class, MKDEV(0, 0));
 	fbcon_exit();
+	do_unregister_con_driver(&fb_con);
 	console_unlock();
-	unregister_con_driver(&fb_con);
 }	
 
 module_exit(fb_console_exit);
-- 
1.7.12.4.dirty
