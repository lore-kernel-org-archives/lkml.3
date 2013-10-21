Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754316Ab3JUIwm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 04:52:42 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39795 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754289Ab3JUIwj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 04:52:39 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Meelis Roos" <mroos@linux.ee>,
        "David S. Miller" <davem@davemloft.net>
Date: Mon, 21 Oct 2013 09:46:28 +0100
Message-ID: <lsq.1382345188.441848292@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 114/149] esp_scsi: Fix tag state corruption when
 autosensing.
In-Reply-To: <lsq.1382345187.199780875@decadent.org.uk>
X-SA-Exim-Connect-IP: 212.20.242.100
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.52-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/scsi/esp_scsi.c | 14 ++++++++------
 drivers/scsi/esp_scsi.h |  1 +
 2 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/esp_scsi.c b/drivers/scsi/esp_scsi.c
index 394ed9e..4aa30d8 100644
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

