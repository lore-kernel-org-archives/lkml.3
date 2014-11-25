Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754181AbaKYKnp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 05:43:45 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:59144 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752984AbaKYKnc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:43:32 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Hiroaki SHIMODA <shimoda.hiroaki@gmail.com>,
        Richard Guy Briggs <rgb@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 224/254] netlink: Properly unbind in error conditions.
Date: Tue, 25 Nov 2014 10:39:34 +0000
Message-Id: <1416912004-5928-225-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
References: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hiroaki SHIMODA <shimoda.hiroaki@gmail.com>

commit 6251edd932ce3faadbfe27b0a0fe79780e0972e9 upstream.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/netlink/af_netlink.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index d158e1c888d8..0ed3c2b65fb7 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -1491,7 +1491,7 @@ static void netlink_unbind(int group, long unsigned int groups,
 		return;
 
 	for (undo = 0; undo < group; undo++)
-		if (test_bit(group, &groups))
+		if (test_bit(undo, &groups))
 			nlk->netlink_unbind(undo);
 }
 
@@ -1543,7 +1543,7 @@ static int netlink_bind(struct socket *sock, struct sockaddr *addr,
 			netlink_insert(sk, net, nladdr->nl_pid) :
 			netlink_autobind(sock);
 		if (err) {
-			netlink_unbind(nlk->ngroups - 1, groups, nlk);
+			netlink_unbind(nlk->ngroups, groups, nlk);
 			return err;
 		}
 	}
@@ -2563,6 +2563,7 @@ __netlink_kernel_create(struct net *net, int unit, struct module *module,
 		nl_table[unit].module = module;
 		if (cfg) {
 			nl_table[unit].bind = cfg->bind;
+			nl_table[unit].unbind = cfg->unbind;
 			nl_table[unit].flags = cfg->flags;
 			if (cfg->compare)
 				nl_table[unit].compare = cfg->compare;
-- 
2.1.0

