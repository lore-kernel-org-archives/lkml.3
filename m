Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755506AbaGQIsk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 04:48:40 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:41013 "EHLO
	mx08-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754866AbaGQIsh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 04:48:37 -0400
From: Amit Virdi <amit.virdi@st.com>
To: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Cc: <gregkh@linuxfoundation.org>, <stern@rowland.harvard.edu>,
        <rdunlap@infradead.org>, <ming.lei@canonical.com>,
        <hdegoede@redhat.com>, <hsi-ss-sw-devel@lists.codex.cro.st.com>,
        Amit Virdi <amit.virdi@st.com>
Subject: [PATCH] usb: core: allow zero packet flag for interrupt urbs
Date: Thu, 17 Jul 2014 14:17:22 +0530
Message-ID: <5255a576a562f60c185e89b5937357290242fe1e.1405586653.git.amit.virdi@st.com>
X-Mailer: git-send-email 1.8.0
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.14,0.0.0000
 definitions=2014-07-17_02:2014-07-16,2014-07-17,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Section 4.4.7.2 of the USB3.0 spec says:
	A zero-length data payload is a valid transfer and may be useful for
	some implementations.

So, extend the logic of allowing URB_ZERO_PACKET to interrupt urbs too.
Otherwise, the kernel throws error of BOGUS transfer flags.

Signed-off-by: Amit Virdi <amit.virdi@st.com>
---
 drivers/usb/core/urb.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/usb/core/urb.c b/drivers/usb/core/urb.c
index 991386c..a136246 100644
--- a/drivers/usb/core/urb.c
+++ b/drivers/usb/core/urb.c
@@ -460,6 +460,10 @@ int usb_submit_urb(struct urb *urb, gfp_t mem_flags)
 	case USB_ENDPOINT_XFER_CONTROL:
 		allowed |= URB_NO_FSBR;	/* only affects UHCI */
 		/* FALLTHROUGH */
+	case USB_ENDPOINT_XFER_INT:
+		if (is_out)
+			allowed |= URB_ZERO_PACKET;
+		/* FALLTHROUGH */
 	default:			/* all non-iso endpoints */
 		if (!is_out)
 			allowed |= URB_SHORT_NOT_OK;
-- 
1.8.0

