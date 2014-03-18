Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754895AbaCRKmE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 06:42:04 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:24000 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754327AbaCRKmA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 06:42:00 -0400
X-AuditID: cbfee61a-b7fb26d00000724f-0b-532822f6a7a2
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Archit Taneja <archit@ti.com>, Hans Verkuil <hans.verkuil@cisco.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] v4l: ti-vpe: fix devm_ioremap_resource() return value checking
Date: Tue, 18 Mar 2014 11:41:42 +0100
Message-id: <2203316.gzhRfbGDkb@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKLMWRmVeSWpSXmKPExsVy+t9jQd1vShrBBu27jSxu7/vNaLHk5y4m
	i8u75rBZ9GzYympxcZ28A6vHlN8bWT36tqxi9Dh+YzuTx+dNcgEsUVw2Kak5mWWpRfp2CVwZ
	G++9YS34wlPxvnMtYwPjf64uRk4OCQETicdL5zFB2GISF+6tZ+ti5OIQEpjOKHHh6gpGCKeF
	SeLy62nMIFVsAlYSE9tXMYLYIgIGEo8XnWQHKWIWaGWUWNa0EGyUsIC/xJ7911hAbBYBVYkf
	z++A2bwCmhI7Pq8FGyQq4CmxY/tKNoi4oMSPyffAapgF5CX27Z/KCmFrSazfeZxpAiPfLCRl
	s5CUzUJStoCReRWjaGpBckFxUnquoV5xYm5xaV66XnJ+7iZGcGA+k9rBuLLB4hCjAAejEg/v
	Czb1YCHWxLLiytxDjBIczEoivCdENIKFeFMSK6tSi/Lji0pzUosPMUpzsCiJ8x5otQ4UEkhP
	LEnNTk0tSC2CyTJxcEo1MIYZHBeKcfppPC9yaskq7zPm8y50JV54eEXUTvBvdJDSv4IV1Yfq
	nzZoPDkQl/yh01LU4u/nvfzXomdY8/j/EkvXlchaev71QrulVjdqrhzskrHQ2/bgfI/1Xv3L
	ak8WzRK+pOn22kNMo0zBY8tevuPKeYXx6Sc3MX5xf97Kd33FzePy5/aEflJiKc5INNRiLipO
	BAD3y7TxSAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devm_ioremap_resource() returns a pointer to the remapped memory or
an ERR_PTR() encoded error code on failure.  Fix the checks inside
csc_create() and sc_create() accordingly.

Cc: Archit Taneja <archit@ti.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
---
Compile tested only.

 drivers/media/platform/ti-vpe/csc.c |    4 ++--
 drivers/media/platform/ti-vpe/sc.c  |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

Index: b/drivers/media/platform/ti-vpe/csc.c
===================================================================
--- a/drivers/media/platform/ti-vpe/csc.c	2014-03-14 16:45:25.848724010 +0100
+++ b/drivers/media/platform/ti-vpe/csc.c	2014-03-18 11:01:36.595182833 +0100
@@ -187,9 +187,9 @@ struct csc_data *csc_create(struct platf
 	}
 
 	csc->base = devm_ioremap_resource(&pdev->dev, csc->res);
-	if (!csc->base) {
+	if (IS_ERR(csc->base)) {
 		dev_err(&pdev->dev, "failed to ioremap\n");
-		return ERR_PTR(-ENOMEM);
+		return csc->base;
 	}
 
 	return csc;
Index: b/drivers/media/platform/ti-vpe/sc.c
===================================================================
--- a/drivers/media/platform/ti-vpe/sc.c	2014-03-14 16:45:25.848724010 +0100
+++ b/drivers/media/platform/ti-vpe/sc.c	2014-03-18 11:02:09.555182273 +0100
@@ -302,9 +302,9 @@ struct sc_data *sc_create(struct platfor
 	}
 
 	sc->base = devm_ioremap_resource(&pdev->dev, sc->res);
-	if (!sc->base) {
+	if (IS_ERR(sc->base)) {
 		dev_err(&pdev->dev, "failed to ioremap\n");
-		return ERR_PTR(-ENOMEM);
+		return sc->base;
 	}
 
 	return sc;

