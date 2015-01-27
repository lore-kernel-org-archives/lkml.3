Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758257AbbA0MRM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 07:17:12 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34840 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758201AbbA0MRD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 07:17:03 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alan Stern <stern@rowland.harvard.edu>,
        James Bottomley <JBottomley@Parallels.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 010/126] SCSI: fix regression in scsi_send_eh_cmnd()
Date: Tue, 27 Jan 2015 12:15:15 +0000
Message-Id: <1422361031-19364-11-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
References: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit 511833acfc06c013d453e288f483c682c60ffbff upstream.

Commit ac61d1955934 (scsi: set correct completion code in
scsi_send_eh_cmnd()) introduced a bug.  It changed the stored return
value from a queuecommand call, but it didn't take into account that
the return value was used again later on.  This patch fixes the bug by
changing the later usage.

There is a big comment in the middle of scsi_send_eh_cmnd() which
does a good job of explaining how the routine works.  But it mentions
a "rtn = FAILURE" value that doesn't exist in the code.  This patch
adjusts the code to match the comment (I assume the comment is right
and the code is wrong).

This fixes Bugzilla #88341.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Reported-by: Андрей Аладьев <aladjev.andrew@gmail.com>
Tested-by: Андрей Аладьев <aladjev.andrew@gmail.com>
Fixes: ac61d19559349e205dad7b5122b281419aa74a82
Acked-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/scsi/scsi_error.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index b350eb8ec898..f0c7a970547f 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1026,7 +1026,7 @@ retry:
 		}
 		/* signal not to enter either branch of the if () below */
 		timeleft = 0;
-		rtn = NEEDS_RETRY;
+		rtn = FAILED;
 	} else {
 		timeleft = wait_for_completion_timeout(&done, timeout);
 		rtn = SUCCESS;
@@ -1067,7 +1067,7 @@ retry:
 			rtn = FAILED;
 			break;
 		}
-	} else if (!rtn) {
+	} else if (rtn != FAILED) {
 		scsi_abort_eh_cmnd(scmd);
 		rtn = FAILED;
 	}
-- 
2.1.4

