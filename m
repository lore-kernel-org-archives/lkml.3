Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030435AbaGCJmO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 05:42:14 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52373 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754745AbaGCJYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 05:24:24 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Michal Schmidt <mschmidt@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 150/198] rtnetlink: fix userspace API breakage for iproute2 < v3.9.0
Date: Thu,  3 Jul 2014 10:19:53 +0100
Message-Id: <1404379241-8590-151-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
References: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Schmidt <mschmidt@redhat.com>

commit e5eca6d41f53db48edd8cf88a3f59d2c30227f8e upstream.

When running RHEL6 userspace on a current upstream kernel, "ip link"
fails to show VF information.

The reason is a kernel<->userspace API change introduced by commit
88c5b5ce5cb57 ("rtnetlink: Call nlmsg_parse() with correct header length"),
after which the kernel does not see iproute2's IFLA_EXT_MASK attribute
in the netlink request.

iproute2 adjusted for the API change in its commit 63338dca4513
("libnetlink: Use ifinfomsg instead of rtgenmsg in rtnl_wilddump_req_filter").

The problem has been noticed before:
http://marc.info/?l=linux-netdev&m=136692296022182&w=2
(Subject: Re: getting VF link info seems to be broken in 3.9-rc8)

We can do better than tell those with old userspace to upgrade. We can
recognize the old iproute2 in the kernel by checking the netlink message
length. Even when including the IFLA_EXT_MASK attribute, its netlink
message is shorter than struct ifinfomsg.

With this patch "ip link" shows VF information in both old and new
iproute2 versions.

Signed-off-by: Michal Schmidt <mschmidt@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
[ luis: backported to 3.11: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/core/rtnetlink.c | 22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 61b25794e74f..d6eac9f048b9 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -1053,6 +1053,7 @@ static int rtnl_dump_ifinfo(struct sk_buff *skb, struct netlink_callback *cb)
 	struct nlattr *tb[IFLA_MAX+1];
 	u32 ext_filter_mask = 0;
 	int err;
+	int hdrlen;
 
 	s_h = cb->args[0];
 	s_idx = cb->args[1];
@@ -1060,8 +1061,17 @@ static int rtnl_dump_ifinfo(struct sk_buff *skb, struct netlink_callback *cb)
 	rcu_read_lock();
 	cb->seq = net->dev_base_seq;
 
-	if (nlmsg_parse(cb->nlh, sizeof(struct ifinfomsg), tb, IFLA_MAX,
-			ifla_policy) >= 0) {
+	/* A hack to preserve kernel<->userspace interface.
+	 * The correct header is ifinfomsg. It is consistent with rtnl_getlink.
+	 * However, before Linux v3.9 the code here assumed rtgenmsg and that's
+	 * what iproute2 < v3.9.0 used.
+	 * We can detect the old iproute2. Even including the IFLA_EXT_MASK
+	 * attribute, its netlink message is shorter than struct ifinfomsg.
+	 */
+	hdrlen = nlmsg_len(cb->nlh) < sizeof(struct ifinfomsg) ?
+		 sizeof(struct rtgenmsg) : sizeof(struct ifinfomsg);
+
+	if (nlmsg_parse(cb->nlh, hdrlen, tb, IFLA_MAX, ifla_policy) >= 0) {
 
 		if (tb[IFLA_EXT_MASK])
 			ext_filter_mask = nla_get_u32(tb[IFLA_EXT_MASK]);
@@ -1925,9 +1935,13 @@ static u16 rtnl_calcit(struct sk_buff *skb, struct nlmsghdr *nlh)
 	struct nlattr *tb[IFLA_MAX+1];
 	u32 ext_filter_mask = 0;
 	u16 min_ifinfo_dump_size = 0;
+	int hdrlen;
+
+	/* Same kernel<->userspace interface hack as in rtnl_dump_ifinfo. */
+	hdrlen = nlmsg_len(nlh) < sizeof(struct ifinfomsg) ?
+		 sizeof(struct rtgenmsg) : sizeof(struct ifinfomsg);
 
-	if (nlmsg_parse(nlh, sizeof(struct ifinfomsg), tb, IFLA_MAX,
-			ifla_policy) >= 0) {
+	if (nlmsg_parse(nlh, hdrlen, tb, IFLA_MAX, ifla_policy) >= 0) {
 		if (tb[IFLA_EXT_MASK])
 			ext_filter_mask = nla_get_u32(tb[IFLA_EXT_MASK]);
 	}
-- 
1.9.1

