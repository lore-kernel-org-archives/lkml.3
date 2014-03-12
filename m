Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756678AbaCLH4v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 03:56:51 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:44060 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756283AbaCLH4t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 03:56:49 -0400
From: Zhouyi Zhou <zhouzhouyi@gmail.com>
To: <davem@davemloft.net>, <pablo@netfilter.org>, <jbenc@redhat.com>,
        <brouer@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Cc: Zhouyi Zhou <yizhouzhou@ict.ac.cn>
Subject: [PATCH RFC] netfilter: cacheline aligning in struct netns_ct
Date: Wed, 12 Mar 2014 15:56:34 +0800
Message-Id: <1394610994-22794-1-git-send-email-yizhouzhou@ict.ac.cn>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

not frequently changing components should share same cachelines

Signed-off-by: Zhouyi Zhou <yizhouzhou@ict.ac.cn>
---
 include/net/netns/conntrack.h |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/include/net/netns/conntrack.h b/include/net/netns/conntrack.h
index fbcc7fa..69d2d58 100644
--- a/include/net/netns/conntrack.h
+++ b/include/net/netns/conntrack.h
@@ -65,6 +65,12 @@ struct nf_ip_net {
 struct netns_ct {
 	atomic_t		count;
 	unsigned int		expect_count;
+	struct hlist_nulls_head	unconfirmed;
+	struct hlist_nulls_head	dying;
+	struct hlist_nulls_head tmpl;
+
+	/*  not frequently changing components should share same cachelines */
+	struct nf_ip_net	nf_ct_proto ____cacheline_aligned_in_smp;
 #ifdef CONFIG_SYSCTL
 	struct ctl_table_header	*sysctl_header;
 	struct ctl_table_header	*acct_sysctl_header;
@@ -86,13 +92,11 @@ struct netns_ct {
 	struct kmem_cache	*nf_conntrack_cachep;
 	struct hlist_nulls_head	*hash;
 	struct hlist_head	*expect_hash;
-	struct hlist_nulls_head	unconfirmed;
-	struct hlist_nulls_head	dying;
-	struct hlist_nulls_head tmpl;
+
 	struct ip_conntrack_stat __percpu *stat;
 	struct nf_ct_event_notifier __rcu *nf_conntrack_event_cb;
 	struct nf_exp_event_notifier __rcu *nf_expect_event_cb;
-	struct nf_ip_net	nf_ct_proto;
+
 #if defined(CONFIG_NF_CONNTRACK_LABELS)
 	unsigned int		labels_used;
 	u8			label_words;
-- 
1.7.10.4

