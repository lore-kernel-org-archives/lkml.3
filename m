Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756951Ab3HOPee (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 11:34:34 -0400
Received: from swan.laptop.org ([18.85.2.166]:39692 "EHLO swan.laptop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752860Ab3HOPed (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 11:34:33 -0400
From: Daniel Drake <dsd@laptop.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, dilinger@queued.net
Subject: [PATCH v2] olpc-ec: initialise earlier
Message-Id: <20130815153548.64219FAB06@dev.laptop.org>
Date: Thu, 15 Aug 2013 11:35:47 -0400 (EDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Being a low-level component, various drivers (e.g. olpc-battery) assume that
it is ok to communicate with the OLPC Embedded Controller during probe.
Therefore the OLPC EC driver must be initialised before other drivers try to
use it. This was the case until it was recently moved out of arch/x86 and
restructured (around commits ac2504151f5af27bbf0c0362b7da5951e05dfc43 and
85f90cf6ca569b19cee212844b543a7355b77163).

Use arch_initcall so that olpc-ec is readied earlier, matching the
previous behaviour.

Fixes a regression introduced in Linux-3.6 where various drivers such as
olpc-battery and olpc-xo1-sci failed to load due to an inability to
communicate with the EC. The user-visible effect was a lack of battery
monitoring, missing ebook/lid switch input devices, etc.

Signed-off-by: Daniel Drake <dsd@laptop.org>
---
 drivers/platform/olpc/olpc-ec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

v2: more informative commit message, thanks Andrew Morton

diff --git a/drivers/platform/olpc/olpc-ec.c b/drivers/platform/olpc/olpc-ec.c
index 0f9f859..f911952 100644
--- a/drivers/platform/olpc/olpc-ec.c
+++ b/drivers/platform/olpc/olpc-ec.c
@@ -330,7 +330,7 @@ static int __init olpc_ec_init_module(void)
 	return platform_driver_register(&olpc_ec_plat_driver);
 }
 
-module_init(olpc_ec_init_module);
+arch_initcall(olpc_ec_init_module);
 
 MODULE_AUTHOR("Andres Salomon <dilinger@queued.net>");
 MODULE_LICENSE("GPL");
-- 
1.8.3.1

