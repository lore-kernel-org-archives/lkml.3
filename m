Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756869Ab3BEUoA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 15:44:00 -0500
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:56623 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755583Ab3BEUnz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 15:43:55 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>, Jiri Slaby <jslaby@suse.cz>,
        Sasha Levin <levinsasha928@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ilya Zykov <ilya@ilyx.ru>, Dave Jones <davej@redhat.com>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH v3 13/23] n_tty: Fully initialize ldisc before restarting buffer work
Date: Tue,  5 Feb 2013 15:20:28 -0500
Message-Id: <1360095638-6624-14-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1360095638-6624-1-git-send-email-peter@hurleysoftware.com>
References: <1355509370-5883-1-git-send-email-peter@hurleysoftware.com>
 <1360095638-6624-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
X-MT-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
X-MT-INTERNAL-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Buffer work may already be pending when the n_tty ldisc is re-opened,
eg., when setting the ldisc (via TIOCSETD ioctl) and when hanging up
the tty. Since n_tty_set_room() may restart buffer work, first ensure
the ldisc is completely initialized.

Factor n_tty_set_room() out of reset_buffer_flags() (only 2 callers)
and reorganize n_tty_open() to set termios last; buffer work will
be restarted there if necessary, after the char_map is properly
initialized.

Fixes this WARNING:

[  549.561769] ------------[ cut here ]------------
[  549.598755] WARNING: at drivers/tty/n_tty.c:160 n_tty_set_room+0xff/0x130()
[  549.604058] scheduling buffer work for halted ldisc
[  549.607741] Pid: 9417, comm: trinity-child28 Tainted: G      D W 3.7.0-next-20121217-sasha-00023-g8689ef9 #219
[  549.652580] Call Trace:
[  549.662754]  [<ffffffff81c432cf>] ? n_tty_set_room+0xff/0x130
[  549.665458]  [<ffffffff8110cae7>] warn_slowpath_common+0x87/0xb0
[  549.668257]  [<ffffffff8110cb71>] warn_slowpath_fmt+0x41/0x50
[  549.671007]  [<ffffffff81c432cf>] n_tty_set_room+0xff/0x130
[  549.673268]  [<ffffffff81c44597>] reset_buffer_flags+0x137/0x150
[  549.675607]  [<ffffffff81c45b71>] n_tty_open+0x131/0x1c0
[  549.677699]  [<ffffffff81c47824>] tty_ldisc_open.isra.5+0x54/0x70
[  549.680147]  [<ffffffff81c482bf>] tty_ldisc_hangup+0x11f/0x1e0
[  549.682409]  [<ffffffff81c3fa17>] __tty_hangup+0x137/0x440
[  549.684634]  [<ffffffff81c3fd49>] tty_vhangup+0x9/0x10
[  549.686443]  [<ffffffff81c4a42c>] pty_close+0x14c/0x160
[  549.688446]  [<ffffffff81c41225>] tty_release+0xd5/0x490
[  549.690460]  [<ffffffff8127d8a2>] __fput+0x122/0x250
[  549.692577]  [<ffffffff8127d9d9>] ____fput+0x9/0x10
[  549.694534]  [<ffffffff811348c2>] task_work_run+0xb2/0xf0
[  549.696349]  [<ffffffff81113c6d>] do_exit+0x36d/0x580
[  549.698286]  [<ffffffff8107d964>] ? syscall_trace_enter+0x24/0x2e0
[  549.702729]  [<ffffffff81113f4a>] do_group_exit+0x8a/0xc0
[  549.706775]  [<ffffffff81113f92>] sys_exit_group+0x12/0x20
[  549.711088]  [<ffffffff83cfab18>] tracesys+0xe1/0xe6
[  549.728001] ---[ end trace 73eb41728f11f87e ]---

Reported-by: Sasha Levin <levinsasha928@gmail.com>
Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/n_tty.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index 5073dd1..e269296 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -218,9 +218,8 @@ static void check_unthrottle(struct tty_struct *tty)
  *	Locking: tty_read_lock for read fields.
  */
 
-static void reset_buffer_flags(struct tty_struct *tty)
+static void reset_buffer_flags(struct n_tty_data *ldata)
 {
-	struct n_tty_data *ldata = tty->disc_data;
 	unsigned long flags;
 
 	spin_lock_irqsave(&ldata->read_lock, flags);
@@ -233,7 +232,6 @@ static void reset_buffer_flags(struct tty_struct *tty)
 
 	ldata->canon_head = ldata->canon_data = ldata->erasing = 0;
 	bitmap_zero(ldata->read_flags, N_TTY_BUF_SIZE);
-	n_tty_set_room(tty);
 }
 
 static void packet_mode_flush(struct tty_struct *tty)
@@ -261,7 +259,8 @@ static void packet_mode_flush(struct tty_struct *tty)
 
 static void n_tty_flush_buffer(struct tty_struct *tty)
 {
-	reset_buffer_flags(tty);
+	reset_buffer_flags(tty->disc_data);
+	n_tty_set_room(tty);
 
 	if (tty->link)
 		packet_mode_flush(tty);
@@ -1653,14 +1652,14 @@ static int n_tty_open(struct tty_struct *tty)
 		goto err_free_bufs;
 
 	tty->disc_data = ldata;
-	/* indicate buffer work may resume */
-	clear_bit(TTY_LDISC_HALTED, &tty->flags);
-	reset_buffer_flags(tty);
-	tty_unthrottle(tty);
+	reset_buffer_flags(tty->disc_data);
 	ldata->column = 0;
-	n_tty_set_termios(tty, NULL);
 	tty->minimum_to_wake = 1;
 	tty->closing = 0;
+	/* indicate buffer work may resume */
+	clear_bit(TTY_LDISC_HALTED, &tty->flags);
+	n_tty_set_termios(tty, NULL);
+	tty_unthrottle(tty);
 
 	return 0;
 err_free_bufs:
-- 
1.8.1.2

