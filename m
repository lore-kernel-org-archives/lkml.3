Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752131AbaLZAGH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2014 19:06:07 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:51726 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751730AbaLZAGB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2014 19:06:01 -0500
From: Jeremiah Mahler <jmmahler@gmail.com>
To: Oleg Drokin <oleg.drokin@intel.com>
Cc: Andreas Dilger <andreas.dilger@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peng Tao <bergwolf@gmail.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Julia Lawall <Julia.Lawall@lip6.fr>,
        Kirill Tkhai <ktkhai@parallels.com>, Joe Perches <joe@perches.com>,
        Zi Shen Lim <zlim.lnx@gmail.com>,
        Dmitry Eremin <dmitry.eremin@intel.com>,
        Masaru Nomura <massa.nomura@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        James A Shackleford <shack@linux.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Jeremiah Mahler <jmmahler@gmail.com>
Subject: [PATCH 1/6] staging: lustre: use min/max instead of MIN/MAX, simple cases
Date: Thu, 25 Dec 2014 16:04:41 -0800
Message-Id: <1419552286-8492-2-git-send-email-jmmahler@gmail.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1419552286-8492-1-git-send-email-jmmahler@gmail.com>
References: <1419552286-8492-1-git-send-email-jmmahler@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Custom MIN/MAX operations are being used which are not as robust
as the built in min/max operations which will warn about potentially
problematic type comparisons.

For the simple cases, where no type warning is produced, simply
replace MIN/MAX with min/max.

Signed-off-by: Jeremiah Mahler <jmmahler@gmail.com>
---
 drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c       |  2 +-
 drivers/staging/lustre/lnet/klnds/socklnd/socklnd.c          |  2 +-
 drivers/staging/lustre/lnet/klnds/socklnd/socklnd_cb.c       |  4 ++--
 drivers/staging/lustre/lnet/lnet/lib-move.c                  | 12 ++++++------
 drivers/staging/lustre/lnet/lnet/router.c                    |  4 ++--
 drivers/staging/lustre/lnet/selftest/conrpc.h                |  2 +-
 drivers/staging/lustre/lnet/selftest/rpc.c                   |  4 ++--
 drivers/staging/lustre/lustre/libcfs/linux/linux-tracefile.c |  2 +-
 8 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c b/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c
index b48d7ed..74df2af 100644
--- a/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c
+++ b/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c
@@ -1125,7 +1125,7 @@ kiblnd_init_rdma (kib_conn_t *conn, kib_tx_t *tx, int type,
 			break;
 		}
 
-		wrknob = MIN(MIN(kiblnd_rd_frag_size(srcrd, srcidx),
+		wrknob = min(min(kiblnd_rd_frag_size(srcrd, srcidx),
 				 kiblnd_rd_frag_size(dstrd, dstidx)), resid);
 
 		sge = &tx->tx_sge[tx->tx_nwrq];
diff --git a/drivers/staging/lustre/lnet/klnds/socklnd/socklnd.c b/drivers/staging/lustre/lnet/klnds/socklnd/socklnd.c
index 9188b34..5956dba 100644
--- a/drivers/staging/lustre/lnet/klnds/socklnd/socklnd.c
+++ b/drivers/staging/lustre/lnet/klnds/socklnd/socklnd.c
@@ -773,7 +773,7 @@ ksocknal_select_ips(ksock_peer_t *peer, __u32 *peerips, int n_peerips)
 	/* Only match interfaces for additional connections
 	 * if I have > 1 interface */
 	n_ips = (net->ksnn_ninterfaces < 2) ? 0 :
-		MIN(n_peerips, net->ksnn_ninterfaces);
+		min(n_peerips, net->ksnn_ninterfaces);
 
 	for (i = 0; peer->ksnp_n_passive_ips < n_ips; i++) {
 		/*	      ^ yes really... */
diff --git a/drivers/staging/lustre/lnet/klnds/socklnd/socklnd_cb.c b/drivers/staging/lustre/lnet/klnds/socklnd/socklnd_cb.c
index e6c1d36..95f1e17 100644
--- a/drivers/staging/lustre/lnet/klnds/socklnd/socklnd_cb.c
+++ b/drivers/staging/lustre/lnet/klnds/socklnd/socklnd_cb.c
@@ -1950,10 +1950,10 @@ ksocknal_connect (ksock_route_t *route)
 	/* This is a retry rather than a new connection */
 	route->ksnr_retry_interval *= 2;
 	route->ksnr_retry_interval =
-		MAX(route->ksnr_retry_interval,
+		max(route->ksnr_retry_interval,
 		    cfs_time_seconds(*ksocknal_tunables.ksnd_min_reconnectms)/1000);
 	route->ksnr_retry_interval =
-		MIN(route->ksnr_retry_interval,
+		min(route->ksnr_retry_interval,
 		    cfs_time_seconds(*ksocknal_tunables.ksnd_max_reconnectms)/1000);
 
 	LASSERT (route->ksnr_retry_interval != 0);
diff --git a/drivers/staging/lustre/lnet/lnet/lib-move.c b/drivers/staging/lustre/lnet/lnet/lib-move.c
index c8c1ed8..706c5ee 100644
--- a/drivers/staging/lustre/lnet/lnet/lib-move.c
+++ b/drivers/staging/lustre/lnet/lnet/lib-move.c
@@ -201,9 +201,9 @@ lnet_copy_iov2iov(unsigned int ndiov, struct iovec *diov, unsigned int doffset,
 	do {
 		LASSERT(ndiov > 0);
 		LASSERT(nsiov > 0);
-		this_nob = MIN(diov->iov_len - doffset,
+		this_nob = min(diov->iov_len - doffset,
 			       siov->iov_len - soffset);
-		this_nob = MIN(this_nob, nob);
+		this_nob = min(this_nob, nob);
 
 		memcpy((char *)diov->iov_base + doffset,
 			(char *)siov->iov_base + soffset, this_nob);
@@ -322,9 +322,9 @@ lnet_copy_kiov2kiov(unsigned int ndiov, lnet_kiov_t *diov, unsigned int doffset,
 	do {
 		LASSERT(ndiov > 0);
 		LASSERT(nsiov > 0);
-		this_nob = MIN(diov->kiov_len - doffset,
+		this_nob = min(diov->kiov_len - doffset,
 			       siov->kiov_len - soffset);
-		this_nob = MIN(this_nob, nob);
+		this_nob = min(this_nob, nob);
 
 		if (daddr == NULL)
 			daddr = ((char *)kmap(diov->kiov_page)) +
@@ -405,7 +405,7 @@ lnet_copy_kiov2iov(unsigned int niov, struct iovec *iov, unsigned int iovoffset,
 		LASSERT(nkiov > 0);
 		this_nob = MIN(iov->iov_len - iovoffset,
 			       kiov->kiov_len - kiovoffset);
-		this_nob = MIN(this_nob, nob);
+		this_nob = min(this_nob, nob);
 
 		if (addr == NULL)
 			addr = ((char *)kmap(kiov->kiov_page)) +
@@ -476,7 +476,7 @@ lnet_copy_iov2kiov(unsigned int nkiov, lnet_kiov_t *kiov,
 		LASSERT(niov > 0);
 		this_nob = MIN(kiov->kiov_len - kiovoffset,
 			       iov->iov_len - iovoffset);
-		this_nob = MIN(this_nob, nob);
+		this_nob = min(this_nob, nob);
 
 		if (addr == NULL)
 			addr = ((char *)kmap(kiov->kiov_page)) +
diff --git a/drivers/staging/lustre/lnet/lnet/router.c b/drivers/staging/lustre/lnet/lnet/router.c
index c667b5b..b43e110 100644
--- a/drivers/staging/lustre/lnet/lnet/router.c
+++ b/drivers/staging/lustre/lnet/lnet/router.c
@@ -793,7 +793,7 @@ lnet_update_ni_status_locked(void)
 	LASSERT(the_lnet.ln_routing);
 
 	timeout = router_ping_timeout +
-		  MAX(live_router_check_interval, dead_router_check_interval);
+		  max(live_router_check_interval, dead_router_check_interval);
 
 	now = get_seconds();
 	list_for_each_entry(ni, &the_lnet.ln_nis, ni_list) {
@@ -1593,7 +1593,7 @@ lnet_router_checker (void)
 		return;
 
 	if (last != 0 &&
-	    interval > MAX(live_router_check_interval,
+	    interval > max(live_router_check_interval,
 			   dead_router_check_interval))
 		CNETERR("Checker(%d/%d) not called for %d seconds\n",
 			live_router_check_interval, dead_router_check_interval,
diff --git a/drivers/staging/lustre/lnet/selftest/conrpc.h b/drivers/staging/lustre/lnet/selftest/conrpc.h
index fc1cb56..2353889 100644
--- a/drivers/staging/lustre/lnet/selftest/conrpc.h
+++ b/drivers/staging/lustre/lnet/selftest/conrpc.h
@@ -54,7 +54,7 @@
 #define LST_TRANS_TIMEOUT       30
 #define LST_TRANS_MIN_TIMEOUT   3
 
-#define LST_VALIDATE_TIMEOUT(t) MIN(MAX(t, LST_TRANS_MIN_TIMEOUT), LST_TRANS_TIMEOUT)
+#define LST_VALIDATE_TIMEOUT(t) min(max(t, LST_TRANS_MIN_TIMEOUT), LST_TRANS_TIMEOUT)
 
 #define LST_PING_INTERVAL       8
 
diff --git a/drivers/staging/lustre/lnet/selftest/rpc.c b/drivers/staging/lustre/lnet/selftest/rpc.c
index f753add..b602077 100644
--- a/drivers/staging/lustre/lnet/selftest/rpc.c
+++ b/drivers/staging/lustre/lnet/selftest/rpc.c
@@ -559,7 +559,7 @@ srpc_add_buffer(struct swi_workitem *wi)
 		LASSERT(scd->scd_buf_posting > 0);
 		scd->scd_buf_posting--;
 		scd->scd_buf_total++;
-		scd->scd_buf_low = MAX(2, scd->scd_buf_total / 4);
+		scd->scd_buf_low = max(2, scd->scd_buf_total / 4);
 	}
 
 	if (rc != 0) {
@@ -1486,7 +1486,7 @@ srpc_lnet_ev_handler(lnet_event_t *ev)
 		if (scd->scd_buf_err == 0 && /* adding buffer is enabled */
 		    scd->scd_buf_adjust == 0 &&
 		    scd->scd_buf_nposted < scd->scd_buf_low) {
-			scd->scd_buf_adjust = MAX(scd->scd_buf_total / 2,
+			scd->scd_buf_adjust = max(scd->scd_buf_total / 2,
 						  SFW_TEST_WI_MIN);
 			swi_schedule_workitem(&scd->scd_buf_wi);
 		}
diff --git a/drivers/staging/lustre/lustre/libcfs/linux/linux-tracefile.c b/drivers/staging/lustre/lustre/libcfs/linux/linux-tracefile.c
index 976c61e..fdc7189 100644
--- a/drivers/staging/lustre/lustre/libcfs/linux/linux-tracefile.c
+++ b/drivers/staging/lustre/lustre/libcfs/linux/linux-tracefile.c
@@ -269,5 +269,5 @@ int cfs_trace_max_debug_mb(void)
 {
 	int  total_mb = (totalram_pages >> (20 - PAGE_SHIFT));
 
-	return MAX(512, (total_mb * 80)/100);
+	return max(512, (total_mb * 80)/100);
 }
-- 
2.1.4

