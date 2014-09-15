Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757947AbaIOUdj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 16:33:39 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55133 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755659AbaIOThA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 15:37:00 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: [PATCH 3.14 005/114] media: mt9v032: fix hblank calculation
Date: Mon, 15 Sep 2014 12:25:05 -0700
Message-Id: <20140915192641.595452873@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140915192641.428509513@linuxfoundation.org>
References: <20140915192641.428509513@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Philipp Zabel <p.zabel@pengutronix.de>

commit f17bc3f4707eb87bdb80b895911c551cdd606fbd upstream.

Since (min_row_time - crop->width) can be negative, we have to do a signed
comparison here. Otherwise max_t casts the negative value to unsigned int
and sets min_hblank to that invalid value.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/i2c/mt9v032.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/media/i2c/mt9v032.c
+++ b/drivers/media/i2c/mt9v032.c
@@ -305,8 +305,8 @@ mt9v032_update_hblank(struct mt9v032 *mt
 
 	if (mt9v032->version->version == MT9V034_CHIP_ID_REV1)
 		min_hblank += (mt9v032->hratio - 1) * 10;
-	min_hblank = max_t(unsigned int, (int)mt9v032->model->data->min_row_time - crop->width,
-			   (int)min_hblank);
+	min_hblank = max_t(int, mt9v032->model->data->min_row_time - crop->width,
+			   min_hblank);
 	hblank = max_t(unsigned int, mt9v032->hblank, min_hblank);
 
 	return mt9v032_write(client, MT9V032_HORIZONTAL_BLANKING, hblank);


