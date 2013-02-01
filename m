Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422993Ab3BANPH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 08:15:07 -0500
Received: from mail.kernel.org ([198.145.19.201]:45771 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422817Ab3BANPC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 08:15:02 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Vitaly E. Lavrov" <lve@guap.ru>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [ 81/89] netfilter: xt_hashlimit: fix namespace destroy path
Date: Fri,  1 Feb 2013 14:08:36 +0100
Message-Id: <20130201130213.310470041@linuxfoundation.org>
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

commit 32263dd1b43378b4f7d7796ed713f77e95f27e8a upstream.

recent_net_exit() is called before recent_mt_destroy() in the
destroy path of network namespaces. Make sure there are no entries
in the parent proc entry xt_recent before removing it.

Signed-off-by: Vitaly E. Lavrov <lve@guap.ru>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/netfilter/xt_hashlimit.c |   29 +++++++++++++++++++++++++----
 1 file changed, 25 insertions(+), 4 deletions(-)

--- a/net/netfilter/xt_hashlimit.c
+++ b/net/netfilter/xt_hashlimit.c
@@ -318,7 +318,10 @@ static void htable_destroy(struct xt_has
 		parent = hashlimit_net->ipt_hashlimit;
 	else
 		parent = hashlimit_net->ip6t_hashlimit;
-	remove_proc_entry(hinfo->pde->name, parent);
+
+	if(parent != NULL)
+		remove_proc_entry(hinfo->pde->name, parent);
+
 	htable_selective_cleanup(hinfo, select_all);
 	vfree(hinfo);
 }
@@ -856,6 +859,27 @@ static int __net_init hashlimit_proc_net
 
 static void __net_exit hashlimit_proc_net_exit(struct net *net)
 {
+	struct xt_hashlimit_htable *hinfo;
+	struct hlist_node *pos;
+	struct proc_dir_entry *pde;
+	struct hashlimit_net *hashlimit_net = hashlimit_pernet(net);
+
+	/* recent_net_exit() is called before recent_mt_destroy(). Make sure
+	 * that the parent xt_recent proc entry is is empty before trying to
+	 * remove it.
+	 */
+	mutex_lock(&hashlimit_mutex);
+	pde = hashlimit_net->ipt_hashlimit;
+	if (pde == NULL)
+		pde = hashlimit_net->ip6t_hashlimit;
+
+	hlist_for_each_entry(hinfo, pos, &hashlimit_net->htables, node)
+		remove_proc_entry(hinfo->pde->name, pde);
+
+	hashlimit_net->ipt_hashlimit = NULL;
+	hashlimit_net->ip6t_hashlimit = NULL;
+	mutex_unlock(&hashlimit_mutex);
+
 	proc_net_remove(net, "ipt_hashlimit");
 #if IS_ENABLED(CONFIG_IP6_NF_IPTABLES)
 	proc_net_remove(net, "ip6t_hashlimit");
@@ -872,9 +896,6 @@ static int __net_init hashlimit_net_init
 
 static void __net_exit hashlimit_net_exit(struct net *net)
 {
-	struct hashlimit_net *hashlimit_net = hashlimit_pernet(net);
-
-	BUG_ON(!hlist_empty(&hashlimit_net->htables));
 	hashlimit_proc_net_exit(net);
 }
 


