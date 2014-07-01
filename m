Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964864AbaGAQVc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 12:21:32 -0400
Received: from zimbra13.linbit.com ([212.69.166.240]:53111 "EHLO
	zimbra13.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757101AbaGAQQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 12:16:54 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 08/20] drbd: New net configuration option socket-check-timeout
Date: Tue,  1 Jul 2014 18:16:38 +0200
Message-Id: <1404231410-29852-9-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404231410-29852-1-git-send-email-philipp.reisner@linbit.com>
References: <1404231410-29852-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In setups involving a DRBD-proxy and connections that experience a lot of
buffer-bloat it might be necessary to set ping-timeout to an
unusual high value. By default DRBD uses the same value to wait if a newly
established TCP-connection is stable. Since the DRBD-proxy is usually located
in the same data center such a long wait time may hinder DRBD's connect process.

In such setups socket-check-timeout should be set to
at least to the round trip time between DRBD and DRBD-proxy. I.e. in most
cases to 1.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_receiver.c | 46 +++++++++++++++++++++++++-------------
 include/linux/drbd_genl.h          |  1 +
 include/linux/drbd_limits.h        |  5 +++++
 3 files changed, 36 insertions(+), 16 deletions(-)

diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 7da83f3..b89e6fb 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -819,7 +819,7 @@ static int receive_first_packet(struct drbd_connection *connection, struct socke
  * drbd_socket_okay() - Free the socket if its connection is not okay
  * @sock:	pointer to the pointer to the socket.
  */
-static int drbd_socket_okay(struct socket **sock)
+static bool drbd_socket_okay(struct socket **sock)
 {
 	int rr;
 	char tb[4];
@@ -837,6 +837,30 @@ static int drbd_socket_okay(struct socket **sock)
 		return false;
 	}
 }
+
+static bool connection_established(struct drbd_connection *connection,
+				   struct socket **sock1,
+				   struct socket **sock2)
+{
+	struct net_conf *nc;
+	int timeout;
+	bool ok;
+
+	if (!*sock1 || !*sock2)
+		return false;
+
+	rcu_read_lock();
+	nc = rcu_dereference(connection->net_conf);
+	timeout = (nc->sock_check_timeo ?: nc->ping_timeo) * HZ / 10;
+	rcu_read_unlock();
+	schedule_timeout_interruptible(timeout);
+
+	ok = drbd_socket_okay(sock1);
+	ok = drbd_socket_okay(sock2) && ok;
+
+	return ok;
+}
+
 /* Gets called if a connection is established, or if a new minor gets created
    in a connection */
 int drbd_connected(struct drbd_peer_device *peer_device)
@@ -878,8 +902,8 @@ static int conn_connect(struct drbd_connection *connection)
 	struct drbd_socket sock, msock;
 	struct drbd_peer_device *peer_device;
 	struct net_conf *nc;
-	int vnr, timeout, h, ok;
-	bool discard_my_data;
+	int vnr, timeout, h;
+	bool discard_my_data, ok;
 	enum drbd_state_rv rv;
 	struct accept_wait_data ad = {
 		.connection = connection,
@@ -923,17 +947,8 @@ static int conn_connect(struct drbd_connection *connection)
 			}
 		}
 
-		if (sock.socket && msock.socket) {
-			rcu_read_lock();
-			nc = rcu_dereference(connection->net_conf);
-			timeout = nc->ping_timeo * HZ / 10;
-			rcu_read_unlock();
-			schedule_timeout_interruptible(timeout);
-			ok = drbd_socket_okay(&sock.socket);
-			ok = drbd_socket_okay(&msock.socket) && ok;
-			if (ok)
-				break;
-		}
+		if (connection_established(connection, &sock.socket, &msock.socket))
+			break;
 
 retry:
 		s = drbd_wait_for_connect(connection, &ad);
@@ -979,8 +994,7 @@ randomize:
 				goto out_release_sockets;
 		}
 
-		ok = drbd_socket_okay(&sock.socket);
-		ok = drbd_socket_okay(&msock.socket) && ok;
+		ok = connection_established(connection, &sock.socket, &msock.socket);
 	} while (!ok);
 
 	if (ad.s_listen)
diff --git a/include/linux/drbd_genl.h b/include/linux/drbd_genl.h
index 71fc924..7b131ed 100644
--- a/include/linux/drbd_genl.h
+++ b/include/linux/drbd_genl.h
@@ -174,6 +174,7 @@ GENL_struct(DRBD_NLA_NET_CONF, 5, net_conf,
 	/* 9: __str_field_def(31,     DRBD_GENLA_F_MANDATORY, name, SHARED_SECRET_MAX) */
 	/* 9: __u32_field(32,         DRBD_F_REQUIRED | DRBD_F_INVARIANT,     peer_node_id) */
 	__flg_field_def(33, 0 /* OPTIONAL */,	csums_after_crash_only, DRBD_CSUMS_AFTER_CRASH_ONLY_DEF)
+	__u32_field_def(34, 0 /* OPTIONAL */, sock_check_timeo, DRBD_SOCKET_CHECK_TIMEO_DEF)
 )
 
 GENL_struct(DRBD_NLA_SET_ROLE_PARMS, 6, set_role_parms,
diff --git a/include/linux/drbd_limits.h b/include/linux/drbd_limits.h
index 9d2df1d..8ac8c5d 100644
--- a/include/linux/drbd_limits.h
+++ b/include/linux/drbd_limits.h
@@ -225,4 +225,9 @@
 #define DRBD_AL_STRIPE_SIZE_MAX   16777216
 #define DRBD_AL_STRIPE_SIZE_DEF   32
 #define DRBD_AL_STRIPE_SIZE_SCALE 'k' /* kilobytes */
+
+#define DRBD_SOCKET_CHECK_TIMEO_MIN 0
+#define DRBD_SOCKET_CHECK_TIMEO_MAX DRBD_PING_TIMEO_MAX
+#define DRBD_SOCKET_CHECK_TIMEO_DEF 0
+#define DRBD_SOCKET_CHECK_TIMEO_SCALE '1'
 #endif
-- 
1.9.1

