Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755337AbaHGU0V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 16:26:21 -0400
Received: from mail-lb0-f175.google.com ([209.85.217.175]:55899 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760AbaHGU0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 16:26:18 -0400
Date: Fri, 8 Aug 2014 00:26:15 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Pavel Emelyanov <xemul@parallels.com>, LKML <linux-kernel@vger.kernel.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH resend] tty: Fix potential use after free in release_one_tty
Message-ID: <20140807202615.GM20553@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case if we're releasing the last tty reference the following
call sequence is possible

tty_driver_kref_put
  destruct_tty_driver
    kfree(driver);

where @driver is used in next module_put call, which leads to

 | [ 285.964007] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
 | [ 285.964007] Workqueue: events release_one_tty
 | [ 285.964007] task: ffff8800cc7ea5f0 ti: ffff8800cb800000 task.ti: ffff8800cb800000
 | [ 285.964007] RIP: 0010:[<ffffffff810aeaf5>] [<ffffffff810aeaf5>] module_put+0x24/0xf4
 | [ 285.964007] RSP: 0018:ffff8800cb801d48 EFLAGS: 00010213
 | [ 285.964007] RAX: ffff8800cb801fd8 RBX: ffff8800ca3429d0 RCX: ffff8800cb1db400
 | [ 285.964007] RDX: 0000000000000000 RSI: ffffffff817349c1 RDI: 0000000000000001
 | [ 285.964007] RBP: ffff8800cb801d60 R08: ffff8800cd632b40 R09: 0000000000000000
 | [ 285.964007] R10: 00000000ffffffff R11: ffff88011f40a000 R12: 6b6b6b6b6b6b6b6b
 | [ 285.964007] R13: ffff8800ca342520 R14: 0000000000000000 R15: ffff88011f5d8200
 | [ 285.964007] FS: 0000000000000000(0000) GS:ffff88011f400000(0000) knlGS:0000000000000000
 | [ 285.964007] CS: 0010 DS: 0000 ES: 0000 CR0: 000000008005003b
 | [ 285.964007] CR2: 00007faf5229d090 CR3: 0000000001c0b000 CR4: 00000000000006f0
 | [ 285.964007] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 | [ 285.964007] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
 | [ 285.964007] Stack:
 | [ 285.964007] ffff8800ca3429d0 ffff8800ca342a30 ffff8800ca342520 ffff8800cb801d88
 | [ 285.964007] ffffffff8146554a ffff8800cc77cc78 ffff8800ca3429d0 ffff88011f5d3800
 | [ 285.964007] ffff8800cb801e08 ffffffff810683c1 ffffffff810682ff 0000000000000046
 | [ 285.964007] Call Trace:
 | [ 285.964007] [<ffffffff8146554a>] release_one_tty+0x54/0xa3
 | [ 285.964007] [<ffffffff810683c1>] process_one_work+0x223/0x404
 | [ 285.964007] [<ffffffff810682ff>] ? process_one_work+0x161/0x404
 | [ 285.964007] [<ffffffff81068971>] worker_thread+0x136/0x205
 | [ 285.964007] [<ffffffff8106883b>] ? rescuer_thread+0x26a/0x26a
 | [ 285.964007] [<ffffffff8106e5bf>] kthread+0xa2/0xaa
 | [ 285.964007] [<ffffffff810a4586>] ? trace_hardirqs_on_caller+0x16/0x1eb
 | [ 285.964007] [<ffffffff8106e51d>] ? __kthread_parkme+0x65/0x65
 | [ 285.964007] [<ffffffff8173f59c>] ret_from_fork+0x7c/0xb0
 | [ 285.964007] [<ffffffff8106e51d>] ? __kthread_parkme+0x65/0x65
 | [ 285.964007] Code: 09 00 5b 41 5c 5d c3 0f 1f 44 00 00 55 48 85 ff 48 89 e5 41 55 41 54 49 89 fc 53 0f 84 d3 00
 | 00 00 bf 01 00 00 00 e8 d0 a1 fc ff <49> 8b 84 24 50 02 00 00 65 48 ff 40 08 4c 8b 6d 08 0f 1f 44 00

so simply keep a local reference to the module owner and
use it later.

CC: Pavel Emelyanov <xemul@parallels.com>
CC: Jiri Slaby <jslaby@suse.cz>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---
 drivers/tty/tty_io.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux-2.6.git/drivers/tty/tty_io.c
===================================================================
--- linux-2.6.git.orig/drivers/tty/tty_io.c
+++ linux-2.6.git/drivers/tty/tty_io.c
@@ -1559,13 +1559,14 @@ static void release_one_tty(struct work_
 	struct tty_struct *tty =
 		container_of(work, struct tty_struct, hangup_work);
 	struct tty_driver *driver = tty->driver;
+	struct module *owner = driver->owner;
 
 	if (tty->ops->cleanup)
 		tty->ops->cleanup(tty);
 
 	tty->magic = 0;
 	tty_driver_kref_put(driver);
-	module_put(driver->owner);
+	module_put(owner);
 
 	spin_lock(&tty_files_lock);
 	list_del_init(&tty->tty_files);
