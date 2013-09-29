Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757556Ab3I2UI1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 16:08:27 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59127 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755175Ab3I2T1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 15:27:12 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sasha Levin <levinsasha928@gmail.com>,
        Mike Christie <michaelc@cs.wisc.edu>,
        James Bottomley <JBottomley@Parallels.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [ 10/17] SCSI: iscsi: dont hang in endless loop if no targets present
Date: Sun, 29 Sep 2013 12:26:49 -0700
Message-Id: <20130929190757.848861665@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20130929190757.138351117@linuxfoundation.org>
References: <20130929190757.138351117@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sasha Levin <levinsasha928@gmail.com>

commit 46a7c17d26967922092f3a8291815ffb20f6cabe upstream.

iscsi_if_send_reply() may return -ESRCH if there were no targets to send
data to. Currently we're ignoring this value and looping in attempt to do it
over and over, which will usually lead in a hung task like this one:

[ 4920.817298] INFO: task trinity:9074 blocked for more than 120 seconds.
[ 4920.818527] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 4920.819982] trinity         D 0000000000000000  5504  9074   2756 0x00000004
[ 4920.825374]  ffff880003961a98 0000000000000086 ffff8800001aa000 ffff8800001aa000
[ 4920.826791]  00000000001d4340 ffff880003961fd8 ffff880003960000 00000000001d4340
[ 4920.828241]  00000000001d4340 00000000001d4340 ffff880003961fd8 00000000001d4340
[ 4920.833231]
[ 4920.833519] Call Trace:
[ 4920.834010]  [<ffffffff826363fa>] schedule+0x3a/0x50
[ 4920.834953]  [<ffffffff82634ac9>] __mutex_lock_common+0x209/0x5b0
[ 4920.836226]  [<ffffffff81af805d>] ? iscsi_if_rx+0x2d/0x990
[ 4920.837281]  [<ffffffff81053943>] ? sched_clock+0x13/0x20
[ 4920.838305]  [<ffffffff81af805d>] ? iscsi_if_rx+0x2d/0x990
[ 4920.839336]  [<ffffffff82634eb0>] mutex_lock_nested+0x40/0x50
[ 4920.840423]  [<ffffffff81af805d>] iscsi_if_rx+0x2d/0x990
[ 4920.841434]  [<ffffffff810dffed>] ? sub_preempt_count+0x9d/0xd0
[ 4920.842548]  [<ffffffff82637bb0>] ? _raw_read_unlock+0x30/0x60
[ 4920.843666]  [<ffffffff821f71de>] netlink_unicast+0x1ae/0x1f0
[ 4920.844751]  [<ffffffff821f7997>] netlink_sendmsg+0x227/0x350
[ 4920.845850]  [<ffffffff821857bd>] ? sock_update_netprioidx+0xdd/0x1b0
[ 4920.847060]  [<ffffffff82185732>] ? sock_update_netprioidx+0x52/0x1b0
[ 4920.848276]  [<ffffffff8217f226>] sock_aio_write+0x166/0x180
[ 4920.849348]  [<ffffffff810dfe41>] ? get_parent_ip+0x11/0x50
[ 4920.850428]  [<ffffffff811d0d9a>] do_sync_write+0xda/0x120
[ 4920.851465]  [<ffffffff810dffed>] ? sub_preempt_count+0x9d/0xd0
[ 4920.852579]  [<ffffffff810dfe41>] ? get_parent_ip+0x11/0x50
[ 4920.853608]  [<ffffffff81791887>] ? security_file_permission+0x27/0xb0
[ 4920.854821]  [<ffffffff811d0f4c>] vfs_write+0x16c/0x180
[ 4920.855781]  [<ffffffff811d104f>] sys_write+0x4f/0xa0
[ 4920.856798]  [<ffffffff82638e79>] system_call_fastpath+0x16/0x1b
[ 4920.877487] 1 lock held by trinity/9074:
[ 4920.878239]  #0:  (rx_queue_mutex){+.+...}, at: [<ffffffff81af805d>] iscsi_if_rx+0x2d/0x990
[ 4920.880005] Kernel panic - not syncing: hung_task: blocked tasks

Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
Acked-by: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Cc: Jiri Slaby <jslaby@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/scsi_transport_iscsi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -1747,7 +1747,7 @@ iscsi_if_rx(struct sk_buff *skb)
 				break;
 			err = iscsi_if_send_reply(group, nlh->nlmsg_seq,
 				nlh->nlmsg_type, 0, 0, ev, sizeof(*ev));
-		} while (err < 0 && err != -ECONNREFUSED);
+		} while (err < 0 && err != -ECONNREFUSED && err != -ESRCH);
 		skb_pull(skb, rlen);
 	}
 	mutex_unlock(&rx_queue_mutex);


