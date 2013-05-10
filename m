Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754810Ab3EJOUx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 10:20:53 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57016 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753097Ab3EJOUi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 10:20:38 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "David S. Miller" <davem@davemloft.net>,
        "Dmitry Popov" <dp@highloadlab.com>
Date: Fri, 10 May 2013 14:39:41 +0100
Message-ID: <lsq.1368193181.158401843@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [094/118] tcp: incoming connections might use wrong route under 
 synflood
In-Reply-To: <lsq.1368193179.973009354@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:d51a:8785:aa0a:cebe
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.45-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/ipv4/syncookies.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/ipv4/syncookies.c
+++ b/net/ipv4/syncookies.c
@@ -347,8 +347,8 @@ struct sock *cookie_v4_check(struct sock
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

