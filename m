Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754140Ab3JXHtA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 03:49:00 -0400
Received: from mail-oa0-f42.google.com ([209.85.219.42]:60872 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754102Ab3JXHsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 03:48:55 -0400
From: "Nicholas A. Bellinger" <nab@daterainc.com>
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Thomas Glanzmann <thomas@glanzmann.de>,
        Douglas Gilbert <dgilbert@interlog.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH 3/3] target: Fail XCOPY for non matching source + destination block_size
Date: Thu, 24 Oct 2013 07:30:59 +0000
Message-Id: <1382599859-13204-4-git-send-email-nab@daterainc.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1382599859-13204-1-git-send-email-nab@daterainc.com>
References: <1382599859-13204-1-git-send-email-nab@daterainc.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch adds an explicit check + failure for XCOPY I/O to source +
destination devices with a non-matching block_size.

This limitiation is currently due to the fact that the scatterlist
memory allocated for the XCOPY READ operation is passed zero-copy
to the XCOPY WRITE operation.

Reported-by: Thomas Glanzmann <thomas@glanzmann.de>
Reported-by: Douglas Gilbert <dgilbert@interlog.com>
Cc: Thomas Glanzmann <thomas@glanzmann.de>
Cc: Douglas Gilbert <dgilbert@interlog.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_xcopy.c |   14 +++++++++++++-
 1 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/drivers/target/target_core_xcopy.c b/drivers/target/target_core_xcopy.c
index 0e41143f..474cd44 100644
--- a/drivers/target/target_core_xcopy.c
+++ b/drivers/target/target_core_xcopy.c
@@ -893,6 +893,7 @@ sense_reason_t target_do_xcopy(struct se_cmd *se_cmd)
 	struct xcopy_op *xop = NULL;
 	unsigned char *p = NULL, *seg_desc;
 	unsigned int list_id, list_id_usage, sdll, inline_dl, sa;
+	sense_reason_t ret = TCM_INVALID_PARAMETER_LIST;
 	int rc;
 	unsigned short tdll;
 
@@ -944,6 +945,17 @@ sense_reason_t target_do_xcopy(struct se_cmd *se_cmd)
 	if (rc <= 0)
 		goto out;
 
+	if (xop->src_dev->dev_attrib.block_size !=
+	    xop->dst_dev->dev_attrib.block_size) {
+		pr_err("XCOPY: Non matching src_dev block_size: %u + dst_dev"
+		       " block_size: %u currently unsupported\n",
+			xop->src_dev->dev_attrib.block_size,
+			xop->dst_dev->dev_attrib.block_size);
+		xcopy_pt_undepend_remotedev(xop);
+		ret = TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
+		goto out;
+	}
+
 	pr_debug("XCOPY: Processed %d target descriptors, length: %u\n", rc,
 				rc * XCOPY_TARGET_DESC_LEN);
 	seg_desc = &p[16];
@@ -966,7 +978,7 @@ out:
 	if (p)
 		transport_kunmap_data_sg(se_cmd);
 	kfree(xop);
-	return TCM_INVALID_PARAMETER_LIST;
+	return ret;
 }
 
 static sense_reason_t target_rcr_operating_parameters(struct se_cmd *se_cmd)
-- 
1.7.2.5

