Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760908AbaLLGoe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 01:44:34 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51773 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758842AbaLLGQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 01:16:55 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Stephen M. Cameron" <scameron@beardog.cce.hp.com>,
        "Masoud Sharbiani" <msharbiani@twopensource.com>,
        "Tomas Henzl" <thenzl@redhat.com>,
        "James Bottomley" <JBottomley@Parallels.com>
Date: Fri, 12 Dec 2014 06:14:26 +0000
Message-ID: <lsq.1418364866.310294764@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 161/164] [SCSI] hpsa: fix a race in cmd_free/scsi_done
In-Reply-To: <lsq.1418364865.554543691@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:c97:8151:cc89:c28d
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.65-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Tomas Henzl <thenzl@redhat.com>

commit 2cc5bfaf854463d9d1aa52091f60110fbf102a96 upstream.

When the driver calls scsi_done and after that frees it's internal
preallocated memory it can happen that a new job is enqueud before
the memory is freed. The allocation fails and the message
"cmd_alloc returned NULL" is shown.
Patch below fixes it by moving cmd->scsi_done after cmd_free.

Signed-off-by: Tomas Henzl <thenzl@redhat.com>
Acked-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Masoud Sharbiani <msharbiani@twopensource.com>
---
 drivers/scsi/hpsa.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -1126,8 +1126,8 @@ static void complete_scsi_command(struct
 	scsi_set_resid(cmd, ei->ResidualCnt);
 
 	if (ei->CommandStatus == 0) {
-		cmd->scsi_done(cmd);
 		cmd_free(h, cp);
+		cmd->scsi_done(cmd);
 		return;
 	}
 
@@ -1300,8 +1300,8 @@ static void complete_scsi_command(struct
 		dev_warn(&h->pdev->dev, "cp %p returned unknown status %x\n",
 				cp, ei->CommandStatus);
 	}
-	cmd->scsi_done(cmd);
 	cmd_free(h, cp);
+	cmd->scsi_done(cmd);
 }
 
 static int hpsa_scsi_detect(struct ctlr_info *h)

