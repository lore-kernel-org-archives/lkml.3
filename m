Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762162AbbA2KQt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 05:16:49 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44737 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757098AbbA2JBM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 04:01:12 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Amit Virdi <amit.virdi@st.com>,
        Felipe Balbi <balbi@ti.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 107/176] usb: dwc3: gadget: Fix TRB preparation during SG
Date: Wed, 28 Jan 2015 15:28:57 +0100
Message-Id: <e0410d7fd7c36cd8552b1c5dd784c47a11c6c2ef.1422455352.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
References: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
In-Reply-To: <cover.1422455352.git.jslaby@suse.cz>
References: <cover.1422455352.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Amit Virdi <amit.virdi@st.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/usb/dwc3/gadget.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index be149b82564f..3a075d1fbf99 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -887,8 +887,7 @@ static void dwc3_prepare_trbs(struct dwc3_ep *dep, bool starting)
 
 				if (i == (request->num_mapped_sgs - 1) ||
 						sg_is_last(s)) {
-					if (list_is_last(&req->list,
-							&dep->request_list))
+					if (list_empty(&dep->request_list))
 						last_one = true;
 					chain = false;
 				}
-- 
2.2.2

