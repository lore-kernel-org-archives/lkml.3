Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752240AbaFFJnM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 05:43:12 -0400
Received: from mail-we0-f176.google.com ([74.125.82.176]:60734 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751390AbaFFJnK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 05:43:10 -0400
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Intel Graphics Development <intel-gfx@lists.freedesktop.org>
Cc: DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, David Herrmann <dh.herrmann@gmail.com>
Subject: [PATCH] vt: Fix replacement console check when unbinding
Date: Fri,  6 Jun 2014 11:43:01 +0200
Message-Id: <1402047781-7241-1-git-send-email-daniel.vetter@ffwll.ch>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1401980308-5116-1-git-send-email-daniel.vetter@ffwll.ch>
References: <1401980308-5116-1-git-send-email-daniel.vetter@ffwll.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I don't fully understand the magic of the vt register/unregister
logic, but apparently everything but the inital console (as set
in the conswitchp pointer) is marked with FLAG_MODULE. Which means
if something unregistered the boot vt driver (e.g. i915.ko kicking
out vga_con) there's nothing left when trying to unbind e.g. fbcon
through sysfs.

But in most cases have the dummy console hanging around besides the
boot console, so this test is fairly dubious. What we actually want is
simply a different console than the one we want to unbind.

v2: Correct the commit message to clarify that the dummy console isn't
always around, but only in most cases (David).

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>
Cc: David Herrmann <dh.herrmann@gmail.com>
Reviewed-by: David Herrmann <dh.herrmann@gmail.com>
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

