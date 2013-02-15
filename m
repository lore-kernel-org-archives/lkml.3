Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751854Ab3BOUVA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 15:21:00 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:51200 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237Ab3BOUUz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 15:20:55 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: dan.magenheimer@oracle.com, sjenning@linux.vnet.ibm.com,
        gregkh@linuxfoundation.org, akpm@linux-foundation.org,
        ngupta@vflare.org, rcj@linux.vnet.ibm.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        minchan@kernel.org
Cc: ric.masonn@gmail.com, lliubbo@gmail.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 11/11] zcache/tmem: Better error checking on frontswap_register_ops return value.
Date: Fri, 15 Feb 2013 15:20:35 -0500
Message-Id: <1360959635-18922-12-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.8.0.2
In-Reply-To: <1360959635-18922-1-git-send-email-konrad.wilk@oracle.com>
References: <1360959635-18922-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
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
index 3554987..48e46c5 100644
--- a/drivers/staging/zcache/zcache-main.c
+++ b/drivers/staging/zcache/zcache-main.c
@@ -2006,8 +2006,11 @@ static int __init zcache_init(void)
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
1.8.0.2

