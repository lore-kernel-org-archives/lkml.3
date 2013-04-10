Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935998Ab3DJUMB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 16:12:01 -0400
Received: from mail-lb0-f181.google.com ([209.85.217.181]:42751 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935970Ab3DJUL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 16:11:59 -0400
Date: Thu, 11 Apr 2013 00:09:09 +0400
From: Dmitry Popov <dp@highloadlab.com>
To: "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] tcp: incoming connections might use wrong route under
 synflood
Message-Id: <20130411000909.d90c6df468bf1830174e88e2@highloadlab.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.15; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a bug in cookie_v4_check (net/ipv4/syncookies.c):
	flowi4_init_output(&fl4, 0, sk->sk_mark, RT_CONN_FLAGS(sk),
			   RT_SCOPE_UNIVERSE, IPPROTO_TCP,
			   inet_sk_flowi_flags(sk),
			   (opt && opt->srr) ? opt->faddr : ireq->rmt_addr,
			   ireq->loc_addr, th->source, th->dest);

Here we do not respect sk->sk_bound_dev_if, therefore wrong dst_entry may be taken. This dst_entry is used in new socket (get_cookie_sock -> tcp_v4_syn_recv_sock), so its packets may take wrong path. There is no such bug in ipv6 code and non-cookie code (usual case). Bugfix below.

Signed-off-by: Dmitry Popov <dp@highloadlab.com>
---
 net/ipv4/syncookies.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)
diff --git a/net/ipv4/syncookies.c b/net/ipv4/syncookies.c
index ef54377..397e0f6 100644
--- a/net/ipv4/syncookies.c
+++ b/net/ipv4/syncookies.c
@@ -349,8 +349,8 @@ struct sock *cookie_v4_check(struct sock *sk, struct sk_buff *skb,
 	 * hasn't changed since we received the original syn, but I see
 	 * no easy way to do this.
 	 */
-	flowi4_init_output(&fl4, 0, sk->sk_mark, RT_CONN_FLAGS(sk),
-			   RT_SCOPE_UNIVERSE, IPPROTO_TCP,
+	flowi4_init_output(&fl4, sk->sk_bound_dev_if, sk->sk_mark,
+			   RT_CONN_FLAGS(sk), RT_SCOPE_UNIVERSE, IPPROTO_TCP,
 			   inet_sk_flowi_flags(sk),
 			   (opt && opt->srr) ? opt->faddr : ireq->rmt_addr,
 			   ireq->loc_addr, th->source, th->dest);
