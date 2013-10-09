Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753378Ab3JIGVD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 02:21:03 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:41628 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382Ab3JIGVB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 02:21:01 -0400
X-AuditID: cbfee61a-b7f7a6d00000235f-0e-5254f5a27c35
From: Robert Baldyga <r.baldyga@samsung.com>
To: balbi@ti.com
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com,
        m.szyprowski@samsung.com, andrzej.p@samsung.com,
        Robert Baldyga <r.baldyga@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH] USB: gadget: s3c-hsotg: fix set_ep_maxpacket function
Date: Wed, 09 Oct 2013 08:20:02 +0200
Message-id: <1381299602-6304-1-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPJMWRmVeSWpSXmKPExsVy+t9jAd1FX0OCDH4tl7OY9bKdxWLjjPWs
	Fgfv11s0L17PZnG26Q27xeVdc9gsFi1rZbZYe+Quu8WDwzvZHTg99s9dw+7Rt2UVo8fxG9uZ
	PD5vkgtgieKySUnNySxLLdK3S+DK6Lm4gqlgOW/FqbfHmBoY33F1MXJySAiYSFxdv54dwhaT
	uHBvPRuILSSwiFFi1xnXLkYuILudSWLXlUtgCTYBHYkt3ycwgtgiAgIS619cYgcpYhb4yyhx
	+2EnWJGwgJvEiXN3mEFsFgFVidW9x8A28Aq4SMx6eRHI5gDapiAxZ5LNBEbuBYwMqxhFUwuS
	C4qT0nMN9YoTc4tL89L1kvNzNzGCg+WZ1A7GlQ0WhxgFOBiVeHgf8IcECbEmlhVX5h5ilOBg
	VhLhzVsIFOJNSaysSi3Kjy8qzUktPsQozcGiJM57oNU6UEggPbEkNTs1tSC1CCbLxMEp1cC4
	vEGg4PnXglV85R0mN8VY35kclGLwerb9iO1BvrPfQ9a66N+0uhfln/zUf7m4hUX+Ybnn3269
	+/Dl2u/srduKpCUNbOSN9Taf2GxwLqR56690o0cnlT6ffdfmGLFlkemMviKpDUt53K/ULkg2
	3eFx9EDwvPTC8+Wn42/5uKX8/b8nb2LaDJ5lSizFGYmGWsxFxYkAS5iAYxICAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes max packet size check in s3c_hsotg_set_ep_maxpacket()
function. According USB specification, bits 10..0 of mps specifies maximum
packet size, so there is bitwise AND between mps and 0x7ff value. Also added
check if maxpacket isn't grater than 1024 which is maximum size od single USB
transaction.
In s3c_hsotg_ep_enable() function added s3c_hsotg_set_ep_maxpacket() call
instead of setting ep.maxpacket value directly.

Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/usb/gadget/s3c-hsotg.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/gadget/s3c-hsotg.c b/drivers/usb/gadget/s3c-hsotg.c
index 5a15de0..139122a 100644
--- a/drivers/usb/gadget/s3c-hsotg.c
+++ b/drivers/usb/gadget/s3c-hsotg.c
@@ -1726,15 +1726,14 @@ static void s3c_hsotg_set_ep_maxpacket(struct s3c_hsotg *hsotg,
 		mpsval = s3c_hsotg_ep0_mps(mps);
 		if (mpsval > 3)
 			goto bad_mps;
+		hs_ep->ep.maxpacket = mps;
 	} else {
-		if (mps >= DxEPCTL_MPS_LIMIT+1)
+		mpsval = mps & DxEPCTL_MPS_MASK;
+		if (mpsval > 1024)
 			goto bad_mps;
-
-		mpsval = mps;
+		hs_ep->ep.maxpacket = mpsval;
 	}
 
-	hs_ep->ep.maxpacket = mps;
-
 	/*
 	 * update both the in and out endpoint controldir_ registers, even
 	 * if one of the directions may not be in use.
@@ -2614,7 +2613,7 @@ static int s3c_hsotg_ep_enable(struct usb_ep *ep,
 	epctrl |= DxEPCTL_SNAK;
 
 	/* update the endpoint state */
-	hs_ep->ep.maxpacket = mps;
+	s3c_hsotg_set_ep_maxpacket(hsotg, hs_ep->index, mps);
 
 	/* default, set to non-periodic */
 	hs_ep->periodic = 0;
-- 
1.7.9.5

