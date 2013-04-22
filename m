Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755512Ab3DVUpn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 16:45:43 -0400
Received: from ven69-h01-31-33-9-98.dsl.sta.abo.bbox.fr ([31.33.9.98]:46599
	"EHLO laptop-kevin.kbaradon.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755477Ab3DVUpl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 16:45:41 -0400
From: Kevin Baradon <kevin.baradon@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Kevin Baradon <kevin.baradon@gmail.com>
Subject: [PATCH 4/4] media/rc/imon.c: kill urb when send_packet() is interrupted
Date: Mon, 22 Apr 2013 22:09:46 +0200
Message-Id: <1366661386-6720-5-git-send-email-kevin.baradon@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1366661386-6720-1-git-send-email-kevin.baradon@gmail.com>
References: <1366661386-6720-1-git-send-email-kevin.baradon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This avoids:
Apr 12 23:52:16 homeserver kernel: imon:send_packet: task interrupted
Apr 12 23:52:16 homeserver kernel: ------------[ cut here ]------------
Apr 12 23:52:16 homeserver kernel: WARNING: at drivers/usb/core/urb.c:327 usb_submit_urb+0x353/0x370()
Apr 12 23:52:16 homeserver kernel: Hardware name: Unknow
Apr 12 23:52:16 homeserver kernel: URB f64b6f00 submitted while active
Apr 12 23:52:16 homeserver kernel: Modules linked in:
Apr 12 23:52:16 homeserver kernel: Pid: 3154, comm: LCDd Not tainted 3.8.6-htpc-00005-g9e6fc5e #26
Apr 12 23:52:16 homeserver kernel: Call Trace:
Apr 12 23:52:16 homeserver kernel: [<c012d778>] ? warn_slowpath_common+0x78/0xb0
Apr 12 23:52:16 homeserver kernel: [<c04136c3>] ? usb_submit_urb+0x353/0x370
Apr 12 23:52:16 homeserver kernel: [<c04136c3>] ? usb_submit_urb+0x353/0x370
Apr 12 23:52:16 homeserver kernel: [<c0447010>] ? imon_ir_change_protocol+0x150/0x150
Apr 12 23:52:16 homeserver kernel: [<c012d843>] ? warn_slowpath_fmt+0x33/0x40
Apr 12 23:52:16 homeserver kernel: [<c04136c3>] ? usb_submit_urb+0x353/0x370
Apr 12 23:52:16 homeserver kernel: [<c0446c67>] ? send_packet+0x97/0x270
Apr 12 23:52:16 homeserver kernel: [<c0446cfe>] ? send_packet+0x12e/0x270
Apr 12 23:52:16 homeserver kernel: [<c05c5743>] ? do_nanosleep+0xa3/0xd0
Apr 12 23:52:16 homeserver kernel: [<c044760e>] ? vfd_write+0xae/0x250
Apr 12 23:52:16 homeserver kernel: [<c0447560>] ? lcd_write+0x180/0x180
Apr 12 23:52:16 homeserver kernel: [<c01b2b19>] ? vfs_write+0x89/0x140
Apr 12 23:52:16 homeserver kernel: [<c01b2dda>] ? sys_write+0x4a/0x90
Apr 12 23:52:16 homeserver kernel: [<c05c7c45>] ? sysenter_do_call+0x12/0x26
Apr 12 23:52:16 homeserver kernel: ---[ end trace a0b6f0fcfd2f9a1d ]---
Apr 12 23:52:16 homeserver kernel: imon:send_packet: error submitting urb(-16)
Apr 12 23:52:16 homeserver kernel: imon:vfd_write: send packet #3 failed
Apr 12 23:52:16 homeserver kernel: imon:send_packet: error submitting urb(-16)
Apr 12 23:52:16 homeserver kernel: imon:vfd_write: send packet #0 failed

Signed-off-by: Kevin Baradon <kevin.baradon@gmail.com>
---
 drivers/media/rc/imon.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/rc/imon.c b/drivers/media/rc/imon.c
index 3af7bb6..72e3fa6 100644
--- a/drivers/media/rc/imon.c
+++ b/drivers/media/rc/imon.c
@@ -528,8 +528,10 @@ static int send_packet(struct imon_context *ictx)
 		mutex_unlock(&ictx->lock);
 		retval = wait_for_completion_interruptible(
 				&ictx->tx.finished);
-		if (retval)
+		if (retval) {
+			usb_kill_urb(ictx->tx_urb);
 			pr_err_ratelimited("task interrupted\n");
+		}
 		mutex_lock(&ictx->lock);
 
 		retval = ictx->tx.status;
-- 
1.7.10.4

