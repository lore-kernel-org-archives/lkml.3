Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754168Ab3DWCoh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 22:44:37 -0400
Received: from mail-bk0-f51.google.com ([209.85.214.51]:50606 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753929Ab3DWCog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 22:44:36 -0400
MIME-Version: 1.0
Date: Tue, 23 Apr 2013 10:44:35 +0800
Message-ID: <CAPgLHd9_yV2V06XgyevDoHUOTMJ-htiJG3m5y4rqE21mC4+SZA@mail.gmail.com>
Subject: [PATCH -next] mei: fix krealloc() misuse in in mei_cl_irq_read_msg()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: tomas.winkler@intel.com, gregkh@linuxfoundation.org
Cc: yongjun_wei@trendmicro.com.cn, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

If krealloc() returns NULL, it doesn't free the original. So any code
of the form 'foo = krealloc(foo, ...);' is almost certainly a bug.

Introduced by commit fcb136e1ac5774909e0d85189f721b8dfa800e0f(mei: fix
reading large reposnes)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/misc/mei/interrupt.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/misc/mei/interrupt.c b/drivers/misc/mei/interrupt.c
index 37a8c35..089c516 100644
--- a/drivers/misc/mei/interrupt.c
+++ b/drivers/misc/mei/interrupt.c
@@ -148,16 +148,16 @@ static int mei_cl_irq_read_msg(struct mei_device *dev,
 			dev_dbg(&dev->pdev->dev, "message overflow. size %d len %d idx %ld\n",
 				cb->response_buffer.size,
 				mei_hdr->length, cb->buf_idx);
-			cb->response_buffer.data =
-					krealloc(cb->response_buffer.data,
-					mei_hdr->length + cb->buf_idx,
-					GFP_KERNEL);
+			buffer = krealloc(cb->response_buffer.data,
+					  mei_hdr->length + cb->buf_idx,
+					  GFP_KERNEL);
 
-			if (!cb->response_buffer.data) {
+			if (!buffer) {
 				dev_err(&dev->pdev->dev, "allocation failed.\n");
 				list_del(&cb->list);
 				return -ENOMEM;
 			}
+			cb->response_buffer.data = buffer;
 			cb->response_buffer.size =
 				mei_hdr->length + cb->buf_idx;
 		}

