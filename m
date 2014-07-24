Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935086AbaGXKDZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 06:03:25 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55018 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934617AbaGXJs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 05:48:27 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: James Bottomley <JBottomley@Parallels.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 086/128] [SCSI] Fix spurious request sense in error handling
Date: Thu, 24 Jul 2014 10:45:35 +0100
Message-Id: <1406195177-8656-87-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406195177-8656-1-git-send-email-luis.henriques@canonical.com>
References: <1406195177-8656-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: James Bottomley <JBottomley@Parallels.com>

commit d555a2abf3481f81303d835046a5ec2c4fb3ca8e upstream.

We unconditionally execute scsi_eh_get_sense() to make sure all failed
commands that should have sense attached, do.  However, the routine forgets
that some commands, because of the way they fail, will not have any sense code
... we should not bother them with a REQUEST_SENSE command.  Fix this by
testing to see if we actually got a CHECK_CONDITION return and skip asking for
sense if we don't.

Tested-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
[ luis: backported to 3.11: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/scsi/scsi_error.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 21505962f539..309f2e1d254d 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -933,6 +933,15 @@ int scsi_eh_get_sense(struct list_head *work_q,
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

