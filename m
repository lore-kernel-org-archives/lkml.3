Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933764Ab3LIPAE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 10:00:04 -0500
Received: from mail-pb0-f50.google.com ([209.85.160.50]:37197 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932572Ab3LIO74 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 09:59:56 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Doug Oucharek <doug.s.oucharek@intel.com>,
        Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 02/13] staging/lustre/lnet: Add LNet Router Priority parameter
Date: Mon,  9 Dec 2013 22:56:54 +0800
Message-Id: <1386601025-422-3-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1386601025-422-1-git-send-email-bergwolf@gmail.com>
References: <1386601025-422-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Doug Oucharek <doug.s.oucharek@intel.com>

This change adds a priority parameter to the route module settings.
This paramter can be >= 0. Like hops, the lower the prioirty number
the higher the priority.  So lower numbered priorities will be
selected over higher numbers.

Lustre-change: http://review.whamcloud.com/5663
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-2934
Signed-off-by: Doug Oucharek <doug.s.oucharek@intel.com>
Reviewed-by: Andreas Dilger <andreas.dilger@intel.com>
Reviewed-by: Amir Shehata <amir.shehata@intel.com>
Reviewed-by: Isaac Huang <he.huang@intel.com>
Reviewed-by: Oleg Drokin <oleg.drokin@intel.com>
Signed-off-by: Peng Tao <bergwolf@gmail.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 .../lustre/include/linux/libcfs/libcfs_ioctl.h     |    1 +
 .../staging/lustre/include/linux/lnet/lib-lnet.h   |    5 ++-
 .../staging/lustre/include/linux/lnet/lib-types.h  |    2 +-
 drivers/staging/lustre/lnet/lnet/api-ni.c          |    5 ++-
 drivers/staging/lustre/lnet/lnet/config.c          |   39 +++++++++++++++++++-
 drivers/staging/lustre/lnet/lnet/lib-move.c        |    6 +++
 drivers/staging/lustre/lnet/lnet/router.c          |   19 ++++++----
 drivers/staging/lustre/lnet/lnet/router_proc.c     |   16 ++++----
 8 files changed, 72 insertions(+), 21 deletions(-)

diff --git a/drivers/staging/lustre/include/linux/libcfs/libcfs_ioctl.h b/drivers/staging/lustre/include/linux/libcfs/libcfs_ioctl.h
index dd1a1f1..74dda57 100644
--- a/drivers/staging/lustre/include/linux/libcfs/libcfs_ioctl.h
+++ b/drivers/staging/lustre/include/linux/libcfs/libcfs_ioctl.h
@@ -69,6 +69,7 @@ struct libcfs_ioctl_data {
 	char ioc_bulk[0];
 };
 
+#define ioc_priority ioc_u32[0]
 
 struct libcfs_ioctl_hdr {
 	__u32 ioc_len;
diff --git a/drivers/staging/lustre/include/linux/lnet/lib-lnet.h b/drivers/staging/lustre/include/linux/lnet/lib-lnet.h
index bf30104..3ac2bb5 100644
--- a/drivers/staging/lustre/include/linux/lnet/lib-lnet.h
+++ b/drivers/staging/lustre/include/linux/lnet/lib-lnet.h
@@ -650,12 +650,13 @@ extern lnet_ni_t *lnet_net2ni(__u32 net);
 
 int lnet_notify(lnet_ni_t *ni, lnet_nid_t peer, int alive, cfs_time_t when);
 void lnet_notify_locked(lnet_peer_t *lp, int notifylnd, int alive, cfs_time_t when);
-int lnet_add_route(__u32 net, unsigned int hops, lnet_nid_t gateway_nid);
+int lnet_add_route(__u32 net, unsigned int hops, lnet_nid_t gateway_nid,
+		   unsigned int priority);
 int lnet_check_routes(void);
 int lnet_del_route(__u32 net, lnet_nid_t gw_nid);
 void lnet_destroy_routes(void);
 int lnet_get_route(int idx, __u32 *net, __u32 *hops,
-		   lnet_nid_t *gateway, __u32 *alive);
+		   lnet_nid_t *gateway, __u32 *alive, __u32 *priority);
 void lnet_proc_init(void);
 void lnet_proc_fini(void);
 int  lnet_rtrpools_alloc(int im_a_router);
diff --git a/drivers/staging/lustre/include/linux/lnet/lib-types.h b/drivers/staging/lustre/include/linux/lnet/lib-types.h
index e579e7e..dd8edcf 100644
--- a/drivers/staging/lustre/include/linux/lnet/lib-types.h
+++ b/drivers/staging/lustre/include/linux/lnet/lib-types.h
@@ -478,7 +478,6 @@ typedef struct lnet_peer {
 	lnet_rc_data_t		*lp_rcd;	/* router checker state */
 } lnet_peer_t;
 
-
 /* peer hash size */
 #define LNET_PEER_HASH_BITS     9
 #define LNET_PEER_HASH_SIZE     (1 << LNET_PEER_HASH_BITS)
@@ -504,6 +503,7 @@ typedef struct {
 	int			lr_seq;		/* sequence for round-robin */
 	unsigned int		lr_downis;	/* number of down NIs */
 	unsigned int		lr_hops;	/* how far I am */
+	unsigned int            lr_priority;    /* route priority */
 } lnet_route_t;
 
 #define LNET_REMOTE_NETS_HASH_DEFAULT	(1U << 7)
diff --git a/drivers/staging/lustre/lnet/lnet/api-ni.c b/drivers/staging/lustre/lnet/lnet/api-ni.c
index 5719959..c562ff3 100644
--- a/drivers/staging/lustre/lnet/lnet/api-ni.c
+++ b/drivers/staging/lustre/lnet/lnet/api-ni.c
@@ -1436,7 +1436,7 @@ LNetCtl(unsigned int cmd, void *arg)
 
 	case IOC_LIBCFS_ADD_ROUTE:
 		rc = lnet_add_route(data->ioc_net, data->ioc_count,
-				    data->ioc_nid);
+				    data->ioc_nid, data->ioc_priority);
 		return (rc != 0) ? rc : lnet_check_routes();
 
 	case IOC_LIBCFS_DEL_ROUTE:
@@ -1445,7 +1445,8 @@ LNetCtl(unsigned int cmd, void *arg)
 	case IOC_LIBCFS_GET_ROUTE:
 		return lnet_get_route(data->ioc_count,
 				      &data->ioc_net, &data->ioc_count,
-				      &data->ioc_nid, &data->ioc_flags);
+				      &data->ioc_nid, &data->ioc_flags,
+				      &data->ioc_priority);
 	case IOC_LIBCFS_NOTIFY_ROUTER:
 		return lnet_notify(NULL, data->ioc_nid, data->ioc_flags,
 				   cfs_time_current() -
diff --git a/drivers/staging/lustre/lnet/lnet/config.c b/drivers/staging/lustre/lnet/lnet/config.c
index de323f7..6a07b0a 100644
--- a/drivers/staging/lustre/lnet/lnet/config.c
+++ b/drivers/staging/lustre/lnet/lnet/config.c
@@ -603,6 +603,37 @@ lnet_parse_hops(char *str, unsigned int *hops)
 		*hops > 0 && *hops < 256);
 }
 
+#define LNET_PRIORITY_SEPARATOR (':')
+
+int
+lnet_parse_priority(char *str, unsigned int *priority, char **token)
+{
+	int   nob;
+	char *sep;
+	int   len;
+
+	sep = strchr(str, LNET_PRIORITY_SEPARATOR);
+	if (sep == NULL) {
+		*priority = 0;
+		return 0;
+	}
+	len = strlen(sep + 1);
+
+	if ((sscanf((sep+1), "%u%n", priority, &nob) < 1) || (len != nob)) {
+		/* Update the caller's token pointer so it treats the found
+		   priority as the token to report in the error message. */
+		*token += sep - str + 1;
+		return -1;
+	}
+
+	CDEBUG(D_NET, "gateway %s, priority %d, nob %d\n", str, *priority, nob);
+
+	/*
+	 * Change priority separator to \0 to be able to parse NID
+	 */
+	*sep = '\0';
+	return 0;
+}
 
 int
 lnet_parse_route(char *str, int *im_a_router)
@@ -624,6 +655,7 @@ lnet_parse_route(char *str, int *im_a_router)
 	int	       myrc = -1;
 	unsigned int      hops;
 	int	       got_hops = 0;
+	unsigned int	  priority = 0;
 
 	INIT_LIST_HEAD(&gateways);
 	INIT_LIST_HEAD(&nets);
@@ -691,6 +723,11 @@ lnet_parse_route(char *str, int *im_a_router)
 				    LNET_NETTYP(net) == LOLND)
 					goto token_error;
 			} else {
+				rc = lnet_parse_priority(ltb->ltb_text,
+							 &priority, &token);
+				if (rc < 0)
+					goto token_error;
+
 				nid = libcfs_str2nid(ltb->ltb_text);
 				if (nid == LNET_NID_ANY ||
 				    LNET_NETTYP(LNET_NIDNET(nid)) == LOLND)
@@ -720,7 +757,7 @@ lnet_parse_route(char *str, int *im_a_router)
 				continue;
 			}
 
-			rc = lnet_add_route(net, hops, nid);
+			rc = lnet_add_route(net, hops, nid, priority);
 			if (rc != 0) {
 				CERROR("Can't create route to %s via %s\n",
 				       libcfs_net2str(net),
diff --git a/drivers/staging/lustre/lnet/lnet/lib-move.c b/drivers/staging/lustre/lnet/lnet/lib-move.c
index 2d61113..bbf43ae 100644
--- a/drivers/staging/lustre/lnet/lnet/lib-move.c
+++ b/drivers/staging/lustre/lnet/lnet/lib-move.c
@@ -1074,6 +1074,12 @@ lnet_compare_routes(lnet_route_t *r1, lnet_route_t *r2)
 	lnet_peer_t *p1 = r1->lr_gateway;
 	lnet_peer_t *p2 = r2->lr_gateway;
 
+	if (r1->lr_priority < r2->lr_priority)
+		return 1;
+
+	if (r1->lr_priority > r2->lr_priority)
+		return -1;
+
 	if (r1->lr_hops < r2->lr_hops)
 		return 1;
 
diff --git a/drivers/staging/lustre/lnet/lnet/router.c b/drivers/staging/lustre/lnet/lnet/router.c
index 80b5ed1..d1ee442 100644
--- a/drivers/staging/lustre/lnet/lnet/router.c
+++ b/drivers/staging/lustre/lnet/lnet/router.c
@@ -301,7 +301,8 @@ lnet_add_route_to_rnet (lnet_remotenet_t *rnet, lnet_route_t *route)
 }
 
 int
-lnet_add_route (__u32 net, unsigned int hops, lnet_nid_t gateway)
+lnet_add_route(__u32 net, unsigned int hops, lnet_nid_t gateway,
+	       unsigned int priority)
 {
 	struct list_head	  *e;
 	lnet_remotenet_t    *rnet;
@@ -311,8 +312,8 @@ lnet_add_route (__u32 net, unsigned int hops, lnet_nid_t gateway)
 	int		  add_route;
 	int		  rc;
 
-	CDEBUG(D_NET, "Add route: net %s hops %u gw %s\n",
-	       libcfs_net2str(net), hops, libcfs_nid2str(gateway));
+	CDEBUG(D_NET, "Add route: net %s hops %u priority %u gw %s\n",
+	       libcfs_net2str(net), hops, priority, libcfs_nid2str(gateway));
 
 	if (gateway == LNET_NID_ANY ||
 	    LNET_NETTYP(LNET_NIDNET(gateway)) == LOLND ||
@@ -342,6 +343,7 @@ lnet_add_route (__u32 net, unsigned int hops, lnet_nid_t gateway)
 	rnet->lrn_net = net;
 	route->lr_hops = hops;
 	route->lr_net = net;
+	route->lr_priority = priority;
 
 	lnet_net_lock(LNET_LOCK_EX);
 
@@ -552,7 +554,7 @@ lnet_destroy_routes (void)
 
 int
 lnet_get_route(int idx, __u32 *net, __u32 *hops,
-	       lnet_nid_t *gateway, __u32 *alive)
+	       lnet_nid_t *gateway, __u32 *alive, __u32 *priority)
 {
 	struct list_head		*e1;
 	struct list_head		*e2;
@@ -574,10 +576,11 @@ lnet_get_route(int idx, __u32 *net, __u32 *hops,
 						       lr_list);
 
 				if (idx-- == 0) {
-					*net     = rnet->lrn_net;
-					*hops    = route->lr_hops;
-					*gateway = route->lr_gateway->lp_nid;
-					*alive   = route->lr_gateway->lp_alive;
+					*net	  = rnet->lrn_net;
+					*hops	  = route->lr_hops;
+					*priority = route->lr_priority;
+					*gateway  = route->lr_gateway->lp_nid;
+					*alive	  = route->lr_gateway->lp_alive;
 					lnet_net_unlock(cpt);
 					return 0;
 				}
diff --git a/drivers/staging/lustre/lnet/lnet/router_proc.c b/drivers/staging/lustre/lnet/lnet/router_proc.c
index e4fe7a1..20d53e0 100644
--- a/drivers/staging/lustre/lnet/lnet/router_proc.c
+++ b/drivers/staging/lustre/lnet/lnet/router_proc.c
@@ -174,8 +174,8 @@ int LL_PROC_PROTO(proc_lnet_routes)
 			      the_lnet.ln_routing ? "enabled" : "disabled");
 		LASSERT(tmpstr + tmpsiz - s > 0);
 
-		s += snprintf(s, tmpstr + tmpsiz - s, "%-8s %4s %7s %s\n",
-			      "net", "hops", "state", "router");
+		s += snprintf(s, tmpstr + tmpsiz - s, "%-8s %4s %8s %7s %s\n",
+			      "net", "hops", "priority", "state", "router");
 		LASSERT(tmpstr + tmpsiz - s > 0);
 
 		lnet_net_lock(0);
@@ -229,14 +229,16 @@ int LL_PROC_PROTO(proc_lnet_routes)
 		}
 
 		if (route != NULL) {
-			__u32	net   = rnet->lrn_net;
-			unsigned int hops  = route->lr_hops;
-			lnet_nid_t   nid   = route->lr_gateway->lp_nid;
-			int	  alive = route->lr_gateway->lp_alive;
+			__u32        net	= rnet->lrn_net;
+			unsigned int hops	= route->lr_hops;
+			unsigned int priority	= route->lr_priority;
+			lnet_nid_t   nid	= route->lr_gateway->lp_nid;
+			int          alive	= route->lr_gateway->lp_alive;
 
 			s += snprintf(s, tmpstr + tmpsiz - s,
-				      "%-8s %4u %7s %s\n",
+				      "%-8s %4u %8u %7s %s\n",
 				      libcfs_net2str(net), hops,
+				      priority,
 				      alive ? "up" : "down",
 				      libcfs_nid2str(nid));
 			LASSERT(tmpstr + tmpsiz - s > 0);
-- 
1.7.9.5

