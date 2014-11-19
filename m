Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758293AbaKSWkL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 17:40:11 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:55908 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756686AbaKSUxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 15:53:50 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Hiroaki SHIMODA <shimoda.hiroaki@gmail.com>,
        Richard Guy Briggs <rgb@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.17 016/141] netlink: Properly unbind in error conditions.
Date: Wed, 19 Nov 2014 12:50:39 -0800
Message-Id: <20141119205151.204524531@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141119205150.700188369@linuxfoundation.org>
References: <20141119205150.700188369@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hiroaki SHIMODA <shimoda.hiroaki@gmail.com>

[ Upstream commit 6251edd932ce3faadbfe27b0a0fe79780e0972e9 ]

Even if netlink_kernel_cfg::unbind is implemented the unbind() method is
not called, because cfg->unbind is omitted in __netlink_kernel_create().
And fix wrong argument of test_bit() and off by one problem.

At this point, no unbind() method is implemented, so there is no real
issue.

Fixes: 4f520900522f ("netlink: have netlink per-protocol bind function return an error code.")
Signed-off-by: Hiroaki SHIMODA <shimoda.hiroaki@gmail.com>
Cc: Richard Guy Briggs <rgb@redhat.com>
Acked-by: Richard Guy Briggs <rgb@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netlink/af_netlink.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -1440,7 +1440,7 @@ static void netlink_unbind(int group, lo
 		return;
 
 	for (undo = 0; undo < group; undo++)
-		if (test_bit(group, &groups))
+		if (test_bit(undo, &groups))
 			nlk->netlink_unbind(undo);
 }
 
@@ -1492,7 +1492,7 @@ static int netlink_bind(struct socket *s
 			netlink_insert(sk, net, nladdr->nl_pid) :
 			netlink_autobind(sock);
 		if (err) {
-			netlink_unbind(nlk->ngroups - 1, groups, nlk);
+			netlink_unbind(nlk->ngroups, groups, nlk);
 			return err;
 		}
 	}
@@ -2509,6 +2509,7 @@ __netlink_kernel_create(struct net *net,
 		nl_table[unit].module = module;
 		if (cfg) {
 			nl_table[unit].bind = cfg->bind;
+			nl_table[unit].unbind = cfg->unbind;
 			nl_table[unit].flags = cfg->flags;
 			if (cfg->compare)
 				nl_table[unit].compare = cfg->compare;


