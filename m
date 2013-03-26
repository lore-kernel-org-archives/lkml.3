Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755543Ab3CZRoc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 13:44:32 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:21168 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754222Ab3CZRgX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 13:36:23 -0400
X-Authority-Analysis: v=2.0 cv=adbjbGUt c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=h8IdcS_5o9AA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=5ssdZkUycogA:10 a=20KFwNOVAAAA:8 a=pGLkceISAAAA:8 a=vmLDa1wCAAAA:8 a=omOdbC7AAAAA:8 a=h1aNt0RaAAAA:8 a=1XWaLZrsAAAA:8 a=J1Y8HTJGAAAA:8 a=OxYGjdJUcJ8bh1yOWlQA:9 a=MSl-tDqOz04A:10 a=gv_BBZfBKR8A:10 a=9n0VZpmWo7gA:10 a=UTB_XpHje0EA:10 a=4N9Db7Z2_RYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130326173612.927497450@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 26 Mar 2013 13:22:21 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Eric Dumazet <eric.dumazet@gmail.com>, Neil Horman <nhorman@tuxdriver.com>,
        Gao Feng <gaofeng@cn.fujitsu.com>,
        YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>,
        Eric Dumazet <edumazet@google.com>,
        "Steinar H. Gunderson" <sesse@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 82/86] ipv6: fix race condition regarding dst->expires and dst->from.
References: <20130326172059.136127374@goodmis.org>
Content-Disposition: inline; filename=0082-ipv6-fix-race-condition-regarding-dst-expires-and-ds.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.1 stable review patch.
If anyone has any objections, please let me know.

------------------

[ Upstream commit eaf11ca939f83c273740d5bcec7225969ae95295 ]

Eric Dumazet wrote:
| Some strange crashes happen in rt6_check_expired(), with access
| to random addresses.
|
| At first glance, it looks like the RTF_EXPIRES and
| stuff added in commit 1716a96101c49186b
| (ipv6: fix problem with expired dst cache)
| are racy : same dst could be manipulated at the same time
| on different cpus.
|
| At some point, our stack believes rt->dst.from contains a dst pointer,
| while its really a jiffie value (as rt->dst.expires shares the same area
| of memory)
|
| rt6_update_expires() should be fixed, or am I missing something ?
|
| CC Neil because of https://bugzilla.redhat.com/show_bug.cgi?id=892060

Because we do not have any locks for dst_entry, we cannot change
essential structure in the entry; e.g., we cannot change reference
to other entity.

To fix this issue, split 'from' and 'expires' field in dst_entry
out of union.  Once it is 'from' is assigned in the constructor,
keep the reference until the very last stage of the life time of
the object.

Of course, it is unsafe to change 'from', so make rt6_set_from simple
just for fresh entries.

Reported-by: Eric Dumazet <eric.dumazet@gmail.com>
Reported-by: Neil Horman <nhorman@tuxdriver.com>
CC: Gao Feng <gaofeng@cn.fujitsu.com>
Signed-off-by: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Reported-by: Steinar H. Gunderson <sesse@google.com>
Reviewed-by: Neil Horman <nhorman@tuxdriver.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 include/net/dst.h     |    8 ++------
 include/net/ip6_fib.h |   39 ++++++++++++---------------------------
 net/core/dst.c        |    1 +
 net/ipv6/route.c      |    8 +++-----
 4 files changed, 18 insertions(+), 38 deletions(-)

diff --git a/include/net/dst.h b/include/net/dst.h
index 621e351..3e3fffe 100644
--- a/include/net/dst.h
+++ b/include/net/dst.h
@@ -36,13 +36,9 @@ struct dst_entry {
 	struct net_device       *dev;
 	struct  dst_ops	        *ops;
 	unsigned long		_metrics;
-	union {
-		unsigned long           expires;
-		/* point to where the dst_entry copied from */
-		struct dst_entry        *from;
-	};
+	unsigned long           expires;
 	struct dst_entry	*path;
-	void			*__pad0;
+	struct dst_entry	*from;
 #ifdef CONFIG_XFRM
 	struct xfrm_state	*xfrm;
 #else
diff --git a/include/net/ip6_fib.h b/include/net/ip6_fib.h
index 9fc7114..0235de8 100644
--- a/include/net/ip6_fib.h
+++ b/include/net/ip6_fib.h
@@ -156,50 +156,35 @@ static inline struct inet6_dev *ip6_dst_idev(struct dst_entry *dst)
 
 static inline void rt6_clean_expires(struct rt6_info *rt)
 {
-	if (!(rt->rt6i_flags & RTF_EXPIRES) && rt->dst.from)
-		dst_release(rt->dst.from);
-
 	rt->rt6i_flags &= ~RTF_EXPIRES;
-	rt->dst.from = NULL;
 }
 
 static inline void rt6_set_expires(struct rt6_info *rt, unsigned long expires)
 {
-	if (!(rt->rt6i_flags & RTF_EXPIRES) && rt->dst.from)
-		dst_release(rt->dst.from);
-
-	rt->rt6i_flags |= RTF_EXPIRES;
 	rt->dst.expires = expires;
+	rt->rt6i_flags |= RTF_EXPIRES;
 }
 
-static inline void rt6_update_expires(struct rt6_info *rt, int timeout)
+static inline void rt6_update_expires(struct rt6_info *rt0, int timeout)
 {
-	if (!(rt->rt6i_flags & RTF_EXPIRES)) {
-		if (rt->dst.from)
-			dst_release(rt->dst.from);
-		/* dst_set_expires relies on expires == 0 
-		 * if it has not been set previously.
-		 */
-		rt->dst.expires = 0;
-	}
-
-	dst_set_expires(&rt->dst, timeout);
-	rt->rt6i_flags |= RTF_EXPIRES;
+	struct rt6_info *rt;
+
+	for (rt = rt0; rt && !(rt->rt6i_flags & RTF_EXPIRES);
+	     rt = (struct rt6_info *)rt->dst.from);
+	if (rt && rt != rt0)
+		rt0->dst.expires = rt->dst.expires;
+
+	dst_set_expires(&rt0->dst, timeout);
+	rt0->rt6i_flags |= RTF_EXPIRES;
 }
 
 static inline void rt6_set_from(struct rt6_info *rt, struct rt6_info *from)
 {
 	struct dst_entry *new = (struct dst_entry *) from;
 
-	if (!(rt->rt6i_flags & RTF_EXPIRES) && rt->dst.from) {
-		if (new == rt->dst.from)
-			return;
-		dst_release(rt->dst.from);
-	}
-
 	rt->rt6i_flags &= ~RTF_EXPIRES;
-	rt->dst.from = new;
 	dst_hold(new);
+	rt->dst.from = new;
 }
 
 struct fib6_walker_t {
diff --git a/net/core/dst.c b/net/core/dst.c
index 56d6361..c63220e 100644
--- a/net/core/dst.c
+++ b/net/core/dst.c
@@ -179,6 +179,7 @@ void *dst_alloc(struct dst_ops *ops, struct net_device *dev,
 	dst_init_metrics(dst, dst_default_metrics, true);
 	dst->expires = 0UL;
 	dst->path = dst;
+	dst->from = NULL;
 #ifdef CONFIG_XFRM
 	dst->xfrm = NULL;
 #endif
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index db30daf..103880b 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -297,6 +297,7 @@ static void ip6_dst_destroy(struct dst_entry *dst)
 {
 	struct rt6_info *rt = (struct rt6_info *)dst;
 	struct inet6_dev *idev = rt->rt6i_idev;
+	struct dst_entry *from = dst->from;
 
 	if (rt->n)
 		neigh_release(rt->n);
@@ -309,8 +310,8 @@ static void ip6_dst_destroy(struct dst_entry *dst)
 		in6_dev_put(idev);
 	}
 
-	if (!(rt->rt6i_flags & RTF_EXPIRES) && dst->from)
-		dst_release(dst->from);
+	dst->from = NULL;
+	dst_release(from);
 
 	if (rt6_has_peer(rt)) {
 		struct inet_peer *peer = rt6_peer_ptr(rt);
@@ -1007,7 +1008,6 @@ struct dst_entry *ip6_blackhole_route(struct net *net, struct dst_entry *dst_ori
 
 		rt->rt6i_gateway = ort->rt6i_gateway;
 		rt->rt6i_flags = ort->rt6i_flags;
-		rt6_clean_expires(rt);
 		rt->rt6i_metric = 0;
 
 		memcpy(&rt->rt6i_dst, &ort->rt6i_dst, sizeof(struct rt6key));
@@ -1810,8 +1810,6 @@ static struct rt6_info *ip6_rt_copy(struct rt6_info *ort,
 		if ((ort->rt6i_flags & (RTF_DEFAULT | RTF_ADDRCONF)) ==
 		    (RTF_DEFAULT | RTF_ADDRCONF))
 			rt6_set_from(rt, ort);
-		else
-			rt6_clean_expires(rt);
 		rt->rt6i_metric = 0;
 
 #ifdef CONFIG_IPV6_SUBTREES
-- 
1.7.10.4


