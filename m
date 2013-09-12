Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757294Ab3ILSZW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 14:25:22 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57024 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755103Ab3ILR7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 13:59:10 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Pravin B Shelar <pshelar@nicira.com>, Jesse Gross <jesse@nicira.com>,
        Johannes Berg <johannes.berg@intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 15/46] genl: Fix genl dumpit() locking.
Date: Thu, 12 Sep 2013 10:58:26 -0700
Message-Id: <20130912175722.697613353@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130912175721.001906199@linuxfoundation.org>
References: <20130912175721.001906199@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pravin B Shelar <pshelar@nicira.com>

[ Upstream commit 9b96309c5b0b9e466773c07a5bc8b7b68fcf010a ]

In case of genl-family with parallel ops off, dumpif() callback
is expected to run under genl_lock, But commit def3117493eafd9df
(genl: Allow concurrent genl callbacks.) changed this behaviour
where only first dumpit() op was called under genl-lock.
For subsequent dump, only nlk->cb_lock was taken.
Following patch fixes it by defining locked dumpit() and done()
callback which takes care of genl-locking.

Signed-off-by: Pravin B Shelar <pshelar@nicira.com>
CC: Jesse Gross <jesse@nicira.com>
CC: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netlink/genetlink.c |   51 +++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 46 insertions(+), 5 deletions(-)

--- a/net/netlink/genetlink.c
+++ b/net/netlink/genetlink.c
@@ -544,6 +544,30 @@ void *genlmsg_put(struct sk_buff *skb, u
 }
 EXPORT_SYMBOL(genlmsg_put);
 
+static int genl_lock_dumpit(struct sk_buff *skb, struct netlink_callback *cb)
+{
+	struct genl_ops *ops = cb->data;
+	int rc;
+
+	genl_lock();
+	rc = ops->dumpit(skb, cb);
+	genl_unlock();
+	return rc;
+}
+
+static int genl_lock_done(struct netlink_callback *cb)
+{
+	struct genl_ops *ops = cb->data;
+	int rc = 0;
+
+	if (ops->done) {
+		genl_lock();
+		rc = ops->done(cb);
+		genl_unlock();
+	}
+	return rc;
+}
+
 static int genl_family_rcv_msg(struct genl_family *family,
 			       struct sk_buff *skb,
 			       struct nlmsghdr *nlh)
@@ -572,15 +596,32 @@ static int genl_family_rcv_msg(struct ge
 		return -EPERM;
 
 	if (nlh->nlmsg_flags & NLM_F_DUMP) {
-		struct netlink_dump_control c = {
-			.dump = ops->dumpit,
-			.done = ops->done,
-		};
+		int rc;
 
 		if (ops->dumpit == NULL)
 			return -EOPNOTSUPP;
 
-		return netlink_dump_start(net->genl_sock, skb, nlh, &c);
+		if (!family->parallel_ops) {
+			struct netlink_dump_control c = {
+				.data = ops,
+				.dump = genl_lock_dumpit,
+				.done = genl_lock_done,
+			};
+
+			genl_unlock();
+			rc = netlink_dump_start(net->genl_sock, skb, nlh, &c);
+			genl_lock();
+
+		} else {
+			struct netlink_dump_control c = {
+				.dump = ops->dumpit,
+				.done = ops->done,
+			};
+
+			rc = netlink_dump_start(net->genl_sock, skb, nlh, &c);
+		}
+
+		return rc;
 	}
 
 	if (ops->doit == NULL)


