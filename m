Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757397Ab3FCMVZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 08:21:25 -0400
Received: from mail-la0-f41.google.com ([209.85.215.41]:40199 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755863Ab3FCMVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 08:21:23 -0400
From: Emil Goode <emilgoode@gmail.com>
To: davem@davemloft.net, kuznet@ms2.inr.ac.ru, jmorris@namei.org,
        yoshfuji@linux-ipv6.org, kaber@trash.net
Cc: lorenzo@google.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, Emil Goode <emilgoode@gmail.com>
Subject: [PATCH] net: ipv6: Fix incompatible pointer type warning
Date: Mon,  3 Jun 2013 14:21:08 +0200
Message-Id: <1370262068-16658-1-git-send-email-emilgoode@gmail.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes the sparse warning below about assignment from
incompatible pointer type.

In the following commit the third argument in function ipv6_chk_addr
was changed to const and struct nf_ipv6_ops was introduced with
the third argument of .chk_addr beeing const.

2a7851bffb008ff4882eee673da74718997b4265
("netfilter: add nf_ipv6_ops hook to fix xt_addrtype with IPv6")

The below commit introduced the warning as the third argument of
dummy_ipv6_chk_addr and .ipv6_chk_addr in struct pingv6_ops is
missing a const.

6d0bfe22611602f36617bc7aa2ffa1bbb2f54c67
("net: ipv6: Add IPv6 support to the ping socket.")

Sparse output:

net/ipv6/ping.c: In function ‘pingv6_init’:
net/ipv6/ping.c:87:27: warning:
	assignment from incompatible pointer type [enabled by default]

Signed-off-by: Emil Goode <emilgoode@gmail.com>
---
 include/net/ping.h |    2 +-
 net/ipv6/ping.c    |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/net/ping.h b/include/net/ping.h
index 9242fa0..2db4860 100644
--- a/include/net/ping.h
+++ b/include/net/ping.h
@@ -38,7 +38,7 @@ struct pingv6_ops {
 	void (*ipv6_icmp_error)(struct sock *sk, struct sk_buff *skb, int err,
 				__be16 port, u32 info, u8 *payload);
 	int (*ipv6_chk_addr)(struct net *net, const struct in6_addr *addr,
-			     struct net_device *dev, int strict);
+			     const struct net_device *dev, int strict);
 };
 
 struct ping_table {
diff --git a/net/ipv6/ping.c b/net/ipv6/ping.c
index a6462d6..c2e9669 100644
--- a/net/ipv6/ping.c
+++ b/net/ipv6/ping.c
@@ -73,7 +73,7 @@ int dummy_icmpv6_err_convert(u8 type, u8 code, int *err)
 void dummy_ipv6_icmp_error(struct sock *sk, struct sk_buff *skb, int err,
 			    __be16 port, u32 info, u8 *payload) {}
 int dummy_ipv6_chk_addr(struct net *net, const struct in6_addr *addr,
-			struct net_device *dev, int strict)
+			const struct net_device *dev, int strict)
 {
 	return 0;
 }
-- 
1.7.10.4

