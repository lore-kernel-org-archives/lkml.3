Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423045Ab3BANPm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 08:15:42 -0500
Received: from mail.kernel.org ([198.145.19.201]:45824 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422817Ab3BANPg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 08:15:36 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        canqun zhang <canqunzhang@gmail.com>,
        Gao feng <gaofeng@cn.fujitsu.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [ 85/89] netfilter: nf_conntrack: fix BUG_ON while removing nf_conntrack with netns
Date: Fri,  1 Feb 2013 14:08:40 +0100
Message-Id: <20130201130213.609279020@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.2.434.g9a6c84e.dirty
In-Reply-To: <20130201130207.444989281@linuxfoundation.org>
References: <20130201130207.444989281@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

commit 1e47ee8367babe6a5e8adf44a714c7086657b87e upstream.

canqun zhang reported that we're hitting BUG_ON in the
nf_conntrack_destroy path when calling kfree_skb while
rmmod'ing the nf_conntrack module.

Currently, the nf_ct_destroy hook is being set to NULL in the
destroy path of conntrack.init_net. However, this is a problem
since init_net may be destroyed before any other existing netns
(we cannot assume any specific ordering while releasing existing
netns according to what I read in recent emails).

Thanks to Gao feng for initial patch to address this issue.

Reported-by: canqun zhang <canqunzhang@gmail.com>
Acked-by: Gao feng <gaofeng@cn.fujitsu.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/net/netfilter/nf_conntrack_core.h |    2 ++
 net/netfilter/nf_conntrack_core.c         |    9 +++++----
 net/netfilter/nf_conntrack_standalone.c   |    1 +
 3 files changed, 8 insertions(+), 4 deletions(-)

--- a/include/net/netfilter/nf_conntrack_core.h
+++ b/include/net/netfilter/nf_conntrack_core.h
@@ -31,6 +31,8 @@ extern void nf_conntrack_cleanup(struct
 extern int nf_conntrack_proto_init(struct net *net);
 extern void nf_conntrack_proto_fini(struct net *net);
 
+extern void nf_conntrack_cleanup_end(void);
+
 extern bool
 nf_ct_get_tuple(const struct sk_buff *skb,
 		unsigned int nhoff,
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1383,11 +1383,12 @@ void nf_conntrack_cleanup(struct net *ne
 	synchronize_net();
 	nf_conntrack_proto_fini(net);
 	nf_conntrack_cleanup_net(net);
+}
 
-	if (net_eq(net, &init_net)) {
-		RCU_INIT_POINTER(nf_ct_destroy, NULL);
-		nf_conntrack_cleanup_init_net();
-	}
+void nf_conntrack_cleanup_end(void)
+{
+	RCU_INIT_POINTER(nf_ct_destroy, NULL);
+	nf_conntrack_cleanup_init_net();
 }
 
 void *nf_ct_alloc_hashtable(unsigned int *sizep, int nulls)
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -571,6 +571,7 @@ static int __init nf_conntrack_standalon
 static void __exit nf_conntrack_standalone_fini(void)
 {
 	unregister_pernet_subsys(&nf_conntrack_net_ops);
+	nf_conntrack_cleanup_end();
 }
 
 module_init(nf_conntrack_standalone_init);


