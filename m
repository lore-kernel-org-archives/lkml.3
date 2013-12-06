Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162043Ab3LFNFc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 08:05:32 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44672 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162015Ab3LFNEr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 08:04:47 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Thomas Pugliese <thomas.pugliese@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 234/272] usb: wusbcore: set the RPIPE wMaxPacketSize value correctly
Date: Fri,  6 Dec 2013 12:58:43 +0000
Message-Id: <1386334761-25517-235-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
References: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Pugliese <thomas.pugliese@gmail.com>

commit 7b6bc07ab554e929c85d51b3d5b26cf7f12c6a3b upstream.

For isochronous endpoints, set the RPIPE wMaxPacketSize value using
wOverTheAirPacketSize from the endpoint companion descriptor instead of
wMaxPacketSize from the normal endpoint descriptor.

Signed-off-by: Thomas Pugliese <thomas.pugliese@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/wusbcore/wa-rpipe.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/wusbcore/wa-rpipe.c b/drivers/usb/wusbcore/wa-rpipe.c
index 9a595c1..fdf731b 100644
--- a/drivers/usb/wusbcore/wa-rpipe.c
+++ b/drivers/usb/wusbcore/wa-rpipe.c
@@ -333,7 +333,10 @@ static int rpipe_aim(struct wa_rpipe *rpipe, struct wahc *wa,
 	/* FIXME: compute so seg_size > ep->maxpktsize */
 	rpipe->descr.wBlocks = cpu_to_le16(16);		/* given */
 	/* ep0 maxpktsize is 0x200 (WUSB1.0[4.8.1]) */
-	rpipe->descr.wMaxPacketSize = cpu_to_le16(ep->desc.wMaxPacketSize);
+	if (usb_endpoint_xfer_isoc(&ep->desc))
+		rpipe->descr.wMaxPacketSize = epcd->wOverTheAirPacketSize;
+	else
+		rpipe->descr.wMaxPacketSize = ep->desc.wMaxPacketSize;
 
 	rpipe->descr.hwa_bMaxBurst = max(min_t(unsigned int,
 				epcd->bMaxBurst, 16U), 1U);
-- 
1.8.3.2

