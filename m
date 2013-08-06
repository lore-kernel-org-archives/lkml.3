Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756520Ab3HFVLd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 17:11:33 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:34100 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755428Ab3HFVLa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 17:11:30 -0400
Date: Tue, 6 Aug 2013 16:10:58 -0500
From: "Philip J. Kelleher" <pjk1939@linux.vnet.ibm.com>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] rsxx: Removing IDA on driver unload.
Message-ID: <20130806211058.GC4939@oc6784271780.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13080621-5518-0000-0000-000010F50065
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
--- linux-block-vanilla/drivers/block/rsxx/core.c	2013-07-23 10:11:20.943772116 -0500
+++ linux-block/drivers/block/rsxx/core.c	2013-07-23 10:14:50.402462948 -0500
@@ -1105,6 +1105,10 @@ static void rsxx_pci_remove(struct pci_d
 	pci_disable_device(dev);
 	pci_release_regions(dev);
 
+	spin_lock(&rsxx_ida_lock);
+	ida_remove(&rsxx_disk_ida, card->disk_id);
+	spin_unlock(&rsxx_ida_lock);
+
 	kfree(card);
 }
 

