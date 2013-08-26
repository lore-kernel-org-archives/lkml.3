Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752844Ab3HZVaL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 17:30:11 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:53177 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752791Ab3HZVaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 17:30:05 -0400
From: "Nicholas A. Bellinger" <nab@daterainc.com>
To: target-devel <target-devel@vger.kernel.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Martin Petersen <martin.petersen@oracle.com>,
        Chris Mason <chris.mason@fusionio.com>,
        Roland Dreier <roland@purestorage.com>,
        Kent Overstreet <kmo@daterainc.com>,
        James Bottomley <JBottomley@Parallels.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        Nicholas Bellinger <nab@daterainc.com>
Subject: [PATCH-v3 07/13] target: Do memory allocation for bidi commands using target_alloc_sgl
Date: Mon, 26 Aug 2013 21:13:40 +0000
Message-Id: <1377551626-27447-8-git-send-email-nab@daterainc.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1377551626-27447-1-git-send-email-nab@daterainc.com>
References: <1377551626-27447-1-git-send-email-nab@daterainc.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicholas Bellinger <nab@daterainc.com>

This patch updates transport_generic_new_cmd() to call target_alloc_sgl()
for SGL + page memory allocation for se_cmd->t_bidi_data_sg.

It also adds the special case for SCF_COMPARE_AND_WRITE to calculate a
different bidi_length based upon se_cmd->t_task_nolb.

Reported-by: Christoph Hellwig <hch@lst.de>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Martin Petersen <martin.petersen@oracle.com>
Cc: Chris Mason <chris.mason@fusionio.com>
Cc: James Bottomley <JBottomley@Parallels.com>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Nicholas Bellinger <nab@daterainc.com>
---
 drivers/target/target_core_transport.c |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 607bc3d..c974e13 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -2149,6 +2149,23 @@ transport_generic_new_cmd(struct se_cmd *cmd)
 	    cmd->data_length) {
 		bool zero_flag = !(cmd->se_cmd_flags & SCF_SCSI_DATA_CDB);
 
+		if ((cmd->se_cmd_flags & SCF_BIDI) ||
+		    (cmd->se_cmd_flags & SCF_COMPARE_AND_WRITE)) {
+			u32 bidi_length;
+
+			if (cmd->se_cmd_flags & SCF_COMPARE_AND_WRITE)
+				bidi_length = cmd->t_task_nolb *
+					      cmd->se_dev->dev_attrib.block_size;
+			else
+				bidi_length = cmd->data_length;
+
+			ret = target_alloc_sgl(&cmd->t_bidi_data_sg,
+					       &cmd->t_bidi_data_nents,
+					       bidi_length, zero_flag);
+			if (ret < 0)
+				return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
+		}
+
 		ret = target_alloc_sgl(&cmd->t_data_sg, &cmd->t_data_nents,
 				       cmd->data_length, zero_flag);
 		if (ret < 0)
-- 
1.7.2.5

