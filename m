Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757632Ab3CNLCX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 07:02:23 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51778 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756915Ab3CNKhI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 06:37:08 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Andy Grover <agrover@redhat.com>, Nicholas Bellinger <nab@linux-iscsi.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 20/88] iscsi-target: Fix immediate queue starvation regression with DATAIN
Date: Thu, 14 Mar 2013 10:35:13 +0000
Message-Id: <1363257381-15900-21-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1363257381-15900-1-git-send-email-luis.henriques@canonical.com>
References: <1363257381-15900-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicholas Bellinger <nab@linux-iscsi.org>

commit fd3a9025c0349bc9b01d627529f54e6e1e389015 upstream.

This patch addresses a v3.5+ regression in iscsi-target where TX thread
process context -> handle_response_queue() execution is allowed to run
unbounded while servicing constant outgoing flow of ISTATE_SEND_DATAIN
response state.

This ends up preventing memory release of StatSN acknowledged commands
in a timely manner when under heavy large block streaming DATAIN
workloads.

The regression bug was initially introduced with:

commit 6f3c0e69a9c20441bdc6d3b2d18b83b244384ec6
Author: Andy Grover <agrover@redhat.com>
Date:   Tue Apr 3 15:51:09 2012 -0700

    target/iscsi: Refactor target_tx_thread immediate+response queue loops

Go ahead and follow original iscsi_target_tx_thread() logic and check
to break for immediate queue processing after each DataIN Sequence and/or
Response PDU has been sent.

Reported-by: Benjamin ESTRABAUD <be@mpstor.com>
Cc: Andy Grover <agrover@redhat.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/target/iscsi/iscsi_target.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index ac41f04..3e7ac0c 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -3608,6 +3608,10 @@ check_rsp_state:
 				spin_lock_bh(&cmd->istate_lock);
 				cmd->i_state = ISTATE_SENT_STATUS;
 				spin_unlock_bh(&cmd->istate_lock);
+
+				if (atomic_read(&conn->check_immediate_queue))
+					return 1;
+
 				continue;
 			} else if (ret == 2) {
 				/* Still must send status,
@@ -3697,7 +3701,7 @@ check_rsp_state:
 		}
 
 		if (atomic_read(&conn->check_immediate_queue))
-			break;
+			return 1;
 	}
 
 	return 0;
@@ -3741,12 +3745,15 @@ restart:
 		     signal_pending(current))
 			goto transport_err;
 
+get_immediate:
 		ret = handle_immediate_queue(conn);
 		if (ret < 0)
 			goto transport_err;
 
 		ret = handle_response_queue(conn);
-		if (ret == -EAGAIN)
+		if (ret == 1)
+			goto get_immediate;
+		else if (ret == -EAGAIN)
 			goto restart;
 		else if (ret < 0)
 			goto transport_err;
-- 
1.8.1.2

