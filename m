Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755975Ab3CLWdV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 18:33:21 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60122 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755789Ab3CLWcp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 18:32:45 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Benjamin ESTRABAUD <be@mpstor.com>, Andy Grover <agrover@redhat.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [ 016/100] iscsi-target: Fix immediate queue starvation regression with DATAIN
Date: Tue, 12 Mar 2013 15:31:01 -0700
Message-Id: <20130312223124.734770485@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130312223122.884099393@linuxfoundation.org>
References: <20130312223122.884099393@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/target/iscsi/iscsi_target.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -3570,6 +3570,10 @@ check_rsp_state:
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
@@ -3659,7 +3663,7 @@ check_rsp_state:
 		}
 
 		if (atomic_read(&conn->check_immediate_queue))
-			break;
+			return 1;
 	}
 
 	return 0;
@@ -3703,12 +3707,15 @@ restart:
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


