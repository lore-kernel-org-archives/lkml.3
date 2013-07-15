Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756845Ab3GONLL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 09:11:11 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:45407 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756319Ab3GONLG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 09:11:06 -0400
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH-v2 06/17] staging/lustre: remove HIPQUAD
Date: Mon, 15 Jul 2013 21:08:04 +0800
Message-Id: <1373893695-4094-7-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1373893695-4094-1-git-send-email-bergwolf@gmail.com>
References: <1373893695-4094-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell reported below error on powerpc:

In file included from drivers/staging/lustre/include/linux/libcfs/libcfs.h:203:0,
                 from drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.h:67,
                 from drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c:41:
drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c: In function 'kiblnd_dev_need_failover':
drivers/staging/lustre/include/linux/libcfs/libcfs_debug.h:215:16: error: implicit declaration of function 'NIPQUAD' [-Werror=implicit-function-declaration]
  static struct libcfs_debug_msg_data msgdata;      \
                ^
We should just remove HIPQUAD and replace it with %pI4.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Peng Tao <bergwolf@gmail.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 .../include/linux/libcfs/linux/linux-tcpip.h       |   15 ----
 .../staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c    |    8 +-
 .../staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c |   12 +--
 .../staging/lustre/lnet/klnds/socklnd/socklnd.c    |   50 +++++------
 .../staging/lustre/lnet/klnds/socklnd/socklnd_cb.c |   94 ++++++++++----------
 .../lustre/lnet/klnds/socklnd/socklnd_proto.c      |   60 ++++++-------
 drivers/staging/lustre/lnet/lnet/acceptor.c        |   62 ++++++-------
 .../lustre/lustre/libcfs/linux/linux-tcpip.c       |    4 +-
 8 files changed, 145 insertions(+), 160 deletions(-)

diff --git a/drivers/staging/lustre/include/linux/libcfs/linux/linux-tcpip.h b/drivers/staging/lustre/include/linux/libcfs/linux/linux-tcpip.h
index 687f33f..7a8d006 100644
--- a/drivers/staging/lustre/include/linux/libcfs/linux/linux-tcpip.h
+++ b/drivers/staging/lustre/include/linux/libcfs/linux/linux-tcpip.h
@@ -48,21 +48,6 @@
 
 #include <net/sock.h>
 
-#ifndef HIPQUAD
-// XXX Should just kill all users
-#if defined(__LITTLE_ENDIAN)
-#define HIPQUAD(addr) \
-	((unsigned char *)&addr)[3], \
-	((unsigned char *)&addr)[2], \
-	((unsigned char *)&addr)[1], \
-	((unsigned char *)&addr)[0]
-#elif defined(__BIG_ENDIAN)
-#define HIPQUAD NIPQUAD
-#else
-#error "Please fix asm/byteorder.h"
-#endif /* __LITTLE_ENDIAN */
-#endif
-
 typedef struct socket   socket_t;
 
 #define SOCK_SNDBUF(so)	 ((so)->sk->sk_sndbuf)
diff --git a/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c b/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c
index 29a9794..3ce4fb0 100644
--- a/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c
+++ b/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c
@@ -2574,8 +2574,8 @@ kiblnd_dev_need_failover(kib_dev_t *dev)
 	rc = rdma_resolve_addr(cmid, (struct sockaddr *)&srcaddr,
 			       (struct sockaddr *)&dstaddr, 1);
 	if (rc != 0 || cmid->device == NULL) {
-		CERROR("Failed to bind %s:%u.%u.%u.%u to device(%p): %d\n",
-		       dev->ibd_ifname, HIPQUAD(dev->ibd_ifip),
+		CERROR("Failed to bind %s:%pI4 to device(%p): %d\n",
+		       dev->ibd_ifname, &dev->ibd_ifip,
 		       cmid->device, rc);
 		rdma_destroy_id(cmid);
 		return rc;
@@ -2647,8 +2647,8 @@ kiblnd_dev_failover(kib_dev_t *dev)
 	/* Bind to failover device or port */
 	rc = rdma_bind_addr(cmid, (struct sockaddr *)&addr);
 	if (rc != 0 || cmid->device == NULL) {
-		CERROR("Failed to bind %s:%u.%u.%u.%u to device(%p): %d\n",
-		       dev->ibd_ifname, HIPQUAD(dev->ibd_ifip),
+		CERROR("Failed to bind %s:%pI4 to device(%p): %d\n",
+		       dev->ibd_ifname, &dev->ibd_ifip,
 		       cmid->device, rc);
 		rdma_destroy_id(cmid);
 		goto out;
diff --git a/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c b/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c
index cc62321..76985c5 100644
--- a/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c
+++ b/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c
@@ -1319,9 +1319,9 @@ kiblnd_connect_peer (kib_peer_t *peer)
 	}
 
 	LASSERT (cmid->device != NULL);
-	CDEBUG(D_NET, "%s: connection bound to %s:%u.%u.%u.%u:%s\n",
+	CDEBUG(D_NET, "%s: connection bound to %s:%pI4:%s\n",
 	       libcfs_nid2str(peer->ibp_nid), dev->ibd_ifname,
-	       HIPQUAD(dev->ibd_ifip), cmid->device->name);
+	       &dev->ibd_ifip, cmid->device->name);
 
 	return;
 
@@ -2209,8 +2209,8 @@ kiblnd_passive_connect (struct rdma_cm_id *cmid, void *priv, int priv_nob)
 	if (*kiblnd_tunables.kib_require_priv_port &&
 	    ntohs(peer_addr->sin_port) >= PROT_SOCK) {
 		__u32 ip = ntohl(peer_addr->sin_addr.s_addr);
-		CERROR("Peer's port (%u.%u.%u.%u:%hu) is not privileged\n",
-		       HIPQUAD(ip), ntohs(peer_addr->sin_port));
+		CERROR("Peer's port (%pI4:%hu) is not privileged\n",
+		       &ip, ntohs(peer_addr->sin_port));
 		goto failed;
 	}
 
@@ -2254,11 +2254,11 @@ kiblnd_passive_connect (struct rdma_cm_id *cmid, void *priv, int priv_nob)
 	if (ni == NULL ||			 /* no matching net */
 	    ni->ni_nid != reqmsg->ibm_dstnid ||   /* right NET, wrong NID! */
 	    net->ibn_dev != ibdev) {	      /* wrong device */
-		CERROR("Can't accept %s on %s (%s:%d:%u.%u.%u.%u): "
+		CERROR("Can't accept %s on %s (%s:%d:%pI4): "
 		       "bad dst nid %s\n", libcfs_nid2str(nid),
 		       ni == NULL ? "NA" : libcfs_nid2str(ni->ni_nid),
 		       ibdev->ibd_ifname, ibdev->ibd_nnets,
-		       HIPQUAD(ibdev->ibd_ifip),
+		       &ibdev->ibd_ifip,
 		       libcfs_nid2str(reqmsg->ibm_dstnid));
 
 		goto failed;
diff --git a/drivers/staging/lustre/lnet/klnds/socklnd/socklnd.c b/drivers/staging/lustre/lnet/klnds/socklnd/socklnd.c
index c826bf9..2af4caa 100644
--- a/drivers/staging/lustre/lnet/klnds/socklnd/socklnd.c
+++ b/drivers/staging/lustre/lnet/klnds/socklnd/socklnd.c
@@ -334,17 +334,17 @@ ksocknal_associate_route_conn_locked(ksock_route_t *route, ksock_conn_t *conn)
 	if (route->ksnr_myipaddr != conn->ksnc_myipaddr) {
 		if (route->ksnr_myipaddr == 0) {
 			/* route wasn't bound locally yet (the initial route) */
-			CDEBUG(D_NET, "Binding %s %u.%u.%u.%u to %u.%u.%u.%u\n",
+			CDEBUG(D_NET, "Binding %s %pI4 to %pI4\n",
 			       libcfs_id2str(peer->ksnp_id),
-			       HIPQUAD(route->ksnr_ipaddr),
-			       HIPQUAD(conn->ksnc_myipaddr));
+			       &route->ksnr_ipaddr,
+			       &conn->ksnc_myipaddr);
 		} else {
-			CDEBUG(D_NET, "Rebinding %s %u.%u.%u.%u from "
-			       "%u.%u.%u.%u to %u.%u.%u.%u\n",
+			CDEBUG(D_NET, "Rebinding %s %pI4 from "
+			       "%pI4 to %pI4\n",
 			       libcfs_id2str(peer->ksnp_id),
-			       HIPQUAD(route->ksnr_ipaddr),
-			       HIPQUAD(route->ksnr_myipaddr),
-			       HIPQUAD(conn->ksnc_myipaddr));
+			       &route->ksnr_ipaddr,
+			       &route->ksnr_myipaddr,
+			       &conn->ksnc_myipaddr);
 
 			iface = ksocknal_ip2iface(route->ksnr_peer->ksnp_ni,
 						  route->ksnr_myipaddr);
@@ -384,9 +384,9 @@ ksocknal_add_route_locked (ksock_peer_t *peer, ksock_route_t *route)
 		route2 = list_entry(tmp, ksock_route_t, ksnr_list);
 
 		if (route2->ksnr_ipaddr == route->ksnr_ipaddr) {
-			CERROR ("Duplicate route %s %u.%u.%u.%u\n",
+			CERROR("Duplicate route %s %pI4\n",
 				libcfs_id2str(peer->ksnp_id),
-				HIPQUAD(route->ksnr_ipaddr));
+				&route->ksnr_ipaddr);
 			LBUG();
 		}
 	}
@@ -982,8 +982,8 @@ ksocknal_accept (lnet_ni_t *ni, socket_t *sock)
 	LIBCFS_ALLOC(cr, sizeof(*cr));
 	if (cr == NULL) {
 		LCONSOLE_ERROR_MSG(0x12f, "Dropping connection request from "
-				   "%u.%u.%u.%u: memory exhausted\n",
-				   HIPQUAD(peer_ip));
+				   "%pI4: memory exhausted\n",
+				   &peer_ip);
 		return -ENOMEM;
 	}
 
@@ -1236,10 +1236,10 @@ ksocknal_create_conn (lnet_ni_t *ni, ksock_route_t *route,
 	 * code below probably isn't going to work. */
 	if (active &&
 	    route->ksnr_ipaddr != conn->ksnc_ipaddr) {
-		CERROR("Route %s %u.%u.%u.%u connected to %u.%u.%u.%u\n",
+		CERROR("Route %s %pI4 connected to %pI4\n",
 		       libcfs_id2str(peer->ksnp_id),
-		       HIPQUAD(route->ksnr_ipaddr),
-		       HIPQUAD(conn->ksnc_ipaddr));
+		       &route->ksnr_ipaddr,
+		       &conn->ksnc_ipaddr);
 	}
 
 	/* Search for a route corresponding to the new connection and
@@ -1297,10 +1297,10 @@ ksocknal_create_conn (lnet_ni_t *ni, ksock_route_t *route,
 	 *	socket callbacks.
 	 */
 
-	CDEBUG(D_NET, "New conn %s p %d.x %u.%u.%u.%u -> %u.%u.%u.%u/%d"
+	CDEBUG(D_NET, "New conn %s p %d.x %pI4 -> %pI4/%d"
 	       " incarnation:"LPD64" sched[%d:%d]\n",
 	       libcfs_id2str(peerid), conn->ksnc_proto->pro_version,
-	       HIPQUAD(conn->ksnc_myipaddr), HIPQUAD(conn->ksnc_ipaddr),
+	       &conn->ksnc_myipaddr, &conn->ksnc_ipaddr,
 	       conn->ksnc_port, incarnation, cpt,
 	       (int)(sched - &sched->kss_info->ksi_scheds[0]));
 
@@ -1648,10 +1648,10 @@ ksocknal_destroy_conn (ksock_conn_t *conn)
 		last_rcv = conn->ksnc_rx_deadline -
 			   cfs_time_seconds(*ksocknal_tunables.ksnd_timeout);
 		CERROR("Completing partial receive from %s[%d]"
-		       ", ip %d.%d.%d.%d:%d, with error, wanted: %d, left: %d, "
+		       ", ip %pI4:%d, with error, wanted: %d, left: %d, "
 		       "last alive is %ld secs ago\n",
 		       libcfs_id2str(conn->ksnc_peer->ksnp_id), conn->ksnc_type,
-		       HIPQUAD(conn->ksnc_ipaddr), conn->ksnc_port,
+		       &conn->ksnc_ipaddr, conn->ksnc_port,
 		       conn->ksnc_rx_nob_wanted, conn->ksnc_rx_nob_left,
 		       cfs_duration_sec(cfs_time_sub(cfs_time_current(),
 					last_rcv)));
@@ -1661,25 +1661,25 @@ ksocknal_destroy_conn (ksock_conn_t *conn)
 	case SOCKNAL_RX_LNET_HEADER:
 		if (conn->ksnc_rx_started)
 			CERROR("Incomplete receive of lnet header from %s"
-			       ", ip %d.%d.%d.%d:%d, with error, protocol: %d.x.\n",
+			       ", ip %pI4:%d, with error, protocol: %d.x.\n",
 			       libcfs_id2str(conn->ksnc_peer->ksnp_id),
-			       HIPQUAD(conn->ksnc_ipaddr), conn->ksnc_port,
+			       &conn->ksnc_ipaddr, conn->ksnc_port,
 			       conn->ksnc_proto->pro_version);
 		break;
 	case SOCKNAL_RX_KSM_HEADER:
 		if (conn->ksnc_rx_started)
 			CERROR("Incomplete receive of ksock message from %s"
-			       ", ip %d.%d.%d.%d:%d, with error, protocol: %d.x.\n",
+			       ", ip %pI4:%d, with error, protocol: %d.x.\n",
 			       libcfs_id2str(conn->ksnc_peer->ksnp_id),
-			       HIPQUAD(conn->ksnc_ipaddr), conn->ksnc_port,
+			       &conn->ksnc_ipaddr, conn->ksnc_port,
 			       conn->ksnc_proto->pro_version);
 		break;
 	case SOCKNAL_RX_SLOP:
 		if (conn->ksnc_rx_started)
 			CERROR("Incomplete receive of slops from %s"
-			       ", ip %d.%d.%d.%d:%d, with error\n",
+			       ", ip %pI4:%d, with error\n",
 			       libcfs_id2str(conn->ksnc_peer->ksnp_id),
-			       HIPQUAD(conn->ksnc_ipaddr), conn->ksnc_port);
+			       &conn->ksnc_ipaddr, conn->ksnc_port);
 	       break;
 	default:
 		LBUG ();
diff --git a/drivers/staging/lustre/lnet/klnds/socklnd/socklnd_cb.c b/drivers/staging/lustre/lnet/klnds/socklnd/socklnd_cb.c
index ad5e241..ac13a20 100644
--- a/drivers/staging/lustre/lnet/klnds/socklnd/socklnd_cb.c
+++ b/drivers/staging/lustre/lnet/klnds/socklnd/socklnd_cb.c
@@ -553,21 +553,21 @@ ksocknal_process_transmit (ksock_conn_t *conn, ksock_tx_t *tx)
 	if (!conn->ksnc_closing) {
 		switch (rc) {
 		case -ECONNRESET:
-			LCONSOLE_WARN("Host %u.%u.%u.%u reset our connection "
+			LCONSOLE_WARN("Host %pI4 reset our connection "
 				      "while we were sending data; it may have "
 				      "rebooted.\n",
-				      HIPQUAD(conn->ksnc_ipaddr));
+				      &conn->ksnc_ipaddr);
 			break;
 		default:
 			LCONSOLE_WARN("There was an unexpected network error "
-				      "while writing to %u.%u.%u.%u: %d.\n",
-				      HIPQUAD(conn->ksnc_ipaddr), rc);
+				      "while writing to %pI4: %d.\n",
+				      &conn->ksnc_ipaddr, rc);
 			break;
 		}
 		CDEBUG(D_NET, "[%p] Error %d on write to %s"
-		       " ip %d.%d.%d.%d:%d\n", conn, rc,
+		       " ip %pI4:%d\n", conn, rc,
 		       libcfs_id2str(conn->ksnc_peer->ksnp_id),
-		       HIPQUAD(conn->ksnc_ipaddr),
+		       &conn->ksnc_ipaddr,
 		       conn->ksnc_port);
 	}
 
@@ -700,9 +700,9 @@ ksocknal_queue_tx_locked (ksock_tx_t *tx, ksock_conn_t *conn)
 	 * ksnc_sock... */
 	LASSERT(!conn->ksnc_closing);
 
-	CDEBUG (D_NET, "Sending to %s ip %d.%d.%d.%d:%d\n",
+	CDEBUG(D_NET, "Sending to %s ip %pI4:%d\n",
 		libcfs_id2str(conn->ksnc_peer->ksnp_id),
-		HIPQUAD(conn->ksnc_ipaddr),
+		&conn->ksnc_ipaddr,
 		conn->ksnc_port);
 
 	ksocknal_tx_prep(conn, tx);
@@ -801,9 +801,9 @@ ksocknal_find_connectable_route_locked (ksock_peer_t *peer)
 		if (!(route->ksnr_retry_interval == 0 || /* first attempt */
 		      cfs_time_aftereq(now, route->ksnr_timeout))) {
 			CDEBUG(D_NET,
-			       "Too soon to retry route %u.%u.%u.%u "
+			       "Too soon to retry route %pI4 "
 			       "(cnted %d, interval %ld, %ld secs later)\n",
-			       HIPQUAD(route->ksnr_ipaddr),
+			       &route->ksnr_ipaddr,
 			       route->ksnr_connected,
 			       route->ksnr_retry_interval,
 			       cfs_duration_sec(route->ksnr_timeout - now));
@@ -1133,17 +1133,17 @@ ksocknal_process_receive (ksock_conn_t *conn)
 			LASSERT (rc != -EAGAIN);
 
 			if (rc == 0)
-				CDEBUG (D_NET, "[%p] EOF from %s"
-					" ip %d.%d.%d.%d:%d\n", conn,
+				CDEBUG(D_NET, "[%p] EOF from %s"
+					" ip %pI4:%d\n", conn,
 					libcfs_id2str(conn->ksnc_peer->ksnp_id),
-					HIPQUAD(conn->ksnc_ipaddr),
+					&conn->ksnc_ipaddr,
 					conn->ksnc_port);
 			else if (!conn->ksnc_closing)
-				CERROR ("[%p] Error %d on read from %s"
-					" ip %d.%d.%d.%d:%d\n",
+				CERROR("[%p] Error %d on read from %s"
+					" ip %pI4:%d\n",
 					conn, rc,
 					libcfs_id2str(conn->ksnc_peer->ksnp_id),
-					HIPQUAD(conn->ksnc_ipaddr),
+					&conn->ksnc_ipaddr,
 					conn->ksnc_port);
 
 			/* it's not an error if conn is being closed */
@@ -1722,8 +1722,8 @@ ksocknal_recv_hello (lnet_ni_t *ni, ksock_conn_t *conn,
 
 	rc = libcfs_sock_read(sock, &hello->kshm_magic, sizeof (hello->kshm_magic), timeout);
 	if (rc != 0) {
-		CERROR ("Error %d reading HELLO from %u.%u.%u.%u\n",
-			rc, HIPQUAD(conn->ksnc_ipaddr));
+		CERROR("Error %d reading HELLO from %pI4\n",
+			rc, &conn->ksnc_ipaddr);
 		LASSERT (rc < 0);
 		return rc;
 	}
@@ -1732,18 +1732,18 @@ ksocknal_recv_hello (lnet_ni_t *ni, ksock_conn_t *conn,
 	    hello->kshm_magic != __swab32(LNET_PROTO_MAGIC) &&
 	    hello->kshm_magic != le32_to_cpu (LNET_PROTO_TCP_MAGIC)) {
 		/* Unexpected magic! */
-		CERROR ("Bad magic(1) %#08x (%#08x expected) from "
-			"%u.%u.%u.%u\n", __cpu_to_le32 (hello->kshm_magic),
+		CERROR("Bad magic(1) %#08x (%#08x expected) from "
+			"%pI4\n", __cpu_to_le32 (hello->kshm_magic),
 			LNET_PROTO_TCP_MAGIC,
-			HIPQUAD(conn->ksnc_ipaddr));
+			&conn->ksnc_ipaddr);
 		return -EPROTO;
 	}
 
 	rc = libcfs_sock_read(sock, &hello->kshm_version,
 			      sizeof(hello->kshm_version), timeout);
 	if (rc != 0) {
-		CERROR ("Error %d reading HELLO from %u.%u.%u.%u\n",
-			rc, HIPQUAD(conn->ksnc_ipaddr));
+		CERROR("Error %d reading HELLO from %pI4\n",
+			rc, &conn->ksnc_ipaddr);
 		LASSERT (rc < 0);
 		return rc;
 	}
@@ -1763,10 +1763,10 @@ ksocknal_recv_hello (lnet_ni_t *ni, ksock_conn_t *conn,
 			ksocknal_send_hello(ni, conn, ni->ni_nid, hello);
 		}
 
-		CERROR ("Unknown protocol version (%d.x expected)"
-			" from %u.%u.%u.%u\n",
+		CERROR("Unknown protocol version (%d.x expected)"
+			" from %pI4\n",
 			conn->ksnc_proto->pro_version,
-			HIPQUAD(conn->ksnc_ipaddr));
+			&conn->ksnc_ipaddr);
 
 		return -EPROTO;
 	}
@@ -1777,8 +1777,8 @@ ksocknal_recv_hello (lnet_ni_t *ni, ksock_conn_t *conn,
 	/* receive the rest of hello message anyway */
 	rc = conn->ksnc_proto->pro_recv_hello(conn, hello, timeout);
 	if (rc != 0) {
-		CERROR("Error %d reading or checking hello from from %u.%u.%u.%u\n",
-		       rc, HIPQUAD(conn->ksnc_ipaddr));
+		CERROR("Error %d reading or checking hello from from %pI4\n",
+		       rc, &conn->ksnc_ipaddr);
 		LASSERT (rc < 0);
 		return rc;
 	}
@@ -1787,7 +1787,7 @@ ksocknal_recv_hello (lnet_ni_t *ni, ksock_conn_t *conn,
 
 	if (hello->kshm_src_nid == LNET_NID_ANY) {
 		CERROR("Expecting a HELLO hdr with a NID, but got LNET_NID_ANY"
-		       "from %u.%u.%u.%u\n", HIPQUAD(conn->ksnc_ipaddr));
+		       "from %pI4\n", &conn->ksnc_ipaddr);
 		return -EPROTO;
 	}
 
@@ -1807,9 +1807,9 @@ ksocknal_recv_hello (lnet_ni_t *ni, ksock_conn_t *conn,
 		/* peer determines type */
 		conn->ksnc_type = ksocknal_invert_type(hello->kshm_ctype);
 		if (conn->ksnc_type == SOCKLND_CONN_NONE) {
-			CERROR ("Unexpected type %d from %s ip %u.%u.%u.%u\n",
+			CERROR("Unexpected type %d from %s ip %pI4\n",
 				hello->kshm_ctype, libcfs_id2str(*peerid),
-				HIPQUAD(conn->ksnc_ipaddr));
+				&conn->ksnc_ipaddr);
 			return -EPROTO;
 		}
 
@@ -1819,11 +1819,11 @@ ksocknal_recv_hello (lnet_ni_t *ni, ksock_conn_t *conn,
 	if (peerid->pid != recv_id.pid ||
 	    peerid->nid != recv_id.nid) {
 		LCONSOLE_ERROR_MSG(0x130, "Connected successfully to %s on host"
-				   " %u.%u.%u.%u, but they claimed they were "
+				   " %pI4, but they claimed they were "
 				   "%s; please check your Lustre "
 				   "configuration.\n",
 				   libcfs_id2str(*peerid),
-				   HIPQUAD(conn->ksnc_ipaddr),
+				   &conn->ksnc_ipaddr,
 				   libcfs_id2str(recv_id));
 		return -EPROTO;
 	}
@@ -1834,9 +1834,9 @@ ksocknal_recv_hello (lnet_ni_t *ni, ksock_conn_t *conn,
 	}
 
 	if (ksocknal_invert_type(hello->kshm_ctype) != conn->ksnc_type) {
-		CERROR ("Mismatched types: me %d, %s ip %u.%u.%u.%u %d\n",
+		CERROR("Mismatched types: me %d, %s ip %pI4 %d\n",
 			conn->ksnc_type, libcfs_id2str(*peerid),
-			HIPQUAD(conn->ksnc_ipaddr),
+			&conn->ksnc_ipaddr,
 			hello->kshm_ctype);
 		return -EPROTO;
 	}
@@ -2208,8 +2208,8 @@ ksocknal_connd (void *arg)
 				/* consecutive retry */
 				if (cons_retry++ > SOCKNAL_INSANITY_RECONN) {
 					CWARN("massive consecutive "
-					      "re-connecting to %u.%u.%u.%u\n",
-					      HIPQUAD(route->ksnr_ipaddr));
+					      "re-connecting to %pI4\n",
+					      &route->ksnr_ipaddr);
 					cons_retry = 0;
 				}
 			} else {
@@ -2274,26 +2274,26 @@ ksocknal_find_timed_out_conn (ksock_peer_t *peer)
 			switch (error) {
 			case ECONNRESET:
 				CNETERR("A connection with %s "
-					"(%u.%u.%u.%u:%d) was reset; "
+					"(%pI4:%d) was reset; "
 					"it may have rebooted.\n",
 					libcfs_id2str(peer->ksnp_id),
-					HIPQUAD(conn->ksnc_ipaddr),
+					&conn->ksnc_ipaddr,
 					conn->ksnc_port);
 				break;
 			case ETIMEDOUT:
 				CNETERR("A connection with %s "
-					"(%u.%u.%u.%u:%d) timed out; the "
+					"(%pI4:%d) timed out; the "
 					"network or node may be down.\n",
 					libcfs_id2str(peer->ksnp_id),
-					HIPQUAD(conn->ksnc_ipaddr),
+					&conn->ksnc_ipaddr,
 					conn->ksnc_port);
 				break;
 			default:
 				CNETERR("An unexpected network error %d "
 					"occurred with %s "
-					"(%u.%u.%u.%u:%d\n", error,
+					"(%pI4:%d\n", error,
 					libcfs_id2str(peer->ksnp_id),
-					HIPQUAD(conn->ksnc_ipaddr),
+					&conn->ksnc_ipaddr,
 					conn->ksnc_port);
 				break;
 			}
@@ -2306,10 +2306,10 @@ ksocknal_find_timed_out_conn (ksock_peer_t *peer)
 				     conn->ksnc_rx_deadline)) {
 			/* Timed out incomplete incoming message */
 			ksocknal_conn_addref(conn);
-			CNETERR("Timeout receiving from %s (%u.%u.%u.%u:%d), "
+			CNETERR("Timeout receiving from %s (%pI4:%d), "
 				"state %d wanted %d left %d\n",
 				libcfs_id2str(peer->ksnp_id),
-				HIPQUAD(conn->ksnc_ipaddr),
+				&conn->ksnc_ipaddr,
 				conn->ksnc_port,
 				conn->ksnc_rx_state,
 				conn->ksnc_rx_nob_wanted,
@@ -2324,10 +2324,10 @@ ksocknal_find_timed_out_conn (ksock_peer_t *peer)
 			/* Timed out messages queued for sending or
 			 * buffered in the socket's send buffer */
 			ksocknal_conn_addref(conn);
-			CNETERR("Timeout sending data to %s (%u.%u.%u.%u:%d) "
+			CNETERR("Timeout sending data to %s (%pI4:%d) "
 				"the network or that node may be down.\n",
 				libcfs_id2str(peer->ksnp_id),
-				HIPQUAD(conn->ksnc_ipaddr),
+				&conn->ksnc_ipaddr,
 				conn->ksnc_port);
 			return (conn);
 		}
diff --git a/drivers/staging/lustre/lnet/klnds/socklnd/socklnd_proto.c b/drivers/staging/lustre/lnet/klnds/socklnd/socklnd_proto.c
index ec57179..5d58313 100644
--- a/drivers/staging/lustre/lnet/klnds/socklnd/socklnd_proto.c
+++ b/drivers/staging/lustre/lnet/klnds/socklnd/socklnd_proto.c
@@ -496,8 +496,8 @@ ksocknal_send_hello_v1 (ksock_conn_t *conn, ksock_hello_msg_t *hello)
 	rc = libcfs_sock_write(sock, hdr, sizeof(*hdr),lnet_acceptor_timeout());
 
 	if (rc != 0) {
-		CNETERR("Error %d sending HELLO hdr to %u.%u.%u.%u/%d\n",
-			rc, HIPQUAD(conn->ksnc_ipaddr), conn->ksnc_port);
+		CNETERR("Error %d sending HELLO hdr to %pI4/%d\n",
+			rc, &conn->ksnc_ipaddr, conn->ksnc_port);
 		goto out;
 	}
 
@@ -513,8 +513,8 @@ ksocknal_send_hello_v1 (ksock_conn_t *conn, ksock_hello_msg_t *hello)
 			       lnet_acceptor_timeout());
 	if (rc != 0) {
 		CNETERR("Error %d sending HELLO payload (%d)"
-			" to %u.%u.%u.%u/%d\n", rc, hello->kshm_nips,
-			HIPQUAD(conn->ksnc_ipaddr), conn->ksnc_port);
+			" to %pI4/%d\n", rc, hello->kshm_nips,
+			&conn->ksnc_ipaddr, conn->ksnc_port);
 	}
 out:
 	LIBCFS_FREE(hdr, sizeof(*hdr));
@@ -545,8 +545,8 @@ ksocknal_send_hello_v2 (ksock_conn_t *conn, ksock_hello_msg_t *hello)
 			       lnet_acceptor_timeout());
 
 	if (rc != 0) {
-		CNETERR("Error %d sending HELLO hdr to %u.%u.%u.%u/%d\n",
-			rc, HIPQUAD(conn->ksnc_ipaddr), conn->ksnc_port);
+		CNETERR("Error %d sending HELLO hdr to %pI4/%d\n",
+			rc, &conn->ksnc_ipaddr, conn->ksnc_port);
 		return rc;
 	}
 
@@ -558,8 +558,8 @@ ksocknal_send_hello_v2 (ksock_conn_t *conn, ksock_hello_msg_t *hello)
 			       lnet_acceptor_timeout());
 	if (rc != 0) {
 		CNETERR("Error %d sending HELLO payload (%d)"
-			" to %u.%u.%u.%u/%d\n", rc, hello->kshm_nips,
-			HIPQUAD(conn->ksnc_ipaddr), conn->ksnc_port);
+			" to %pI4/%d\n", rc, hello->kshm_nips,
+			&conn->ksnc_ipaddr, conn->ksnc_port);
 	}
 
 	return rc;
@@ -583,18 +583,18 @@ ksocknal_recv_hello_v1(ksock_conn_t *conn, ksock_hello_msg_t *hello,int timeout)
 			      sizeof (*hdr) - offsetof (lnet_hdr_t, src_nid),
 			      timeout);
 	if (rc != 0) {
-		CERROR ("Error %d reading rest of HELLO hdr from %u.%u.%u.%u\n",
-			rc, HIPQUAD(conn->ksnc_ipaddr));
+		CERROR("Error %d reading rest of HELLO hdr from %pI4\n",
+			rc, &conn->ksnc_ipaddr);
 		LASSERT (rc < 0 && rc != -EALREADY);
 		goto out;
 	}
 
 	/* ...and check we got what we expected */
 	if (hdr->type != cpu_to_le32 (LNET_MSG_HELLO)) {
-		CERROR ("Expecting a HELLO hdr,"
-			" but got type %d from %u.%u.%u.%u\n",
+		CERROR("Expecting a HELLO hdr,"
+			" but got type %d from %pI4\n",
 			le32_to_cpu (hdr->type),
-			HIPQUAD(conn->ksnc_ipaddr));
+			&conn->ksnc_ipaddr);
 		rc = -EPROTO;
 		goto out;
 	}
@@ -607,8 +607,8 @@ ksocknal_recv_hello_v1(ksock_conn_t *conn, ksock_hello_msg_t *hello,int timeout)
 					 sizeof (__u32);
 
 	if (hello->kshm_nips > LNET_MAX_INTERFACES) {
-		CERROR("Bad nips %d from ip %u.%u.%u.%u\n",
-		       hello->kshm_nips, HIPQUAD(conn->ksnc_ipaddr));
+		CERROR("Bad nips %d from ip %pI4\n",
+		       hello->kshm_nips, &conn->ksnc_ipaddr);
 		rc = -EPROTO;
 		goto out;
 	}
@@ -619,9 +619,9 @@ ksocknal_recv_hello_v1(ksock_conn_t *conn, ksock_hello_msg_t *hello,int timeout)
 	rc = libcfs_sock_read(sock, hello->kshm_ips,
 			      hello->kshm_nips * sizeof(__u32), timeout);
 	if (rc != 0) {
-		CERROR ("Error %d reading IPs from ip %u.%u.%u.%u\n",
-			rc, HIPQUAD(conn->ksnc_ipaddr));
-		LASSERT (rc < 0 && rc != -EALREADY);
+		CERROR("Error %d reading IPs from ip %pI4\n",
+			rc, &conn->ksnc_ipaddr);
+		LASSERT(rc < 0 && rc != -EALREADY);
 		goto out;
 	}
 
@@ -629,8 +629,8 @@ ksocknal_recv_hello_v1(ksock_conn_t *conn, ksock_hello_msg_t *hello,int timeout)
 		hello->kshm_ips[i] = __le32_to_cpu(hello->kshm_ips[i]);
 
 		if (hello->kshm_ips[i] == 0) {
-			CERROR("Zero IP[%d] from ip %u.%u.%u.%u\n",
-			       i, HIPQUAD(conn->ksnc_ipaddr));
+			CERROR("Zero IP[%d] from ip %pI4\n",
+			       i, &conn->ksnc_ipaddr);
 			rc = -EPROTO;
 			break;
 		}
@@ -658,9 +658,9 @@ ksocknal_recv_hello_v2 (ksock_conn_t *conn, ksock_hello_msg_t *hello, int timeou
 				       offsetof(ksock_hello_msg_t, kshm_src_nid),
 			      timeout);
 	if (rc != 0) {
-		CERROR ("Error %d reading HELLO from %u.%u.%u.%u\n",
-			rc, HIPQUAD(conn->ksnc_ipaddr));
-		LASSERT (rc < 0 && rc != -EALREADY);
+		CERROR("Error %d reading HELLO from %pI4\n",
+			rc, &conn->ksnc_ipaddr);
+		LASSERT(rc < 0 && rc != -EALREADY);
 		return rc;
 	}
 
@@ -676,8 +676,8 @@ ksocknal_recv_hello_v2 (ksock_conn_t *conn, ksock_hello_msg_t *hello, int timeou
 	}
 
 	if (hello->kshm_nips > LNET_MAX_INTERFACES) {
-		CERROR("Bad nips %d from ip %u.%u.%u.%u\n",
-		       hello->kshm_nips, HIPQUAD(conn->ksnc_ipaddr));
+		CERROR("Bad nips %d from ip %pI4\n",
+		       hello->kshm_nips, &conn->ksnc_ipaddr);
 		return -EPROTO;
 	}
 
@@ -687,9 +687,9 @@ ksocknal_recv_hello_v2 (ksock_conn_t *conn, ksock_hello_msg_t *hello, int timeou
 	rc = libcfs_sock_read(sock, hello->kshm_ips,
 			      hello->kshm_nips * sizeof(__u32), timeout);
 	if (rc != 0) {
-		CERROR ("Error %d reading IPs from ip %u.%u.%u.%u\n",
-			rc, HIPQUAD(conn->ksnc_ipaddr));
-		LASSERT (rc < 0 && rc != -EALREADY);
+		CERROR("Error %d reading IPs from ip %pI4\n",
+			rc, &conn->ksnc_ipaddr);
+		LASSERT(rc < 0 && rc != -EALREADY);
 		return rc;
 	}
 
@@ -698,8 +698,8 @@ ksocknal_recv_hello_v2 (ksock_conn_t *conn, ksock_hello_msg_t *hello, int timeou
 			__swab32s(&hello->kshm_ips[i]);
 
 		if (hello->kshm_ips[i] == 0) {
-			CERROR("Zero IP[%d] from ip %u.%u.%u.%u\n",
-			       i, HIPQUAD(conn->ksnc_ipaddr));
+			CERROR("Zero IP[%d] from ip %pI4\n",
+			       i, &conn->ksnc_ipaddr);
 			return -EPROTO;
 		}
 	}
diff --git a/drivers/staging/lustre/lnet/lnet/acceptor.c b/drivers/staging/lustre/lnet/lnet/acceptor.c
index 81ef28b..f317c9a 100644
--- a/drivers/staging/lustre/lnet/lnet/acceptor.c
+++ b/drivers/staging/lustre/lnet/lnet/acceptor.c
@@ -101,52 +101,52 @@ lnet_connect_console_error (int rc, lnet_nid_t peer_nid,
 	switch (rc) {
 	/* "normal" errors */
 	case -ECONNREFUSED:
-		CNETERR("Connection to %s at host %u.%u.%u.%u on port %d was "
+		CNETERR("Connection to %s at host %pI4 on port %d was "
 			"refused: check that Lustre is running on that node.\n",
 			libcfs_nid2str(peer_nid),
-			HIPQUAD(peer_ip), peer_port);
+			&peer_ip, peer_port);
 		break;
 	case -EHOSTUNREACH:
 	case -ENETUNREACH:
-		CNETERR("Connection to %s at host %u.%u.%u.%u "
+		CNETERR("Connection to %s at host %pI4 "
 			"was unreachable: the network or that node may "
 			"be down, or Lustre may be misconfigured.\n",
-			libcfs_nid2str(peer_nid), HIPQUAD(peer_ip));
+			libcfs_nid2str(peer_nid), &peer_ip);
 		break;
 	case -ETIMEDOUT:
-		CNETERR("Connection to %s at host %u.%u.%u.%u on "
+		CNETERR("Connection to %s at host %pI4 on "
 			"port %d took too long: that node may be hung "
 			"or experiencing high load.\n",
 			libcfs_nid2str(peer_nid),
-			HIPQUAD(peer_ip), peer_port);
+			&peer_ip, peer_port);
 		break;
 	case -ECONNRESET:
-		LCONSOLE_ERROR_MSG(0x11b, "Connection to %s at host %u.%u.%u.%u"
+		LCONSOLE_ERROR_MSG(0x11b, "Connection to %s at host %pI4"
 				   " on port %d was reset: "
 				   "is it running a compatible version of "
 				   "Lustre and is %s one of its NIDs?\n",
 				   libcfs_nid2str(peer_nid),
-				   HIPQUAD(peer_ip), peer_port,
+				   &peer_ip, peer_port,
 				   libcfs_nid2str(peer_nid));
 		break;
 	case -EPROTO:
 		LCONSOLE_ERROR_MSG(0x11c, "Protocol error connecting to %s at "
-				   "host %u.%u.%u.%u on port %d: is it running "
+				   "host %pI4 on port %d: is it running "
 				   "a compatible version of Lustre?\n",
 				   libcfs_nid2str(peer_nid),
-				   HIPQUAD(peer_ip), peer_port);
+				   &peer_ip, peer_port);
 		break;
 	case -EADDRINUSE:
 		LCONSOLE_ERROR_MSG(0x11d, "No privileged ports available to "
-				   "connect to %s at host %u.%u.%u.%u on port "
+				   "connect to %s at host %pI4 on port "
 				   "%d\n", libcfs_nid2str(peer_nid),
-				   HIPQUAD(peer_ip), peer_port);
+				   &peer_ip, peer_port);
 		break;
 	default:
 		LCONSOLE_ERROR_MSG(0x11e, "Unexpected error %d connecting to %s"
-				   " at host %u.%u.%u.%u on port %d\n", rc,
+				   " at host %pI4 on port %d\n", rc,
 				   libcfs_nid2str(peer_nid),
-				   HIPQUAD(peer_ip), peer_port);
+				   &peer_ip, peer_port);
 		break;
 	}
 }
@@ -253,8 +253,8 @@ lnet_accept(socket_t *sock, __u32 magic)
 
 			if (rc != 0)
 				CERROR("Error sending magic+version in response"
-				       "to LNET magic from %u.%u.%u.%u: %d\n",
-				       HIPQUAD(peer_ip), rc);
+				       "to LNET magic from %pI4: %d\n",
+				       &peer_ip, rc);
 			return -EPROTO;
 		}
 
@@ -265,9 +265,9 @@ lnet_accept(socket_t *sock, __u32 magic)
 		else
 			str = "unrecognised";
 
-		LCONSOLE_ERROR_MSG(0x11f, "Refusing connection from %u.%u.%u.%u"
+		LCONSOLE_ERROR_MSG(0x11f, "Refusing connection from %pI4"
 				   " magic %08x: %s acceptor protocol\n",
-				   HIPQUAD(peer_ip), magic, str);
+				   &peer_ip, magic, str);
 		return -EPROTO;
 	}
 
@@ -278,7 +278,7 @@ lnet_accept(socket_t *sock, __u32 magic)
 			      accept_timeout);
 	if (rc != 0) {
 		CERROR("Error %d reading connection request version from "
-		       "%u.%u.%u.%u\n", rc, HIPQUAD(peer_ip));
+		       "%pI4\n", rc, &peer_ip);
 		return -EIO;
 	}
 
@@ -301,8 +301,8 @@ lnet_accept(socket_t *sock, __u32 magic)
 
 		if (rc != 0)
 			CERROR("Error sending magic+version in response"
-			       "to version %d from %u.%u.%u.%u: %d\n",
-			       peer_version, HIPQUAD(peer_ip), rc);
+			       "to version %d from %pI4: %d\n",
+			       peer_version, &peer_ip, rc);
 		return -EPROTO;
 	}
 
@@ -312,7 +312,7 @@ lnet_accept(socket_t *sock, __u32 magic)
 			      accept_timeout);
 	if (rc != 0) {
 		CERROR("Error %d reading connection request from "
-		       "%u.%u.%u.%u\n", rc, HIPQUAD(peer_ip));
+		       "%pI4\n", rc, &peer_ip);
 		return -EIO;
 	}
 
@@ -324,23 +324,23 @@ lnet_accept(socket_t *sock, __u32 magic)
 	    ni->ni_nid != cr.acr_nid) { /* right NET, wrong NID! */
 		if (ni != NULL)
 			lnet_ni_decref(ni);
-		LCONSOLE_ERROR_MSG(0x120, "Refusing connection from %u.%u.%u.%u"
+		LCONSOLE_ERROR_MSG(0x120, "Refusing connection from %pI4"
 				   " for %s: No matching NI\n",
-				   HIPQUAD(peer_ip), libcfs_nid2str(cr.acr_nid));
+				   &peer_ip, libcfs_nid2str(cr.acr_nid));
 		return -EPERM;
 	}
 
 	if (ni->ni_lnd->lnd_accept == NULL) {
 		/* This catches a request for the loopback LND */
 		lnet_ni_decref(ni);
-		LCONSOLE_ERROR_MSG(0x121, "Refusing connection from %u.%u.%u.%u"
+		LCONSOLE_ERROR_MSG(0x121, "Refusing connection from %pI4"
 				  " for %s: NI doesn not accept IP connections\n",
-				  HIPQUAD(peer_ip), libcfs_nid2str(cr.acr_nid));
+				  &peer_ip, libcfs_nid2str(cr.acr_nid));
 		return -EPERM;
 	}
 
-	CDEBUG(D_NET, "Accept %s from %u.%u.%u.%u\n",
-	       libcfs_nid2str(cr.acr_nid), HIPQUAD(peer_ip));
+	CDEBUG(D_NET, "Accept %s from %pI4\n",
+	       libcfs_nid2str(cr.acr_nid), &peer_ip);
 
 	rc = ni->ni_lnd->lnd_accept(ni, sock);
 
@@ -410,9 +410,9 @@ lnet_acceptor(void *arg)
 		}
 
 		if (secure && peer_port > LNET_ACCEPTOR_MAX_RESERVED_PORT) {
-			CERROR("Refusing connection from %u.%u.%u.%u: "
+			CERROR("Refusing connection from %pI4: "
 			       "insecure port %d\n",
-			       HIPQUAD(peer_ip), peer_port);
+			       &peer_ip, peer_port);
 			goto failed;
 		}
 
@@ -420,7 +420,7 @@ lnet_acceptor(void *arg)
 				      accept_timeout);
 		if (rc != 0) {
 			CERROR("Error %d reading connection request from "
-			       "%u.%u.%u.%u\n", rc, HIPQUAD(peer_ip));
+			       "%pI4\n", rc, &peer_ip);
 			goto failed;
 		}
 
diff --git a/drivers/staging/lustre/lustre/libcfs/linux/linux-tcpip.c b/drivers/staging/lustre/lustre/libcfs/linux/linux-tcpip.c
index 855c7e8..9cd6143 100644
--- a/drivers/staging/lustre/lustre/libcfs/linux/linux-tcpip.c
+++ b/drivers/staging/lustre/lustre/libcfs/linux/linux-tcpip.c
@@ -641,8 +641,8 @@ libcfs_sock_connect (struct socket **sockp, int *fatal,
 	*fatal = !(rc == -EADDRNOTAVAIL);
 
 	CDEBUG_LIMIT(*fatal ? D_NETERROR : D_NET,
-	       "Error %d connecting %u.%u.%u.%u/%d -> %u.%u.%u.%u/%d\n", rc,
-	       HIPQUAD(local_ip), local_port, HIPQUAD(peer_ip), peer_port);
+	       "Error %d connecting %pI4/%d -> %pI4/%d\n", rc,
+	       &local_ip, local_port, &peer_ip, peer_port);
 
 	sock_release(*sockp);
 	return rc;
-- 
1.7.9.5

