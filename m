Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753924AbaC3XdM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 19:33:12 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36504 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753143AbaC3XZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 19:25:04 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Ian Abbott" <abbotti@mev.co.uk>,
        "Dan Carpenter" <dan.carpenter@oracle.com>
Date: Mon, 31 Mar 2014 00:23:35 +0100
Message-ID: <lsq.1396221815.717221491@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 178/200] staging: comedi: pcmuio: fix possible NULL
 deref on detach
In-Reply-To: <lsq.1396221814.369444335@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.56-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/staging/comedi/drivers/pcmuio.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/comedi/drivers/pcmuio.c b/drivers/staging/comedi/drivers/pcmuio.c
index 661ba2e..6e936c5 100644
--- a/drivers/staging/comedi/drivers/pcmuio.c
+++ b/drivers/staging/comedi/drivers/pcmuio.c
@@ -464,13 +464,13 @@ static int pcmuio_detach(struct comedi_device *dev)
 	if (dev->iobase)
 		release_region(dev->iobase, ASIC_IOSIZE * thisboard->num_asics);
 
-	for (i = 0; i < MAX_ASICS; ++i) {
-		if (devpriv->asics[i].irq)
-			free_irq(devpriv->asics[i].irq, dev);
-	}
-
-	if (devpriv && devpriv->sprivs)
+	if (devpriv) {
+		for (i = 0; i < MAX_ASICS; ++i) {
+			if (devpriv->asics[i].irq)
+				free_irq(devpriv->asics[i].irq, dev);
+		}
 		kfree(devpriv->sprivs);
+	}
 
 	return 0;
 }

