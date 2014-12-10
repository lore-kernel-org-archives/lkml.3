Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754244AbaLJGzm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 01:55:42 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:49270 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753323AbaLJGzk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 01:55:40 -0500
From: Shalin Mehta <shalinmehta85@gmail.com>
X-Google-Original-From: Shalin Mehta < shalinmehta85@gmail.com>
To: andreas.dilger@intel.com
Cc: gregkh@linuxfoundation.org, bergwolf@gmail.com, gdonald@gmail.com,
        peterz@infradead.org, tranmanphong@gmail.com, massa.nomura@gmail.com,
        HPDD-discuss@ml01.01.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, majordomo@vger.kernel.org,
        Shalin Mehta <shalinmehta85@gmail.com>
Subject: [PATCH] staging: lustre: Fix the warning messages about casting without __user macro
Date: Tue,  9 Dec 2014 22:56:12 -0800
Message-Id: <1418194573-1271-1-git-send-email-shalinmehta85@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shalin Mehta <shalinmehta85@gmail.com>

This issue is showed up while compiling with sparse. The iov_base in struct iovec struct explicitly declares that the assigned value should be user space pointer with __user macro. Where as here, the __user macro isn't used while casting.

Signed-off-by: Shalin Mehta <shalinmehta85@gmail.com>
---
 drivers/staging/lustre/lnet/klnds/socklnd/socklnd_cb.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/lustre/lnet/klnds/socklnd/socklnd_cb.c b/drivers/staging/lustre/lnet/klnds/socklnd/socklnd_cb.c
index d29f5f1..c40b7e0 100644
--- a/drivers/staging/lustre/lnet/klnds/socklnd/socklnd_cb.c
+++ b/drivers/staging/lustre/lnet/klnds/socklnd/socklnd_cb.c
@@ -131,7 +131,7 @@ ksocknal_send_iov (ksock_conn_t *conn, ksock_tx_t *tx)
 		LASSERT (tx->tx_niov > 0);
 
 		if (nob < (int) iov->iov_len) {
-			iov->iov_base = (void *)((char *)iov->iov_base + nob);
+			iov->iov_base = (void __user *)((char __user *)iov->iov_base + nob);
 			iov->iov_len -= nob;
 			return rc;
 		}
@@ -1052,7 +1052,7 @@ ksocknal_new_packet (ksock_conn_t *conn, int nob_to_skip)
 		case  KSOCK_PROTO_V3:
 			conn->ksnc_rx_state = SOCKNAL_RX_KSM_HEADER;
 			conn->ksnc_rx_iov = (struct iovec *)&conn->ksnc_rx_iov_space;
-			conn->ksnc_rx_iov[0].iov_base = (char *)&conn->ksnc_msg;
+			conn->ksnc_rx_iov[0].iov_base = (char __user *)&conn->ksnc_msg;
 
 			conn->ksnc_rx_nob_wanted = offsetof(ksock_msg_t, ksm_u);
 			conn->ksnc_rx_nob_left = offsetof(ksock_msg_t, ksm_u);
@@ -1066,7 +1066,7 @@ ksocknal_new_packet (ksock_conn_t *conn, int nob_to_skip)
 			conn->ksnc_rx_nob_left = sizeof(lnet_hdr_t);
 
 			conn->ksnc_rx_iov = (struct iovec *)&conn->ksnc_rx_iov_space;
-			conn->ksnc_rx_iov[0].iov_base = (char *)&conn->ksnc_msg.ksm_u.lnetmsg;
+			conn->ksnc_rx_iov[0].iov_base = (char __user *)&conn->ksnc_msg.ksm_u.lnetmsg;
 			conn->ksnc_rx_iov[0].iov_len  = sizeof (lnet_hdr_t);
 			break;
 
@@ -1093,7 +1093,7 @@ ksocknal_new_packet (ksock_conn_t *conn, int nob_to_skip)
 	do {
 		nob = MIN (nob_to_skip, sizeof (ksocknal_slop_buffer));
 
-		conn->ksnc_rx_iov[niov].iov_base = ksocknal_slop_buffer;
+		conn->ksnc_rx_iov[niov].iov_base = (void __user *)ksocknal_slop_buffer;
 		conn->ksnc_rx_iov[niov].iov_len  = nob;
 		niov++;
 		skipped += nob;
@@ -1218,7 +1218,7 @@ ksocknal_process_receive (ksock_conn_t *conn)
 		conn->ksnc_rx_nob_left = sizeof(ksock_lnet_msg_t);
 
 		conn->ksnc_rx_iov = (struct iovec *)&conn->ksnc_rx_iov_space;
-		conn->ksnc_rx_iov[0].iov_base = (char *)&conn->ksnc_msg.ksm_u.lnetmsg;
+		conn->ksnc_rx_iov[0].iov_base = (char __user *)&conn->ksnc_msg.ksm_u.lnetmsg;
 		conn->ksnc_rx_iov[0].iov_len  = sizeof(ksock_lnet_msg_t);
 
 		conn->ksnc_rx_niov = 1;
-- 
1.9.1

