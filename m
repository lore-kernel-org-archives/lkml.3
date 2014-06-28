Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757603AbaF1TG7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 15:06:59 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53049 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754569AbaF1Rs0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 13:48:26 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sagi Grimberg <sagig@mellanox.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH 3.10 50/77] Target/iser: Bail from accept_np if np_thread is trying to close
Date: Sat, 28 Jun 2014 10:46:43 -0700
Message-Id: <20140628174524.144356024@linuxfoundation.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <20140628174521.691276402@linuxfoundation.org>
References: <20140628174521.691276402@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sagi Grimberg <sagig@mellanox.com>

commit e346ab343f4f58c12a96725c7b13df9cc2ad56f6 upstream.

In case np_thread state is in RESET/SHUTDOWN/EXIT states,
no point for isert to stall there as we may get a hang in
case no one will wake it up later.

Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/ulp/isert/ib_isert.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -2190,9 +2190,14 @@ accept_wait:
 		return -ENODEV;
 
 	spin_lock_bh(&np->np_thread_lock);
-	if (np->np_thread_state == ISCSI_NP_THREAD_RESET) {
+	if (np->np_thread_state >= ISCSI_NP_THREAD_RESET) {
 		spin_unlock_bh(&np->np_thread_lock);
-		pr_debug("ISCSI_NP_THREAD_RESET for isert_accept_np\n");
+		pr_debug("np_thread_state %d for isert_accept_np\n",
+			 np->np_thread_state);
+		/**
+		 * No point in stalling here when np_thread
+		 * is in state RESET/SHUTDOWN/EXIT - bail
+		 **/
 		return -ENODEV;
 	}
 	spin_unlock_bh(&np->np_thread_lock);


