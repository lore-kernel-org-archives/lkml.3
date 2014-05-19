Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932806AbaESTyn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 15:54:43 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:51138 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932626AbaESTyf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 15:54:35 -0400
Date: Tue, 20 May 2014 01:24:27 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: julia.lawall@lip6.fr
Subject: [PATCH] Input: tps6507x-ts: Introduce the use of the managed version
 of kzalloc
Message-ID: <20140519195427.GA17152@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves data allocated using kzalloc to managed data allocated
using devm_kzalloc and cleans now unnecessary kfrees in probe and remove
functions. Also, the unnecessary label err_free_mem is removed.

The following Coccinelle semantic patch was used for making the change:

@platform@
identifier p, probefn, removefn;
@@
struct platform_driver p = {
  .probe = probefn,
  .remove = removefn,
};

@prb@
identifier platform.probefn, pdev;
expression e, e1, e2;
@@
probefn(struct platform_device *pdev, ...) {
  <+...
- e = kzalloc(e1, e2)
+ e = devm_kzalloc(&pdev->dev, e1, e2)
  ...
?-kfree(e);
  ...+>
}

@rem depends on prb@
identifier platform.removefn;
expression e;
@@
removefn(...) {
  <...
- kfree(e);
  ...>
}

Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
Acked-by: Julia Lawall <julia.lawall@lip6.fr>
---
I would like to know if it is desirable to add a
devm_input_allocate_polled_device like devm_input_allocate_device. If
this is done, it seems that no change is required in
input_unregister_polled_device as there is a separate call to this
function, and then to input_free_polled_device (which would go away).
Please let me know if this reasoning is correct.

 drivers/input/touchscreen/tps6507x-ts.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/input/touchscreen/tps6507x-ts.c b/drivers/input/touchscreen/tps6507x-ts.c
index 94cde2c..bd57be1 100644
--- a/drivers/input/touchscreen/tps6507x-ts.c
+++ b/drivers/input/touchscreen/tps6507x-ts.c
@@ -233,7 +233,7 @@ static int tps6507x_ts_probe(struct platform_device *pdev)
 	 */
 	init_data = tps_board->tps6507x_ts_init_data;
 
-	tsc = kzalloc(sizeof(struct tps6507x_ts), GFP_KERNEL);
+	tsc = devm_kzalloc(&pdev->dev, sizeof(struct tps6507x_ts), GFP_KERNEL);
 	if (!tsc) {
 		dev_err(tps6507x_dev->dev, "failed to allocate driver data\n");
 		return -ENOMEM;
@@ -250,8 +250,7 @@ static int tps6507x_ts_probe(struct platform_device *pdev)
 	poll_dev = input_allocate_polled_device();
 	if (!poll_dev) {
 		dev_err(tsc->dev, "Failed to allocate polled input device.\n");
-		error = -ENOMEM;
-		goto err_free_mem;
+		return -ENOMEM;
 	}
 
 	tsc->poll_dev = poll_dev;
@@ -293,8 +292,6 @@ static int tps6507x_ts_probe(struct platform_device *pdev)
 
 err_free_polled_dev:
 	input_free_polled_device(poll_dev);
-err_free_mem:
-	kfree(tsc);
 	return error;
 }
 
@@ -306,8 +303,6 @@ static int tps6507x_ts_remove(struct platform_device *pdev)
 	input_unregister_polled_device(poll_dev);
 	input_free_polled_device(poll_dev);
 
-	kfree(tsc);
-
 	return 0;
 }
 
-- 
1.9.1

