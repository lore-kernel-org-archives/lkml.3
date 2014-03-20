Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933488AbaCTOL0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 10:11:26 -0400
Received: from e06smtp11.uk.ibm.com ([195.75.94.107]:43080 "EHLO
	e06smtp11.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932685AbaCTOLP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 10:11:15 -0400
From: Frank Haverkamp <haver@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, arnd@arndb.de, cody@linux.vnet.ibm.com,
        schwidefsky@de.ibm.com, utz.bacher@de.ibm.com, jsvogt@de.ibm.com,
        MIJUNG@de.ibm.com, cascardo@linux.vnet.ibm.com, michael@ibmra.de,
        colin.king@canonical.com, bjking1@us.ibm.com, esa@de.ibm.com,
        haver@linux.vnet.ibm.com
Subject: [PATCH 2/5] GenWQE: Add wmb before DDCB is started
Date: Thu, 20 Mar 2014 15:11:03 +0100
Message-Id: <1395324666-27153-2-git-send-email-haver@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1395324666-27153-1-git-send-email-haver@linux.vnet.ibm.com>
References: <1395324666-27153-1-git-send-email-haver@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14032014-5024-0000-0000-00000937DB56
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Needed to add wmb() before we send the DDCB for execution.
Without the syncronizing it failed on System p.

Signed-off-by: Frank Haverkamp <haver@linux.vnet.ibm.com>
---
 drivers/misc/genwqe/card_ddcb.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/misc/genwqe/card_ddcb.c
+++ b/drivers/misc/genwqe/card_ddcb.c
@@ -305,6 +305,8 @@ static int enqueue_ddcb(struct genwqe_de
 			break;
 
 		new = (old | DDCB_NEXT_BE32);
+
+		wmb();
 		icrc_hsi_shi = cmpxchg(&prev_ddcb->icrc_hsi_shi_32, old, new);
 
 		if (icrc_hsi_shi == old)
@@ -314,6 +316,8 @@ static int enqueue_ddcb(struct genwqe_de
 	/* Queue must be re-started by updating QUEUE_OFFSET */
 	ddcb_mark_tapped(pddcb);
 	num = (u64)ddcb_no << 8;
+
+	wmb();
 	__genwqe_writeq(cd, queue->IO_QUEUE_OFFSET, num); /* start queue */
 
 	return RET_DDCB_TAPPED;

