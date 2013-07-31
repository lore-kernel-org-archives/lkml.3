Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760668Ab3GaSHc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 14:07:32 -0400
Received: from mailout01.c08.mtsvc.net ([205.186.168.189]:36931 "EHLO
	mailout01.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751894Ab3GaSH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 14:07:28 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH] tty: Only hangup once
Date: Wed, 31 Jul 2013 14:05:45 -0400
Message-Id: <1375293945-4087-1-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instrumented testing shows a tty can be hungup multiple times [1].
Although concurrent hangups are properly serialized, multiple
hangups for the same tty should be prevented.

If tty has already been HUPPED, abort hangup. Note it is not
necessary to cleanup file *redirect on subsequent hangups,
as only TIOCCONS can set that value and ioctls are disabled
after hangup.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>

[1]
Test performed by simulating a concurrent async hangup via
tty_hangup() with a sync hangup via tty_vhangup(), while
__tty_hangup() was instrumented with:

diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index 26bb78c..fe8b061 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -629,6 +629,8 @@ static void __tty_hangup(struct tty_struct *tty, int exit_session)

 	tty_lock(tty);

+	WARN_ON(test_bit(TTY_HUPPED, &tty->flags));
+
 	/* some functions below drop BTM, so we need this bit */
 	set_bit(TTY_HUPPING, &tty->flags);

Test result:

WARNING: at /home/peter/src/kernels/mainline/drivers/tty/tty_io.c:632 __tty_hangup+0x459/0x460()
Modules linked in: ip6table_filter ip6_tables ebtable_nat <...snip...>
CPU: 6 PID: 1197 Comm: kworker/6:2 Not tainted 3.10.0-0+rfcomm-xeon #0+rfcomm
Hardware name: Dell Inc. Precision WorkStation T5400  /0RW203, BIOS A11 04/30/2012
Workqueue: events do_tty_hangup
 0000000000000009 ffff8802b16d7d18 ffffffff816b553e ffff8802b16d7d58
 ffffffff810407e0 ffff880254f95c00 ffff880254f95c00 ffff8802bfd92b00
 ffff8802bfd96b00 ffff880254f95e40 0000000000000180 ffff8802b16d7d68
Call Trace:
 [<ffffffff816b553e>] dump_stack+0x19/0x1b
 [<ffffffff810407e0>] warn_slowpath_common+0x70/0xa0
 [<ffffffff8104082a>] warn_slowpath_null+0x1a/0x20
 [<ffffffff813fb279>] __tty_hangup+0x459/0x460
 [<ffffffff8107409c>] ? finish_task_switch+0xbc/0xe0
 [<ffffffff813fb297>] do_tty_hangup+0x17/0x20
 [<ffffffff8105fd6f>] process_one_work+0x16f/0x450
 [<ffffffff8106007c>] process_scheduled_works+0x2c/0x40
 [<ffffffff8106060a>] worker_thread+0x26a/0x380
 [<ffffffff810603a0>] ? rescuer_thread+0x310/0x310
 [<ffffffff810698a0>] kthread+0xc0/0xd0
 [<ffffffff816b0000>] ? destroy_compound_page+0x65/0x92
 [<ffffffff810697e0>] ? kthread_create_on_node+0x130/0x130
 [<ffffffff816c495c>] ret_from_fork+0x7c/0xb0
 [<ffffffff810697e0>] ? kthread_create_on_node+0x130/0x130
---[ end trace 98d9f01536cf411e ]---
---
 drivers/tty/tty_io.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index 26bb78c..a9355ce 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -629,6 +629,11 @@ static void __tty_hangup(struct tty_struct *tty, int exit_session)
 
 	tty_lock(tty);
 
+	if (test_bit(TTY_HUPPED, &tty->flags)) {
+		tty_unlock(tty);
+		return;
+	}
+
 	/* some functions below drop BTM, so we need this bit */
 	set_bit(TTY_HUPPING, &tty->flags);
 
-- 
1.8.1.2

