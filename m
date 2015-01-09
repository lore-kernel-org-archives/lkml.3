Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933250AbbAIKuU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 05:50:20 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44533 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757418AbbAIKc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 05:32:29 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Marcelo Leitner <mleitner@redhat.com>,
        "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 02/78] Fix race condition between vxlan_sock_add and vxlan_sock_release
Date: Fri,  9 Jan 2015 11:31:11 +0100
Message-Id: <555533176833d396f82cdcc131e9188286a74b0d.1420799385.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <72002f1f248c28d1715d10454190e209d5a20fe1.1420799385.git.jslaby@suse.cz>
References: <72002f1f248c28d1715d10454190e209d5a20fe1.1420799385.git.jslaby@suse.cz>
In-Reply-To: <cover.1420799385.git.jslaby@suse.cz>
References: <cover.1420799385.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcelo Leitner <mleitner@redhat.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

[ Upstream commit 00c83b01d58068dfeb2e1351cca6fccf2a83fa8f ]

Currently, when trying to reuse a socket, vxlan_sock_add will grab
vn->sock_lock, locate a reusable socket, inc refcount and release
vn->sock_lock.

But vxlan_sock_release() will first decrement refcount, and then grab
that lock. refcnt operations are atomic but as currently we have
deferred works which hold vs->refcnt each, this might happen, leading to
a use after free (specially after vxlan_igmp_leave):

  CPU 1                            CPU 2

deferred work                    vxlan_sock_add
  ...                              ...
                                   spin_lock(&vn->sock_lock)
                                   vs = vxlan_find_sock();
  vxlan_sock_release
    dec vs->refcnt, reaches 0
    spin_lock(&vn->sock_lock)
                                   vxlan_sock_hold(vs), refcnt=1
                                   spin_unlock(&vn->sock_lock)
    hlist_del_rcu(&vs->hlist);
    vxlan_notify_del_rx_port(vs)
    spin_unlock(&vn->sock_lock)

So when we look for a reusable socket, we check if it wasn't freed
already before reusing it.

Signed-off-by: Marcelo Ricardo Leitner <mleitner@redhat.com>
Fixes: 7c47cedf43a8b3 ("vxlan: move IGMP join/leave to work queue")
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/net/vxlan.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
index 5407c11a9f14..c8e333306c4c 100644
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -2002,9 +2002,8 @@ static int vxlan_init(struct net_device *dev)
 	spin_lock(&vn->sock_lock);
 	vs = vxlan_find_sock(dev_net(dev), ipv6 ? AF_INET6 : AF_INET,
 			     vxlan->dst_port);
-	if (vs) {
+	if (vs && atomic_add_unless(&vs->refcnt, 1, 0)) {
 		/* If we have a socket with same port already, reuse it */
-		atomic_inc(&vs->refcnt);
 		vxlan_vs_add_dev(vs, vxlan);
 	} else {
 		/* otherwise make new socket outside of RTNL */
@@ -2447,12 +2446,9 @@ struct vxlan_sock *vxlan_sock_add(struct net *net, __be16 port,
 
 	spin_lock(&vn->sock_lock);
 	vs = vxlan_find_sock(net, ipv6 ? AF_INET6 : AF_INET, port);
-	if (vs) {
-		if (vs->rcv == rcv)
-			atomic_inc(&vs->refcnt);
-		else
+	if (vs && ((vs->rcv != rcv) ||
+		   !atomic_add_unless(&vs->refcnt, 1, 0)))
 			vs = ERR_PTR(-EBUSY);
-	}
 	spin_unlock(&vn->sock_lock);
 
 	if (!vs)
-- 
2.2.1

