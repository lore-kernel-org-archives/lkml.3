Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932070AbaETPJ1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 11:09:27 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:42805 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751161AbaETPJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 11:09:25 -0400
Date: Tue, 20 May 2014 20:39:18 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: julia.lawall@lip6.fr
Subject: [PATCH] Input: misc : Introduce the use of the managed version of
 kzalloc
Message-ID: <20140520150918.GA6269@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves data allocated using kzalloc to managed data allocated
using devm_kzalloc and cleans now unnecessary kfrees in probe and remove
functions.

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
Would be better to add the definition of a
devm_input_allocate_polled_device, like there is a
devm_input_allocate_device defined?

 drivers/input/misc/sgi_btns.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/input/misc/sgi_btns.c b/drivers/input/misc/sgi_btns.c
index f104749..e2dea37 100644
--- a/drivers/input/misc/sgi_btns.c
+++ b/drivers/input/misc/sgi_btns.c
@@ -97,7 +97,8 @@ static int sgi_buttons_probe(struct platform_device *pdev)
 	struct input_dev *input;
 	int error, i;
 
-	bdev = kzalloc(sizeof(struct buttons_dev), GFP_KERNEL);
+	bdev = devm_kzalloc(&pdev->dev, sizeof(struct buttons_dev),
+			    GFP_KERNEL);
 	poll_dev = input_allocate_polled_device();
 	if (!bdev || !poll_dev) {
 		error = -ENOMEM;
@@ -137,7 +138,6 @@ static int sgi_buttons_probe(struct platform_device *pdev)
 
  err_free_mem:
 	input_free_polled_device(poll_dev);
-	kfree(bdev);
 	return error;
 }
 
@@ -147,7 +147,6 @@ static int sgi_buttons_remove(struct platform_device *pdev)
 
 	input_unregister_polled_device(bdev->poll_dev);
 	input_free_polled_device(bdev->poll_dev);
-	kfree(bdev);
 
 	return 0;
 }
-- 
1.9.1

