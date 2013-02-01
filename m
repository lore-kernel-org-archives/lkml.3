Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423018Ab3BANP2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 08:15:28 -0500
Received: from mail.kernel.org ([198.145.19.201]:45801 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422817Ab3BANPT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 08:15:19 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Vitaly E. Lavrov" <lve@guap.ru>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [ 83/89] netfilter: xt_recent: fix namespace destroy path
Date: Fri,  1 Feb 2013 14:08:38 +0100
Message-Id: <20130201130213.470814202@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.2.434.g9a6c84e.dirty
In-Reply-To: <20130201130207.444989281@linuxfoundation.org>
References: <20130201130207.444989281@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Vitaly E. Lavrov" <lve@guap.ru>

commit 665e205c16c1f902ac6763b8ce8a0a3a1dcefe59 upstream.

recent_net_exit() is called before recent_mt_destroy() in the
destroy path of network namespaces. Make sure there are no entries
in the parent proc entry xt_recent before removing it.

Signed-off-by: Vitaly E. Lavrov <lve@guap.ru>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/netfilter/xt_recent.c |   20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

--- a/net/netfilter/xt_recent.c
+++ b/net/netfilter/xt_recent.c
@@ -431,7 +431,8 @@ static void recent_mt_destroy(const stru
 		list_del(&t->list);
 		spin_unlock_bh(&recent_lock);
 #ifdef CONFIG_PROC_FS
-		remove_proc_entry(t->name, recent_net->xt_recent);
+		if (recent_net->xt_recent != NULL)
+			remove_proc_entry(t->name, recent_net->xt_recent);
 #endif
 		recent_table_flush(t);
 		kfree(t);
@@ -615,6 +616,20 @@ static int __net_init recent_proc_net_in
 
 static void __net_exit recent_proc_net_exit(struct net *net)
 {
+	struct recent_net *recent_net = recent_pernet(net);
+	struct recent_table *t;
+
+	/* recent_net_exit() is called before recent_mt_destroy(). Make sure
+	 * that the parent xt_recent proc entry is is empty before trying to
+	 * remove it.
+	 */
+	spin_lock_bh(&recent_lock);
+	list_for_each_entry(t, &recent_net->tables, list)
+	        remove_proc_entry(t->name, recent_net->xt_recent);
+
+	recent_net->xt_recent = NULL;
+	spin_unlock_bh(&recent_lock);
+
 	proc_net_remove(net, "xt_recent");
 }
 #else
@@ -638,9 +653,6 @@ static int __net_init recent_net_init(st
 
 static void __net_exit recent_net_exit(struct net *net)
 {
-	struct recent_net *recent_net = recent_pernet(net);
-
-	BUG_ON(!list_empty(&recent_net->tables));
 	recent_proc_net_exit(net);
 }
 


