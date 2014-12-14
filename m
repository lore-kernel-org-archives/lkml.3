Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754167AbaLNUpX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 15:45:23 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53040 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952AbaLNUVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 15:21:53 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Marcelo Ricardo Leitner <mleitner@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.14 20/34] Fix race condition between vxlan_sock_add and vxlan_sock_release
Date: Sun, 14 Dec 2014 12:20:58 -0800
Message-Id: <20141214201804.382183768@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141214201803.791392744@linuxfoundation.org>
References: <20141214201803.791392744@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marcelo Leitner <mleitner@redhat.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/vxlan.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -2106,9 +2106,8 @@ static int vxlan_init(struct net_device
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
@@ -2574,12 +2573,9 @@ struct vxlan_sock *vxlan_sock_add(struct
 
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


