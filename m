Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932822Ab3KIGwV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 01:52:21 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:33342 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932778Ab3KIGwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Nov 2013 01:52:09 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Roland Dreier <roland@purestorage.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH 3.11 43/94] target: Fix assignment of LUN in tracepoints
Date: Fri,  8 Nov 2013 22:51:49 -0800
Message-Id: <20131109065207.259892960@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc0.dirty
In-Reply-To: <20131109065204.252462489@linuxfoundation.org>
References: <20131109065204.252462489@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roland Dreier <roland@purestorage.com>

commit 2053a1db41193c2b5e1f47a91aaba0fd63ba7102 upstream.

The unpacked_lun field in the SCSI target tracepoints should be
initialized with cmd->orig_fe_lun rather than cmd->se_lun->unpacked_lun
for two reasons:

 - most importantly, if we are in the cmd_complete tracepoint
   returning a check condition due to no LUN found, cmd->se_lun will
   be NULL and we'll crash trying to dereference it.

 - also, in any case, cmd->se_lun->unpacked_lun is an internal index
   into the target's internal set of LUNs; cmd->orig_fe_lun is much
   more useful and interesting, since it's the value the initiator
   actually sent.

Signed-off-by: Roland Dreier <roland@purestorage.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/trace/events/target.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/trace/events/target.h
+++ b/include/trace/events/target.h
@@ -144,7 +144,7 @@ TRACE_EVENT(target_sequencer_start,
 	),
 
 	TP_fast_assign(
-		__entry->unpacked_lun	= cmd->se_lun->unpacked_lun;
+		__entry->unpacked_lun	= cmd->orig_fe_lun;
 		__entry->opcode		= cmd->t_task_cdb[0];
 		__entry->data_length	= cmd->data_length;
 		__entry->task_attribute	= cmd->sam_task_attr;
@@ -182,7 +182,7 @@ TRACE_EVENT(target_cmd_complete,
 	),
 
 	TP_fast_assign(
-		__entry->unpacked_lun	= cmd->se_lun->unpacked_lun;
+		__entry->unpacked_lun	= cmd->orig_fe_lun;
 		__entry->opcode		= cmd->t_task_cdb[0];
 		__entry->data_length	= cmd->data_length;
 		__entry->task_attribute	= cmd->sam_task_attr;


