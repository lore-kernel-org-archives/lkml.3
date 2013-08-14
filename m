Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760259Ab3HNVgb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 17:36:31 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:38304 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760012Ab3HNVga (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 17:36:30 -0400
Date: Wed, 14 Aug 2013 16:36:25 -0500
From: "Philip J. Kelleher" <pjk1939@linux.vnet.ibm.com>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, brking@linux.vnet.ibm.com
Subject: [PATCH 4/5] rsxx: Removing IDA on driver unload.
Message-ID: <20130814213625.GE26562@oc6784271780.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13081421-0320-0000-0000-000000ADBBA4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Philip J Kelleher <pjk1939@linux.vnet.ibm.com>

The rsxx driver was not releasing the IDA entry during
driver unload. This would be a big problem on a DLPAR
remove where the card is remove from the LPAR but the
driver is still loaded. This patch fixes that issue.

Signed-off-by: Philip J Kelleher <pjk1939@linux.vnet.ibm.com>
-------------------------------------------------------------------------------


 
diff -uprN -X linux-block-vanilla/Documentation/dontdiff linux-block-vanilla/drivers/block/rsxx/core.c linux-block/drivers/block/rsxx/core.c
--- linux-block-vanilla/drivers/block/rsxx/core.c	2013-08-12 15:30:57.959857895 -0500
+++ linux-block/drivers/block/rsxx/core.c	2013-08-12 15:31:12.833861866 -0500
@@ -1101,6 +1101,10 @@ static void rsxx_pci_remove(struct pci_d
 	pci_disable_device(dev);
 	pci_release_regions(dev);
 
+	spin_lock(&rsxx_ida_lock);
+	ida_remove(&rsxx_disk_ida, card->disk_id);
+	spin_unlock(&rsxx_ida_lock);
+
 	kfree(card);
 }
 

