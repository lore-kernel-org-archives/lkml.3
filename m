Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752062AbaL2BM5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2014 20:12:57 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33197 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751914AbaL2BMR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2014 20:12:17 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "David S. Miller" <davem@davemloft.net>,
        "Vasily Averin" <vvs@parallels.com>,
        "Eric Dumazet" <edumazet@google.com>
Date: Mon, 29 Dec 2014 02:11:31 +0100
Message-ID: <lsq.1419815491.800439287@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 24/27] ipv4: dst_entry leak in ip_send_unicast_reply()
In-Reply-To: <lsq.1419815490.288081487@decadent.org.uk>
X-SA-Exim-Connect-IP: 46.189.28.191
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.66-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Vasily Averin <vvs@parallels.com>

commit 4062090e3e5caaf55bed4523a69f26c3265cc1d2 upstream.

ip_setup_cork() called inside ip_append_data() steals dst entry from rt to cork
and in case errors in __ip_append_data() nobody frees stolen dst entry

Fixes: 2e77d89b2fa8 ("net: avoid a pair of dst_hold()/dst_release() in ip_append_data()")
Signed-off-by: Vasily Averin <vvs@parallels.com>
Acked-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/ipv4/ip_output.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -1472,6 +1472,7 @@ void ip_send_reply(struct sock *sk, stru
 	struct ipcm_cookie ipc;
 	struct flowi4 fl4;
 	struct rtable *rt = skb_rtable(skb);
+	int err;
 
 	if (ip_options_echo(&replyopts.opt.opt, skb))
 		return;
@@ -1509,8 +1510,13 @@ void ip_send_reply(struct sock *sk, stru
 	sk->sk_priority = skb->priority;
 	sk->sk_protocol = ip_hdr(skb)->protocol;
 	sk->sk_bound_dev_if = arg->bound_dev_if;
-	ip_append_data(sk, &fl4, ip_reply_glue_bits, arg->iov->iov_base, len, 0,
-		       &ipc, &rt, MSG_DONTWAIT);
+	err = ip_append_data(sk, &fl4, ip_reply_glue_bits, arg->iov->iov_base,
+			     len, 0, &ipc, &rt, MSG_DONTWAIT);
+	if (unlikely(err)) {
+		ip_flush_pending_frames(sk);
+		goto out;
+	}
+
 	if ((skb = skb_peek(&sk->sk_write_queue)) != NULL) {
 		if (arg->csumoffset >= 0)
 			*((__sum16 *)skb_transport_header(skb) +
@@ -1519,7 +1525,7 @@ void ip_send_reply(struct sock *sk, stru
 		skb->ip_summed = CHECKSUM_NONE;
 		ip_push_pending_frames(sk, &fl4);
 	}
-
+out:
 	bh_unlock_sock(sk);
 
 	ip_rt_put(rt);

