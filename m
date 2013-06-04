Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754790Ab3FDWqL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 18:46:11 -0400
Received: from 1wt.eu ([62.212.114.60]:35940 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752667Ab3FDWoy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 18:44:54 -0400
Message-Id: <20130604172137.437323314@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 04 Jun 2013 19:24:22 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Mathias Krause <minipli@googlemail.com>,
        Wensong Zhang <wensong@linux-vs.org>,
        Simon Horman <horms@verge.net.au>, Julian Anastasov <ja@ssi.bg>,
        "David S. Miller" <davem@davemloft.net>, Willy Tarreau <w@1wt.eu>
Subject: [ 172/184] ipvs: fix info leak in
In-Reply-To: <58df134a4b98edf5b0073e2e1e988fe6@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------
 getsockopt(IP_VS_SO_GET_TIMEOUT)

From: Mathias Krause <minipli@googlemail.com>

commit 2d8a041b7bfe1097af21441cb77d6af95f4f4680 upstream.

If at least one of CONFIG_IP_VS_PROTO_TCP or CONFIG_IP_VS_PROTO_UDP is
not set, __ip_vs_get_timeouts() does not fully initialize the structure
that gets copied to userland and that for leaks up to 12 bytes of kernel
stack. Add an explicit memset(0) before passing the structure to
__ip_vs_get_timeouts() to avoid the info leak.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Cc: Wensong Zhang <wensong@linux-vs.org>
Cc: Simon Horman <horms@verge.net.au>
Cc: Julian Anastasov <ja@ssi.bg>
Signed-off-by: David S. Miller <davem@davemloft.net>
[bwh: Backported to 2.6.32: adjust context]
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 net/netfilter/ipvs/ip_vs_ctl.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
index 02b2610..9bcd972 100644
--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -2455,6 +2455,7 @@ do_ip_vs_get_ctl(struct sock *sk, int cmd, void __user *user, int *len)
 	{
 		struct ip_vs_timeout_user t;
 
+		memset(&t, 0, sizeof(t));
 		__ip_vs_get_timeouts(&t);
 		if (copy_to_user(user, &t, sizeof(t)) != 0)
 			ret = -EFAULT;
-- 
1.7.12.2.21.g234cd45.dirty



