Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753698AbaABRXc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 12:23:32 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40362 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753186AbaABRIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 12:08:41 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ian Abbott <abbotti@mev.co.uk>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 55/91] staging: comedi: pcmuio: fix possible NULL deref on detach
Date: Thu,  2 Jan 2014 09:04:30 -0800
Message-Id: <1388682306-30859-56-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1388682306-30859-1-git-send-email-kamal@canonical.com>
References: <1388682306-30859-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Abbott <abbotti@mev.co.uk>

commit 2fd2bdfccae61efe18f6b92b6a45fbf936d75b48 upstream.

pcmuio_detach() is called by the comedi core even if pcmuio_attach()
returned an error, so `dev->private` might be `NULL`.  Check for that
before dereferencing it.

Also, as pointed out by Dan Carpenter, there is no need to check the
pointer passed to `kfree()` is non-NULL, so remove that check.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/staging/comedi/drivers/pcmuio.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/comedi/drivers/pcmuio.c b/drivers/staging/comedi/drivers/pcmuio.c
index 31ea20c..2c44647 100644
--- a/drivers/staging/comedi/drivers/pcmuio.c
+++ b/drivers/staging/comedi/drivers/pcmuio.c
@@ -908,12 +908,13 @@ static void pcmuio_detach(struct comedi_device *dev)
 
 	if (dev->iobase)
 		release_region(dev->iobase, ASIC_IOSIZE * board->num_asics);
-	for (i = 0; i < MAX_ASICS; ++i) {
-		if (devpriv->asics[i].irq)
-			free_irq(devpriv->asics[i].irq, dev);
-	}
-	if (devpriv && devpriv->sprivs)
+	if (devpriv) {
+		for (i = 0; i < MAX_ASICS; ++i) {
+			if (devpriv->asics[i].irq)
+				free_irq(devpriv->asics[i].irq, dev);
+		}
 		kfree(devpriv->sprivs);
+	}
 }
 
 static const struct pcmuio_board pcmuio_boards[] = {
-- 
1.8.3.2

