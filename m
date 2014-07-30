Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753331AbaG3MQ4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 08:16:56 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:36824 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753073AbaG3MPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 08:15:35 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Christoph Paasch <christoph.paasch@uclouvain.be>,
        Andrew Vagin <avagin@openvz.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 41/94] tcp: Fix divide by zero when pushing during tcp-repair
Date: Wed, 30 Jul 2014 14:14:30 +0200
Message-Id: <9f22c5c1f1c8611cc4c9e8817b88065f7d3c5a3d.1406722270.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <e43bbc2c2b44d8f0bd0b7f65d6fd50ef738c57aa.1406722270.git.jslaby@suse.cz>
References: <e43bbc2c2b44d8f0bd0b7f65d6fd50ef738c57aa.1406722270.git.jslaby@suse.cz>
In-Reply-To: <cover.1406722269.git.jslaby@suse.cz>
References: <cover.1406722269.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Paasch <christoph.paasch@uclouvain.be>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

[ Upstream commit 5924f17a8a30c2ae18d034a86ee7581b34accef6 ]

When in repair-mode and TCP_RECV_QUEUE is set, we end up calling
tcp_push with mss_now being 0. If data is in the send-queue and
tcp_set_skb_tso_segs gets called, we crash because it will divide by
mss_now:

[  347.151939] divide error: 0000 [#1] SMP
[  347.152907] Modules linked in:
[  347.152907] CPU: 1 PID: 1123 Comm: packetdrill Not tainted 3.16.0-rc2 #4
[  347.152907] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2007
[  347.152907] task: f5b88540 ti: f3c82000 task.ti: f3c82000
[  347.152907] EIP: 0060:[<c1601359>] EFLAGS: 00210246 CPU: 1
[  347.152907] EIP is at tcp_set_skb_tso_segs+0x49/0xa0
[  347.152907] EAX: 00000b67 EBX: f5acd080 ECX: 00000000 EDX: 00000000
[  347.152907] ESI: f5a28f40 EDI: f3c88f00 EBP: f3c83d10 ESP: f3c83d00
[  347.152907]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[  347.152907] CR0: 80050033 CR2: 083158b0 CR3: 35146000 CR4: 000006b0
[  347.152907] Stack:
[  347.152907]  c167f9d9 f5acd080 000005b4 00000002 f3c83d20 c16013e6 f3c88f00 f5acd080
[  347.152907]  f3c83da0 c1603b5a f3c83d38 c10a0188 00000000 00000000 f3c83d84 c10acc85
[  347.152907]  c1ad5ec0 00000000 00000000 c1ad679c 010003e0 00000000 00000000 f3c88fc8
[  347.152907] Call Trace:
[  347.152907]  [<c167f9d9>] ? apic_timer_interrupt+0x2d/0x34
[  347.152907]  [<c16013e6>] tcp_init_tso_segs+0x36/0x50
[  347.152907]  [<c1603b5a>] tcp_write_xmit+0x7a/0xbf0
[  347.152907]  [<c10a0188>] ? up+0x28/0x40
[  347.152907]  [<c10acc85>] ? console_unlock+0x295/0x480
[  347.152907]  [<c10ad24f>] ? vprintk_emit+0x1ef/0x4b0
[  347.152907]  [<c1605716>] __tcp_push_pending_frames+0x36/0xd0
[  347.152907]  [<c15f4860>] tcp_push+0xf0/0x120
[  347.152907]  [<c15f7641>] tcp_sendmsg+0xf1/0xbf0
[  347.152907]  [<c116d920>] ? kmem_cache_free+0xf0/0x120
[  347.152907]  [<c106a682>] ? __sigqueue_free+0x32/0x40
[  347.152907]  [<c106a682>] ? __sigqueue_free+0x32/0x40
[  347.152907]  [<c114f0f0>] ? do_wp_page+0x3e0/0x850
[  347.152907]  [<c161c36a>] inet_sendmsg+0x4a/0xb0
[  347.152907]  [<c1150269>] ? handle_mm_fault+0x709/0xfb0
[  347.152907]  [<c15a006b>] sock_aio_write+0xbb/0xd0
[  347.152907]  [<c1180b79>] do_sync_write+0x69/0xa0
[  347.152907]  [<c1181023>] vfs_write+0x123/0x160
[  347.152907]  [<c1181d55>] SyS_write+0x55/0xb0
[  347.152907]  [<c167f0d8>] sysenter_do_call+0x12/0x28

This can easily be reproduced with the following packetdrill-script (the
"magic" with netem, sk_pacing and limit_output_bytes is done to prevent
the kernel from pushing all segments, because hitting the limit without
doing this is not so easy with packetdrill):

0   socket(..., SOCK_STREAM, IPPROTO_TCP) = 3
+0  setsockopt(3, SOL_SOCKET, SO_REUSEADDR, [1], 4) = 0

+0  bind(3, ..., ...) = 0
+0  listen(3, 1) = 0

+0  < S 0:0(0) win 32792 <mss 1460>
+0  > S. 0:0(0) ack 1 <mss 1460>
+0.1  < . 1:1(0) ack 1 win 65000

+0  accept(3, ..., ...) = 4

// This forces that not all segments of the snd-queue will be pushed
+0 `tc qdisc add dev tun0 root netem delay 10ms`
+0 `sysctl -w net.ipv4.tcp_limit_output_bytes=2`
+0 setsockopt(4, SOL_SOCKET, 47, [2], 4) = 0

+0 write(4,...,10000) = 10000
+0 write(4,...,10000) = 10000

// Set tcp-repair stuff, particularly TCP_RECV_QUEUE
+0 setsockopt(4, SOL_TCP, 19, [1], 4) = 0
+0 setsockopt(4, SOL_TCP, 20, [1], 4) = 0

// This now will make the write push the remaining segments
+0 setsockopt(4, SOL_SOCKET, 47, [20000], 4) = 0
+0 `sysctl -w net.ipv4.tcp_limit_output_bytes=130000`

// Now we will crash
+0 write(4,...,1000) = 1000

This happens since ec3423257508 (tcp: fix retransmission in repair
mode). Prior to that, the call to tcp_push was prevented by a check for
tp->repair.

The patch fixes it, by adding the new goto-label out_nopush. When exiting
tcp_sendmsg and a push is not required, which is the case for tp->repair,
we go to this label.

When repairing and calling send() with TCP_RECV_QUEUE, the data is
actually put in the receive-queue. So, no push is required because no
data has been added to the send-queue.

Cc: Andrew Vagin <avagin@openvz.org>
Cc: Pavel Emelyanov <xemul@parallels.com>
Fixes: ec3423257508 (tcp: fix retransmission in repair mode)
Signed-off-by: Christoph Paasch <christoph.paasch@uclouvain.be>
Acked-by: Andrew Vagin <avagin@openvz.org>
Acked-by: Pavel Emelyanov <xemul@parallels.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 net/ipv4/tcp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 531ab5721d79..cbe5adaad338 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1064,7 +1064,7 @@ int tcp_sendmsg(struct kiocb *iocb, struct sock *sk, struct msghdr *msg,
 	if (unlikely(tp->repair)) {
 		if (tp->repair_queue == TCP_RECV_QUEUE) {
 			copied = tcp_send_rcvq(sk, msg, size);
-			goto out;
+			goto out_nopush;
 		}
 
 		err = -EINVAL;
@@ -1237,6 +1237,7 @@ wait_for_memory:
 out:
 	if (copied)
 		tcp_push(sk, flags, mss_now, tp->nonagle);
+out_nopush:
 	release_sock(sk);
 	return copied + copied_syn;
 
-- 
2.0.1

