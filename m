Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758386AbbA2JCm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 04:02:42 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44776 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754198AbbA2JCd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 04:02:33 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Amit Virdi <amit.virdi@st.com>,
        Felipe Balbi <balbi@ti.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 108/176] usb: dwc3: gadget: Stop TRB preparation after limit is reached
Date: Wed, 28 Jan 2015 15:28:58 +0100
Message-Id: <fc642bfa122cccd22b32f734bf7f10fc84a729ab.1422455352.git.jslaby@suse.cz>
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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/usb/dwc3/gadget.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 3a075d1fbf99..d19564d0f79a 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -905,6 +905,9 @@ static void dwc3_prepare_trbs(struct dwc3_ep *dep, bool starting)
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
2.2.2

