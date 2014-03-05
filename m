Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753631AbaCEN3I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 08:29:08 -0500
Received: from mail-pd0-f181.google.com ([209.85.192.181]:36990 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751564AbaCEN3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 08:29:06 -0500
From: Peng Tao <bergwolf@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>,
        Oleg Drokin <oleg.drokin@intel.com>
Subject: [PATCH 1/6] staging/lustre/lnet: remove kiblnd_debug_conn/rx/tx
Date: Wed,  5 Mar 2014 21:27:15 +0800
Message-Id: <1394026040-1968-1-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.7.6
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

They are not called by anyone and cause gcc warning:
drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c:609: warning: ‘kiblnd_debug_conn’
defined but not used
drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c:589: warning: ‘kiblnd_debug_rx’
defined but not used
drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c:597: warning: ‘kiblnd_debug_tx’
defined but not used

Cc: Andreas Dilger <andreas.dilger@intel.com>
Cc: Oleg Drokin <oleg.drokin@intel.com>
Signed-off-by: Peng Tao <bergwolf@gmail.com>
---
 .../staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c    |   68 --------------------
 1 files changed, 0 insertions(+), 68 deletions(-)

diff --git a/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c b/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c
index 0727998..d42c8f6 100644
--- a/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c
+++ b/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c
@@ -584,74 +584,6 @@ kiblnd_get_conn_by_idx(lnet_ni_t *ni, int index)
 	return NULL;
 }
 
-static void
-kiblnd_debug_rx(kib_rx_t *rx)
-{
-	CDEBUG(D_CONSOLE, "      %p status %d msg_type %x cred %d\n",
-	       rx, rx->rx_status, rx->rx_msg->ibm_type,
-	       rx->rx_msg->ibm_credits);
-}
-
-static void
-kiblnd_debug_tx(kib_tx_t *tx)
-{
-	CDEBUG(D_CONSOLE, "      %p snd %d q %d w %d rc %d dl %lx "
-	       "cookie "LPX64" msg %s%s type %x cred %d\n",
-	       tx, tx->tx_sending, tx->tx_queued, tx->tx_waiting,
-	       tx->tx_status, tx->tx_deadline, tx->tx_cookie,
-	       tx->tx_lntmsg[0] == NULL ? "-" : "!",
-	       tx->tx_lntmsg[1] == NULL ? "-" : "!",
-	       tx->tx_msg->ibm_type, tx->tx_msg->ibm_credits);
-}
-
-static void
-kiblnd_debug_conn(kib_conn_t *conn)
-{
-	struct list_head	*tmp;
-	int		i;
-
-	spin_lock(&conn->ibc_lock);
-
-	CDEBUG(D_CONSOLE, "conn[%d] %p [version %x] -> %s: \n",
-	       atomic_read(&conn->ibc_refcount), conn,
-	       conn->ibc_version, libcfs_nid2str(conn->ibc_peer->ibp_nid));
-	CDEBUG(D_CONSOLE, "   state %d nposted %d/%d cred %d o_cred %d r_cred %d\n",
-	       conn->ibc_state, conn->ibc_noops_posted,
-	       conn->ibc_nsends_posted, conn->ibc_credits,
-	       conn->ibc_outstanding_credits, conn->ibc_reserved_credits);
-	CDEBUG(D_CONSOLE, "   comms_err %d\n", conn->ibc_comms_error);
-
-	CDEBUG(D_CONSOLE, "   early_rxs:\n");
-	list_for_each(tmp, &conn->ibc_early_rxs)
-		kiblnd_debug_rx(list_entry(tmp, kib_rx_t, rx_list));
-
-	CDEBUG(D_CONSOLE, "   tx_noops:\n");
-	list_for_each(tmp, &conn->ibc_tx_noops)
-		kiblnd_debug_tx(list_entry(tmp, kib_tx_t, tx_list));
-
-	CDEBUG(D_CONSOLE, "   tx_queue_nocred:\n");
-	list_for_each(tmp, &conn->ibc_tx_queue_nocred)
-		kiblnd_debug_tx(list_entry(tmp, kib_tx_t, tx_list));
-
-	CDEBUG(D_CONSOLE, "   tx_queue_rsrvd:\n");
-	list_for_each(tmp, &conn->ibc_tx_queue_rsrvd)
-		kiblnd_debug_tx(list_entry(tmp, kib_tx_t, tx_list));
-
-	CDEBUG(D_CONSOLE, "   tx_queue:\n");
-	list_for_each(tmp, &conn->ibc_tx_queue)
-		kiblnd_debug_tx(list_entry(tmp, kib_tx_t, tx_list));
-
-	CDEBUG(D_CONSOLE, "   active_txs:\n");
-	list_for_each(tmp, &conn->ibc_active_txs)
-		kiblnd_debug_tx(list_entry(tmp, kib_tx_t, tx_list));
-
-	CDEBUG(D_CONSOLE, "   rxs:\n");
-	for (i = 0; i < IBLND_RX_MSGS(conn->ibc_version); i++)
-		kiblnd_debug_rx(&conn->ibc_rxs[i]);
-
-	spin_unlock(&conn->ibc_lock);
-}
-
 int
 kiblnd_translate_mtu(int value)
 {
-- 
1.7.7.6

