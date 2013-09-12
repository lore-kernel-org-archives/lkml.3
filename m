Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756377Ab3ILSUw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 14:20:52 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57276 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756225Ab3ILSPL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 14:15:11 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [ 02/16] iscsi-target: Fix ImmediateData=Yes failure regression in >= v3.10
Date: Thu, 12 Sep 2013 11:14:54 -0700
Message-Id: <20130912181156.476451115@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130912181156.173326121@linuxfoundation.org>
References: <20130912181156.173326121@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicholas Bellinger <nab@linux-iscsi.org>

commit 9d86a2befceb06ee83c1a588915e6d6e0abef797 upstream.

This patch addresses a regression bug within ImmediateData=Yes failure
handling that ends up triggering an OOPs within >= v3.10 iscsi-target
code.

The problem occurs when iscsit_process_scsi_cmd() does the call to
target_put_sess_cmd(), and once again in iscsit_get_immediate_data()
that is triggered during two different cases:

 - When iscsit_sequence_cmd() returns CMDSN_LOWER_THAN_EXP, for which
   the descriptor state will already have been set to ISTATE_REMOVE
   by iscsit_sequence_cmd(), and
 - When iscsi_cmd->sense_reason is set, for which iscsit_execute_cmd()
   will have already called transport_send_check_condition_and_sense()
   to queue the exception response.

It changes iscsit_process_scsi_cmd() to drop the early call, and makes
iscsit_get_immediate_data() call target_put_sess_cmd() from a single
location after dumping the immediate data for the failed command.

The regression was initially introduced in commit:

commit 561bf15892375597ee59d473a704a3e634c4f311
Author: Nicholas Bellinger <nab@linux-iscsi.org>
Date:   Wed Jul 3 03:58:58 2013 -0700

    iscsi-target: Fix iscsit_sequence_cmd reject handling for iser

Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/target/iscsi/iscsi_target.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -1086,7 +1086,6 @@ int iscsit_process_scsi_cmd(struct iscsi
 		if (cmd->reject_reason)
 			return 0;
 
-		target_put_sess_cmd(conn->sess->se_sess, &cmd->se_cmd);
 		return 1;
 	}
 	/*
@@ -1124,14 +1123,10 @@ after_immediate_data:
 		 */
 		cmdsn_ret = iscsit_sequence_cmd(cmd->conn, cmd,
 					(unsigned char *)hdr, hdr->cmdsn);
-		if (cmdsn_ret == CMDSN_ERROR_CANNOT_RECOVER) {
+		if (cmdsn_ret == CMDSN_ERROR_CANNOT_RECOVER)
 			return -1;
-		} else if (cmdsn_ret == CMDSN_LOWER_THAN_EXP) {
-			target_put_sess_cmd(conn->sess->se_sess, &cmd->se_cmd);
-			return 0;
-		}
 
-		if (cmd->sense_reason) {
+		if (cmd->sense_reason || cmdsn_ret == CMDSN_LOWER_THAN_EXP) {
 			int rc;
 
 			rc = iscsit_dump_data_payload(cmd->conn,


