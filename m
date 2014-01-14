Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753666AbaANA2N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 19:28:13 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54228 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753601AbaANA2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 19:28:05 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Laine Stump <laine@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>,
        Jiri Pirko <jiri@resnulli.us>, Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.12 11/77] br: fix use of ->rx_handler_data in code executed on non-rx_handler path
Date: Mon, 13 Jan 2014 16:27:32 -0800
Message-Id: <20140114002752.822231261@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140114002752.497010554@linuxfoundation.org>
References: <20140114002752.497010554@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Pirko <jiri@resnulli.us>

[ Upstream commit 859828c0ea476b42f3a93d69d117aaba90994b6f ]

br_stp_rcv() is reached by non-rx_handler path. That means there is no
guarantee that dev is bridge port and therefore simple NULL check of
->rx_handler_data is not enough. There is need to check if dev is really
bridge port and since only rcu read lock is held here, do it by checking
->rx_handler pointer.

Note that synchronize_net() in netdev_rx_handler_unregister() ensures
this approach as valid.

Introduced originally by:
commit f350a0a87374418635689471606454abc7beaa3a
  "bridge: use rx_handler_data pointer to store net_bridge_port pointer"

Fixed but not in the best way by:
commit b5ed54e94d324f17c97852296d61a143f01b227a
  "bridge: fix RCU races with bridge port"

Reintroduced by:
commit 716ec052d2280d511e10e90ad54a86f5b5d4dcc2
  "bridge: fix NULL pointer deref of br_port_get_rcu"

Please apply to stable trees as well. Thanks.

RH bugzilla reference: https://bugzilla.redhat.com/show_bug.cgi?id=1025770

Reported-by: Laine Stump <laine@redhat.com>
Debugged-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Jiri Pirko <jiri@resnulli.us>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bridge/br_private.h  |   10 ++++++++++
 net/bridge/br_stp_bpdu.c |    2 +-
 2 files changed, 11 insertions(+), 1 deletion(-)

--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -442,6 +442,16 @@ extern netdev_features_t br_features_rec
 extern int br_handle_frame_finish(struct sk_buff *skb);
 extern rx_handler_result_t br_handle_frame(struct sk_buff **pskb);
 
+static inline bool br_rx_handler_check_rcu(const struct net_device *dev)
+{
+	return rcu_dereference(dev->rx_handler) == br_handle_frame;
+}
+
+static inline struct net_bridge_port *br_port_get_check_rcu(const struct net_device *dev)
+{
+	return br_rx_handler_check_rcu(dev) ? br_port_get_rcu(dev) : NULL;
+}
+
 /* br_ioctl.c */
 extern int br_dev_ioctl(struct net_device *dev, struct ifreq *rq, int cmd);
 extern int br_ioctl_deviceless_stub(struct net *net, unsigned int cmd, void __user *arg);
--- a/net/bridge/br_stp_bpdu.c
+++ b/net/bridge/br_stp_bpdu.c
@@ -153,7 +153,7 @@ void br_stp_rcv(const struct stp_proto *
 	if (buf[0] != 0 || buf[1] != 0 || buf[2] != 0)
 		goto err;
 
-	p = br_port_get_rcu(dev);
+	p = br_port_get_check_rcu(dev);
 	if (!p)
 		goto err;
 


