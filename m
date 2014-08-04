Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753856AbaHDREf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 13:04:35 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56520 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751913AbaHDQt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 12:49:56 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Michal Schmidt" <mschmidt@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Date: Mon, 04 Aug 2014 17:48:32 +0100
Message-ID: <lsq.1407170912.920871543@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 64/94] rtnetlink: fix userspace API breakage for
 iproute2 < v3.9.0
In-Reply-To: <lsq.1407170911.107020799@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.62-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/core/rtnetlink.c | 22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -1062,6 +1062,7 @@ static int rtnl_dump_ifinfo(struct sk_bu
 	struct nlattr *tb[IFLA_MAX+1];
 	u32 ext_filter_mask = 0;
 	int err;
+	int hdrlen;
 
 	s_h = cb->args[0];
 	s_idx = cb->args[1];
@@ -1069,8 +1070,17 @@ static int rtnl_dump_ifinfo(struct sk_bu
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
@@ -1917,9 +1927,13 @@ static u16 rtnl_calcit(struct sk_buff *s
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

