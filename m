Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756661AbbAWWHa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 17:07:30 -0500
Received: from mail-qg0-f50.google.com ([209.85.192.50]:60027 "EHLO
	mail-qg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038AbbAWWHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 17:07:25 -0500
Date: Fri, 23 Jan 2015 17:07:21 -0500 (EST)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc: linux-kernel@vger.kernel.org, Dave Mielke <dave@mielke.cc>
Subject: [PATCH] vt: provide notifications on selection changes
Message-ID: <alpine.LFD.2.11.1501231636200.1322@knanqh.ubzr>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The vcs device's poll/fasync support relies on the vt notifier to signal
changes to the screen content.  Notifier invocations were missing for
changes that comes through the selection interface though.  Fix that.

Tested with BRLTTY 5.2.

Signed-off-by: Nicolas Pitre <nico@linaro.org>
Cc: Dave Mielke <dave@mielke.cc>

---

Greg: Would be highly convenient to have this patch applied to the 
stable tree as well to help affected blind Linux users via distro 
updates.  Yet it took a while before this issue was discovered. Your 
call.

diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
index f7f5ed1..84252a0 100644
--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -502,6 +502,7 @@ void invert_screen(struct vc_data *vc, int offset, int count, int viewed)
 #endif
 	if (DO_UPDATE(vc))
 		do_update_region(vc, (unsigned long) p, count);
+	notify_update(vc);
 }
 
 /* used by selection: complement pointer position */
@@ -518,6 +519,7 @@ void complement_pos(struct vc_data *vc, int offset)
 		scr_writew(old, screenpos(vc, old_offset, 1));
 		if (DO_UPDATE(vc))
 			vc->vc_sw->con_putc(vc, old, oldy, oldx);
+		notify_update(vc);
 	}
 
 	old_offset = offset;
@@ -535,8 +537,8 @@ void complement_pos(struct vc_data *vc, int offset)
 			oldy = (offset >> 1) / vc->vc_cols;
 			vc->vc_sw->con_putc(vc, new, oldy, oldx);
 		}
+		notify_update(vc);
 	}
-
 }
 
 static void insert_char(struct vc_data *vc, unsigned int nr)
