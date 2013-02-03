Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753932Ab3BCB3o (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 20:29:44 -0500
Received: from mail-da0-f44.google.com ([209.85.210.44]:34905 "EHLO
	mail-da0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753840Ab3BCBWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 20:22:23 -0500
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au, bfields@fieldses.org,
        skinsbursky@parallels.com, ebiederm@xmission.com, jmorris@namei.org,
        axboe@kernel.dk, Tejun Heo <tj@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Alex Dubov <oakad@yahoo.com>
Subject: [PATCH 35/62] misc/tifm_core: convert to idr_alloc()
Date: Sat,  2 Feb 2013 17:20:36 -0800
Message-Id: <1359854463-2538-36-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1359854463-2538-1-git-send-email-tj@kernel.org>
References: <1359854463-2538-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert to the much saner new idr interface.

Only compile tested.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Alex Dubov <oakad@yahoo.com>
---
This patch depends on an earlier idr changes and I think it would be
best to route these together through -mm.  Please holler if there's
any objection.  Thanks.

 drivers/misc/tifm_core.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/misc/tifm_core.c b/drivers/misc/tifm_core.c
index 0bd5349..0ab7c92 100644
--- a/drivers/misc/tifm_core.c
+++ b/drivers/misc/tifm_core.c
@@ -196,13 +196,14 @@ int tifm_add_adapter(struct tifm_adapter *fm)
 {
 	int rc;
 
-	if (!idr_pre_get(&tifm_adapter_idr, GFP_KERNEL))
-		return -ENOMEM;
-
+	idr_preload(GFP_KERNEL);
 	spin_lock(&tifm_adapter_lock);
-	rc = idr_get_new(&tifm_adapter_idr, fm, &fm->id);
+	rc = idr_alloc(&tifm_adapter_idr, fm, 0, 0, GFP_NOWAIT);
+	if (rc >= 0)
+		fm->id = rc;
 	spin_unlock(&tifm_adapter_lock);
-	if (rc)
+	idr_preload_end();
+	if (rc < 0)
 		return rc;
 
 	dev_set_name(&fm->dev, "tifm%u", fm->id);
-- 
1.8.1

