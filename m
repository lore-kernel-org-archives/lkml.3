Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752478Ab3LaJKf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Dec 2013 04:10:35 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:39299 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752027Ab3LaJKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Dec 2013 04:10:32 -0500
Date: Tue, 31 Dec 2013 17:09:32 +0800
From: Wang YanQing <udknight@gmail.com>
To: gregkh@linuxfoundation.org
Cc: jslaby@suse.cz, airlied@redhat.com, akpm@linux-foundation.org,
        kilobyte@angband.pl, linux-kernel@vger.kernel.org
Subject: [PATCH ]vt: use vc_allocate in con_init
Message-ID: <20131231090932.GA3223@udknight>
Mail-Followup-To: Wang YanQing <udknight@gmail.com>,
	gregkh@linuxfoundation.org, jslaby@suse.cz, airlied@redhat.com,
	akpm@linux-foundation.org, kilobyte@angband.pl,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After commit a5f4f52e82114e85aa1a066bd1a450acc19a464d
("vt: use kzalloc() instead of the bootmem allocator"),
then we could use vc_allocate in con_init.

The benefit we get:
1: reduce code duplication
2: vc_allocate is more robust

Signed-off-by: Wang YanQing <udknight@gmail.com>
---
 drivers/tty/vt/vt.c       | 25 +++++++++++--------------
 drivers/tty/vt/vt_ioctl.c |  8 ++++----
 include/linux/vt_kern.h   |  2 +-
 3 files changed, 16 insertions(+), 19 deletions(-)

diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
index 15aaa01..8723cb4 100644
--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -748,7 +748,7 @@ static void visual_init(struct vc_data *vc, int num, int init)
 	vc->vc_screenbuf_size = vc->vc_rows * vc->vc_size_row;
 }
 
-int vc_allocate(unsigned int currcons)	/* return 0 on success */
+int vc_allocate(unsigned int currcons, int early)	/* return 0 on success */
 {
 	WARN_CONSOLE_UNLOCKED();
 
@@ -789,9 +789,11 @@ int vc_allocate(unsigned int currcons)	/* return 0 on success */
 	    if (global_cursor_default == -1)
 		    global_cursor_default = 1;
 
-	    vc_init(vc, vc->vc_rows, vc->vc_cols, 1);
-	    vcs_make_sysfs(currcons);
-	    atomic_notifier_call_chain(&vt_notifier_list, VT_ALLOCATE, &param);
+	    vc_init(vc, vc->vc_rows, vc->vc_cols, currcons == 0 ? !vc->vc_sw->con_save_screen : 1);
+	    if (!early) {
+		    vcs_make_sysfs(currcons);
+		    atomic_notifier_call_chain(&vt_notifier_list, VT_ALLOCATE, &param);
+	    }
 	}
 	return 0;
 }
@@ -2765,7 +2767,7 @@ static int con_install(struct tty_driver *driver, struct tty_struct *tty)
 	int ret;
 
 	console_lock();
-	ret = vc_allocate(currcons);
+	ret = vc_allocate(currcons, 0);
 	if (ret)
 		goto unlock;
 
@@ -2901,15 +2903,10 @@ static int __init con_init(void)
 		mod_timer(&console_timer, jiffies + (blankinterval * HZ));
 	}
 
-	for (currcons = 0; currcons < MIN_NR_CONSOLES; currcons++) {
-		vc_cons[currcons].d = vc = kzalloc(sizeof(struct vc_data), GFP_NOWAIT);
-		INIT_WORK(&vc_cons[currcons].SAK_work, vc_SAK);
-		tty_port_init(&vc->port);
-		visual_init(vc, currcons, 1);
-		vc->vc_screenbuf = kzalloc(vc->vc_screenbuf_size, GFP_NOWAIT);
-		vc_init(vc, vc->vc_rows, vc->vc_cols,
-			currcons || !vc->vc_sw->con_save_screen);
-	}
+	for (currcons = 0; currcons < MIN_NR_CONSOLES; currcons++)
+		if (vc_allocate(currcons, 1))
+			panic("Can't initialize console %d!", currcons + 1);
+
 	currcons = fg_console = 0;
 	master_display_fg = vc = vc_cons[currcons].d;
 	set_origin(vc);
diff --git a/drivers/tty/vt/vt_ioctl.c b/drivers/tty/vt/vt_ioctl.c
index 2bd78e2..59667c1 100644
--- a/drivers/tty/vt/vt_ioctl.c
+++ b/drivers/tty/vt/vt_ioctl.c
@@ -680,7 +680,7 @@ int vt_ioctl(struct tty_struct *tty,
 		else {
 			arg--;
 			console_lock();
-			ret = vc_allocate(arg);
+			ret = vc_allocate(arg, 0);
 			console_unlock();
 			if (ret)
 				break;
@@ -705,7 +705,7 @@ int vt_ioctl(struct tty_struct *tty,
 		else {
 			vsa.console--;
 			console_lock();
-			ret = vc_allocate(vsa.console);
+			ret = vc_allocate(vsa.console, 0);
 			if (ret == 0) {
 				struct vc_data *nvc;
 				/* This is safe providing we don't drop the
@@ -778,7 +778,7 @@ int vt_ioctl(struct tty_struct *tty,
 				int newvt;
 				newvt = vc->vt_newvt;
 				vc->vt_newvt = -1;
-				ret = vc_allocate(newvt);
+				ret = vc_allocate(newvt, 0);
 				if (ret) {
 					console_unlock();
 					break;
@@ -1441,7 +1441,7 @@ int vt_move_to_console(unsigned int vt, int alloc)
 	}
 	prev = fg_console;
 
-	if (alloc && vc_allocate(vt)) {
+	if (alloc && vc_allocate(vt, 0)) {
 		/* we can't have a free VC for now. Too bad,
 		 * we don't want to mess the screen for now. */
 		console_unlock();
diff --git a/include/linux/vt_kern.h b/include/linux/vt_kern.h
index 8d76342..96d8795 100644
--- a/include/linux/vt_kern.h
+++ b/include/linux/vt_kern.h
@@ -33,7 +33,7 @@ extern int fg_console, last_console, want_console;
 
 /* console.c */
 
-int vc_allocate(unsigned int console);
+int vc_allocate(unsigned int console, int early);
 int vc_cons_allocated(unsigned int console);
 int vc_resize(struct vc_data *vc, unsigned int cols, unsigned int lines);
 struct vc_data *vc_deallocate(unsigned int console);
-- 
1.8.3.4.8.g69490f3.dirty
