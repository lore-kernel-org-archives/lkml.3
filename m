Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933227AbaJaOvL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 10:51:11 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:11614 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932255AbaJaOvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 10:51:09 -0400
From: Chen Weilong <chenweilong@huawei.com>
To: <davem@davemloft.net>, <kuznet@ms2.inr.ac.ru>, <jmorris@namei.org>,
        <yoshfuji@linux-ipv6.org>, <kaber@trash.net>
CC: <linux-kernel@vger.kernel.org>
Subject: [PATCH] ipv4: avoid divide 0 error in tcp_incr_quickack
Date: Fri, 31 Oct 2014 22:50:47 +0800
Message-ID: <1414767047-8972-1-git-send-email-chenweilong@huawei.com>
X-Mailer: git-send-email 1.8.1.msysgit.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.177.37.162]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Weilong Chen <chenweilong@huawei.com>

We got a problem like this:
 [ffff8801c1a05570] machine_kexec at ffffffff81025039
 [ffff8801c1a055d0] crash_kexec at ffffffff8109b253
 [ffff8801c1a056a0] oops_end at ffffffff81442aed
 [ffff8801c1a056d0] die at ffffffff81005603
 [ffff8801c1a05700] do_trap at ffffffff81442448
 [ffff8801c1a05760] do_divide_error at ffffffff81002c10
 [ffff8801c1a05888] tcp_send_dupack at ffffffff81385e44
 [ffff8801c1a058c8] tcp_validate_incoming at ffffffff813886b5
 [ffff8801c1a05908] tcp_rcv_state_process at ffffffff8138d0b7
 [ffff8801c1a05958] tcp_child_process at ffffffff81397255
 [ffff8801c1a05988] tcp_v4_do_rcv at ffffffff81395a70
 [ffff8801c1a059d8] tcp_v4_rcv at ffffffff81396fc8
 [ffff8801c1a05a48] ip_local_deliver_finish at ffffffff813746e9
 [ffff8801c1a05a78] ip_local_deliver at ffffffff81374a20
 [ffff8801c1a05aa8] ip_rcv_finish at ffffffff81374389
 [ffff8801c1a05ad8] ip_rcv at ffffffff81374c78
There was a wrong ack packet coming during TCP handshake. The socket's state
was TCP_SYN_RECV, its rcv_mss was not initialize yet. So
tcp_send_dupack -> tcp_enter_quickack_mode got a divide 0 error.
This patch add a state check before tcp_enter_quickack_mode.

Signed-off-by: Weilong Chen <chenweilong@huawei.com>
---
 net/ipv4/tcp_input.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 4e4617e..9eb56dc 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -3986,7 +3986,8 @@ static void tcp_send_dupack(struct sock *sk, const struct sk_buff *skb)
 	if (TCP_SKB_CB(skb)->end_seq != TCP_SKB_CB(skb)->seq &&
 	    before(TCP_SKB_CB(skb)->seq, tp->rcv_nxt)) {
 		NET_INC_STATS_BH(sock_net(sk), LINUX_MIB_DELAYEDACKLOST);
-		tcp_enter_quickack_mode(sk);
+		if (sk->sk_state != TCP_SYN_RECV)
+			tcp_enter_quickack_mode(sk);
 
 		if (tcp_is_sack(tp) && sysctl_tcp_dsack) {
 			u32 end_seq = TCP_SKB_CB(skb)->end_seq;
-- 
1.7.12


