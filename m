Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758768AbbA0MUS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 07:20:18 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35454 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758723AbbA0MUJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 07:20:09 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Amit Virdi <amit.virdi@st.com>, Felipe Balbi <balbi@ti.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 116/126] usb: dwc3: gadget: Stop TRB preparation after limit is reached
Date: Tue, 27 Jan 2015 12:17:01 +0000
Message-Id: <1422361031-19364-117-git-send-email-luis.henriques@canonical.com>
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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/dwc3/gadget.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 9b833a43212a..c24c0bb7f6f3 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -988,6 +988,9 @@ static void dwc3_prepare_trbs(struct dwc3_ep *dep, bool starting)
 				if (last_one)
 					break;
 			}
+
+			if (last_one)
+				break;
 		} else {
 			dma = req->request.dma;
 			length = req->request.length;
-- 
2.1.4

