Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756097AbaHHIYE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 04:24:04 -0400
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:53488
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752894AbaHHIYA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 04:24:00 -0400
X-IronPort-AV: E=Sophos;i="5.01,823,1400018400"; 
   d="scan'208";a="74291464"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Joshua Morris <josh.h.morris@us.ibm.com>, Jeff Moyer <jmoyer@redhat.com>
Cc: kernel-janitors@vger.kernel.org,
        Philip Kelleher <pjk1939@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] block: add abort on failure
Date: Fri,  8 Aug 2014 10:20:50 +0200
Message-Id: <1407486050-9375-1-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Initializing card seems to be critical to the rest of the probe process, so
abort the probe function if the calls to rsxx_load_config and
rsxx_get_num_targets do not succeed.

Suggested by Jeff Moyer.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/block/rsxx/core.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/block/rsxx/core.c b/drivers/block/rsxx/core.c
index a8de2ee..ae2805b 100644
--- a/drivers/block/rsxx/core.c
+++ b/drivers/block/rsxx/core.c
@@ -915,15 +915,19 @@ static int rsxx_pci_probe(struct pci_dev *dev,
 
 	/************* Load Card Config *************/
 	st = rsxx_load_config(card);
-	if (st)
+	if (st) {
 		dev_err(CARD_TO_DEV(card),
 			"Failed loading card config\n");
+		goto failed_dma_setup;
+	}
 
 	/************* Setup DMA Engine *************/
 	st = rsxx_get_num_targets(card, &card->n_targets);
-	if (st)
+	if (st) {
 		dev_info(CARD_TO_DEV(card),
 			"Failed reading the number of DMA targets\n");
+		goto failed_dma_setup;
+	}
 
 	card->ctrl = kzalloc(card->n_targets * sizeof(*card->ctrl), GFP_KERNEL);
 	if (!card->ctrl) {

