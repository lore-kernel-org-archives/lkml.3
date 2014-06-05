Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752171AbaFEO75 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 10:59:57 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:43730 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752036AbaFEO7i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 10:59:38 -0400
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Intel Graphics Development <intel-gfx@lists.freedesktop.org>
Cc: DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3/5] vt: Don't ignore unbind errors in vt_unbind
Date: Thu,  5 Jun 2014 16:58:26 +0200
Message-Id: <1401980308-5116-3-git-send-email-daniel.vetter@ffwll.ch>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1401980308-5116-1-git-send-email-daniel.vetter@ffwll.ch>
References: <1401980308-5116-1-git-send-email-daniel.vetter@ffwll.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Otherwise the loop will never stop since we don't make any
forward progress. Noticed while breaking this accidentally
in a painful attempt to make vga_con unregistering work.

With this patch we'll bail out on the first attempt, which
at least leaves a useful enough system behind for debugging.
Livelocks on console_lock just aren't fun.

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
---
 drivers/tty/vt/vt.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
index 5077fe87324d..3c00dcb3b145 100644
--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -3260,6 +3260,7 @@ static int vt_unbind(struct con_driver *con)
 {
 	const struct consw *csw = NULL;
 	int i, more = 1, first = -1, last = -1, deflt = 0;
+	int ret;
 
  	if (!con->con || !(con->flag & CON_DRIVER_FLAG_MODULE) ||
 	    con_is_graphics(con->con, con->first, con->last))
@@ -3285,8 +3286,10 @@ static int vt_unbind(struct con_driver *con)
 
 		if (first != -1) {
 			console_lock();
-			do_unbind_con_driver(csw, first, last, deflt);
+			ret = do_unbind_con_driver(csw, first, last, deflt);
 			console_unlock();
+			if (ret != 0)
+				return ret;
 		}
 
 		first = -1;
-- 
1.8.1.4

