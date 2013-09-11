Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755903Ab3IKE6c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 00:58:32 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:22176 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754288Ab3IKE5A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 00:57:00 -0400
X-Authority-Analysis: v=2.0 cv=V4T/IJbi c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=HpurA7B_sYUA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=7Tqv5ZG2UGkA:10 a=QyXUC8HyAAAA:8 a=VwQbUJbxAAAA:8 a=J1Y8HTJGAAAA:8 a=5cIBTxRJ4pZzZk2xk6UA:9 a=dGJ0OcVc7YAA:10 a=4N9Db7Z2_RYA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042925.297207769@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:30:26 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Andrei Otcheretianski <andrei.otcheretianski@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [199/251] genetlink: fix family dump race
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0199-genetlink-fix-family-dump-race.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 58ad436fcf49810aa006016107f494c9ac9013db ]

When dumping generic netlink families, only the first dump call
is locked with genl_lock(), which protects the list of families,
and thus subsequent calls can access the data without locking,
racing against family addition/removal. This can cause a crash.
Fix it - the locking needs to be conditional because the first
time around it's already locked.

A similar bug was reported to me on an old kernel (3.4.47) but
the exact scenario that happened there is no longer possible,
on those kernels the first round wasn't locked either. Looking
at the current code I found the race described above, which had
also existed on the old kernel.

Cc: stable@vger.kernel.org
Reported-by: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 net/netlink/genetlink.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/netlink/genetlink.c b/net/netlink/genetlink.c
index 42556ce..17e7104 100644
--- a/net/netlink/genetlink.c
+++ b/net/netlink/genetlink.c
@@ -749,6 +749,10 @@ static int ctrl_dumpfamily(struct sk_buff *skb, struct netlink_callback *cb)
 	struct net *net = sock_net(skb->sk);
 	int chains_to_skip = cb->args[0];
 	int fams_to_skip = cb->args[1];
+	bool need_locking = chains_to_skip || fams_to_skip;
+
+	if (need_locking)
+		genl_lock();
 
 	for (i = chains_to_skip; i < GENL_FAM_TAB_SIZE; i++) {
 		n = 0;
@@ -770,6 +774,9 @@ errout:
 	cb->args[0] = i;
 	cb->args[1] = n;
 
+	if (need_locking)
+		genl_unlock();
+
 	return skb->len;
 }
 
-- 
1.7.10.4


