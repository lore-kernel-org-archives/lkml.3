Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936311Ab3DKVTi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 17:19:38 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:2760 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935467Ab3DKUsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:48:55 -0400
X-Authority-Analysis: v=2.0 cv=F+XVh9dN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=azyGtpXCO3wA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=9_77BVQ30tUA:10 a=1XWaLZrsAAAA:8 a=J1Y8HTJGAAAA:8 a=i5l3BeYsPBN1KbzBBJEA:9 a=UTB_XpHje0EA:10 a=4N9Db7Z2_RYA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130411202610.234043385@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 11 Apr 2013 16:27:29 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Laurent Chavey <chavey@google.com>, Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 146/171 ] net: remove a WARN_ON() in net_enable_timestamp()
References: <20130411202503.783159048@goodmis.org>
Content-Disposition: inline; filename=0146-net-remove-a-WARN_ON-in-net_enable_timestamp.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.2 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 9979a55a833883242e3a29f3596676edd7199c46 ]

The WARN_ON(in_interrupt()) in net_enable_timestamp() can get false
positive, in socket clone path, run from softirq context :

[ 3641.624425] WARNING: at net/core/dev.c:1532 net_enable_timestamp+0x7b/0x80()
[ 3641.668811] Call Trace:
[ 3641.671254]  <IRQ>  [<ffffffff80286817>] warn_slowpath_common+0x87/0xc0
[ 3641.677871]  [<ffffffff8028686a>] warn_slowpath_null+0x1a/0x20
[ 3641.683683]  [<ffffffff80742f8b>] net_enable_timestamp+0x7b/0x80
[ 3641.689668]  [<ffffffff80732ce5>] sk_clone_lock+0x425/0x450
[ 3641.695222]  [<ffffffff8078db36>] inet_csk_clone_lock+0x16/0x170
[ 3641.701213]  [<ffffffff807ae449>] tcp_create_openreq_child+0x29/0x820
[ 3641.707663]  [<ffffffff807d62e2>] ? ipt_do_table+0x222/0x670
[ 3641.713354]  [<ffffffff807aaf5b>] tcp_v4_syn_recv_sock+0xab/0x3d0
[ 3641.719425]  [<ffffffff807af63a>] tcp_check_req+0x3da/0x530
[ 3641.724979]  [<ffffffff8078b400>] ? inet_hashinfo_init+0x60/0x80
[ 3641.730964]  [<ffffffff807ade6f>] ? tcp_v4_rcv+0x79f/0xbe0
[ 3641.736430]  [<ffffffff807ab9bd>] tcp_v4_do_rcv+0x38d/0x4f0
[ 3641.741985]  [<ffffffff807ae14a>] tcp_v4_rcv+0xa7a/0xbe0

Its safe at this point because the parent socket owns a reference
on the netstamp_needed, so we cant have a 0 -> 1 transition, which
requires to lock a mutex.

Instead of refining the check, lets remove it, as all known callers
are safe. If it ever changes in the future, static_key_slow_inc()
will complain anyway.

Reported-by: Laurent Chavey <chavey@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 net/core/dev.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index c41efb7..d283020 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -1481,7 +1481,6 @@ void net_enable_timestamp(void)
 		return;
 	}
 #endif
-	WARN_ON(in_interrupt());
 	static_key_slow_inc(&netstamp_needed);
 }
 EXPORT_SYMBOL(net_enable_timestamp);
-- 
1.7.10.4


