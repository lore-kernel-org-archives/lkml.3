Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757405Ab3ILSXo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 14:23:44 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57033 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755446Ab3ILR7L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 13:59:11 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Pravin B Shelar <pshelar@nicira.com>, Jesse Gross <jesse@nicira.com>,
        Johannes Berg <johannes.berg@intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 16/46] genl: Hold reference on correct module while netlink-dump.
Date: Thu, 12 Sep 2013 10:58:27 -0700
Message-Id: <20130912175722.808067311@linuxfoundation.org>
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

[ Upstream commit 33c6b1f6b154894321f5734e50c66621e9134e7e ]

netlink dump operations take module as parameter to hold
reference for entire netlink dump duration.
Currently it holds ref only on genl module which is not correct
when we use ops registered to genl from another module.
Following patch adds module pointer to genl_ops so that netlink
can hold ref count on it.

Signed-off-by: Pravin B Shelar <pshelar@nicira.com>
CC: Jesse Gross <jesse@nicira.com>
CC: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/genetlink.h |   20 ++++++++++++++++++--
 net/netlink/genetlink.c |   20 +++++++++++---------
 2 files changed, 29 insertions(+), 11 deletions(-)

--- a/include/net/genetlink.h
+++ b/include/net/genetlink.h
@@ -61,6 +61,7 @@ struct genl_family {
 	struct list_head	ops_list;	/* private */
 	struct list_head	family_list;	/* private */
 	struct list_head	mcast_groups;	/* private */
+	struct module		*module;
 };
 
 /**
@@ -121,9 +122,24 @@ struct genl_ops {
 	struct list_head	ops_list;
 };
 
-extern int genl_register_family(struct genl_family *family);
-extern int genl_register_family_with_ops(struct genl_family *family,
+extern int __genl_register_family(struct genl_family *family);
+
+static inline int genl_register_family(struct genl_family *family)
+{
+	family->module = THIS_MODULE;
+	return __genl_register_family(family);
+}
+
+extern int __genl_register_family_with_ops(struct genl_family *family,
 	struct genl_ops *ops, size_t n_ops);
+
+static inline int genl_register_family_with_ops(struct genl_family *family,
+	struct genl_ops *ops, size_t n_ops)
+{
+	family->module = THIS_MODULE;
+	return __genl_register_family_with_ops(family, ops, n_ops);
+}
+
 extern int genl_unregister_family(struct genl_family *family);
 extern int genl_register_ops(struct genl_family *, struct genl_ops *ops);
 extern int genl_unregister_ops(struct genl_family *, struct genl_ops *ops);
--- a/net/netlink/genetlink.c
+++ b/net/netlink/genetlink.c
@@ -364,7 +364,7 @@ int genl_unregister_ops(struct genl_fami
 EXPORT_SYMBOL(genl_unregister_ops);
 
 /**
- * genl_register_family - register a generic netlink family
+ * __genl_register_family - register a generic netlink family
  * @family: generic netlink family
  *
  * Registers the specified family after validating it first. Only one
@@ -374,7 +374,7 @@ EXPORT_SYMBOL(genl_unregister_ops);
  *
  * Return 0 on success or a negative error code.
  */
-int genl_register_family(struct genl_family *family)
+int __genl_register_family(struct genl_family *family)
 {
 	int err = -EINVAL;
 
@@ -430,10 +430,10 @@ errout_locked:
 errout:
 	return err;
 }
-EXPORT_SYMBOL(genl_register_family);
+EXPORT_SYMBOL(__genl_register_family);
 
 /**
- * genl_register_family_with_ops - register a generic netlink family
+ * __genl_register_family_with_ops - register a generic netlink family
  * @family: generic netlink family
  * @ops: operations to be registered
  * @n_ops: number of elements to register
@@ -457,12 +457,12 @@ EXPORT_SYMBOL(genl_register_family);
  *
  * Return 0 on success or a negative error code.
  */
-int genl_register_family_with_ops(struct genl_family *family,
+int __genl_register_family_with_ops(struct genl_family *family,
 	struct genl_ops *ops, size_t n_ops)
 {
 	int err, i;
 
-	err = genl_register_family(family);
+	err = __genl_register_family(family);
 	if (err)
 		return err;
 
@@ -476,7 +476,7 @@ err_out:
 	genl_unregister_family(family);
 	return err;
 }
-EXPORT_SYMBOL(genl_register_family_with_ops);
+EXPORT_SYMBOL(__genl_register_family_with_ops);
 
 /**
  * genl_unregister_family - unregister generic netlink family
@@ -603,22 +603,24 @@ static int genl_family_rcv_msg(struct ge
 
 		if (!family->parallel_ops) {
 			struct netlink_dump_control c = {
+				.module = family->module,
 				.data = ops,
 				.dump = genl_lock_dumpit,
 				.done = genl_lock_done,
 			};
 
 			genl_unlock();
-			rc = netlink_dump_start(net->genl_sock, skb, nlh, &c);
+			rc = __netlink_dump_start(net->genl_sock, skb, nlh, &c);
 			genl_lock();
 
 		} else {
 			struct netlink_dump_control c = {
+				.module = family->module,
 				.dump = ops->dumpit,
 				.done = ops->done,
 			};
 
-			rc = netlink_dump_start(net->genl_sock, skb, nlh, &c);
+			rc = __netlink_dump_start(net->genl_sock, skb, nlh, &c);
 		}
 
 		return rc;


