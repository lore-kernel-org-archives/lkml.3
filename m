Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754580AbaFNHbD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2014 03:31:03 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:40936 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751882AbaFNHa7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2014 03:30:59 -0400
Date: Sat, 14 Jun 2014 17:29:51 +1000
From: Vitaly Osipov <vitaly.osipov@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peng Tao <bergwolf@gmail.com>, Joe Perches <joe@perches.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: lustre: remove memset(0) after LIBCFS_ALLOC
Message-ID: <20140614072951.GA87525@witts-MacBook-Pro.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches mentioned on driverdev-devel that memset after LIBCFS_ALLOC
is not necessary as it is already done during LIBCFS_ALLOC_POST. This
commit removes these unnecessary memsets. Based on the results of running 
a cocci patch along the lines of:

@@
expression E1, E2;
@@

LIBCFS_ALLOC (E1,E2);
...
- memset(E1,0,E2);

Signed-off-by: Vitaly Osipov <vitaly.osipov@gmail.com>
---
 drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c      |  5 -----
 drivers/staging/lustre/lnet/klnds/socklnd/socklnd.c      |  4 ----
 drivers/staging/lustre/lnet/lnet/router.c                |  1 -
 drivers/staging/lustre/lnet/selftest/console.c           | 10 ----------
 drivers/staging/lustre/lnet/selftest/framework.c         |  2 --
 drivers/staging/lustre/lustre/libcfs/linux/linux-tcpip.c |  2 --
 6 files changed, 24 deletions(-)

diff --git a/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c b/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c
index 892c419..1a4c9e6 100644
--- a/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c
+++ b/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c
@@ -2430,8 +2430,6 @@ kiblnd_hdev_setup_mrs(kib_hca_dev_t *hdev)
 		return -ENOMEM;
 	}
 
-	memset(hdev->ibh_mrs, 0, sizeof(*hdev->ibh_mrs) * hdev->ibh_nmrs);
-
 	for (i = 0; i < hdev->ibh_nmrs; i++) {
 		struct ib_phys_buf ipb;
 		__u64	      iova;
@@ -2704,7 +2702,6 @@ kiblnd_create_dev(char *ifname)
 	if (dev == NULL)
 		return NULL;
 
-	memset(dev, 0, sizeof(*dev));
 	netdev = dev_get_by_name(&init_net, ifname);
 	if (netdev == NULL) {
 		dev->ibd_can_failover = 0;
@@ -3088,8 +3085,6 @@ kiblnd_startup (lnet_ni_t *ni)
 	if (net == NULL)
 		goto failed;
 
-	memset(net, 0, sizeof(*net));
-
 	do_gettimeofday(&tv);
 	net->ibn_incarnation = (((__u64)tv.tv_sec) * 1000000) + tv.tv_usec;
 
diff --git a/drivers/staging/lustre/lnet/klnds/socklnd/socklnd.c b/drivers/staging/lustre/lnet/klnds/socklnd/socklnd.c
index 775dcd2..f528b65 100644
--- a/drivers/staging/lustre/lnet/klnds/socklnd/socklnd.c
+++ b/drivers/staging/lustre/lnet/klnds/socklnd/socklnd.c
@@ -113,8 +113,6 @@ ksocknal_create_peer (ksock_peer_t **peerp, lnet_ni_t *ni, lnet_process_id_t id)
 	if (peer == NULL)
 		return -ENOMEM;
 
-	memset (peer, 0, sizeof (*peer));       /* NULL pointers/clear flags etc */
-
 	peer->ksnp_ni = ni;
 	peer->ksnp_id = id;
 	atomic_set (&peer->ksnp_refcount, 1);   /* 1 ref for caller */
@@ -1040,8 +1038,6 @@ ksocknal_create_conn (lnet_ni_t *ni, ksock_route_t *route,
 		goto failed_0;
 	}
 
-	memset (conn, 0, sizeof (*conn));
-
 	conn->ksnc_peer = NULL;
 	conn->ksnc_route = NULL;
 	conn->ksnc_sock = sock;
diff --git a/drivers/staging/lustre/lnet/lnet/router.c b/drivers/staging/lustre/lnet/lnet/router.c
index 926923a..1359b11 100644
--- a/drivers/staging/lustre/lnet/lnet/router.c
+++ b/drivers/staging/lustre/lnet/lnet/router.c
@@ -866,7 +866,6 @@ lnet_create_rc_data_locked(lnet_peer_t *gateway)
 	if (pi == NULL)
 		goto out;
 
-	memset(pi, 0, LNET_PINGINFO_SIZE);
 	for (i = 0; i < LNET_MAX_RTR_NIS; i++) {
 		pi->pi_ni[i].ns_nid = LNET_NID_ANY;
 		pi->pi_ni[i].ns_status = LNET_NI_STATUS_INVALID;
diff --git a/drivers/staging/lustre/lnet/selftest/console.c b/drivers/staging/lustre/lnet/selftest/console.c
index 352fc96..2aeebbf 100644
--- a/drivers/staging/lustre/lnet/selftest/console.c
+++ b/drivers/staging/lustre/lnet/selftest/console.c
@@ -204,9 +204,6 @@ lstcon_group_alloc(char *name, lstcon_group_t **grpp)
 	if (grp == NULL)
 		return -ENOMEM;
 
-	memset(grp, 0, offsetof(lstcon_group_t,
-				grp_ndl_hash[LST_NODE_HASHSIZE]));
-
 	grp->grp_ref = 1;
 	if (name != NULL)
 		strcpy(grp->grp_name, name);
@@ -815,8 +812,6 @@ lstcon_group_info(char *name, lstcon_ndlist_ent_t *gents_p,
 		return -ENOMEM;
 	}
 
-	memset(gentp, 0, sizeof(lstcon_ndlist_ent_t));
-
 	list_for_each_entry(ndl, &grp->grp_ndl_list, ndl_link)
 		LST_NODE_STATE_COUNTER(ndl->ndl_node, gentp);
 
@@ -971,8 +966,6 @@ lstcon_batch_info(char *name, lstcon_test_batch_ent_t *ent_up, int server,
 	if (entp == NULL)
 		return -ENOMEM;
 
-	memset(entp, 0, sizeof(lstcon_test_batch_ent_t));
-
 	if (test == NULL) {
 		entp->u.tbe_batch.bae_ntest = bat->bat_ntest;
 		entp->u.tbe_batch.bae_state = bat->bat_state;
@@ -1319,7 +1312,6 @@ lstcon_test_add(char *batch_name, int type, int loop,
 		goto out;
 	}
 
-	memset(test, 0, offsetof(lstcon_test_t, tes_param[paramlen]));
 	test->tes_hdr.tsb_id	= batch->bat_hdr.tsb_id;
 	test->tes_batch		= batch;
 	test->tes_type		= type;
@@ -1789,8 +1781,6 @@ lstcon_session_info(lst_sid_t *sid_up, int *key_up, unsigned *featp,
 	if (entp == NULL)
 		return -ENOMEM;
 
-	memset(entp, 0, sizeof(*entp));
-
 	list_for_each_entry(ndl, &console_session.ses_ndl_list, ndl_link)
 		LST_NODE_STATE_COUNTER(ndl->ndl_node, entp);
 
diff --git a/drivers/staging/lustre/lnet/selftest/framework.c b/drivers/staging/lustre/lnet/selftest/framework.c
index 050723a..b2b63e9 100644
--- a/drivers/staging/lustre/lnet/selftest/framework.c
+++ b/drivers/staging/lustre/lnet/selftest/framework.c
@@ -149,7 +149,6 @@ sfw_register_test (srpc_service_t *service, sfw_test_client_ops_t *cliops)
 	if (tsc == NULL)
 		return -ENOMEM;
 
-	memset(tsc, 0, sizeof(sfw_test_case_t));
 	tsc->tsc_cli_ops     = cliops;
 	tsc->tsc_srv_service = service;
 
@@ -747,7 +746,6 @@ sfw_add_test_instance (sfw_batch_t *tsb, srpc_server_rpc_t *rpc)
 		return -ENOMEM;
 	}
 
-	memset(tsi, 0, sizeof(*tsi));
 	spin_lock_init(&tsi->tsi_lock);
 	atomic_set(&tsi->tsi_nactive, 0);
 	INIT_LIST_HEAD(&tsi->tsi_units);
diff --git a/drivers/staging/lustre/lustre/libcfs/linux/linux-tcpip.c b/drivers/staging/lustre/lustre/libcfs/linux/linux-tcpip.c
index ac3a444..a21b426 100644
--- a/drivers/staging/lustre/lustre/libcfs/linux/linux-tcpip.c
+++ b/drivers/staging/lustre/lustre/libcfs/linux/linux-tcpip.c
@@ -183,8 +183,6 @@ libcfs_ipif_enumerate (char ***namesp)
 		rc = -ENOMEM;
 		goto out1;
 	}
-	/* NULL out all names[i] */
-	memset (names, 0, nfound * sizeof(*names));
 
 	for (i = 0; i < nfound; i++) {
 
-- 
1.9.1

