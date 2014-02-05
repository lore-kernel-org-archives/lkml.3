Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755373AbaBEUuL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 15:50:11 -0500
Received: from mail1.windriver.com ([147.11.146.13]:48261 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753990AbaBEUGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:06:08 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Takashi Iwai <tiwai@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 107/213] ALSA: seq: Fix missing error handling in snd_seq_timer_open()
Date: Wed, 5 Feb 2014 15:01:02 -0500
Message-ID: <1391630568-49251-108-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
References: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 66efdc71d95887b652a742a5dae51fa834d71465 upstream.

snd_seq_timer_open() didn't catch the whole error path but let through
if the timer id is a slave.  This may lead to Oops by accessing the
uninitialized pointer.

 BUG: unable to handle kernel NULL pointer dereference at 00000000000002ae
 IP: [<ffffffff819b3477>] snd_seq_timer_open+0xe7/0x130
 PGD 785cd067 PUD 76964067 PMD 0
 Oops: 0002 [#4] SMP
 CPU 0
 Pid: 4288, comm: trinity-child7 Tainted: G      D W 3.9.0-rc1+ #100 Bochs Bochs
 RIP: 0010:[<ffffffff819b3477>]  [<ffffffff819b3477>] snd_seq_timer_open+0xe7/0x130
 RSP: 0018:ffff88006ece7d38  EFLAGS: 00010246
 RAX: 0000000000000286 RBX: ffff88007851b400 RCX: 0000000000000000
 RDX: 000000000000ffff RSI: ffff88006ece7d58 RDI: ffff88006ece7d38
 RBP: ffff88006ece7d98 R08: 000000000000000a R09: 000000000000fffe
 R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
 R13: ffff8800792c5400 R14: 0000000000e8f000 R15: 0000000000000007
 FS:  00007f7aaa650700(0000) GS:ffff88007f800000(0000) GS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 00000000000002ae CR3: 000000006efec000 CR4: 00000000000006f0
 DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
 Process trinity-child7 (pid: 4288, threadinfo ffff88006ece6000, task ffff880076a8a290)
 Stack:
  0000000000000286 ffffffff828f2be0 ffff88006ece7d58 ffffffff810f354d
  65636e6575716573 2065756575712072 ffff8800792c0030 0000000000000000
  ffff88006ece7d98 ffff8800792c5400 ffff88007851b400 ffff8800792c5520
 Call Trace:
  [<ffffffff810f354d>] ? trace_hardirqs_on+0xd/0x10
  [<ffffffff819b17e9>] snd_seq_queue_timer_open+0x29/0x70
  [<ffffffff819ae01a>] snd_seq_ioctl_set_queue_timer+0xda/0x120
  [<ffffffff819acb9b>] snd_seq_do_ioctl+0x9b/0xd0
  [<ffffffff819acbe0>] snd_seq_ioctl+0x10/0x20
  [<ffffffff811b9542>] do_vfs_ioctl+0x522/0x570
  [<ffffffff8130a4b3>] ? file_has_perm+0x83/0xa0
  [<ffffffff810f354d>] ? trace_hardirqs_on+0xd/0x10
  [<ffffffff811b95ed>] sys_ioctl+0x5d/0xa0
  [<ffffffff813663fe>] ? trace_hardirqs_on_thunk+0x3a/0x3f
  [<ffffffff81faed69>] system_call_fastpath+0x16/0x1b

Reported-and-tested-by: Tommi Rantala <tt.rantala@gmail.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 sound/core/seq/seq_timer.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/sound/core/seq/seq_timer.c b/sound/core/seq/seq_timer.c
index 160b1bd0cd62..24d44b2f61ac 100644
--- a/sound/core/seq/seq_timer.c
+++ b/sound/core/seq/seq_timer.c
@@ -290,10 +290,10 @@ int snd_seq_timer_open(struct snd_seq_queue *q)
 			tid.device = SNDRV_TIMER_GLOBAL_SYSTEM;
 			err = snd_timer_open(&t, str, &tid, q->queue);
 		}
-		if (err < 0) {
-			snd_printk(KERN_ERR "seq fatal error: cannot create timer (%i)\n", err);
-			return err;
-		}
+	}
+	if (err < 0) {
+		snd_printk(KERN_ERR "seq fatal error: cannot create timer (%i)\n", err);
+		return err;
 	}
 	t->callback = snd_seq_timer_interrupt;
 	t->callback_data = q;
-- 
1.8.5.2

