Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752574Ab3LRVJL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 16:09:11 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:35821 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752384Ab3LRVJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 16:09:09 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ian Abbott <abbotti@mev.co.uk>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH 3.4 27/31] staging: comedi: pcmuio: fix possible NULL deref on detach
Date: Wed, 18 Dec 2013 13:08:35 -0800
Message-Id: <20131218210523.549723497@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20131218210522.790152625@linuxfoundation.org>
References: <20131218210522.790152625@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/staging/comedi/drivers/pcmuio.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/staging/comedi/drivers/pcmuio.c
+++ b/drivers/staging/comedi/drivers/pcmuio.c
@@ -464,13 +464,13 @@ static int pcmuio_detach(struct comedi_d
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


