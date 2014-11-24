Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754592AbaKXS4H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 13:56:07 -0500
Received: from mail-wg0-f48.google.com ([74.125.82.48]:47179 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754252AbaKXSz6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 13:55:58 -0500
From: Zahari Doychev <zahari.doychev@linux.com>
To: linux-kernel@vger.kernel.org
Cc: devel@driverdev.osuosl.org, oleg.drokin@intel.com,
        andreas.dilger@intel.com, gregkh@linuxfoundation.org,
        bergwolf@gmail.com
Subject: [PATCH 2/2] [drivers] staging/lustre: fix sparse warnings
Date: Mon, 24 Nov 2014 19:55:42 +0100
Message-Id: <fc168bf46a904a7fd84f237d41ef29a5fd663e75.1416853961.git.zahari.doychev@linux.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <cover.1416853961.git.zahari.doychev@linux.com>
References: <cover.1416853961.git.zahari.doychev@linux.com>
In-Reply-To: <cover.1416853961.git.zahari.doychev@linux.com>
References: <cover.1416853961.git.zahari.doychev@linux.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following warnings:

socklnd_cb.c:134:39: warning: incorrect type in assignment (different address spaces)
socklnd_cb.c:134:39:    expected void [noderef] <asn:1>*iov_base
socklnd_cb.c:134:39:    got void *<noident>

Signed-off-by: Zahari Doychev <zahari.doychev@linux.com>
---
 drivers/staging/lustre/lnet/klnds/socklnd/socklnd_cb.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/lustre/lnet/klnds/socklnd/socklnd_cb.c b/drivers/staging/lustre/lnet/klnds/socklnd/socklnd_cb.c
index d29f5f1..971b877 100644
--- a/drivers/staging/lustre/lnet/klnds/socklnd/socklnd_cb.c
+++ b/drivers/staging/lustre/lnet/klnds/socklnd/socklnd_cb.c
@@ -131,7 +131,8 @@ ksocknal_send_iov (ksock_conn_t *conn, ksock_tx_t *tx)
 		LASSERT (tx->tx_niov > 0);
 
 		if (nob < (int) iov->iov_len) {
-			iov->iov_base = (void *)((char *)iov->iov_base + nob);
+			iov->iov_base =
+				(void __user *)((char *)iov->iov_base + nob);
 			iov->iov_len -= nob;
 			return rc;
 		}
@@ -1052,7 +1053,8 @@ ksocknal_new_packet (ksock_conn_t *conn, int nob_to_skip)
 		case  KSOCK_PROTO_V3:
 			conn->ksnc_rx_state = SOCKNAL_RX_KSM_HEADER;
 			conn->ksnc_rx_iov = (struct iovec *)&conn->ksnc_rx_iov_space;
-			conn->ksnc_rx_iov[0].iov_base = (char *)&conn->ksnc_msg;
+			conn->ksnc_rx_iov[0].iov_base =
+				(void __user *)&conn->ksnc_msg;
 
 			conn->ksnc_rx_nob_wanted = offsetof(ksock_msg_t, ksm_u);
 			conn->ksnc_rx_nob_left = offsetof(ksock_msg_t, ksm_u);
@@ -1066,7 +1068,8 @@ ksocknal_new_packet (ksock_conn_t *conn, int nob_to_skip)
 			conn->ksnc_rx_nob_left = sizeof(lnet_hdr_t);
 
 			conn->ksnc_rx_iov = (struct iovec *)&conn->ksnc_rx_iov_space;
-			conn->ksnc_rx_iov[0].iov_base = (char *)&conn->ksnc_msg.ksm_u.lnetmsg;
+			conn->ksnc_rx_iov[0].iov_base =
+				(void __user *)&conn->ksnc_msg.ksm_u.lnetmsg;
 			conn->ksnc_rx_iov[0].iov_len  = sizeof (lnet_hdr_t);
 			break;
 
@@ -1093,7 +1096,8 @@ ksocknal_new_packet (ksock_conn_t *conn, int nob_to_skip)
 	do {
 		nob = MIN (nob_to_skip, sizeof (ksocknal_slop_buffer));
 
-		conn->ksnc_rx_iov[niov].iov_base = ksocknal_slop_buffer;
+		conn->ksnc_rx_iov[niov].iov_base =
+			(void __user *)ksocknal_slop_buffer;
 		conn->ksnc_rx_iov[niov].iov_len  = nob;
 		niov++;
 		skipped += nob;
@@ -1218,7 +1222,8 @@ ksocknal_process_receive (ksock_conn_t *conn)
 		conn->ksnc_rx_nob_left = sizeof(ksock_lnet_msg_t);
 
 		conn->ksnc_rx_iov = (struct iovec *)&conn->ksnc_rx_iov_space;
-		conn->ksnc_rx_iov[0].iov_base = (char *)&conn->ksnc_msg.ksm_u.lnetmsg;
+		conn->ksnc_rx_iov[0].iov_base =
+				(void __user *)&conn->ksnc_msg.ksm_u.lnetmsg;
 		conn->ksnc_rx_iov[0].iov_len  = sizeof(ksock_lnet_msg_t);
 
 		conn->ksnc_rx_niov = 1;
-- 
2.1.0

