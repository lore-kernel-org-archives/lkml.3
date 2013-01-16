Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756449Ab3APOov (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 09:44:51 -0500
Received: from mail-la0-f50.google.com ([209.85.215.50]:34830 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756400Ab3APOot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 09:44:49 -0500
From: sjur.brandeland@stericsson.com
To: Ido Yariv <ido@wizery.com>, Ohad Ben-Cohen <ohad@wizery.com>
Cc: mporter@ti.com, =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjurbren@gmail.com>,
        linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Loic Pallardy <loic.pallardy@stericsson.com>,
        Ludovic BARRE <ludovic.barre@stericsson.com>,
        Fernando Guzman Lugo <fernando.lugo@ti.com>,
        Suman Anna <s-anna@ti.com>, Mark Grosen <mgrosen@ti.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>
Subject: [RFCv3 11/11] remoteproc: Calculate max_notifyid by counting vrings
Date: Wed, 16 Jan 2013 15:43:50 +0100
Message-Id: <1358347430-9243-12-git-send-email-sjur.brandeland@stericsson.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358347430-9243-1-git-send-email-sjur.brandeland@stericsson.com>
References: <1358347430-9243-1-git-send-email-sjur.brandeland@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sjur Brændeland <sjur.brandeland@stericsson.com>

Simplify hanling of max_notifyid by simply counting the
number of vrings.

Signed-off-by: Sjur Brændeland <sjur.brandeland@stericsson.com>
---
 drivers/remoteproc/remoteproc_core.c |   20 +++++---------------
 1 files changed, 5 insertions(+), 15 deletions(-)

diff --git a/drivers/remoteproc/remoteproc_core.c b/drivers/remoteproc/remoteproc_core.c
index 4f342e0..31ecb30 100644
--- a/drivers/remoteproc/remoteproc_core.c
+++ b/drivers/remoteproc/remoteproc_core.c
@@ -227,9 +227,6 @@ int rproc_alloc_vring(struct rproc_vdev *rvdev, int i)
 		return ret;
 	}
 
-	/* Store largest notifyid */
-	rproc->max_notifyid = max(rproc->max_notifyid, notifyid);
-
 	dev_dbg(dev, "vring%d: va %p dma %llx size %x idr %d\n", i, va,
 				(unsigned long long)dma, size, notifyid);
 
@@ -279,25 +276,13 @@ rproc_parse_vring(struct rproc_vdev *rvdev, struct fw_rsc_vdev *rsc, int i)
 	return 0;
 }
 
-static int rproc_max_notifyid(int id, void *p, void *data)
-{
-	int *maxid = data;
-	*maxid = max(*maxid, id);
-	return 0;
-}
-
 void rproc_free_vring(struct rproc_vring *rvring)
 {
 	int size = PAGE_ALIGN(vring_size(rvring->len, rvring->align));
 	struct rproc *rproc = rvring->rvdev->rproc;
-	int maxid = 0;
 
 	dma_free_coherent(rproc->dev.parent, size, rvring->va, rvring->dma);
 	idr_remove(&rproc->notifyids, rvring->notifyid);
-
-	/* Find the largest remaining notifyid */
-	idr_for_each(&rproc->notifyids, rproc_max_notifyid, &maxid);
-	rproc->max_notifyid = maxid;
 }
 
 /**
@@ -372,6 +357,9 @@ static int rproc_handle_vdev(struct rproc *rproc, struct fw_rsc_vdev *rsc,
 	/* remember the resource entry */
 	rvdev->rsc = rsc;
 
+	/* Summerize the number of notification IDs */
+	rproc->max_notifyid += rsc->num_of_vrings;
+
 	list_add_tail(&rvdev->node, &rproc->rvdevs);
 
 	/* it is now safe to add the virtio device */
@@ -827,6 +815,8 @@ static void rproc_fw_load(const struct firmware *fw, void *context)
 		goto clean_up;
 	}
 
+	rproc->max_notifyid = 0;
+
 	/* handle fw resources which are required to load rproc */
 	ret = rproc_handle_resource(rproc, table, tablesz, rproc_handle_rsc);
 	if (ret) {
-- 
1.7.5.4

