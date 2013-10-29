Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756284Ab3J2STt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 14:19:49 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59462 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754051Ab3J2SJC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 14:09:02 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 58/81] esp_scsi: Fix tag state corruption when autosensing.
Date: Tue, 29 Oct 2013 11:04:19 -0700
Message-Id: <1383069882-11437-59-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1383069882-11437-1-git-send-email-kamal@canonical.com>
References: <1383069882-11437-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "David S. Miller" <davem@davemloft.net>

[ Upstream commit 21af8107f27878813d0364733c0b08813c2c192a ]

Meelis Roos reports a crash in esp_free_lun_tag() in the presense
of a disk which has died.

The issue is that when we issue an autosense command, we do so by
hijacking the original command that caused the check-condition.

When we do so we clear out the ent->tag[] array when we issue it via
find_and_prep_issuable_command().  This is so that the autosense
command is forced to be issued non-tagged.

That is problematic, because it is the value of ent->tag[] which
determines whether we issued the original scsi command as tagged
vs. non-tagged (see esp_alloc_lun_tag()).

And that, in turn, is what trips up the sanity checks in
esp_free_lun_tag().  That function needs the original ->tag[] values
in order to free up the tag slot properly.

Fix this by remembering the original command's tag values, and
having esp_alloc_lun_tag() and esp_free_lun_tag() use them.

Reported-by: Meelis Roos <mroos@linux.ee>
Tested-by: Meelis Roos <mroos@linux.ee>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/scsi/esp_scsi.c | 14 ++++++++------
 drivers/scsi/esp_scsi.h |  1 +
 2 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/esp_scsi.c b/drivers/scsi/esp_scsi.c
index 34552bf..55548dc 100644
--- a/drivers/scsi/esp_scsi.c
+++ b/drivers/scsi/esp_scsi.c
@@ -530,7 +530,7 @@ static int esp_need_to_nego_sync(struct esp_target_data *tp)
 static int esp_alloc_lun_tag(struct esp_cmd_entry *ent,
 			     struct esp_lun_data *lp)
 {
-	if (!ent->tag[0]) {
+	if (!ent->orig_tag[0]) {
 		/* Non-tagged, slot already taken?  */
 		if (lp->non_tagged_cmd)
 			return -EBUSY;
@@ -564,9 +564,9 @@ static int esp_alloc_lun_tag(struct esp_cmd_entry *ent,
 			return -EBUSY;
 	}
 
-	BUG_ON(lp->tagged_cmds[ent->tag[1]]);
+	BUG_ON(lp->tagged_cmds[ent->orig_tag[1]]);
 
-	lp->tagged_cmds[ent->tag[1]] = ent;
+	lp->tagged_cmds[ent->orig_tag[1]] = ent;
 	lp->num_tagged++;
 
 	return 0;
@@ -575,9 +575,9 @@ static int esp_alloc_lun_tag(struct esp_cmd_entry *ent,
 static void esp_free_lun_tag(struct esp_cmd_entry *ent,
 			     struct esp_lun_data *lp)
 {
-	if (ent->tag[0]) {
-		BUG_ON(lp->tagged_cmds[ent->tag[1]] != ent);
-		lp->tagged_cmds[ent->tag[1]] = NULL;
+	if (ent->orig_tag[0]) {
+		BUG_ON(lp->tagged_cmds[ent->orig_tag[1]] != ent);
+		lp->tagged_cmds[ent->orig_tag[1]] = NULL;
 		lp->num_tagged--;
 	} else {
 		BUG_ON(lp->non_tagged_cmd != ent);
@@ -667,6 +667,8 @@ static struct esp_cmd_entry *find_and_prep_issuable_command(struct esp *esp)
 			ent->tag[0] = 0;
 			ent->tag[1] = 0;
 		}
+		ent->orig_tag[0] = ent->tag[0];
+		ent->orig_tag[1] = ent->tag[1];
 
 		if (esp_alloc_lun_tag(ent, lp) < 0)
 			continue;
diff --git a/drivers/scsi/esp_scsi.h b/drivers/scsi/esp_scsi.h
index 28e22ac..cd68805 100644
--- a/drivers/scsi/esp_scsi.h
+++ b/drivers/scsi/esp_scsi.h
@@ -271,6 +271,7 @@ struct esp_cmd_entry {
 #define ESP_CMD_FLAG_AUTOSENSE	0x04 /* Doing automatic REQUEST_SENSE */
 
 	u8			tag[2];
+	u8			orig_tag[2];
 
 	u8			status;
 	u8			message;
-- 
1.8.1.2

