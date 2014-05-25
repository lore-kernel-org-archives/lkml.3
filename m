Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751441AbaEYSur (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2014 14:50:47 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53563 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075AbaEYSuq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2014 14:50:46 -0400
Date: Mon, 26 May 2014 00:20:38 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: julia.lawall@lip6.fr, David Miller <davem@davemloft.net>
Subject: [PATCH v2] ehea: Introduce the use of the managed version of kzalloc
Message-ID: <20140525185037.GA3041@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves data allocated using kzalloc to managed data allocated
using devm_kzalloc and cleans now unnecessary kfrees in probe and remove
functions. Also, linux/device.h is added to make sure the devm_*()
routine declarations are unambiguously available.

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
---
Not compiled due to incompatible architecture

v2: add linux/device.h include
 drivers/net/ethernet/ibm/ehea/ehea_main.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ehea/ehea_main.c b/drivers/net/ethernet/ibm/ehea/ehea_main.c
index 538903b..a25f3c6 100644
--- a/drivers/net/ethernet/ibm/ehea/ehea_main.c
+++ b/drivers/net/ethernet/ibm/ehea/ehea_main.c
@@ -29,6 +29,7 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/in.h>
+#include<linux/device.h>
 #include <linux/ip.h>
 #include <linux/tcp.h>
 #include <linux/udp.h>
@@ -3273,7 +3274,7 @@ static int ehea_probe_adapter(struct platform_device *dev)
 		return -EINVAL;
 	}
 
-	adapter = kzalloc(sizeof(*adapter), GFP_KERNEL);
+	adapter = devm_kzalloc(&dev->dev, sizeof(*adapter), GFP_KERNEL);
 	if (!adapter) {
 		ret = -ENOMEM;
 		dev_err(&dev->dev, "no mem for ehea_adapter\n");
@@ -3359,7 +3360,6 @@ out_kill_eq:
 
 out_free_ad:
 	list_del(&adapter->list);
-	kfree(adapter);
 
 out:
 	ehea_update_firmware_handles();
@@ -3386,7 +3386,6 @@ static int ehea_remove(struct platform_device *dev)
 	ehea_destroy_eq(adapter->neq);
 	ehea_remove_adapter_mr(adapter);
 	list_del(&adapter->list);
-	kfree(adapter);
 
 	ehea_update_firmware_handles();
 
-- 
1.9.1

