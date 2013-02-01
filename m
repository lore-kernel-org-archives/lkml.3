Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422967Ab3BANOx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 08:14:53 -0500
Received: from mail.kernel.org ([198.145.19.201]:45698 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422854Ab3BANOt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 08:14:49 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [ 79/89] netfilter: xt_CT: recover NOTRACK target support
Date: Fri,  1 Feb 2013 14:08:34 +0100
Message-Id: <20130201130213.170163521@linuxfoundation.org>
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

commit 10db9069eb5c60195170a4119bdbcbce69a4945f upstream.

Florian Westphal reported that the removal of the NOTRACK target
(9655050 netfilter: remove xt_NOTRACK) is breaking some existing
setups.

That removal was scheduled for removal since long time ago as
described in Documentation/feature-removal-schedule.txt

What:  xt_NOTRACK
Files: net/netfilter/xt_NOTRACK.c
When:  April 2011
Why:   Superseded by xt_CT

Still, people may have not notice / may have decided to stick to an
old iptables version. I agree with him in that some more conservative
approach by spotting some printk to warn users for some time is less
agressive.

Current iptables 1.4.16.3 already contains the aliasing support
that makes it point to the CT target, so upgrading would fix it.
Still, the policy so far has been to avoid pushing our users to
upgrade.

As a solution, this patch recovers the NOTRACK target inside the CT
target and it now spots a warning.

Reported-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/net/netns/x_tables.h |    1 
 net/netfilter/Kconfig        |    4 +++
 net/netfilter/xt_CT.c        |   50 ++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 54 insertions(+), 1 deletion(-)

--- a/include/net/netns/x_tables.h
+++ b/include/net/netns/x_tables.h
@@ -8,6 +8,7 @@ struct ebt_table;
 
 struct netns_xt {
 	struct list_head tables[NFPROTO_NUMPROTO];
+	bool notrack_deprecated_warning;
 #if defined(CONFIG_BRIDGE_NF_EBTABLES) || \
     defined(CONFIG_BRIDGE_NF_EBTABLES_MODULE)
 	struct ebt_table *broute_table;
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -680,6 +680,10 @@ config NETFILTER_XT_TARGET_NFQUEUE
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
+config NETFILTER_XT_TARGET_NOTRACK
+	tristate  '"NOTRACK" target support (DEPRECATED)'
+	select NETFILTER_XT_TARGET_CT
+
 config NETFILTER_XT_TARGET_RATEEST
 	tristate '"RATEEST" target support'
 	depends on NETFILTER_ADVANCED
--- a/net/netfilter/xt_CT.c
+++ b/net/netfilter/xt_CT.c
@@ -377,14 +377,60 @@ static struct xt_target xt_ct_tg_reg[] _
 	},
 };
 
+static unsigned int
+notrack_tg(struct sk_buff *skb, const struct xt_action_param *par)
+{
+	/* Previously seen (loopback)? Ignore. */
+	if (skb->nfct != NULL)
+		return XT_CONTINUE;
+
+	skb->nfct = &nf_ct_untracked_get()->ct_general;
+	skb->nfctinfo = IP_CT_NEW;
+	nf_conntrack_get(skb->nfct);
+
+	return XT_CONTINUE;
+}
+
+static int notrack_chk(const struct xt_tgchk_param *par)
+{
+	if (!par->net->xt.notrack_deprecated_warning) {
+		pr_info("netfilter: NOTRACK target is deprecated, "
+			"use CT instead or upgrade iptables\n");
+		par->net->xt.notrack_deprecated_warning = true;
+	}
+	return 0;
+}
+
+static struct xt_target notrack_tg_reg __read_mostly = {
+	.name		= "NOTRACK",
+	.revision	= 0,
+	.family		= NFPROTO_UNSPEC,
+	.checkentry	= notrack_chk,
+	.target		= notrack_tg,
+	.table		= "raw",
+	.me		= THIS_MODULE,
+};
+
 static int __init xt_ct_tg_init(void)
 {
-	return xt_register_targets(xt_ct_tg_reg, ARRAY_SIZE(xt_ct_tg_reg));
+	int ret;
+
+	ret = xt_register_target(&notrack_tg_reg);
+	if (ret < 0)
+		return ret;
+
+	ret = xt_register_targets(xt_ct_tg_reg, ARRAY_SIZE(xt_ct_tg_reg));
+	if (ret < 0) {
+		xt_unregister_target(&notrack_tg_reg);
+		return ret;
+	}
+	return 0;
 }
 
 static void __exit xt_ct_tg_exit(void)
 {
 	xt_unregister_targets(xt_ct_tg_reg, ARRAY_SIZE(xt_ct_tg_reg));
+	xt_unregister_target(&notrack_tg_reg);
 }
 
 module_init(xt_ct_tg_init);
@@ -394,3 +440,5 @@ MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Xtables: connection tracking target");
 MODULE_ALIAS("ipt_CT");
 MODULE_ALIAS("ip6t_CT");
+MODULE_ALIAS("ipt_NOTRACK");
+MODULE_ALIAS("ip6t_NOTRACK");


