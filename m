Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760645Ab3EGEnO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 00:43:14 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:27877 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759436Ab3EGEZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 00:25:39 -0400
X-Authority-Analysis: v=2.0 cv=cOZiQyiN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=mVRcFgP9zmEA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=mDda2rsxiAYA:10 a=LfA-LBJFAAAA:8 a=J1Y8HTJGAAAA:8 a=BU4qch4usoZhajSmOKEA:9 a=KHTnqCBSESUA:10 a=4N9Db7Z2_RYA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130507035900.685326413@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 06 May 2013 23:59:10 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Dmitry Popov <dp@highloadlab.com>, "David S. Miller" <davem@davemloft.net>
Subject: [118/126] tcp: incoming connections might use wrong route under synflood
References: <20130507035712.909872333@goodmis.org>
Content-Disposition: inline; filename=0118-tcp-incoming-connections-might-use-wrong-route-under.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.3 stable review patch.
If anyone has any objections, please let me know.

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
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 net/ipv4/syncookies.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/syncookies.c b/net/ipv4/syncookies.c
index 650e152..3324857 100644
--- a/net/ipv4/syncookies.c
+++ b/net/ipv4/syncookies.c
@@ -347,8 +347,8 @@ struct sock *cookie_v4_check(struct sock *sk, struct sk_buff *skb,
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
-- 
1.7.10.4


