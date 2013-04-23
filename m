Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757385Ab3DWQcN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 12:32:13 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:63142 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757234Ab3DWQcJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 12:32:09 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Nitin Gupta <ngupta@vflare.org>
Subject: [PATCH 16/21] staging/zsmalloc: don't use pgtable-mapping from modules
Date: Tue, 23 Apr 2013 18:30:48 +0200
Message-Id: <1366734653-488286-17-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1366734653-488286-1-git-send-email-arnd@arndb.de>
References: <1366734653-488286-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:xIo56AkjYml3DME6MwtW6uSAHF+jSbRRtp/qLxKpVBS
 HshJ7VfcKztfPtEeoDCJSJguN58jMQ3jnm9Zd1iKTNT7TzhQBR
 fOQJtH6v9a5FMes8zMlEX76WX7leuN4ChrABQgmDIEjVs0p4yG
 +3D2rA5uLjwL0SyHzn9K2TJsGFb87EJA4DqfRp2dKvRA5YxgP+
 AZc6f0GAsDLDrwKmQ+LoxRME06hrMFH+lP5BlBQGzigCNWNvHl
 OHbpNk8WOOtU8tKts5WozikPhbPdwbRnQqrXGCuxCE1/1Q6zGA
 dTpzxOThrPUTT0gCjJGKzvdzIF9ZiiHdLEArCxO51EhIGbilvk
 v52XBsiDmvHMCzJjjelF3NRzi8K+gnzgXr7woxtf0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Building zsmalloc as a module does not work on ARM because it uses
an interface that is not exported:

ERROR: "flush_tlb_kernel_range" [drivers/staging/zsmalloc/zsmalloc.ko] undefined!

Since this is only used as a performance optimization and only on ARM,
we can avoid the problem simply by not using that optimization when
building zsmalloc it is a loadable module.

flush_tlb_kernel_range is often an inline function, but out of the
architectures that use an extern function, only powerpc exports
it.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Seth Jennings <sjenning@linux.vnet.ibm.com>
Cc: Nitin Gupta <ngupta@vflare.org>
---
 drivers/staging/zsmalloc/zsmalloc-main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/zsmalloc/zsmalloc-main.c b/drivers/staging/zsmalloc/zsmalloc-main.c
index e78d262..291c1d8 100644
--- a/drivers/staging/zsmalloc/zsmalloc-main.c
+++ b/drivers/staging/zsmalloc/zsmalloc-main.c
@@ -225,7 +225,7 @@ struct zs_pool {
  * so that USE_PGTABLE_MAPPING is defined. This causes zsmalloc to use
  * page table mapping rather than copying for object mapping.
 */
-#if defined(CONFIG_ARM)
+#if defined(CONFIG_ARM) && !defined(MODULE)
 #define USE_PGTABLE_MAPPING
 #endif
 
-- 
1.8.1.2

