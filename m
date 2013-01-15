Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934383Ab3AOXFF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 18:05:05 -0500
Received: from mail.kernel.org ([198.145.19.201]:48351 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934349Ab3AOW5L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:57:11 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Greg Rose <gregory.v.rose@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ben Hutchings <bhutchings@solarflare.com>
Subject: [ 45/71] rtnetlink: fix rtnl_calcit() and rtnl_dump_ifinfo()
Date: Tue, 15 Jan 2013 14:54:42 -0800
Message-Id: <20130115225343.665402101@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115225340.367496998@linuxfoundation.org>
References: <20130115225340.367496998@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Eric Dumazet <eric.dumazet@gmail.com>

commit a4b64fbe482c7766f7925f03067fc637716bfa3f upstream.

nlmsg_parse() might return an error, so test its return value before
potential random memory accesses.

Errors introduced in commit 115c9b81928 (rtnetlink: Fix problem with
buffer allocation)

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Acked-by: Greg Rose <gregory.v.rose@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: Ben Hutchings <bhutchings@solarflare.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/rtnetlink.c |   18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -1044,11 +1044,12 @@ static int rtnl_dump_ifinfo(struct sk_bu
 
 	rcu_read_lock();
 
-	nlmsg_parse(cb->nlh, sizeof(struct rtgenmsg), tb, IFLA_MAX,
-		    ifla_policy);
+	if (nlmsg_parse(cb->nlh, sizeof(struct rtgenmsg), tb, IFLA_MAX,
+			ifla_policy) >= 0) {
 
-	if (tb[IFLA_EXT_MASK])
-		ext_filter_mask = nla_get_u32(tb[IFLA_EXT_MASK]);
+		if (tb[IFLA_EXT_MASK])
+			ext_filter_mask = nla_get_u32(tb[IFLA_EXT_MASK]);
+	}
 
 	for (h = s_h; h < NETDEV_HASHENTRIES; h++, s_idx = 0) {
 		idx = 0;
@@ -1874,10 +1875,11 @@ static u16 rtnl_calcit(struct sk_buff *s
 	u32 ext_filter_mask = 0;
 	u16 min_ifinfo_dump_size = 0;
 
-	nlmsg_parse(nlh, sizeof(struct rtgenmsg), tb, IFLA_MAX, ifla_policy);
-
-	if (tb[IFLA_EXT_MASK])
-		ext_filter_mask = nla_get_u32(tb[IFLA_EXT_MASK]);
+	if (nlmsg_parse(nlh, sizeof(struct rtgenmsg), tb, IFLA_MAX,
+			ifla_policy) >= 0) {
+		if (tb[IFLA_EXT_MASK])
+			ext_filter_mask = nla_get_u32(tb[IFLA_EXT_MASK]);
+	}
 
 	if (!ext_filter_mask)
 		return NLMSG_GOODSIZE;


