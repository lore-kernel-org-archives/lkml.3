Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753371AbaLOOcD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 09:32:03 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:39037 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753095AbaLOO3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 09:29:22 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Marcelo Ricardo Leitner <mleitner@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 154/168] Fix race condition between vxlan_sock_add and vxlan_sock_release
Date: Mon, 15 Dec 2014 14:26:48 +0000
Message-Id: <1418653622-21105-155-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
References: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marcelo Leitner <mleitner@redhat.com>

commit 00c83b01d58068dfeb2e1351cca6fccf2a83fa8f upstream.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/vxlan.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
index 032c52e1208a..24c1bef7abc6 100644
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -2064,9 +2064,8 @@ static int vxlan_init(struct net_device *dev)
 	spin_lock(&vn->sock_lock);
 	vs = vxlan_find_sock(vxlan->net, ipv6 ? AF_INET6 : AF_INET,
 			     vxlan->dst_port);
-	if (vs) {
+	if (vs && atomic_add_unless(&vs->refcnt, 1, 0)) {
 		/* If we have a socket with same port already, reuse it */
-		atomic_inc(&vs->refcnt);
 		vxlan_vs_add_dev(vs, vxlan);
 	} else {
 		/* otherwise make new socket outside of RTNL */
@@ -2545,12 +2544,9 @@ struct vxlan_sock *vxlan_sock_add(struct net *net, __be16 port,
 
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
2.1.3

