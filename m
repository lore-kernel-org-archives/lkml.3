Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756270AbaGHBFt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 21:05:49 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55226 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753174AbaGGXyA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 19:54:00 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jukka Taimisto <jtt@codenomicon.com>,
        Marcel Holtmann <marcel@holtmann.org>
Subject: [PATCH 3.15 060/122] Bluetooth: Fix deadlock in l2cap_conn_del()
Date: Mon,  7 Jul 2014 16:57:02 -0700
Message-Id: <20140707235736.070326260@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
In-Reply-To: <20140707235734.234226883@linuxfoundation.org>
References: <20140707235734.234226883@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jukka Taimisto <jtt@codenomicon.com>

commit 7ab56c3a6eccb215034b0cb096e0313441cbf2a4 upstream.

A deadlock occurs when PDU containing invalid SMP opcode is received on
Security Manager Channel over LE link and conn->pending_rx_work worker
has not run yet.

When LE link is created l2cap_conn_ready() is called and before
returning it schedules conn->pending_rx_work worker to hdev->workqueue.
Incoming data to SMP fixed channel is handled by l2cap_recv_frame()
which calls smp_sig_channel() to handle the SMP PDU. If
smp_sig_channel() indicates failure l2cap_conn_del() is called to delete
the connection. When deleting the connection, l2cap_conn_del() purges
the pending_rx queue and calls flush_work() to wait for the
pending_rx_work worker to complete.

Since incoming data is handled by a worker running from the same
workqueue as the pending_rx_work is being scheduled on, we will deadlock
on waiting for pending_rx_work to complete.

This patch fixes the deadlock by calling cancel_work_sync() instead of
flush_work().

Signed-off-by: Jukka Taimisto <jtt@codenomicon.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/bluetooth/l2cap_core.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -1657,7 +1657,13 @@ static void l2cap_conn_del(struct hci_co
 	kfree_skb(conn->rx_skb);
 
 	skb_queue_purge(&conn->pending_rx);
-	flush_work(&conn->pending_rx_work);
+
+	/* We can not call flush_work(&conn->pending_rx_work) here since we
+	 * might block if we are running on a worker from the same workqueue
+	 * pending_rx_work is waiting on.
+	 */
+	if (work_pending(&conn->pending_rx_work))
+		cancel_work_sync(&conn->pending_rx_work);
 
 	l2cap_unregister_all_users(conn);
 


