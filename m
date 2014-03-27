Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756923AbaC0PRT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 11:17:19 -0400
Received: from vsp-authed02.binero.net ([195.74.38.226]:32307 "EHLO
	vsp-authed-03-02.binero.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755961AbaC0PRK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 11:17:10 -0400
From: Andreas Larsson <andreas@gaisler.com>
To: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Mark Rutland <mark.rutland@arm.com>,
        Dan Carpenter <dan.carpenter@oracle.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        software@gaisler.com
Subject: [PATCH v2 4/7] usb: gadget: gr_udc: Use of_property_read_u32_index to access arrays
Date: Thu, 27 Mar 2014 16:15:56 +0100
Message-Id: <1395933359-7109-5-git-send-email-andreas@gaisler.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1395933359-7109-1-git-send-email-andreas@gaisler.com>
References: <1395933359-7109-1-git-send-email-andreas@gaisler.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use an appropriate accessor function for property arrays to make the code nicer
and make the code correct if it would ever run on little endian architectures.
Suggested by Mark Rutland.

Signed-off-by: Andreas Larsson <andreas@gaisler.com>
---
Differences since v1: none

 drivers/usb/gadget/gr_udc.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/usb/gadget/gr_udc.c b/drivers/usb/gadget/gr_udc.c
index 7a99254..0f3a953 100644
--- a/drivers/usb/gadget/gr_udc.c
+++ b/drivers/usb/gadget/gr_udc.c
@@ -2020,9 +2020,7 @@ static int gr_udc_init(struct gr_udc *dev)
 	u32 dmactrl_val;
 	int i;
 	int ret = 0;
-	u32 *bufsizes;
 	u32 bufsize;
-	int len;
 
 	gr_set_address(dev, 0);
 
@@ -2033,19 +2031,17 @@ static int gr_udc_init(struct gr_udc *dev)
 	INIT_LIST_HEAD(&dev->ep_list);
 	gr_set_ep0state(dev, GR_EP0_DISCONNECT);
 
-	bufsizes = (u32 *)of_get_property(np, "epobufsizes", &len);
-	len /= sizeof(u32);
 	for (i = 0; i < dev->nepo; i++) {
-		bufsize = (bufsizes && i < len) ? bufsizes[i] : 1024;
+		if (of_property_read_u32_index(np, "epobufsizes", i, &bufsize))
+			bufsize = 1024;
 		ret = gr_ep_init(dev, i, 0, bufsize);
 		if (ret)
 			return ret;
 	}
 
-	bufsizes = (u32 *)of_get_property(np, "epibufsizes", &len);
-	len /= sizeof(u32);
 	for (i = 0; i < dev->nepi; i++) {
-		bufsize = (bufsizes && i < len) ? bufsizes[i] : 1024;
+		if (of_property_read_u32_index(np, "epibufsizes", i, &bufsize))
+			bufsize = 1024;
 		ret = gr_ep_init(dev, i, 1, bufsize);
 		if (ret)
 			return ret;
-- 
1.7.10.4

