Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932693AbbA0MXL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 07:23:11 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35451 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758715AbbA0MUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 07:20:08 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Amit Virdi <amit.virdi@st.com>, Felipe Balbi <balbi@ti.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 115/126] usb: dwc3: gadget: Fix TRB preparation during SG
Date: Tue, 27 Jan 2015 12:17:00 +0000
Message-Id: <1422361031-19364-116-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
References: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amit Virdi <amit.virdi@st.com>

commit ec512fb8e5611fed1df2895f90317ce6797d6b32 upstream.

When scatter gather (SG) is used, multiple TRBs are prepared from one DWC3
request (dwc3_request). So while preparing TRBs, the 'last' flag should be set
only when it is the last TRB being prepared from the last dwc3_request entry.

The current implementation uses list_is_last to check if the dwc3_request is the
last entry from the request_list. However, list_is_last returns false for the
last entry too. This is because, while preparing the first TRB from a request,
the function dwc3_prepare_one_trb modifies the request's next and prev pointers
while moving the URB to req_queued. Hence, list_is_last always returns false no
matter what.

The correct way is not to access the modified pointers of dwc3_request but to
use list_empty macro instead.

Fixes: e5ba5ec833aa (usb: dwc3: gadget: fix scatter gather implementation)
Signed-off-by: Amit Virdi <amit.virdi@st.com>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/dwc3/gadget.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 9a565f0e3532..9b833a43212a 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -970,8 +970,7 @@ static void dwc3_prepare_trbs(struct dwc3_ep *dep, bool starting)
 
 				if (i == (request->num_mapped_sgs - 1) ||
 						sg_is_last(s)) {
-					if (list_is_last(&req->list,
-							&dep->request_list))
+					if (list_empty(&dep->request_list))
 						last_one = true;
 					chain = false;
 				}
-- 
2.1.4

