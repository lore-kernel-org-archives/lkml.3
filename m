Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934177Ab3GWUTf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 16:19:35 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:33407 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932447Ab3GWUTe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 16:19:34 -0400
Date: Tue, 23 Jul 2013 15:19:28 -0500
From: "Philip J. Kelleher" <pjk1939@linux.vnet.ibm.com>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] rsxx: Correcting return values during failure scenarios.
Message-ID: <20130723201927.GD12914@oc6784271780.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13072320-5806-0000-0000-00002229A13C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Philip J Kelleher <pjk1939@linux.vnet.ibm.com>

The driver is returning the wrong values during
copy_from_user and copy_to_user. It, also, is not
setting ENOMEM during a failed workqueue allocation.

Signed-off-by: Philip J Kelleher <pjk1939@linux.vnet.ibm.com>
-------------------------------------------------------------------------------


diff -uprN -X linux-block-vanilla/Documentation/dontdiff linux-block-vanilla/drivers/block/rsxx/core.c linux-block/drivers/block/rsxx/core.c
--- linux-block-vanilla/drivers/block/rsxx/core.c	2013-07-23 10:43:46.182724965 -0500
+++ linux-block/drivers/block/rsxx/core.c	2013-07-23 10:46:25.646465285 -0500
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
 
@@ -946,6 +944,7 @@ static int rsxx_pci_probe(struct pci_dev
 	card->event_wq = create_singlethread_workqueue(DRIVER_NAME"_event");
 	if (!card->event_wq) {
 		dev_err(CARD_TO_DEV(card), "Failed card event setup.\n");
+		st = -ENOMEM;
 		goto failed_event_handler;
 	}
 

