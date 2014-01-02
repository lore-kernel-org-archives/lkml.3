Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752763AbaABRG5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 12:06:57 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40269 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752627AbaABRGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 12:06:54 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Pavel Emelyanov <xemul@parallels.com>, Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>, Andrey Vagin <avagin@openvz.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 26/91] tcp: don't update snd_nxt, when a socket is switched from repair mode
Date: Thu,  2 Jan 2014 09:04:01 -0800
Message-Id: <1388682306-30859-27-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1388682306-30859-1-git-send-email-kamal@canonical.com>
References: <1388682306-30859-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrey Vagin <avagin@openvz.org>

[ Upstream commit dbde497966804e63a38fdedc1e3815e77097efc2 ]

snd_nxt must be updated synchronously with sk_send_head.  Otherwise
tp->packets_out may be updated incorrectly, what may bring a kernel panic.

Here is a kernel panic from my host.
[  103.043194] BUG: unable to handle kernel NULL pointer dereference at 0000000000000048
[  103.044025] IP: [<ffffffff815aaaaf>] tcp_rearm_rto+0xcf/0x150
...
[  146.301158] Call Trace:
[  146.301158]  [<ffffffff815ab7f0>] tcp_ack+0xcc0/0x12c0

Before this panic a tcp socket was restored. This socket had sent and
unsent data in the write queue. Sent data was restored in repair mode,
then the socket was switched from reapair mode and unsent data was
restored. After that the socket was switched back into repair mode.

In that moment we had a socket where write queue looks like this:
snd_una    snd_nxt   write_seq
   |_________|________|
             |
	  sk_send_head

After a second switching from repair mode the state of socket was
changed:

snd_una          snd_nxt, write_seq
   |_________ ________|
             |
	  sk_send_head

This state is inconsistent, because snd_nxt and sk_send_head are not
synchronized.

Bellow you can find a call trace, how packets_out can be incremented
twice for one skb, if snd_nxt and sk_send_head are not synchronized.
In this case packets_out will be always positive, even when
sk_write_queue is empty.

tcp_write_wakeup
	skb = tcp_send_head(sk);
	tcp_fragment
		if (!before(tp->snd_nxt, TCP_SKB_CB(buff)->end_seq))
			tcp_adjust_pcount(sk, skb, diff);
	tcp_event_new_data_sent
		tp->packets_out += tcp_skb_pcount(skb);

I think update of snd_nxt isn't required, when a socket is switched from
repair mode.  Because it's initialized in tcp_connect_init. Then when a
write queue is restored, snd_nxt is incremented in tcp_event_new_data_sent,
so it's always is in consistent state.

I have checked, that the bug is not reproduced with this patch and
all tests about restoring tcp connections work fine.

Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
Cc: James Morris <jmorris@namei.org>
Cc: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Cc: Patrick McHardy <kaber@trash.net>
Signed-off-by: Andrey Vagin <avagin@openvz.org>
Acked-by: Pavel Emelyanov <xemul@parallels.com>
Acked-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/ipv4/tcp_output.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 168a0d0..aa215b8 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -3178,7 +3178,6 @@ void tcp_send_window_probe(struct sock *sk)
 {
 	if (sk->sk_state == TCP_ESTABLISHED) {
 		tcp_sk(sk)->snd_wl1 = tcp_sk(sk)->rcv_nxt - 1;
-		tcp_sk(sk)->snd_nxt = tcp_sk(sk)->write_seq;
 		tcp_xmit_probe_skb(sk, 0);
 	}
 }
-- 
1.8.3.2

