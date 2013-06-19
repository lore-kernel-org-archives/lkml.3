Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757086Ab3FSQBU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 12:01:20 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:19242 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756860Ab3FSQBS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 12:01:18 -0400
Date: Wed, 19 Jun 2013 19:01:01 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alessandro Rubini <rubini@gnudd.com>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch -next] FMC: NULL dereference on allocation failure
Message-ID: <20130619160101.GA29108@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130619155731.GA4957@mwanda>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we don't allocate "arr" then the cleanup path will dereference it and
oops.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Alessandro Rubini <rubini@gnudd.com>

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
--
To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
