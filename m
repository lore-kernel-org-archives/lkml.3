Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760398Ab3HNVhW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 17:37:22 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:46396 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760185Ab3HNVhU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 17:37:20 -0400
Date: Wed, 14 Aug 2013 16:37:13 -0500
From: "Philip J. Kelleher" <pjk1939@linux.vnet.ibm.com>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, brking@linux.vnet.ibm.com
Subject: [PATCH 5/5] rsxx: Correcting return values during failure scenarios.
Message-ID: <20130814213713.GF26562@oc6784271780.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13081421-5806-0000-0000-0000226DC3D3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Philip J Kelleher <pjk1939@linux.vnet.ibm.com>

The rsxx driver is returning the wrong values during
copy_from_user and copy_to_user. It, also, is not
setting ENOMEM during a failed workqueue allocation.

Signed-off-by: Philip J Kelleher <pjk1939@linux.vnet.ibm.com>
-------------------------------------------------------------------------------


diff -uprN -X linux-block-vanilla/Documentation/dontdiff linux-block-vanilla/drivers/block/rsxx/core.c linux-block/drivers/block/rsxx/core.c
--- linux-block-vanilla/drivers/block/rsxx/core.c	2013-08-12 15:32:49.468858233 -0500
+++ linux-block/drivers/block/rsxx/core.c	2013-08-12 15:33:03.600861005 -0500
@@ -199,9 +199,8 @@ static ssize_t rsxx_cram_read(struct fil
 	if (st)
 		return st;
 
-	st = copy_to_user(ubuf, buf, cnt);
-	if (st)
-		return st;
+	if (copy_to_user(ubuf, buf, cnt))
+		return -EFAULT;
 
 	info->offset += cnt;
 
@@ -222,9 +221,8 @@ static ssize_t rsxx_cram_write(struct fi
 	if (!buf)
 		return -ENOMEM;
 
-	st = copy_from_user(buf, ubuf, cnt);
-	if (st)
-		return st;
+	if (copy_from_user(buf, ubuf, cnt))
+		return -EFAULT;
 
 	info->f_pos = (u32)*ppos + info->offset;
 
@@ -942,6 +940,7 @@ static int rsxx_pci_probe(struct pci_dev
 	card->event_wq = create_singlethread_workqueue(DRIVER_NAME"_event");
 	if (!card->event_wq) {
 		dev_err(CARD_TO_DEV(card), "Failed card event setup.\n");
+		st = -ENOMEM;
 		goto failed_event_handler;
 	}
 

