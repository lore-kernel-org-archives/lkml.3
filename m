Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756897Ab3FSOt0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 10:49:26 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:20382 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756637Ab3FSOtZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 10:49:25 -0400
Date: Wed, 19 Jun 2013 17:49:04 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Alessandro Rubini <rubini@gnudd.com>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] FMC: NULL dereference on allocation failure
Message-ID: <20130619144904.GA10484@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we don't allocate "arr" then the cleanup path will dereference it and
oops.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/fmc/fmc-sdb.c b/drivers/fmc/fmc-sdb.c
index 74fb326..79adc39 100644
--- a/drivers/fmc/fmc-sdb.c
+++ b/drivers/fmc/fmc-sdb.c
@@ -46,16 +46,17 @@ static struct sdb_array *__fmc_scan_sdb_tree(struct fmc_device *fmc,
 	onew = __sdb_rd(fmc, sdb_addr + 4, convert);
 	n = __be16_to_cpu(*(uint16_t *)&onew);
 	arr = kzalloc(sizeof(*arr), GFP_KERNEL);
-	if (arr) {
-		arr->record = kzalloc(sizeof(arr->record[0]) * n, GFP_KERNEL);
-		arr->subtree = kzalloc(sizeof(arr->subtree[0]) * n, GFP_KERNEL);
-	}
-	if (!arr || !arr->record || !arr->subtree) {
+	if (!arr)
+		return ERR_PTR(-ENOMEM);
+	arr->record = kzalloc(sizeof(arr->record[0]) * n, GFP_KERNEL);
+	arr->subtree = kzalloc(sizeof(arr->subtree[0]) * n, GFP_KERNEL);
+	if (!arr->record || !arr->subtree) {
 		kfree(arr->record);
 		kfree(arr->subtree);
 		kfree(arr);
 		return ERR_PTR(-ENOMEM);
 	}
+
 	arr->len = n;
 	arr->level = level;
 	arr->fmc = fmc;
