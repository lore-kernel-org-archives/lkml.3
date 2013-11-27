Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759026Ab3K0BNV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 20:13:21 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39612 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758811Ab3K0A7o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 19:59:44 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Thomas Pugliese <thomas.pugliese@gmail.com>
Subject: [PATCH 3.12 104/116] usb: wusbcore: set the RPIPE wMaxPacketSize value correctly
Date: Tue, 26 Nov 2013 16:57:57 -0800
Message-Id: <20131127005744.084364843@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc3
In-Reply-To: <20131127005736.915454872@linuxfoundation.org>
References: <20131127005736.915454872@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Pugliese <thomas.pugliese@gmail.com>

commit 7b6bc07ab554e929c85d51b3d5b26cf7f12c6a3b upstream.

For isochronous endpoints, set the RPIPE wMaxPacketSize value using
wOverTheAirPacketSize from the endpoint companion descriptor instead of
wMaxPacketSize from the normal endpoint descriptor.

Signed-off-by: Thomas Pugliese <thomas.pugliese@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/wusbcore/wa-rpipe.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/usb/wusbcore/wa-rpipe.c
+++ b/drivers/usb/wusbcore/wa-rpipe.c
@@ -333,7 +333,10 @@ static int rpipe_aim(struct wa_rpipe *rp
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


