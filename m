Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756639AbbAYSL2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 13:11:28 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57208 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755288AbbAYSJW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 13:09:22 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Amit Virdi <amit.virdi@st.com>, Felipe Balbi <balbi@ti.com>
Subject: [PATCH 3.14 60/98] usb: dwc3: gadget: Stop TRB preparation after limit is reached
Date: Sun, 25 Jan 2015 10:07:18 -0800
Message-Id: <20150125180715.448916623@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150125180712.859646324@linuxfoundation.org>
References: <20150125180712.859646324@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amit Virdi <amit.virdi@st.com>

commit 39e60635a01520e8c8ed3946a28c2b98e6a46f79 upstream.

DWC3 gadget sets up a pool of 32 TRBs for each EP during initialization. This
means, the max TRBs that can be submitted for an EP is fixed to 32. Since the
request queue for an EP is a linked list, any number of requests can be queued
to it by the gadget layer.  However, the dwc3 driver must not submit TRBs more
than the pool it has created for. This limit wasn't respected when SG was used
resulting in submitting more than the max TRBs, eventually leading to
non-transfer of the TRBs submitted over the max limit.

Root cause:
When SG is used, there are two loops iterating to prepare TRBs:
 - Outer loop over the request_list
 - Inner loop over the SG list
The code was missing break to get out of the outer loop.

Fixes: eeb720fb21d6 (usb: dwc3: gadget: add support for SG lists)
Signed-off-by: Amit Virdi <amit.virdi@st.com>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/dwc3/gadget.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -905,6 +905,9 @@ static void dwc3_prepare_trbs(struct dwc
 				if (last_one)
 					break;
 			}
+
+			if (last_one)
+				break;
 		} else {
 			dma = req->request.dma;
 			length = req->request.length;


