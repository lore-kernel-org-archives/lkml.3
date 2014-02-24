Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753112AbaBXIFC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 03:05:02 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:27347 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752415AbaBXID0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 03:03:26 -0500
From: Neil Zhang <zhangwm@marvell.com>
To: <balbi@ti.com>, <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: Neil Zhang <zhangwm@marvell.com>
Subject: [PATCH 3/6] usb: gadget: mv_udc: clear corresponding interrupt when flush fifo
Date: Mon, 24 Feb 2014 16:03:13 +0800
Message-ID: <1393228996-14787-4-git-send-email-zhangwm@marvell.com>
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

The interruts are useless when this endpoint is going to be flushed.
Especially in the enumeration phase, let's take get device description
for example.
1. Device doesn't ACK the status package from host in time due to irq is
disabled by some module.
2. Host find no ACK in time, and send another request.
3. Device gets the chance to handle the interrupt, the sequence is as
following.
	a. Flush pending requests in ep0.
	b. Queue a request in ep0 according to host's request and change
	   the ep0 state to DATA_STATE_XMIT.
	c. Handle the pending interrupt for the last status package. But
	   actually it will check the new added request instead of the status
	   package and because of wront ep0 state, device will request an
	   unexpected status package from host.
	d. The ep0 state is going mad.

The solution is that we need clear the pending corresponding interrupt
as well as flush
endpoint.

Signed-off-by: Neil Zhang <zhangwm@marvell.com>
---
 drivers/usb/gadget/mv_udc_core.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/gadget/mv_udc_core.c b/drivers/usb/gadget/mv_udc_core.c
index 657ac5c..d5a9bdf 100644
--- a/drivers/usb/gadget/mv_udc_core.c
+++ b/drivers/usb/gadget/mv_udc_core.c
@@ -692,6 +692,8 @@ static void mv_ep_fifo_flush(struct usb_ep *_ep)
 		}
 		loops--;
 	} while (readl(&udc->op_regs->epstatus) & bit_pos);
+
+	writel(bit_pos, &udc->op_regs->epcomplete);
 }
 
 /* queues (submits) an I/O request to an endpoint */
-- 
1.7.9.5

