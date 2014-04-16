Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756119AbaDPKso (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 06:48:44 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51688 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755686AbaDPKcd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 06:32:33 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 18/46] tcp: tcp_release_cb() should release socket ownership
Date: Wed, 16 Apr 2014 11:31:34 +0100
Message-Id: <1397644322-13905-19-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1397644322-13905-1-git-send-email-luis.henriques@canonical.com>
References: <1397644322-13905-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <eric.dumazet@gmail.com>

commit c3f9b01849ef3bc69024990092b9f42e20df7797 upstream.

Lars Persson reported following deadlock :

-000 |M:0x0:0x802B6AF8(asm) <-- arch_spin_lock
-001 |tcp_v4_rcv(skb = 0x8BD527A0) <-- sk = 0x8BE6B2A0
-002 |ip_local_deliver_finish(skb = 0x8BD527A0)
-003 |__netif_receive_skb_core(skb = 0x8BD527A0, ?)
-004 |netif_receive_skb(skb = 0x8BD527A0)
-005 |elk_poll(napi = 0x8C770500, budget = 64)
-006 |net_rx_action(?)
-007 |__do_softirq()
-008 |do_softirq()
-009 |local_bh_enable()
-010 |tcp_rcv_established(sk = 0x8BE6B2A0, skb = 0x87D3A9E0, th = 0x814EBE14, ?)
-011 |tcp_v4_do_rcv(sk = 0x8BE6B2A0, skb = 0x87D3A9E0)
-012 |tcp_delack_timer_handler(sk = 0x8BE6B2A0)
-013 |tcp_release_cb(sk = 0x8BE6B2A0)
-014 |release_sock(sk = 0x8BE6B2A0)
-015 |tcp_sendmsg(?, sk = 0x8BE6B2A0, ?, ?)
-016 |sock_sendmsg(sock = 0x8518C4C0, msg = 0x87D8DAA8, size = 4096)
-017 |kernel_sendmsg(?, ?, ?, ?, size = 4096)
-018 |smb_send_kvec()
-019 |smb_send_rqst(server = 0x87C4D400, rqst = 0x87D8DBA0)
-020 |cifs_call_async()
-021 |cifs_async_writev(wdata = 0x87FD6580)
-022 |cifs_writepages(mapping = 0x852096E4, wbc = 0x87D8DC88)
-023 |__writeback_single_inode(inode = 0x852095D0, wbc = 0x87D8DC88)
-024 |writeback_sb_inodes(sb = 0x87D6D800, wb = 0x87E4A9C0, work = 0x87D8DD88)
-025 |__writeback_inodes_wb(wb = 0x87E4A9C0, work = 0x87D8DD88)
-026 |wb_writeback(wb = 0x87E4A9C0, work = 0x87D8DD88)
-027 |wb_do_writeback(wb = 0x87E4A9C0, force_wait = 0)
-028 |bdi_writeback_workfn(work = 0x87E4A9CC)
-029 |process_one_work(worker = 0x8B045880, work = 0x87E4A9CC)
-030 |worker_thread(__worker = 0x8B045880)
-031 |kthread(_create = 0x87CADD90)
-032 |ret_from_kernel_thread(asm)

Bug occurs because __tcp_checksum_complete_user() enables BH, assuming
it is running from softirq context.

Lars trace involved a NIC without RX checksum support but other points
are problematic as well, like the prequeue stuff.

Problem is triggered by a timer, that found socket being owned by user.

tcp_release_cb() should call tcp_write_timer_handler() or
tcp_delack_timer_handler() in the appropriate context :

BH disabled and socket lock held, but 'owned' field cleared,
as if they were running from timer handlers.

Fixes: 6f458dfb4092 ("tcp: improve latencies of timer triggered events")
Reported-by: Lars Persson <lars.persson@axis.com>
Tested-by: Lars Persson <lars.persson@axis.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 include/net/sock.h    |  5 +++++
 net/core/sock.c       |  5 ++++-
 net/ipv4/tcp_output.c | 11 +++++++++++
 3 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 04e148f..643f92e 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1443,6 +1443,11 @@ static inline void sk_wmem_free_skb(struct sock *sk, struct sk_buff *skb)
  */
 #define sock_owned_by_user(sk)	((sk)->sk_lock.owned)
 
+static inline void sock_release_ownership(struct sock *sk)
+{
+	sk->sk_lock.owned = 0;
+}
+
 /*
  * Macro so as to not evaluate some arguments when
  * lockdep is not enabled.
diff --git a/net/core/sock.c b/net/core/sock.c
index 2d92ff8..0e2b67e 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2335,10 +2335,13 @@ void release_sock(struct sock *sk)
 	if (sk->sk_backlog.tail)
 		__release_sock(sk);
 
+	/* Warning : release_cb() might need to release sk ownership,
+	 * ie call sock_release_ownership(sk) before us.
+	 */
 	if (sk->sk_prot->release_cb)
 		sk->sk_prot->release_cb(sk);
 
-	sk->sk_lock.owned = 0;
+	sock_release_ownership(sk);
 	if (waitqueue_active(&sk->sk_lock.wq))
 		wake_up(&sk->sk_lock.wq);
 	spin_unlock_bh(&sk->sk_lock.slock);
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 24b88d5..acc001e 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -760,6 +760,17 @@ void tcp_release_cb(struct sock *sk)
 	if (flags & (1UL << TCP_TSQ_DEFERRED))
 		tcp_tsq_handler(sk);
 
+	/* Here begins the tricky part :
+	 * We are called from release_sock() with :
+	 * 1) BH disabled
+	 * 2) sk_lock.slock spinlock held
+	 * 3) socket owned by us (sk->sk_lock.owned == 1)
+	 *
+	 * But following code is meant to be called from BH handlers,
+	 * so we should keep BH disabled, but early release socket ownership
+	 */
+	sock_release_ownership(sk);
+
 	if (flags & (1UL << TCP_WRITE_TIMER_DEFERRED)) {
 		tcp_write_timer_handler(sk);
 		__sock_put(sk);
-- 
1.9.1

