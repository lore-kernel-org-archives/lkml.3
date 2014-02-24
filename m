Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752928AbaBXIDe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 03:03:34 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:18224 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752868AbaBXID1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 03:03:27 -0500
From: Neil Zhang <zhangwm@marvell.com>
To: <balbi@ti.com>, <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: Neil Zhang <zhangwm@marvell.com>
Subject: [PATCH 4/6] usb: gadget: mv_udc: check endpoint before queue dtd
Date: Mon, 24 Feb 2014 16:03:14 +0800
Message-ID: <1393228996-14787-5-git-send-email-zhangwm@marvell.com>
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

There is a corner case that endpoint is disabled by system shutdown
between check ep->desc and hold spin lock in mv_ep_queue. In this
case ep->ep.desc will be NULL and occur kernel panic when access
it in build_dtd.

Signed-off-by: Neil Zhang <zhangwm@marvell.com>
---
 drivers/usb/gadget/mv_udc_core.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/usb/gadget/mv_udc_core.c b/drivers/usb/gadget/mv_udc_core.c
index d5a9bdf..a620cff 100644
--- a/drivers/usb/gadget/mv_udc_core.c
+++ b/drivers/usb/gadget/mv_udc_core.c
@@ -734,6 +734,14 @@ mv_ep_queue(struct usb_ep *_ep, struct usb_request *_req, gfp_t gfp_flags)
 
 	spin_lock_irqsave(&udc->lock, flags);
 
+	if (!ep->ep.desc) {
+		spin_unlock_irqrestore(&udc->lock, flags);
+		dev_info(&udc->dev->dev,
+			"%s is already disabled!\n", ep->name);
+		retval = -EINVAL;
+		goto err_unmap_dma;
+	}
+
 	/* build dtds and push them to device queue */
 	if (!req_to_dtd(req)) {
 		retval = queue_dtd(ep, req);
-- 
1.7.9.5

