Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757791Ab3EBAb3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 20:31:29 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:40153 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752838Ab3EBAb1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 20:31:27 -0400
Date: Wed, 1 May 2013 19:31:19 -0500
From: "Philip J. Kelleher" <pjk1939@linux.vnet.ibm.com>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, klebers@linux.vnet.ibm.com,
        brking@linux.vnet.ibm.com
Subject: [PATCH 7/8] rsxx: Adding EEH check inside cregs timeout.
Message-ID: <20130502003119.GA6657@oc6784271780.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13050200-5806-0000-0000-000020F6EA62
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Philip J Kelleher <pjk1939@linux.vnet.ibm.com>

Unfortunaly, our CPU register path does not do any kind of
EEH error checking. So to fix this issue, an ioread32 was
added to the CPU register timeout code. This way, the
driver can check to see if the timeout was caused by an EEH
error or not.

Signed-off-by: Philip J Kelleher <pjk1939@linux.vnet.ibm.com>
-------------------------------------------------------------------------------


diff -uprN -X linux-block-vanilla/Documentation/dontdiff linux-block-vanilla/drivers/block/rsxx/cregs.c linux-block/drivers/block/rsxx/cregs.c
--- linux-block-vanilla/drivers/block/rsxx/cregs.c	2013-05-01 18:36:44.693307317 -0500
+++ linux-block/drivers/block/rsxx/cregs.c	2013-05-01 18:59:57.596197150 -0500
@@ -431,6 +431,15 @@ static int __issue_creg_rw(struct rsxx_c
 	*hw_stat = completion.creg_status;
 
 	if (completion.st) {
+		/*
+		 * This read is needed to verify that there has not been any
+		 * extreme errors that might have occurred, i.e. EEH. The
+		 * function iowrite32 will not detect EEH errors, so it is
+		 * necessary that we recover if such an error is the reason
+		 * for the timeout.
+		 */
+		ioread32(card->regmap + SCRATCH);
+
 		dev_warn(CARD_TO_DEV(card),
 			"creg command failed(%d x%08x)\n",
 			completion.st, addr);

