Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754206Ab3JXHtq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 03:49:46 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:33039 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753090Ab3JXHsw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 03:48:52 -0400
From: "Nicholas A. Bellinger" <nab@daterainc.com>
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Thomas Glanzmann <thomas@glanzmann.de>,
        Douglas Gilbert <dgilbert@interlog.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH 1/3] target: Add missing XCOPY I/O operation sense_buffer
Date: Thu, 24 Oct 2013 07:30:57 +0000
Message-Id: <1382599859-13204-2-git-send-email-nab@daterainc.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1382599859-13204-1-git-send-email-nab@daterainc.com>
References: <1382599859-13204-1-git-send-email-nab@daterainc.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch adds the missing xcopy_pt_cmd->sense_buffer[] required for
correctly handling CHECK_CONDITION exceptions within the locally
generated XCOPY I/O path.

Also update target_xcopy_read_source() + target_xcopy_setup_pt_cmd()
to pass this buffer into transport_init_se_cmd() to correctly setup
se_cmd->sense_buffer.

Reported-by: Thomas Glanzmann <thomas@glanzmann.de>
Reported-by: Douglas Gilbert <dgilbert@interlog.com>
Cc: Thomas Glanzmann <thomas@glanzmann.de>
Cc: Douglas Gilbert <dgilbert@interlog.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_xcopy.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_xcopy.c b/drivers/target/target_core_xcopy.c
index eeeaf99..5edcd2b 100644
--- a/drivers/target/target_core_xcopy.c
+++ b/drivers/target/target_core_xcopy.c
@@ -360,6 +360,7 @@ struct xcopy_pt_cmd {
 	struct se_cmd se_cmd;
 	struct xcopy_op *xcopy_op;
 	struct completion xpt_passthrough_sem;
+	unsigned char sense_buffer[TRANSPORT_SENSE_BUFFER];
 };
 
 static struct se_port xcopy_pt_port;
@@ -711,7 +712,7 @@ static int target_xcopy_read_source(
 		(unsigned long long)src_lba, src_sectors, length);
 
 	transport_init_se_cmd(se_cmd, &xcopy_pt_tfo, NULL, length,
-				DMA_FROM_DEVICE, 0, NULL);
+			      DMA_FROM_DEVICE, 0, &xpt_cmd->sense_buffer[0]);
 	xop->src_pt_cmd = xpt_cmd;
 
 	rc = target_xcopy_setup_pt_cmd(xpt_cmd, xop, src_dev, &cdb[0],
@@ -771,7 +772,7 @@ static int target_xcopy_write_destination(
 		(unsigned long long)dst_lba, dst_sectors, length);
 
 	transport_init_se_cmd(se_cmd, &xcopy_pt_tfo, NULL, length,
-				DMA_TO_DEVICE, 0, NULL);
+			      DMA_TO_DEVICE, 0, &xpt_cmd->sense_buffer[0]);
 	xop->dst_pt_cmd = xpt_cmd;
 
 	rc = target_xcopy_setup_pt_cmd(xpt_cmd, xop, dst_dev, &cdb[0],
-- 
1.7.2.5

