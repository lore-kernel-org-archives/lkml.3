Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755287Ab3HXRNZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Aug 2013 13:13:25 -0400
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:15091
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750861Ab3HXRNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Aug 2013 13:13:24 -0400
X-IronPort-AV: E=Sophos;i="4.89,947,1367964000"; 
   d="scan'208";a="24669911"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: linux-spi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        rtc-linux@googlegroups.com
Subject: [PATCH 0/2] simplify devm_request_mem_region/devm_ioremap
Date: Sat, 24 Aug 2013 19:13:14 +0200
Message-Id: <1377364396-27861-1-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert the composition of devm_request_mem_region and devm_ioremap to a
single call to devm_ioremap_resource.  The associated call to
platform_get_resource is also simplified and moved next to the new call to
devm_ioremap_resource.

The semantic patch used to perform this transformation is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@r@
expression dev,res,size,name,base;
identifier l;
@@

-if (!devm_request_mem_region(dev, res->start, size, name))
- { ... \(goto l;\|return ...;\) }
... when != res->start
base =
(
-devm_ioremap(dev,res->start,size)
+devm_request_and_ioremap(dev,res)
|
-devm_ioremap_nocache(dev,res->start,size)
+devm_request_and_ioremap(dev,res)
)
... when any
    when != res->start

@@
expression pdev,res,n,r.base,e1,e2;
identifier l,f,res1;
type T;
@@

(
(
  T res1 = f(pdev, IORESOURCE_MEM, n);
|
  res1 = f(pdev, IORESOURCE_MEM, n);
)
- if (res1 == NULL) { ... \(goto l;\|return ...;\) }
  base = devm_request_and_ioremap(e1, res1);
|
(
- res = f(pdev, IORESOURCE_MEM, n);
|
  T res1
-  = f(pdev, IORESOURCE_MEM, n)
  ;
)
  ... when != res
(
- if (res == NULL) { ... \(goto l;\|return ...;\) }
|
 if (
-     res == NULL ||
      e2
    ) { ... \(goto l;\|return ...;\) }
)
  ... when != res
+ res = f(pdev, IORESOURCE_MEM, n);
  base = devm_request_and_ioremap(e1, res);
)

@@
expression r.base, dev, res;
@@

base = 
- devm_request_and_ioremap
+ devm_ioremap_resource
 (dev, res);
 ...
 if (
-base == NULL
+IS_ERR(base)
 || ...) {
<...
-	return ...;
+	return PTR_ERR(base);
...>
 }

@@
expression r.base, dev, res;
@@

base = 
- devm_request_and_ioremap
+ devm_ioremap_resource
 (dev, res);

@@
expression r.base, E, ret;
identifier l;
@@

 base = devm_ioremap_resource(...);
 ...
 if (IS_ERR(base) || ...) {
 	... when any
-	ret = E;
+	ret = PTR_ERR(base);
 	...
(
 	return ret;
|
 	goto l;
)
 }

@@
expression r.base;
@@

 base = devm_ioremap_resource(...);
 ...
 if (IS_ERR(base) || ...) {
 	<...
-	\(dev_dbg\|dev_warn\|dev_err\|pr_debug\|pr_err\|DRM_ERROR\)(...);
 	...>
 }

@@
expression r.base;
identifier l;
@@

 base = devm_ioremap_resource(...);
 ...
 if (IS_ERR(base) || ...)
-{
(
 	return ...;
|
 	goto l;
)
-}
// </smpl>


