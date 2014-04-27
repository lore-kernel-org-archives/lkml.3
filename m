Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752697AbaD0RQx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 13:16:53 -0400
Received: from linuxhacker.ru ([217.76.32.60]:48071 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754287AbaD0RIS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 13:08:18 -0400
From: Oleg Drokin <green@linuxhacker.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Cc: Dmitry Eremin <dmitry.eremin@intel.com>,
        Oleg Drokin <oleg.drokin@intel.com>
Subject: [PATCH 29/47] staging/lustre/lnet: lnet: fix issues found by Klocwork Insight tool
Date: Sun, 27 Apr 2014 13:06:53 -0400
Message-Id: <1398618431-29757-30-git-send-email-green@linuxhacker.ru>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1398618431-29757-1-git-send-email-green@linuxhacker.ru>
References: <1398618431-29757-1-git-send-email-green@linuxhacker.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dmitry Eremin <dmitry.eremin@intel.com>

Null pointer 'cp' that comes from line 2544 may be dereferenced
at line 2618.

Pointer 'ni' checked for NULL at line 1569 may be passed to
function and may be dereferenced there by passing argument 1 to
function 'lnet_ni_notify_locked' at line 1621.

Null pointer 'best_iface' that comes from line 802 may be
dereferenced at line 832.

Buffer overflow of string buffer due to non null terminated string.

Pointer 'tsc' returned from call to function 'sfw_find_test_case'
at line 571 may be NULL and will be dereferenced at line 572.

Local variable 'hash' is never used.

Signed-off-by: Dmitry Eremin <dmitry.eremin@intel.com>
Reviewed-on: http://review.whamcloud.com/9386
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-4629
Reviewed-by: John L. Hammond <john.hammond@intel.com>
Reviewed-by: Isaac Huang <he.huang@intel.com>
Signed-off-by: Oleg Drokin <oleg.drokin@intel.com>
---
 drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c |  8 ++++++--
 drivers/staging/lustre/lnet/klnds/socklnd/socklnd.c    |  4 ++--
 drivers/staging/lustre/lnet/lnet/api-ni.c              |  6 +++---
 drivers/staging/lustre/lnet/lnet/router.c              |  3 ++-
 drivers/staging/lustre/lnet/selftest/conctl.c          | 11 +++++++----
 drivers/staging/lustre/lnet/selftest/framework.c       | 14 +++++++++++---
 6 files changed, 31 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c b/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c
index 6173e74..9bf6c94 100644
--- a/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c
+++ b/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c
@@ -2609,13 +2609,17 @@ kiblnd_rejected (kib_conn_t *conn, int reason, void *priv, int priv_nob)
 
 			case IBLND_REJECT_MSG_QUEUE_SIZE:
 				CERROR("%s rejected: incompatible message queue depth %d, %d\n",
-				       libcfs_nid2str(peer->ibp_nid), cp->ibcp_queue_depth,
+				       libcfs_nid2str(peer->ibp_nid),
+				       cp != NULL ? cp->ibcp_queue_depth :
+				       IBLND_MSG_QUEUE_SIZE(rej->ibr_version),
 				       IBLND_MSG_QUEUE_SIZE(conn->ibc_version));
 				break;
 
 			case IBLND_REJECT_RDMA_FRAGS:
 				CERROR("%s rejected: incompatible # of RDMA fragments %d, %d\n",
-				       libcfs_nid2str(peer->ibp_nid), cp->ibcp_max_frags,
+				       libcfs_nid2str(peer->ibp_nid),
+				       cp != NULL ? cp->ibcp_max_frags :
+				       IBLND_RDMA_FRAGS(rej->ibr_version),
 				       IBLND_RDMA_FRAGS(conn->ibc_version));
 				break;
 
diff --git a/drivers/staging/lustre/lnet/klnds/socklnd/socklnd.c b/drivers/staging/lustre/lnet/klnds/socklnd/socklnd.c
index 21d36ee..516f623 100644
--- a/drivers/staging/lustre/lnet/klnds/socklnd/socklnd.c
+++ b/drivers/staging/lustre/lnet/klnds/socklnd/socklnd.c
@@ -829,14 +829,14 @@ ksocknal_select_ips(ksock_peer_t *peer, __u32 *peerips, int n_peerips)
 				best_npeers = iface->ksni_npeers;
 			}
 
+			LASSERT(best_iface != NULL);
+
 			best_iface->ksni_npeers++;
 			ip = best_iface->ksni_ipaddr;
 			peer->ksnp_passive_ips[i] = ip;
 			peer->ksnp_n_passive_ips = i+1;
 		}
 
-		LASSERT (best_iface != NULL);
-
 		/* mark the best matching peer IP used */
 		j = ksocknal_match_peerip(best_iface, peerips, n_peerips);
 		peerips[j] = 0;
diff --git a/drivers/staging/lustre/lnet/lnet/api-ni.c b/drivers/staging/lustre/lnet/lnet/api-ni.c
index 3f3c341..f5a9ae3 100644
--- a/drivers/staging/lustre/lnet/lnet/api-ni.c
+++ b/drivers/staging/lustre/lnet/lnet/api-ni.c
@@ -127,8 +127,7 @@ lnet_create_remote_nets_table(void)
 static void
 lnet_destroy_remote_nets_table(void)
 {
-	int		i;
-	struct list_head	*hash;
+	int i;
 
 	if (the_lnet.ln_remote_nets_hash == NULL)
 		return;
@@ -137,7 +136,8 @@ lnet_destroy_remote_nets_table(void)
 		LASSERT(list_empty(&the_lnet.ln_remote_nets_hash[i]));
 
 	LIBCFS_FREE(the_lnet.ln_remote_nets_hash,
-		    LNET_REMOTE_NETS_HASH_SIZE * sizeof(*hash));
+		    LNET_REMOTE_NETS_HASH_SIZE *
+		    sizeof(the_lnet.ln_remote_nets_hash[0]));
 	the_lnet.ln_remote_nets_hash = NULL;
 }
 
diff --git a/drivers/staging/lustre/lnet/lnet/router.c b/drivers/staging/lustre/lnet/lnet/router.c
index 995f509..ba0278e 100644
--- a/drivers/staging/lustre/lnet/lnet/router.c
+++ b/drivers/staging/lustre/lnet/lnet/router.c
@@ -1559,7 +1559,8 @@ lnet_notify(lnet_ni_t *ni, lnet_nid_t nid, int alive, cfs_time_t when)
 
 	lnet_notify_locked(lp, ni == NULL, alive, when);
 
-	lnet_ni_notify_locked(ni, lp);
+	if (ni != NULL)
+		lnet_ni_notify_locked(ni, lp);
 
 	lnet_peer_decref_locked(lp);
 
diff --git a/drivers/staging/lustre/lnet/selftest/conctl.c b/drivers/staging/lustre/lnet/selftest/conctl.c
index 68e1a17..c5b5068 100644
--- a/drivers/staging/lustre/lnet/selftest/conctl.c
+++ b/drivers/staging/lustre/lnet/selftest/conctl.c
@@ -764,13 +764,18 @@ int lst_test_add_ioctl(lstio_test_args_t *args)
 		goto out;
 
 	LIBCFS_ALLOC(dst_name, args->lstio_tes_dgrp_nmlen + 1);
-	 if (dst_name == NULL)
+	if (dst_name == NULL)
 		goto out;
 
 	if (args->lstio_tes_param != NULL) {
 		LIBCFS_ALLOC(param, args->lstio_tes_param_len);
 		if (param == NULL)
 			goto out;
+		if (copy_from_user(param, args->lstio_tes_param,
+				   args->lstio_tes_param_len)) {
+			rc = -EFAULT;
+			goto out;
+		}
 	}
 
 	rc = -EFAULT;
@@ -779,9 +784,7 @@ int lst_test_add_ioctl(lstio_test_args_t *args)
 	    copy_from_user(src_name, args->lstio_tes_sgrp_name,
 			   args->lstio_tes_sgrp_nmlen) ||
 	    copy_from_user(dst_name, args->lstio_tes_dgrp_name,
-			   args->lstio_tes_dgrp_nmlen) ||
-	    copy_from_user(param, args->lstio_tes_param,
-			      args->lstio_tes_param_len))
+			   args->lstio_tes_dgrp_nmlen))
 		goto out;
 
 	rc = lstcon_test_add(batch_name,
diff --git a/drivers/staging/lustre/lnet/selftest/framework.c b/drivers/staging/lustre/lnet/selftest/framework.c
index 050723a..c141f93 100644
--- a/drivers/staging/lustre/lnet/selftest/framework.c
+++ b/drivers/staging/lustre/lnet/selftest/framework.c
@@ -547,10 +547,16 @@ sfw_test_rpc_fini (srpc_client_rpc_t *rpc)
 static inline int
 sfw_test_buffers(sfw_test_instance_t *tsi)
 {
-	struct sfw_test_case	*tsc = sfw_find_test_case(tsi->tsi_service);
-	struct srpc_service	*svc = tsc->tsc_srv_service;
+	struct sfw_test_case	*tsc;
+	struct srpc_service	*svc;
 	int			nbuf;
 
+	LASSERT(tsi != NULL);
+	tsc = sfw_find_test_case(tsi->tsi_service);
+	LASSERT(tsc != NULL);
+	svc = tsc->tsc_srv_service;
+	LASSERT(svc != NULL);
+
 	nbuf = min(svc->sv_wi_total, tsi->tsi_loop) / svc->sv_ncpts;
 	return max(SFW_TEST_WI_MIN, nbuf + SFW_TEST_WI_EXTRA);
 }
@@ -595,8 +601,10 @@ sfw_load_test(struct sfw_test_instance *tsi)
 void
 sfw_unload_test(struct sfw_test_instance *tsi)
 {
-	struct sfw_test_case *tsc = sfw_find_test_case(tsi->tsi_service);
+	struct sfw_test_case *tsc;
 
+	LASSERT(tsi != NULL);
+	tsc = sfw_find_test_case(tsi->tsi_service);
 	LASSERT(tsc != NULL);
 
 	if (tsi->tsi_is_client)
-- 
1.8.5.3

