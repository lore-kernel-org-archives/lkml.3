Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753821Ab3HVFNL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 01:13:11 -0400
Received: from mail-oa0-f47.google.com ([209.85.219.47]:56995 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753537Ab3HVFKO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 01:10:14 -0400
From: "Nicholas A. Bellinger" <nab@daterainc.com>
To: target-devel <target-devel@vger.kernel.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Martin Petersen <martin.petersen@oracle.com>,
        Chris Mason <chris.mason@fusionio.com>,
        Roland Dreier <roland@purestorage.com>,
        James Bottomley <JBottomley@Parallels.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        Nicholas Bellinger <nab@daterainc.com>
Subject: [PATCH-v2 05/12] target: Convert se_cmd->t_bidi_data_sg checks to use SCF_BIDI
Date: Thu, 22 Aug 2013 04:54:03 +0000
Message-Id: <1377147250-10125-6-git-send-email-nab@daterainc.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1377147250-10125-1-git-send-email-nab@daterainc.com>
References: <1377147250-10125-1-git-send-email-nab@daterainc.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicholas Bellinger <nab@daterainc.com>

Stop keying off se_cmd->t_bidi_data_sg within transport_complete_qf()
+ target_complete_ok_work(), and just use SCF_BIDI instead.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Martin Petersen <martin.petersen@oracle.com>
Cc: Chris Mason <chris.mason@fusionio.com>
Cc: James Bottomley <JBottomley@Parallels.com>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Nicholas Bellinger <nab@daterainc.com>
---
 drivers/target/target_core_transport.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 3d3dc97..781859e 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1832,7 +1832,7 @@ static void transport_complete_qf(struct se_cmd *cmd)
 		ret = cmd->se_tfo->queue_data_in(cmd);
 		break;
 	case DMA_TO_DEVICE:
-		if (cmd->t_bidi_data_sg) {
+		if (cmd->se_cmd_flags & SCF_BIDI) {
 			ret = cmd->se_tfo->queue_data_in(cmd);
 			if (ret < 0)
 				break;
@@ -1947,7 +1947,7 @@ static void target_complete_ok_work(struct work_struct *work)
 		/*
 		 * Check if we need to send READ payload for BIDI-COMMAND
 		 */
-		if (cmd->t_bidi_data_sg) {
+		if (cmd->se_cmd_flags & SCF_BIDI) {
 			spin_lock(&cmd->se_lun->lun_sep_lock);
 			if (cmd->se_lun->lun_sep) {
 				cmd->se_lun->lun_sep->sep_stats.tx_data_octets +=
-- 
1.7.2.5

