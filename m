Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753830Ab3HVFNd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 01:13:33 -0400
Received: from mail-oa0-f47.google.com ([209.85.219.47]:44098 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753487Ab3HVFKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 01:10:10 -0400
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
Subject: [PATCH-v2 03/12] target: Add TCM_MISCOMPARE_VERIFY sense handling
Date: Thu, 22 Aug 2013 04:54:01 +0000
Message-Id: <1377147250-10125-4-git-send-email-nab@daterainc.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1377147250-10125-1-git-send-email-nab@daterainc.com>
References: <1377147250-10125-1-git-send-email-nab@daterainc.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicholas Bellinger <nab@daterainc.com>

This patch adds TCM_MISCOMPARE_VERIFY (ASC=0x1d, ASCQ=0x00) sense
handling to transport_send_check_condition_and_sense(), which is
required for a COMPARE_AND_WRITE comparision failure.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Martin Petersen <martin.petersen@oracle.com>
Cc: Chris Mason <chris.mason@fusionio.com>
Cc: James Bottomley <JBottomley@Parallels.com>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Nicholas Bellinger <nab@daterainc.com>
---
 drivers/target/target_core_transport.c |    9 +++++++++
 include/target/target_core_base.h      |    1 +
 2 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 53d1d75..3d3dc97 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -2791,6 +2791,15 @@ transport_send_check_condition_and_sense(struct se_cmd *cmd,
 		buffer[SPC_ASC_KEY_OFFSET] = asc;
 		buffer[SPC_ASCQ_KEY_OFFSET] = ascq;
 		break;
+	case TCM_MISCOMPARE_VERIFY:
+		/* CURRENT ERROR */
+		buffer[0] = 0x70;
+		buffer[SPC_ADD_SENSE_LEN_OFFSET] = 10;
+		buffer[SPC_SENSE_KEY_OFFSET] = MISCOMPARE;
+		/* MISCOMPARE DURING VERIFY OPERATION */
+		buffer[SPC_ASC_KEY_OFFSET] = 0x1d;
+		buffer[SPC_ASCQ_KEY_OFFSET] = 0x00;
+		break;
 	case TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE:
 	default:
 		/* CURRENT ERROR */
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 6e946f3..fac25c5 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -197,6 +197,7 @@ enum tcm_sense_reason_table {
 	TCM_ADDRESS_OUT_OF_RANGE		= R(0x11),
 	TCM_OUT_OF_RESOURCES			= R(0x12),
 	TCM_PARAMETER_LIST_LENGTH_ERROR		= R(0x13),
+	TCM_MISCOMPARE_VERIFY			= R(0x14),
 #undef R
 };
 
-- 
1.7.2.5

