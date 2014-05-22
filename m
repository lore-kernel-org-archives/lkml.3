Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752395AbaEVTek (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 15:34:40 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:43650 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131AbaEVTei (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 15:34:38 -0400
Date: Fri, 23 May 2014 01:04:30 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: julia.lawall@lip6.fr
Subject: [PATCH] dt/sparc: Introduce the use of the managed version of kzalloc
Message-ID: <20140522193430.GA16315@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves data allocated using kzalloc to managed data allocated
using devm_kzalloc and cleans now unnecessary kfrees in probe and remove
functions. Also the unnecessary labels are done away with.

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
+kfree(DROPME,e);
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

@label1@
identifier platform.probefn, l1, l2;
expression e;
@@
probefn(...) {
  <+...
  l1:kfree(DROPME, e);
  l2:
  ...+>
}

@rem_label depends on label1@
identifier platform.probefn,label1.l1,label1.l2;
expression e;
@@
probefn(...) {
 <+...
-goto l1;
+goto l2;
 ...
-l1:kfree(DROPME, e);
 ...+>
}

Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
---
Not compiled due to incompatible architecture.

 drivers/input/misc/sparcspkr.c | 29 +++++++++--------------------
 1 file changed, 9 insertions(+), 20 deletions(-)

diff --git a/drivers/input/misc/sparcspkr.c b/drivers/input/misc/sparcspkr.c
index 65fd315..da9cdc6 100644
--- a/drivers/input/misc/sparcspkr.c
+++ b/drivers/input/misc/sparcspkr.c
@@ -187,29 +187,28 @@ static int bbc_beep_probe(struct platform_device *op)
 	struct sparcspkr_state *state;
 	struct bbc_beep_info *info;
 	struct device_node *dp;
-	int err = -ENOMEM;
+	int err;
 
-	state = kzalloc(sizeof(*state), GFP_KERNEL);
+	state = devm_kzalloc(&op->dev, sizeof(*state), GFP_KERNEL);
 	if (!state)
-		goto out_err;
+		return -ENOMEM;
 
 	state->name = "Sparc BBC Speaker";
 	state->event = bbc_spkr_event;
 	spin_lock_init(&state->lock);
 
 	dp = of_find_node_by_path("/");
-	err = -ENODEV;
 	if (!dp)
-		goto out_free;
+		return -ENODEV;
 
 	info = &state->u.bbc;
 	info->clock_freq = of_getintprop_default(dp, "clock-frequency", 0);
 	if (!info->clock_freq)
-		goto out_free;
+		return -ENODEV;
 
 	info->regs = of_ioremap(&op->resource[0], 0, 6, "bbc beep");
 	if (!info->regs)
-		goto out_free;
+		return -ENODEV;
 
 	platform_set_drvdata(op, state);
 
@@ -222,9 +221,6 @@ static int bbc_beep_probe(struct platform_device *op)
 out_clear_drvdata:
 	of_iounmap(&op->resource[0], info->regs, 6);
 
-out_free:
-	kfree(state);
-out_err:
 	return err;
 }
 
@@ -241,8 +237,6 @@ static int bbc_remove(struct platform_device *op)
 
 	of_iounmap(&op->resource[0], info->regs, 6);
 
-	kfree(state);
-
 	return 0;
 }
 
@@ -271,9 +265,9 @@ static int grover_beep_probe(struct platform_device *op)
 	struct grover_beep_info *info;
 	int err = -ENOMEM;
 
-	state = kzalloc(sizeof(*state), GFP_KERNEL);
+	state = devm_kzalloc(&op->dev, sizeof(*state), GFP_KERNEL);
 	if (!state)
-		goto out_err;
+		return -ENOMEM;
 
 	state->name = "Sparc Grover Speaker";
 	state->event = grover_spkr_event;
@@ -282,7 +276,7 @@ static int grover_beep_probe(struct platform_device *op)
 	info = &state->u.grover;
 	info->freq_regs = of_ioremap(&op->resource[2], 0, 2, "grover beep freq");
 	if (!info->freq_regs)
-		goto out_free;
+		return -ENOMEM;
 
 	info->enable_reg = of_ioremap(&op->resource[3], 0, 1, "grover beep enable");
 	if (!info->enable_reg)
@@ -301,9 +295,6 @@ out_clear_drvdata:
 
 out_unmap_freq_regs:
 	of_iounmap(&op->resource[2], info->freq_regs, 2);
-out_free:
-	kfree(state);
-out_err:
 	return err;
 }
 
@@ -321,8 +312,6 @@ static int grover_remove(struct platform_device *op)
 	of_iounmap(&op->resource[3], info->enable_reg, 1);
 	of_iounmap(&op->resource[2], info->freq_regs, 2);
 
-	kfree(state);
-
 	return 0;
 }
 
-- 
1.9.1

