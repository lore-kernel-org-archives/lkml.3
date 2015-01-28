Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934749AbbA1Eyf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 23:54:35 -0500
Received: from mail.kernel.org ([198.145.29.136]:39617 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761317AbbA1EVg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 23:21:36 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, James Bottomley <JBottomley@Parallels.com>,
        Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 83/91] Fix spurious request sense in error handling
Date: Wed, 28 Jan 2015 12:08:52 +0800
Message-Id: <1422418236-12852-165-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422418050-12581-1-git-send-email-lizf@kernel.org>
References: <1422418050-12581-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: James Bottomley <JBottomley@Parallels.com>

3.4.105-rc1 review patch.  If anyone has any objections, please let me know.

------------------


commit d555a2abf3481f81303d835046a5ec2c4fb3ca8e upstream.

We unconditionally execute scsi_eh_get_sense() to make sure all failed
commands that should have sense attached, do.  However, the routine forgets
that some commands, because of the way they fail, will not have any sense code
... we should not bother them with a REQUEST_SENSE command.  Fix this by
testing to see if we actually got a CHECK_CONDITION return and skip asking for
sense if we don't.

Tested-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 drivers/scsi/scsi_error.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index b3f0b0f..dcc39b6 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -916,6 +916,15 @@ int scsi_eh_get_sense(struct list_head *work_q,
 		    SCSI_SENSE_VALID(scmd))
 			continue;
 
+		if (status_byte(scmd->result) != CHECK_CONDITION)
+			/*
+			 * don't request sense if there's no check condition
+			 * status because the error we're processing isn't one
+			 * that has a sense code (and some devices get
+			 * confused by sense requests out of the blue)
+			 */
+			continue;
+
 		SCSI_LOG_ERROR_RECOVERY(2, scmd_printk(KERN_INFO, scmd,
 						  "%s: requesting sense\n",
 						  current->comm));
-- 
1.9.1

