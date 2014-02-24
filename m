Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752903AbaBXIDb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 03:03:31 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:47760 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752256AbaBXID2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 03:03:28 -0500
From: Neil Zhang <zhangwm@marvell.com>
To: <balbi@ti.com>, <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: Neil Zhang <zhangwm@marvell.com>
Subject: [PATCH 5/6] USB: gadget: mv_udc: workaroud for missing dTD
Date: Mon, 24 Feb 2014 16:03:15 +0800
Message-ID: <1393228996-14787-6-git-send-email-zhangwm@marvell.com>
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

There is an issue with the add dTD tripwire semaphore (ATDTW bit in
USBCMD register) that can cause the controller to ignore a dTD that is
added to a primed endpoint. When this happens, the software can read
the tripwire bit and the status bit at '1' even though the endpoint
is unprimed.

After executing a dTD, the device controller endpoint state machine
executes a final read of the dTD terminate bit to check if the
application added a dTD to the linked list at the last moment. This read
is done in the finpkt_read_latest_next_td (44) state. After the read is
performed, if the terminate bit is still set, the state machine moves to
unprime the endpoint. The decision to unprime the endpoint is done in
the checkqh_decision (59) state, based on the value of the terminate bit.

Before reaching the checkqh_decision state, the state machine traverses
the writeqhtd_status (57), writeqh_status (56), and release_prime_mask
(42) states. As shown in the waveform, the ep_addtd_tripwire_clr signal
is not set to clear the tripwire bit in these states.

Signed-off-by: Neil Zhang <zhangwm@marvell.com>
---
 drivers/usb/gadget/mv_udc_core.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/usb/gadget/mv_udc_core.c b/drivers/usb/gadget/mv_udc_core.c
index a620cff..8df8606 100644
--- a/drivers/usb/gadget/mv_udc_core.c
+++ b/drivers/usb/gadget/mv_udc_core.c
@@ -196,7 +196,27 @@ static int process_ep_req(struct mv_udc *udc, int index,
 			while (readl(&udc->op_regs->epstatus) & bit_pos)
 				udelay(1);
 			break;
+		} else {
+			if (!(readl(&udc->op_regs->epstatus) & bit_pos)) {
+				/* The DMA engine thinks there is no more dTD */
+				curr_dqh->next_dtd_ptr = curr_dtd->dtd_next
+					& EP_QUEUE_HEAD_NEXT_POINTER_MASK;
+
+				/* clear active and halt bit */
+				curr_dqh->size_ioc_int_sts &=
+						~(DTD_STATUS_ACTIVE
+						| DTD_STATUS_HALTED);
+
+				/* Do prime again */
+				wmb();
+				writel(bit_pos, &udc->op_regs->epprime);
+				while (readl(&udc->op_regs->epprime) & bit_pos)
+					cpu_relax();
+
+				break;
+			}
 		}
+
 		udelay(1);
 	}
 
-- 
1.7.9.5

