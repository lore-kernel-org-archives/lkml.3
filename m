Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932384Ab3HGHi4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 03:38:56 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:45079 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932299Ab3HGHiP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 03:38:15 -0400
From: Rui Xiang <rui.xiang@huawei.com>
To: <containers@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>
CC: <netdev@vger.kernel.org>, <netfilter-devel@vger.kernel.org>,
        <serge.hallyn@ubuntu.com>, <ebiederm@xmission.com>,
        <akpm@linux-foundation.org>, <gaofeng@cn.fujitsu.com>,
        <guz.fnst@cn.fujitsu.com>, <libo.chen@huawei.com>,
        Rui Xiang <rui.xiang@huawei.com>
Subject: [PATCH v3 11/11] netfilter: use ns_printk in iptable context
Date: Wed, 7 Aug 2013 15:37:15 +0800
Message-ID: <1375861035-24320-12-git-send-email-rui.xiang@huawei.com>
X-Mailer: git-send-email 1.8.1.msysgit.1
In-Reply-To: <1375861035-24320-1-git-send-email-rui.xiang@huawei.com>
References: <1375861035-24320-1-git-send-email-rui.xiang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.135.72.188]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To containerise iptables log, use ns_printk
to report individual logs to container as
getting syslog_ns from net->user_ns.

Signed-off-by: Rui Xiang <rui.xiang@huawei.com>
---
 include/net/netfilter/xt_log.h | 6 +++++-
 net/netfilter/xt_LOG.c         | 4 ++--
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/include/net/netfilter/xt_log.h b/include/net/netfilter/xt_log.h
index 9d9756c..834d972 100644
--- a/include/net/netfilter/xt_log.h
+++ b/include/net/netfilter/xt_log.h
@@ -39,10 +39,14 @@ static struct sbuff *sb_open(void)
 	return m;
 }
 
-static void sb_close(struct sbuff *m)
+static void sb_close(struct sbuff *m, struct net *net)
 {
 	m->buf[m->count] = 0;
+#ifdef CONFIG_NET_NS
+	ns_printk(net->user_ns->syslog_ns, "%s\n", m->buf);
+#else
 	printk("%s\n", m->buf);
+#endif
 
 	if (likely(m != &emergency))
 		kfree(m);
diff --git a/net/netfilter/xt_LOG.c b/net/netfilter/xt_LOG.c
index 5ab2484..e034a74 100644
--- a/net/netfilter/xt_LOG.c
+++ b/net/netfilter/xt_LOG.c
@@ -493,7 +493,7 @@ ipt_log_packet(struct net *net,
 
 	dump_ipv4_packet(m, loginfo, skb, 0);
 
-	sb_close(m);
+	sb_close(m, net);
 }
 
 #if IS_ENABLED(CONFIG_IP6_NF_IPTABLES)
@@ -824,7 +824,7 @@ ip6t_log_packet(struct net *net,
 
 	dump_ipv6_packet(m, loginfo, skb, skb_network_offset(skb), 1);
 
-	sb_close(m);
+	sb_close(m, net);
 }
 #endif
 
-- 
1.8.2.2


