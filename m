Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752949AbaBXIDh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 03:03:37 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:40441 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752876AbaBXIDf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 03:03:35 -0500
From: Neil Zhang <zhangwm@marvell.com>
To: <balbi@ti.com>, <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: Neil Zhang <zhangwm@marvell.com>
Subject: [PATCH 6/6] USB: gadget: mv_udc: fix corner case for missiong dTD
Date: Mon, 24 Feb 2014 16:03:16 +0800
Message-ID: <1393228996-14787-7-git-send-email-zhangwm@marvell.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1393228996-14787-1-git-send-email-zhangwm@marvell.com>
References: <1393228996-14787-1-git-send-email-zhangwm@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.87,1.0.14,0.0.0000
 definitions=2014-02-23_03:2014-02-21,2014-02-23,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1305240000 definitions=main-1402230265
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the missing dTD issue is triggerred, queue_dtd may prime the new
request instead of the missing dTD.
We can just add the request to the queue end and jump out if there are
more than one request in the queue already.

Signed-off-by: Neil Zhang <zhangwm@marvell.com>
---
 drivers/usb/gadget/mv_udc_core.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/mv_udc_core.c b/drivers/usb/gadget/mv_udc_core.c
index 8df8606..918b603 100644
--- a/drivers/usb/gadget/mv_udc_core.c
+++ b/drivers/usb/gadget/mv_udc_core.c
@@ -295,13 +295,23 @@ static int queue_dtd(struct mv_ep *ep, struct mv_req *req)
 
 	/* check if the pipe is empty */
 	if (!(list_empty(&ep->queue))) {
-		struct mv_req *lastreq;
+		struct mv_req *firstreq, *lastreq;
+		firstreq = list_entry(ep->queue.next, struct mv_req, queue);
 		lastreq = list_entry(ep->queue.prev, struct mv_req, queue);
 		lastreq->tail->dtd_next =
 			req->head->td_dma & EP_QUEUE_HEAD_NEXT_POINTER_MASK;
 
 		wmb();
 
+		/*
+		 * If there are more than one reqs in the queue,
+		 * then it's safe to just add it to the list end.
+		 * It should be able to handle the missing DTD issue.
+		 * And suppose it can improve the performance too.
+		 */
+		if (firstreq != lastreq)
+			goto done;
+
 		if (readl(&udc->op_regs->epprime) & bit_pos)
 			goto done;
 
-- 
1.7.9.5

