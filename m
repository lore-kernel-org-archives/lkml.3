Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752847Ab3GEGDJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 02:03:09 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:19688 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751259Ab3GEGDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 02:03:07 -0400
Date: Fri, 5 Jul 2013 09:02:31 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Matt Porter <mporter@kernel.crashing.org>
Cc: Alexandre Bounine <alexandre.bounine@idt.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] rapidio: use after free in unregister function
Message-ID: <20130705060231.GA14443@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to use the _safe version of list_for_each_entry() because we
are freeing the iterator.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/rapidio/rio.c b/drivers/rapidio/rio.c
index f4f30af..84ac64a 100644
--- a/drivers/rapidio/rio.c
+++ b/drivers/rapidio/rio.c
@@ -1701,7 +1701,7 @@ EXPORT_SYMBOL_GPL(rio_register_scan);
 int rio_unregister_scan(int mport_id, struct rio_scan *scan_ops)
 {
 	struct rio_mport *port;
-	struct rio_scan_node *scan;
+	struct rio_scan_node *scan, *tmp;
 
 	pr_debug("RIO: %s for mport_id=%d\n", __func__, mport_id);
 
@@ -1715,7 +1715,7 @@ int rio_unregister_scan(int mport_id, struct rio_scan *scan_ops)
 		    (mport_id == RIO_MPORT_ANY && port->nscan == scan_ops))
 			port->nscan = NULL;
 
-	list_for_each_entry(scan, &rio_scans, node)
+	list_for_each_entry_safe(scan, tmp, &rio_scans, node)
 		if (scan->mport_id == mport_id) {
 			list_del(&scan->node);
 			kfree(scan);
