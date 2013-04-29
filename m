Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760743Ab3D2Tf5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 15:35:57 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60721 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759489Ab3D2TCr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 15:02:47 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dmitry Popov <dp@highloadlab.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 30/42] tcp: incoming connections might use wrong route under synflood
Date: Mon, 29 Apr 2013 12:02:12 -0700
Message-Id: <20130429184755.823227492@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130429184752.435249613@linuxfoundation.org>
References: <20130429184752.435249613@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Dmitry Popov <dp@highloadlab.com>

[ Upstream commit d66954a066158781ccf9c13c91d0316970fe57b6 ]

There is a bug in cookie_v4_check (net/ipv4/syncookies.c):
	flowi4_init_output(&fl4, 0, sk->sk_mark, RT_CONN_FLAGS(sk),
			   RT_SCOPE_UNIVERSE, IPPROTO_TCP,
			   inet_sk_flowi_flags(sk),
			   (opt && opt->srr) ? opt->faddr : ireq->rmt_addr,
			   ireq->loc_addr, th->source, th->dest);

Here we do not respect sk->sk_bound_dev_if, therefore wrong dst_entry may be
taken. This dst_entry is used by new socket (get_cookie_sock ->
tcp_v4_syn_recv_sock), so its packets may take the wrong path.

Signed-off-by: Dmitry Popov <dp@highloadlab.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/syncookies.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/ipv4/syncookies.c
+++ b/net/ipv4/syncookies.c
@@ -348,8 +348,8 @@ struct sock *cookie_v4_check(struct sock
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


