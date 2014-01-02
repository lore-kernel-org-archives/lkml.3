Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752579AbaABRGS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 12:06:18 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40233 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752486AbaABRGQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 12:06:16 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alexei Starovoitov <ast@plumgrid.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 27/91] ipv4: fix race in concurrent ip_route_input_slow()
Date: Thu,  2 Jan 2014 09:04:02 -0800
Message-Id: <1388682306-30859-28-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1388682306-30859-1-git-send-email-kamal@canonical.com>
References: <1388682306-30859-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.15 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/ipv4/route.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 0bf88e4..c219f8b 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -1724,8 +1724,12 @@ local_input:
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
-- 
1.8.3.2

