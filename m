Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751797AbaFEO7c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 10:59:32 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:53433 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314AbaFEO7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 10:59:31 -0400
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Intel Graphics Development <intel-gfx@lists.freedesktop.org>
Cc: DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 1/5] vt: Fix replacement console check when unbinding
Date: Thu,  5 Jun 2014 16:58:24 +0200
Message-Id: <1401980308-5116-1-git-send-email-daniel.vetter@ffwll.ch>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I don't fully understand the magic of the vt register/unregister
logic, but apparently everything but the inital console (as set
in the conswitchp pointer) is marked with FLAG_MODULE. Which means
if something unregistered the boot vt driver (e.g. i915.ko kicking
out vga_con) there's nothing left when trying to unbind e.g. fbcon
through sysfs.

But we always have the dummy console hanging around, so this test
is fairly dubious. What we actually want is simply a different console
than the one we want to unbind.

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
---
 drivers/tty/vt/vt.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
index 3ad0b61e35b4..ea600f482eeb 100644
--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -3155,8 +3155,7 @@ int do_unbind_con_driver(const struct consw *csw, int first, int last, int deflt
 	for (i = 0; i < MAX_NR_CON_DRIVER; i++) {
 		con_back = &registered_con_driver[i];
 
-		if (con_back->con &&
-		    !(con_back->flag & CON_DRIVER_FLAG_MODULE)) {
+		if (con_back->con && con_back->con != csw) {
 			defcsw = con_back->con;
 			retval = 0;
 			break;
-- 
1.8.1.4

