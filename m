Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759318AbaHHW0X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 18:26:23 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40350 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751157AbaHHUpR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 16:45:17 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Kevin Hao <haokexin@gmail.com>, Tejun Heo <tj@kernel.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 161/259] libata: support the ata host which implements a queue depth less than 32
Date: Fri,  8 Aug 2014 13:39:44 -0700
Message-Id: <1407530482-4483-162-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407530482-4483-1-git-send-email-kamal@canonical.com>
References: <1407530482-4483-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kevin Hao <haokexin@gmail.com>

commit 1871ee134b73fb4cadab75752a7152ed2813c751 upstream.

The sata on fsl mpc8315e is broken after the commit 8a4aeec8d2d6
("libata/ahci: accommodate tag ordered controllers"). The reason is
that the ata controller on this SoC only implement a queue depth of
16. When issuing the commands in tag order, all the commands in tag
16 ~ 31 are mapped to tag 0 unconditionally and then causes the sata
malfunction. It makes no senses to use a 32 queue in software while
the hardware has less queue depth. So consider the queue depth
implemented by the hardware when requesting a command tag.

Fixes: 8a4aeec8d2d6 ("libata/ahci: accommodate tag ordered controllers")
Signed-off-by: Kevin Hao <haokexin@gmail.com>
Acked-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/ata/libata-core.c | 22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 62fda16..0172e30 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -4787,6 +4787,10 @@ void swap_buf_le16(u16 *buf, unsigned int buf_words)
  *	ata_qc_new - Request an available ATA command, for queueing
  *	@ap: target port
  *
+ *	Some ATA host controllers may implement a queue depth which is less
+ *	than ATA_MAX_QUEUE. So we shouldn't allocate a tag which is beyond
+ *	the hardware limitation.
+ *
  *	LOCKING:
  *	None.
  */
@@ -4794,14 +4798,16 @@ void swap_buf_le16(u16 *buf, unsigned int buf_words)
 static struct ata_queued_cmd *ata_qc_new(struct ata_port *ap)
 {
 	struct ata_queued_cmd *qc = NULL;
-	unsigned int i, tag;
+	unsigned int i, tag, max_queue;
+
+	max_queue = ap->scsi_host->can_queue;
 
 	/* no command while frozen */
 	if (unlikely(ap->pflags & ATA_PFLAG_FROZEN))
 		return NULL;
 
-	for (i = 0; i < ATA_MAX_QUEUE; i++) {
-		tag = (i + ap->last_tag + 1) % ATA_MAX_QUEUE;
+	for (i = 0, tag = ap->last_tag + 1; i < max_queue; i++, tag++) {
+		tag = tag < max_queue ? tag : 0;
 
 		/* the last tag is reserved for internal command. */
 		if (tag == ATA_TAG_INTERNAL)
@@ -6184,6 +6190,16 @@ int ata_host_register(struct ata_host *host, struct scsi_host_template *sht)
 {
 	int i, rc;
 
+	/*
+	 * The max queue supported by hardware must not be greater than
+	 * ATA_MAX_QUEUE.
+	 */
+	if (sht->can_queue > ATA_MAX_QUEUE) {
+		dev_err(host->dev, "BUG: the hardware max queue is too large\n");
+		WARN_ON(1);
+		return -EINVAL;
+	}
+
 	/* host must have been started */
 	if (!(host->flags & ATA_HOST_STARTED)) {
 		dev_err(host->dev, "BUG: trying to register unstarted host\n");
-- 
1.9.1

