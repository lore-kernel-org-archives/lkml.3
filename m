Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757908AbaEPT2M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 15:28:12 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:56930 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754932AbaEPT2J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 15:28:09 -0400
Date: Sat, 17 May 2014 00:58:02 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: julia.lawall@lip6.fr
Subject: [PATCH] Input: Introduce the use of the managed version of kzalloc
Message-ID: <20140516192802.GA16211@himangi-Dell>
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
Can I make the code simpler by changing the code:
        poll_dev = input_allocate_polled_device();
        if (!poll_dev) {
                error = -ENOMEM;
                goto failed;
        }
to have only return -ENOMEM as there is no error message for failure of
kzalloc and the call to input_free_polled_device does nothing when
poll_dev is null.

 drivers/input/keyboard/jornada680_kbd.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/input/keyboard/jornada680_kbd.c b/drivers/input/keyboard/jornada680_kbd.c
index 69b1f00..02c8f5b 100644
--- a/drivers/input/keyboard/jornada680_kbd.c
+++ b/drivers/input/keyboard/jornada680_kbd.c
@@ -185,7 +185,8 @@ static int jornada680kbd_probe(struct platform_device *pdev)
 	struct input_dev *input_dev;
 	int i, error;
 
-	jornadakbd = kzalloc(sizeof(struct jornadakbd), GFP_KERNEL);
+	jornadakbd = devm_kzalloc(&pdev->dev, sizeof(struct jornadakbd),
+				  GFP_KERNEL);
 	if (!jornadakbd)
 		return -ENOMEM;
 
@@ -233,7 +234,6 @@ static int jornada680kbd_probe(struct platform_device *pdev)
 	printk(KERN_ERR "Jornadakbd: failed to register driver, error: %d\n",
 		error);
 	input_free_polled_device(poll_dev);
-	kfree(jornadakbd);
 	return error;
 
 }
@@ -244,7 +244,6 @@ static int jornada680kbd_remove(struct platform_device *pdev)
 
 	input_unregister_polled_device(jornadakbd->poll_dev);
 	input_free_polled_device(jornadakbd->poll_dev);
-	kfree(jornadakbd);
 
 	return 0;
 }
-- 
1.9.1

