Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161960Ab3LFWOI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 17:14:08 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60919 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759368Ab3LFVxj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 16:53:39 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Andrey Vagin <avagin@openvz.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>
Subject: [PATCH 3.10 28/58] tcp: dont update snd_nxt, when a socket is switched from repair mode
Date: Fri,  6 Dec 2013 13:51:59 -0800
Message-Id: <20131206214847.511681418@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.67.gb00d244
In-Reply-To: <20131206214844.906193530@linuxfoundation.org>
References: <20131206214844.906193530@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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

Signed-off-by: Andrey Vagin <avagin@openvz.org>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
Cc: James Morris <jmorris@namei.org>
Cc: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Cc: Patrick McHardy <kaber@trash.net>
Acked-by: Pavel Emelyanov <xemul@parallels.com>
Acked-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp_output.c |    1 -
 1 file changed, 1 deletion(-)

--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -3102,7 +3102,6 @@ void tcp_send_window_probe(struct sock *
 {
 	if (sk->sk_state == TCP_ESTABLISHED) {
 		tcp_sk(sk)->snd_wl1 = tcp_sk(sk)->rcv_nxt - 1;
-		tcp_sk(sk)->snd_nxt = tcp_sk(sk)->write_seq;
 		tcp_xmit_probe_skb(sk, 0);
 	}
 }


