Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754689AbaAGXOt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 18:14:49 -0500
Received: from mail-pd0-f178.google.com ([209.85.192.178]:41856 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753007AbaAGXOj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 18:14:39 -0500
Date: Wed, 8 Jan 2014 07:13:10 +0800
From: Wang YanQing <udknight@gmail.com>
To: gregkh@linuxfoundation.org
Cc: jslaby@suse.cz, airlied@redhat.com, akpm@linux-foundation.org,
        kilobyte@angband.pl, peter@hurleysoftware.com, rosslagerwall@gmail.com,
        tiwai@suse.de, linux-kernel@vger.kernel.org
Subject: [PATCH v4]vt: use vc_allocate in con_init
Message-ID: <20140107231310.GA3397@udknight>
Mail-Followup-To: Wang YanQing <udknight@gmail.com>,
	gregkh@linuxfoundation.org, jslaby@suse.cz, airlied@redhat.com,
	akpm@linux-foundation.org, kilobyte@angband.pl,
	peter@hurleysoftware.com, rosslagerwall@gmail.com, tiwai@suse.de,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After a5f4f52e82114e85aa1a066bd1a450acc19a464d
("vt: use kzalloc() instead of the bootmem allocator"),
con_init began to use kzalloc to initialize vc_data,
this patch convert con_init to use vc_allocate.

The benefit we get:
1: reduce code duplication
2: vc_allocate is more robust
3: use kmalloc instead of kzalloc for vc_screenbuf

Signed-off-by: Wang YanQing <udknight@gmail.com>
---
 this patch don't have v2 :) I jump to v3 directly
 from v1, but I keep the mistake for less confusion.

 Changes v3-v4:
 1: use bool/true/false instead of int/1/0

 Thanks for Jiri Slaby

 drivers/tty/vt/vt.c       | 28 ++++++++++++++--------------
 drivers/tty/vt/vt_ioctl.c |  8 ++++----
 include/linux/vt_kern.h   |  2 +-
 3 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
index 15aaa01..c0d6255 100644
--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -748,7 +748,8 @@ static void visual_init(struct vc_data *vc, int num, int init)
 	vc->vc_screenbuf_size = vc->vc_rows * vc->vc_size_row;
 }
 
-int vc_allocate(unsigned int currcons)	/* return 0 on success */
+/* return 0 on success */
+int vc_allocate(unsigned int currcons, bool early)
 {
 	WARN_CONSOLE_UNLOCKED();
 
@@ -789,9 +790,13 @@ int vc_allocate(unsigned int currcons)	/* return 0 on success */
 	    if (global_cursor_default == -1)
 		    global_cursor_default = 1;
 
-	    vc_init(vc, vc->vc_rows, vc->vc_cols, 1);
-	    vcs_make_sysfs(currcons);
-	    atomic_notifier_call_chain(&vt_notifier_list, VT_ALLOCATE, &param);
+	    vc_init(vc, vc->vc_rows, vc->vc_cols,
+		    currcons == 0 ? !vc->vc_sw->con_save_screen : 1);
+	    if (!early) {
+		vcs_make_sysfs(currcons);
+		atomic_notifier_call_chain(&vt_notifier_list, VT_ALLOCATE,
+					   &param);
+	    }
 	}
 	return 0;
 }
@@ -2765,7 +2770,7 @@ static int con_install(struct tty_driver *driver, struct tty_struct *tty)
 	int ret;
 
 	console_lock();
-	ret = vc_allocate(currcons);
+	ret = vc_allocate(currcons, false);
 	if (ret)
 		goto unlock;
 
@@ -2901,15 +2906,10 @@ static int __init con_init(void)
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
+		if (vc_allocate(currcons, true))
+			panic("Can't initialize console %d!", currcons + 1);
+
 	currcons = fg_console = 0;
 	master_display_fg = vc = vc_cons[currcons].d;
 	set_origin(vc);
diff --git a/drivers/tty/vt/vt_ioctl.c b/drivers/tty/vt/vt_ioctl.c
index 2bd78e2..2f78d25 100644
--- a/drivers/tty/vt/vt_ioctl.c
+++ b/drivers/tty/vt/vt_ioctl.c
@@ -680,7 +680,7 @@ int vt_ioctl(struct tty_struct *tty,
 		else {
 			arg--;
 			console_lock();
-			ret = vc_allocate(arg);
+			ret = vc_allocate(arg, false);
 			console_unlock();
 			if (ret)
 				break;
@@ -705,7 +705,7 @@ int vt_ioctl(struct tty_struct *tty,
 		else {
 			vsa.console--;
 			console_lock();
-			ret = vc_allocate(vsa.console);
+			ret = vc_allocate(vsa.console, false);
 			if (ret == 0) {
 				struct vc_data *nvc;
 				/* This is safe providing we don't drop the
@@ -778,7 +778,7 @@ int vt_ioctl(struct tty_struct *tty,
 				int newvt;
 				newvt = vc->vt_newvt;
 				vc->vt_newvt = -1;
-				ret = vc_allocate(newvt);
+				ret = vc_allocate(newvt, false);
 				if (ret) {
 					console_unlock();
 					break;
@@ -1441,7 +1441,7 @@ int vt_move_to_console(unsigned int vt, int alloc)
 	}
 	prev = fg_console;
 
-	if (alloc && vc_allocate(vt)) {
+	if (alloc && vc_allocate(vt, false)) {
 		/* we can't have a free VC for now. Too bad,
 		 * we don't want to mess the screen for now. */
 		console_unlock();
diff --git a/include/linux/vt_kern.h b/include/linux/vt_kern.h
index 8d76342..89cfa33 100644
--- a/include/linux/vt_kern.h
+++ b/include/linux/vt_kern.h
@@ -33,7 +33,7 @@ extern int fg_console, last_console, want_console;
 
 /* console.c */
 
-int vc_allocate(unsigned int console);
+int vc_allocate(unsigned int console, bool early);
 int vc_cons_allocated(unsigned int console);
 int vc_resize(struct vc_data *vc, unsigned int cols, unsigned int lines);
 struct vc_data *vc_deallocate(unsigned int console);
-- 
1.8.3.4.8.g69490f3.dirty
