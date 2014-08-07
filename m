Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755093AbaHGVBE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 17:01:04 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:50575 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751414AbaHGVA7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 17:00:59 -0400
X-IronPort-AV: E=Sophos;i="5.01,820,1400018400"; 
   d="scan'208";a="88647124"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: linux-kernel@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org
Subject: [PATCH 1/4] umem: fix error return code
Date: Thu,  7 Aug 2014 22:57:45 +0200
Message-Id: <1407445067-4044-3-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1407445067-4044-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1407445067-4044-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Convert a zero return value on error to a negative one, as returned
elsewhere in the function.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
identifier ret; expression e1,e2;
@@
(
if (\(ret < 0\|ret != 0\))
 { ... return ret; }
|
ret = 0
)
... when != ret = e1
    when != &ret
*if(...)
{
  ... when != ret = e2
      when forall
 return ret;
}
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/block/umem.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/block/umem.c b/drivers/block/umem.c
index 4cf81b5..371e819 100644
--- a/drivers/block/umem.c
+++ b/drivers/block/umem.c
@@ -881,6 +881,7 @@ static int mm_pci_probe(struct pci_dev *dev, const struct pci_device_id *id)
 	if (card->mm_pages[0].desc == NULL ||
 	    card->mm_pages[1].desc == NULL) {
 		dev_printk(KERN_ERR, &card->dev->dev, "alloc failed\n");
+		ret = -ENOMEM;
 		goto failed_alloc;
 	}
 	reset_page(&card->mm_pages[0]);
@@ -891,8 +892,10 @@ static int mm_pci_probe(struct pci_dev *dev, const struct pci_device_id *id)
 	card->biotail = &card->bio;
 
 	card->queue = blk_alloc_queue(GFP_KERNEL);
-	if (!card->queue)
+	if (!card->queue) {
+		ret = -ENOMEM;
 		goto failed_alloc;
+	}
 
 	blk_queue_make_request(card->queue, mm_make_request);
 	card->queue->queue_lock = &card->lock;

