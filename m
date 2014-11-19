Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933063AbaKSVXR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 16:23:17 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57291 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933877AbaKSVOu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 16:14:50 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Tomas Henzl <thenzl@redhat.com>,
        "Stephen M. Cameron" <scameron@beardog.cce.hp.com>,
        James Bottomley <JBottomley@Parallels.com>,
        Masoud Sharbiani <msharbiani@twitter.com>
Subject: [PATCH 3.10 57/70] SCSI: hpsa: fix a race in cmd_free/scsi_done
Date: Wed, 19 Nov 2014 12:52:48 -0800
Message-Id: <20141119205212.804954795@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141119205210.913169042@linuxfoundation.org>
References: <20141119205210.913169042@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Cc: Masoud Sharbiani <msharbiani@twitter.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/hpsa.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -1206,8 +1206,8 @@ static void complete_scsi_command(struct
 	scsi_set_resid(cmd, ei->ResidualCnt);
 
 	if (ei->CommandStatus == 0) {
-		cmd->scsi_done(cmd);
 		cmd_free(h, cp);
+		cmd->scsi_done(cmd);
 		return;
 	}
 
@@ -1380,8 +1380,8 @@ static void complete_scsi_command(struct
 		dev_warn(&h->pdev->dev, "cp %p returned unknown status %x\n",
 				cp, ei->CommandStatus);
 	}
-	cmd->scsi_done(cmd);
 	cmd_free(h, cp);
+	cmd->scsi_done(cmd);
 }
 
 static void hpsa_pci_unmap(struct pci_dev *pdev,


