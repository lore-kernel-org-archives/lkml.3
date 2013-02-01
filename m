Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757452Ab3BAU2p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 15:28:45 -0500
Received: from mail-vc0-f177.google.com ([209.85.220.177]:34599 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757411Ab3BAU2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 15:28:39 -0500
From: Konrad Rzeszutek Wilk <konrad@kernel.org>
To: dan.magenheimer@oracle.com, konrad.wilk@oracle.com,
        sjenning@linux.vnet.ibm.com, gregkh@linuxfoundation.org,
        akpm@linux-foundation.org, ngupta@vflare.org, rcj@linux.vnet.ibm.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: [PATCH 14/15] zcache/tmem: Better error checking on frontswap_register_ops return value.
Date: Fri,  1 Feb 2013 15:23:03 -0500
Message-Id: <1359750184-23408-15-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1359750184-23408-1-git-send-email-konrad.wilk@oracle.com>
References: <1359750184-23408-1-git-send-email-konrad.wilk@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the past it either used to be NULL or the "older" backend. Now we
also return -Exx error codes.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/staging/zcache/zcache-main.c | 5 ++++-
 drivers/xen/tmem.c                   | 5 ++++-
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/zcache/zcache-main.c b/drivers/staging/zcache/zcache-main.c
index 288c841..79c10af 100644
--- a/drivers/staging/zcache/zcache-main.c
+++ b/drivers/staging/zcache/zcache-main.c
@@ -1826,8 +1826,11 @@ static int zcache_init(void)
 			namestr, frontswap_has_exclusive_gets,
 			!disable_frontswap_ignore_nonactive);
 #endif
-		if (old_ops != NULL)
+		if (IS_ERR(old_ops) || old_ops) {
+			if (IS_ERR(old_ops))
+				return PTR_RET(old_ops);
 			pr_warn("%s: frontswap_ops overridden\n", namestr);
+		}
 	}
 	if (ramster_enabled)
 		ramster_init(!disable_cleancache, !disable_frontswap,
diff --git a/drivers/xen/tmem.c b/drivers/xen/tmem.c
index 9a4a9ec..2f939e5 100644
--- a/drivers/xen/tmem.c
+++ b/drivers/xen/tmem.c
@@ -395,8 +395,11 @@ static int xen_tmem_init(void)
 			frontswap_register_ops(&tmem_frontswap_ops);
 
 		tmem_frontswap_poolid = -1;
-		if (old_ops)
+		if (IS_ERR(old_ops) || old_ops) {
+			if (IS_ERR(old_ops))
+				return PTR_ERR(old_ops);
 			s = " (WARNING: frontswap_ops overridden)";
+		}
 		printk(KERN_INFO "frontswap enabled, RAM provided by "
 				 "Xen Transcendent Memory\n");
 	}
-- 
1.7.11.7

