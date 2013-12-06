Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759135Ab3LFVwu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 16:52:50 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60519 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754730Ab3LFVwj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 16:52:39 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alexei Starovoitov <ast@plumgrid.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.12 41/83] ipv4: fix race in concurrent ip_route_input_slow()
Date: Fri,  6 Dec 2013 13:51:31 -0800
Message-Id: <20131206214643.876014820@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.67.gb00d244
In-Reply-To: <20131206214640.002320724@linuxfoundation.org>
References: <20131206214640.002320724@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexei Starovoitov <ast@plumgrid.com>

[ Upstream commit dcdfdf56b4a6c9437fc37dbc9cee94a788f9b0c4 ]

CPUs can ask for local route via ip_route_input_noref() concurrently.
if nh_rth_input is not cached yet, CPUs will proceed to allocate
equivalent DSTs on 'lo' and then will try to cache them in nh_rth_input
via rt_cache_route()
Most of the time they succeed, but on occasion the following two lines:
	orig = *p;
	prev = cmpxchg(p, orig, rt);
in rt_cache_route() do race and one of the cpus fails to complete cmpxchg.
But ip_route_input_slow() doesn't check the return code of rt_cache_route(),
so dst is leaking. dst_destroy() is never called and 'lo' device
refcnt doesn't go to zero, which can be seen in the logs as:
	unregister_netdevice: waiting for lo to become free. Usage count = 1
Adding mdelay() between above two lines makes it easily reproducible.
Fix it similar to nh_pcpu_rth_output case.

Fixes: d2d68ba9fe8b ("ipv4: Cache input routes in fib_info nexthops.")
Signed-off-by: Alexei Starovoitov <ast@plumgrid.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/route.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -1772,8 +1772,12 @@ local_input:
 		rth->dst.error= -err;
 		rth->rt_flags 	&= ~RTCF_LOCAL;
 	}
-	if (do_cache)
-		rt_cache_route(&FIB_RES_NH(res), rth);
+	if (do_cache) {
+		if (unlikely(!rt_cache_route(&FIB_RES_NH(res), rth))) {
+			rth->dst.flags |= DST_NOCACHE;
+			rt_add_uncached_list(rth);
+		}
+	}
 	skb_dst_set(skb, &rth->dst);
 	err = 0;
 	goto out;


