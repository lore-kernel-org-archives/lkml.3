Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751901AbaI3L2P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 07:28:15 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:61917 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751044AbaI3L2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 07:28:13 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: netdev@vger.kernel.org
Cc: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>, davem@davemloft.net,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        Patrick McHardy <kaber@trash.net>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH] netfilter: fix nf_conn_nat->masq_index visibility
Date: Tue, 30 Sep 2014 13:27:50 +0200
Message-ID: <2670668.vq09CjLWH3@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:POO6PW9966krg9WZGo9W9LXicttfYHiYP/KH53Nsq7m
 P9unKkebH4zQKNZL2Jmwn7KrWOAxUWCxo1gN9exu/yhMyXeL5B
 2FdJwXDZYobsvO2ZINO5ve8q2XMDi9Elm0fPu2HlQ1nLA9053O
 PMh6zkGQAcqY3vTaDDAb/sAfmc2BfTZI+0FCjuYVmv6C+GjL6n
 c5nZolhHbSmx9BCE6ipJ+1c8zifyk2EutvLCzFqyzzKr0hSaRM
 0cQiljxsNCc0oAVxq5ub4G2wc3EvjkWSbQDVus6UsoccN/IDxM
 oJIBZ96WYvLgreDZdN+lC2zzhy/yXfgl63yA6GehLn6akZlFlD
 aq1OflkXAa6o+y8TVrr0=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A recent change introduced the NF_NAT_MASQUERADE_IPV4/6 symbols and now
builds the masquerading code based on this symbol rather than the
IP_NF_TARGET_MASQUERADE symbol, however the nf_nat.h header file
still uses the old symbol, which leads to a build error when that
is disabled:

nf_nat_masquerade_ipv4.c: In function 'nf_nat_masquerade_ipv4':
nf_nat_masquerade_ipv4.c:59:5: error: 'struct nf_conn_nat' has no member named 'masq_index'

This changes the header file to do the respective change, and move
to using the IS_ENABLED() macro in the process, to improve readability
of the check

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Fixes: 8dd33cc93ec92 ("netfilter: nf_nat: generalize IPv4 masquerading support for nf_tables")
---
found while doing ARM randconfig tests

diff --git a/include/net/netfilter/nf_nat.h b/include/net/netfilter/nf_nat.h
index a71dd333ac68..68f0953c86c3 100644
--- a/include/net/netfilter/nf_nat.h
+++ b/include/net/netfilter/nf_nat.h
@@ -32,10 +32,8 @@ struct nf_conn_nat {
 	struct hlist_node bysource;
 	struct nf_conn *ct;
 	union nf_conntrack_nat_help help;
-#if defined(CONFIG_IP_NF_TARGET_MASQUERADE) || \
-    defined(CONFIG_IP_NF_TARGET_MASQUERADE_MODULE) || \
-    defined(CONFIG_IP6_NF_TARGET_MASQUERADE) || \
-    defined(CONFIG_IP6_NF_TARGET_MASQUERADE_MODULE)
+#if IS_ENABLED(CONFIG_NF_NAT_MASQUERADE_IPV4) || \
+    IS_ENABLED(CONFIG_NF_NAT_MASQUERADE_IPV6)
 	int masq_index;
 #endif
 };
@@ -56,7 +54,7 @@ int nf_nat_used_tuple(const struct nf_conntrack_tuple *tuple,
 
 static inline struct nf_conn_nat *nfct_nat(const struct nf_conn *ct)
 {
-#if defined(CONFIG_NF_NAT) || defined(CONFIG_NF_NAT_MODULE)
+#if IS_ENABLED(CONFIG_NF_NAT)
 	return nf_ct_ext_find(ct, NF_CT_EXT_NAT);
 #else
 	return NULL;
@@ -68,8 +66,8 @@ static inline bool nf_nat_oif_changed(unsigned int hooknum,
 				      struct nf_conn_nat *nat,
 				      const struct net_device *out)
 {
-#if IS_ENABLED(CONFIG_IP_NF_TARGET_MASQUERADE) || \
-    IS_ENABLED(CONFIG_IP6_NF_TARGET_MASQUERADE)
+#if IS_ENABLED(CONFIG_NF_NAT_MASQUERADE_IPV4) || \
+    IS_ENABLED(CONFIG_NF_NAT_MASQUERADE_IPV6)
 	return nat->masq_index && hooknum == NF_INET_POST_ROUTING &&
 	       CTINFO2DIR(ctinfo) == IP_CT_DIR_ORIGINAL &&
 	       nat->masq_index != out->ifindex;

