Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933837Ab3GEUjp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 16:39:45 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:46636 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752374Ab3GEUjn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 16:39:43 -0400
Date: Fri, 5 Jul 2013 23:39:08 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Matt Porter <mporter@kernel.crashing.org>
Cc: Alexandre Bounine <alexandre.bounine@idt.com>,
        Ryan Mallon <rmallon@gmail.com>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [patch v2] rapidio: use after free in unregister function
Message-ID: <20130705203908.GA7594@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51D67066.9070105@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We're freeing the list iterator so we can't move to the next entry.
Since there is only one matching mport_id, we can just break after
finding it.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
v2: cleaner fix than v1

diff --git a/drivers/rapidio/rio.c b/drivers/rapidio/rio.c
index f4f30af..2e8a20c 100644
--- a/drivers/rapidio/rio.c
+++ b/drivers/rapidio/rio.c
@@ -1715,11 +1715,13 @@ int rio_unregister_scan(int mport_id, struct rio_scan *scan_ops)
 		    (mport_id == RIO_MPORT_ANY && port->nscan == scan_ops))
 			port->nscan = NULL;
 
-	list_for_each_entry(scan, &rio_scans, node)
+	list_for_each_entry(scan, &rio_scans, node) {
 		if (scan->mport_id == mport_id) {
 			list_del(&scan->node);
 			kfree(scan);
+			break;
 		}
+	}
 
 	mutex_unlock(&rio_mport_list_lock);
 
