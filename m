Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753388Ab3F1TUN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 15:20:13 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41528 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751636Ab3F1Sw1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 14:52:27 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Pratyush Anand <pratyush.anand@st.com>, Felipe Balbi <balbi@ti.com>,
        Luis Henriques <luis.henriques@canonical.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 001/105] usb: dwc3: gadget: req->queued must be forced to false in cleanup
Date: Fri, 28 Jun 2013 11:50:23 -0700
Message-Id: <1372445527-24414-2-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1372445527-24414-1-git-send-email-kamal@canonical.com>
References: <1372445527-24414-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pratyush Anand <pratyush.anand@st.com>

commit c9fda7d6f62a6520e01652d370654c5657d3c1a1 upstream.

I am not sure, why I found it during SG debugging. But, I noticed that
even when req_queued list was empty, there were some request in
request_list having queued flag true. If I run test second time, it
first removes all request from request_list and hence busy_slot was
wrongly incremented.

Signed-off-by: Pratyush Anand <pratyush.anand@st.com>
Signed-off-by: Felipe Balbi <balbi@ti.com>
[ luis: adjust context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/usb/dwc3/gadget.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 3c0351a..be13492 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -256,6 +256,7 @@ void dwc3_gadget_giveback(struct dwc3_ep *dep, struct dwc3_request *req,
 		if (((dep->busy_slot & DWC3_TRB_MASK) == DWC3_TRB_NUM - 1) &&
 				usb_endpoint_xfer_isoc(dep->endpoint.desc))
 			dep->busy_slot++;
+		req->queued = false;
 	}
 	list_del(&req->list);
 	req->trb = NULL;
-- 
1.8.1.2

