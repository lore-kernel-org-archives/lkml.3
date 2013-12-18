Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755496Ab3LRVyG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 16:54:06 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:36149 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753429Ab3LRVMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 16:12:43 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ian Abbott <abbotti@mev.co.uk>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH 3.10 68/78] staging: comedi: pcmuio: fix possible NULL deref on detach
Date: Wed, 18 Dec 2013 13:11:36 -0800
Message-Id: <20131218211113.820729544@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20131218211111.903835960@linuxfoundation.org>
References: <20131218211111.903835960@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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

---
 drivers/staging/comedi/drivers/pcmuio.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/drivers/staging/comedi/drivers/pcmuio.c
+++ b/drivers/staging/comedi/drivers/pcmuio.c
@@ -935,12 +935,13 @@ static void pcmuio_detach(struct comedi_
 	struct pcmuio_private *devpriv = dev->private;
 	int i;
 
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
 	comedi_legacy_detach(dev);
 }
 


