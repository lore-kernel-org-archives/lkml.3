Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755531Ab3EQQlr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 12:41:47 -0400
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:43325 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753602Ab3EQQlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 12:41:45 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        Peter Hurley <peter@hurleysoftware.com>, Dave Jones <davej@redhat.com>
Subject: [PATCH] tty/vt: Fix vc_deallocate() lock order
Date: Fri, 17 May 2013 12:41:03 -0400
Message-Id: <1368808863-5919-1-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <20130507180009.GA16771@redhat.com>
References: <20130507180009.GA16771@redhat.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that the tty port owns the flip buffers and i/o is allowed
from the driver even when no tty is attached, the destruction
of the tty port (and the flip buffers) must ensure that no
outstanding work is pending.

Unfortunately, this creates a lock order problem with the
console_lock (see attached lockdep report [1] below).

For single console deallocation, drop the console_lock prior
to port destruction. When multiple console deallocation,
defer port destruction until the consoles have been
deallocated.

tty_port_destroy() is not required if the port has not
been used; remove from vc_allocate() failure path.

[1] lockdep report from Dave Jones <davej@redhat.com>

 ======================================================
 [ INFO: possible circular locking dependency detected ]
 3.9.0+ #16 Not tainted
 -------------------------------------------------------
 (agetty)/26163 is trying to acquire lock:
 blocked:  ((&buf->work)){+.+...}, instance: ffff88011c8b0020, at: [<ffffffff81062065>] flush_work+0x5/0x2e0

 but task is already holding lock:
 blocked:  (console_lock){+.+.+.}, instance: ffffffff81c2fde0, at: [<ffffffff813bc201>] vt_ioctl+0xb61/0x1230

 which lock already depends on the new lock.

 the existing dependency chain (in reverse order) is:

 -> #1 (console_lock){+.+.+.}:
        [<ffffffff810b3f74>] lock_acquire+0xa4/0x210
        [<ffffffff810416c7>] console_lock+0x77/0x80
        [<ffffffff813c3dcd>] con_flush_chars+0x2d/0x50
        [<ffffffff813b32b2>] n_tty_receive_buf+0x122/0x14d0
        [<ffffffff813b7709>] flush_to_ldisc+0x119/0x170
        [<ffffffff81064381>] process_one_work+0x211/0x700
        [<ffffffff8106498b>] worker_thread+0x11b/0x3a0
        [<ffffffff8106ce5d>] kthread+0xed/0x100
        [<ffffffff81601cac>] ret_from_fork+0x7c/0xb0

 -> #0 ((&buf->work)){+.+...}:
        [<ffffffff810b349a>] __lock_acquire+0x193a/0x1c00
        [<ffffffff810b3f74>] lock_acquire+0xa4/0x210
        [<ffffffff810620ae>] flush_work+0x4e/0x2e0
        [<ffffffff81065305>] __cancel_work_timer+0x95/0x130
        [<ffffffff810653b0>] cancel_work_sync+0x10/0x20
        [<ffffffff813b8212>] tty_port_destroy+0x12/0x20
        [<ffffffff813c65e8>] vc_deallocate+0xf8/0x110
        [<ffffffff813bc20c>] vt_ioctl+0xb6c/0x1230
        [<ffffffff813b01a5>] tty_ioctl+0x285/0xd50
        [<ffffffff811ba825>] do_vfs_ioctl+0x305/0x530
        [<ffffffff811baad1>] sys_ioctl+0x81/0xa0
        [<ffffffff81601d59>] system_call_fastpath+0x16/0x1b

 other info that might help us debug this:

 [ 6760.076175]  Possible unsafe locking scenario:

        CPU0                    CPU1
        ----                    ----
   lock(console_lock);
                                lock((&buf->work));
                                lock(console_lock);
   lock((&buf->work));

  *** DEADLOCK ***

 1 lock on stack by (agetty)/26163:
  #0: blocked:  (console_lock){+.+.+.}, instance: ffffffff81c2fde0, at: [<ffffffff813bc201>] vt_ioctl+0xb61/0x1230
 stack backtrace:
 Pid: 26163, comm: (agetty) Not tainted 3.9.0+ #16
 Call Trace:
  [<ffffffff815edb14>] print_circular_bug+0x200/0x20e
  [<ffffffff810b349a>] __lock_acquire+0x193a/0x1c00
  [<ffffffff8100a269>] ? sched_clock+0x9/0x10
  [<ffffffff8100a269>] ? sched_clock+0x9/0x10
  [<ffffffff8100a200>] ? native_sched_clock+0x20/0x80
  [<ffffffff810b3f74>] lock_acquire+0xa4/0x210
  [<ffffffff81062065>] ? flush_work+0x5/0x2e0
  [<ffffffff810620ae>] flush_work+0x4e/0x2e0
  [<ffffffff81062065>] ? flush_work+0x5/0x2e0
  [<ffffffff810b15db>] ? mark_held_locks+0xbb/0x140
  [<ffffffff8113c8a3>] ? __free_pages_ok.part.57+0x93/0xc0
  [<ffffffff810b15db>] ? mark_held_locks+0xbb/0x140
  [<ffffffff810652f2>] ? __cancel_work_timer+0x82/0x130
  [<ffffffff81065305>] __cancel_work_timer+0x95/0x130
  [<ffffffff810653b0>] cancel_work_sync+0x10/0x20
  [<ffffffff813b8212>] tty_port_destroy+0x12/0x20
  [<ffffffff813c65e8>] vc_deallocate+0xf8/0x110
  [<ffffffff813bc20c>] vt_ioctl+0xb6c/0x1230
  [<ffffffff810aec41>] ? lock_release_holdtime.part.30+0xa1/0x170
  [<ffffffff813b01a5>] tty_ioctl+0x285/0xd50
  [<ffffffff812b00f6>] ? inode_has_perm.isra.46.constprop.61+0x56/0x80
  [<ffffffff811ba825>] do_vfs_ioctl+0x305/0x530
  [<ffffffff812b04db>] ? selinux_file_ioctl+0x5b/0x110
  [<ffffffff811baad1>] sys_ioctl+0x81/0xa0
  [<ffffffff81601d59>] system_call_fastpath+0x16/0x1b

Cc: Dave Jones <davej@redhat.com>
Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/vt/vt.c       | 14 +++++-----
 drivers/tty/vt/vt_ioctl.c | 67 ++++++++++++++++++++++++++++++++++-------------
 include/linux/vt_kern.h   |  2 +-
 3 files changed, 56 insertions(+), 27 deletions(-)

diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
index 0829c02..374797b 100644
--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -779,7 +779,6 @@ int vc_allocate(unsigned int currcons)	/* return 0 on success */
 		con_set_default_unimap(vc);
 	    vc->vc_screenbuf = kmalloc(vc->vc_screenbuf_size, GFP_KERNEL);
 	    if (!vc->vc_screenbuf) {
-		tty_port_destroy(&vc->port);
 		kfree(vc);
 		vc_cons[currcons].d = NULL;
 		return -ENOMEM;
@@ -986,26 +985,25 @@ static int vt_resize(struct tty_struct *tty, struct winsize *ws)
 	return ret;
 }
 
-void vc_deallocate(unsigned int currcons)
+struct vc_data *vc_deallocate(unsigned int currcons)
 {
+	struct vc_data *vc = NULL;
+
 	WARN_CONSOLE_UNLOCKED();
 
 	if (vc_cons_allocated(currcons)) {
-		struct vc_data *vc = vc_cons[currcons].d;
-		struct vt_notifier_param param = { .vc = vc };
+		struct vt_notifier_param param;
 
+		param.vc = vc = vc_cons[currcons].d;
 		atomic_notifier_call_chain(&vt_notifier_list, VT_DEALLOCATE, &param);
 		vcs_remove_sysfs(currcons);
 		vc->vc_sw->con_deinit(vc);
 		put_pid(vc->vt_pid);
 		module_put(vc->vc_sw->owner);
 		kfree(vc->vc_screenbuf);
-		if (currcons >= MIN_NR_CONSOLES) {
-			tty_port_destroy(&vc->port);
-			kfree(vc);
-		}
 		vc_cons[currcons].d = NULL;
 	}
+	return vc;
 }
 
 /*
diff --git a/drivers/tty/vt/vt_ioctl.c b/drivers/tty/vt/vt_ioctl.c
index 98ff173..fc2c06c 100644
--- a/drivers/tty/vt/vt_ioctl.c
+++ b/drivers/tty/vt/vt_ioctl.c
@@ -283,6 +283,51 @@ do_unimap_ioctl(int cmd, struct unimapdesc __user *user_ud, int perm, struct vc_
 	return 0;
 }
 
+/* deallocate a single console, if possible (leave 0) */
+static int vt_disallocate(unsigned int vc_num)
+{
+	struct vc_data *vc = NULL;
+	int ret = 0;
+
+	if (!vc_num)
+		return 0;
+
+	console_lock();
+	if (VT_BUSY(vc_num))
+		ret = -EBUSY;
+	else
+		vc = vc_deallocate(vc_num);
+	console_unlock();
+
+	if (vc && vc_num >= MIN_NR_CONSOLES) {
+		tty_port_destroy(&vc->port);
+		kfree(vc);
+	}
+
+	return ret;
+}
+
+/* deallocate all unused consoles, but leave 0 */
+static void vt_disallocate_all(void)
+{
+	struct vc_data *vc[MAX_NR_CONSOLES];
+	int i;
+
+	console_lock();
+	for (i = 1; i < MAX_NR_CONSOLES; i++)
+		if (!VT_BUSY(i))
+			vc[i] = vc_deallocate(i);
+		else
+			vc[i] = NULL;
+	console_unlock();
+
+	for (i = 1; i < MAX_NR_CONSOLES; i++) {
+		if (vc[i] && i >= MIN_NR_CONSOLES) {
+			tty_port_destroy(&vc[i]->port);
+			kfree(vc[i]);
+		}
+	}
+}
 
 
 /*
@@ -769,24 +814,10 @@ int vt_ioctl(struct tty_struct *tty,
 			ret = -ENXIO;
 			break;
 		}
-		if (arg == 0) {
-		    /* deallocate all unused consoles, but leave 0 */
-			console_lock();
-			for (i=1; i<MAX_NR_CONSOLES; i++)
-				if (! VT_BUSY(i))
-					vc_deallocate(i);
-			console_unlock();
-		} else {
-			/* deallocate a single console, if possible */
-			arg--;
-			if (VT_BUSY(arg))
-				ret = -EBUSY;
-			else if (arg) {			      /* leave 0 */
-				console_lock();
-				vc_deallocate(arg);
-				console_unlock();
-			}
-		}
+		if (arg == 0)
+			vt_disallocate_all();
+		else
+			ret = vt_disallocate(--arg);
 		break;
 
 	case VT_RESIZE:
diff --git a/include/linux/vt_kern.h b/include/linux/vt_kern.h
index e8d6571..0d33fca 100644
--- a/include/linux/vt_kern.h
+++ b/include/linux/vt_kern.h
@@ -36,7 +36,7 @@ extern int fg_console, last_console, want_console;
 int vc_allocate(unsigned int console);
 int vc_cons_allocated(unsigned int console);
 int vc_resize(struct vc_data *vc, unsigned int cols, unsigned int lines);
-void vc_deallocate(unsigned int console);
+struct vc_data *vc_deallocate(unsigned int console);
 void reset_palette(struct vc_data *vc);
 void do_blank_screen(int entering_gfx);
 void do_unblank_screen(int leaving_gfx);
-- 
1.8.1.2

