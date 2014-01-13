Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755873AbaAMROA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 12:14:00 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:52794 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752114AbaAMQBC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 11:01:02 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ian Abbott <abbotti@mev.co.uk>, Dan Carpenter <dan.carpenter@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 004/208] staging: comedi: pcmuio: fix possible NULL deref on detach
Date: Mon, 13 Jan 2014 15:57:25 +0000
Message-Id: <1389628849-1614-5-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
References: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Abbott <abbotti@mev.co.uk>

commit 2fd2bdfccae61efe18f6b92b6a45fbf936d75b48 upstream.

pcmuio_detach() is called by the comedi core even if pcmuio_attach()
returned an error, so `dev->private` might be `NULL`.  Check for that
before dereferencing it.

Also, as pointed out by Dan Carpenter, there is no need to check the
pointer passed to `kfree()` is non-NULL, so remove that check.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/staging/comedi/drivers/pcmuio.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/comedi/drivers/pcmuio.c b/drivers/staging/comedi/drivers/pcmuio.c
index c43b633..7211c6b 100644
--- a/drivers/staging/comedi/drivers/pcmuio.c
+++ b/drivers/staging/comedi/drivers/pcmuio.c
@@ -680,12 +680,13 @@ static void pcmuio_detach(struct comedi_device *dev)
 	struct pcmuio_private *devpriv = dev->private;
 	int i;
 
-	for (i = 0; i < PCMUIO_MAX_ASICS; ++i) {
-		if (devpriv->asics[i].irq)
-			free_irq(devpriv->asics[i].irq, dev);
-	}
-	if (devpriv && devpriv->sprivs)
+	if (devpriv) {
+		for (i = 0; i < PCMUIO_MAX_ASICS; ++i) {
+			if (devpriv->asics[i].irq)
+				free_irq(devpriv->asics[i].irq, dev);
+		}
 		kfree(devpriv->sprivs);
+	}
 	comedi_legacy_detach(dev);
 }
 
-- 
1.8.3.2

