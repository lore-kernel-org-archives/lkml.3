Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752015AbaFEO7g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 10:59:36 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:56735 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314AbaFEO7e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 10:59:34 -0400
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Intel Graphics Development <intel-gfx@lists.freedesktop.org>
Cc: DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 2/5] vt: Fix up unregistration of vt drivers
Date: Thu,  5 Jun 2014 16:58:25 +0200
Message-Id: <1401980308-5116-2-git-send-email-daniel.vetter@ffwll.ch>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1401980308-5116-1-git-send-email-daniel.vetter@ffwll.ch>
References: <1401980308-5116-1-git-send-email-daniel.vetter@ffwll.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A bunch of issues:
- We should not kick out the default console (which is tracked in
  conswitchp), so check for that.
- Add better error codes so callers can differentiate between "something
  went wrong" and "your driver isn't registered already". i915 needs
  that so it doesn't fall over when reloading the driver and hence
  vga_con is already unregistered.
- There's a mess with the driver flags: What we need to check for is
  that the driver isn't used any more, i.e. unbound completely (FLAG_INIT).
  And not whether it's the boot console or not (which is the only one
  which doesn't have FLAG_MODULE). Otherwise there's no way to kick
  out the boot console, which i915 wants to do to prevent havoc with
  vga_con interferring (which tends to hang machines).

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
---
 drivers/tty/vt/vt.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
index ea600f482eeb..5077fe87324d 100644
--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -3573,17 +3573,20 @@ err:
  */
 int do_unregister_con_driver(const struct consw *csw)
 {
-	int i, retval = -ENODEV;
+	int i;
 
 	/* cannot unregister a bound driver */
 	if (con_is_bound(csw))
-		goto err;
+		return -EBUSY;
+
+	if (csw == conswitchp)
+		return -EINVAL;
 
 	for (i = 0; i < MAX_NR_CON_DRIVER; i++) {
 		struct con_driver *con_driver = &registered_con_driver[i];
 
 		if (con_driver->con == csw &&
-		    con_driver->flag & CON_DRIVER_FLAG_MODULE) {
+		    con_driver->flag & CON_DRIVER_FLAG_INIT) {
 			vtconsole_deinit_device(con_driver);
 			device_destroy(vtconsole_class,
 				       MKDEV(0, con_driver->node));
@@ -3594,12 +3597,11 @@ int do_unregister_con_driver(const struct consw *csw)
 			con_driver->flag = 0;
 			con_driver->first = 0;
 			con_driver->last = 0;
-			retval = 0;
-			break;
+			return 0;
 		}
 	}
-err:
-	return retval;
+
+	return -ENODEV;
 }
 EXPORT_SYMBOL_GPL(do_unregister_con_driver);
 
-- 
1.8.1.4

