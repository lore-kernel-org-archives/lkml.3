Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933577AbaCQNsP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 09:48:15 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:51781 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933154AbaCQNbc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 09:31:32 -0400
Message-Id: <20140317133132.458780689@bombadil.infradead.org>
User-Agent: quilt/0.60-1
Date: Mon, 17 Mar 2014 06:27:40 -0700
From: Christoph Hellwig <hch@infradead.org>
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 07/39] scsi: avoid useless free_list lock roundtrips
References: <20140317132733.789623766@bombadil.infradead.org>
Content-Disposition: inline; filename=0007-scsi-avoid-useless-free_list-lock-roundtrips.patch
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avoid hitting the host-wide free_list lock unless we need to put a command
back onto the freelist.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index d8afec8..fb86479 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -320,13 +320,14 @@ void __scsi_put_command(struct Scsi_Host *shost, struct scsi_cmnd *cmd,
 {
 	unsigned long flags;
 
-	/* changing locks here, don't need to restore the irq state */
-	spin_lock_irqsave(&shost->free_list_lock, flags);
 	if (unlikely(list_empty(&shost->free_list))) {
-		list_add(&cmd->list, &shost->free_list);
-		cmd = NULL;
+		spin_lock_irqsave(&shost->free_list_lock, flags);
+		if (list_empty(&shost->free_list)) {
+			list_add(&cmd->list, &shost->free_list);
+			cmd = NULL;
+		}
+		spin_unlock_irqrestore(&shost->free_list_lock, flags);
 	}
-	spin_unlock_irqrestore(&shost->free_list_lock, flags);
 
 	if (likely(cmd != NULL))
 		scsi_pool_free_command(shost->cmd_pool, cmd);
-- 
1.7.10.4


