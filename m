Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760058Ab3LFXYw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 18:24:52 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:49022 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423024Ab3LFXUv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 18:20:51 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Thomas Pugliese <thomas.pugliese@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 031/152] usb: wusbcore: set the RPIPE wMaxPacketSize value correctly
Date: Fri,  6 Dec 2013 15:09:15 -0800
Message-Id: <1386371476-2477-32-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386371476-2477-1-git-send-email-kamal@canonical.com>
References: <1386371476-2477-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Pugliese <thomas.pugliese@gmail.com>

commit 7b6bc07ab554e929c85d51b3d5b26cf7f12c6a3b upstream.

For isochronous endpoints, set the RPIPE wMaxPacketSize value using
wOverTheAirPacketSize from the endpoint companion descriptor instead of
wMaxPacketSize from the normal endpoint descriptor.

Signed-off-by: Thomas Pugliese <thomas.pugliese@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[ kamal: backport to 3.8 (context) ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/usb/wusbcore/wa-rpipe.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/wusbcore/wa-rpipe.c b/drivers/usb/wusbcore/wa-rpipe.c
index f0d546c..ca1031b 100644
--- a/drivers/usb/wusbcore/wa-rpipe.c
+++ b/drivers/usb/wusbcore/wa-rpipe.c
@@ -332,7 +332,10 @@ static int rpipe_aim(struct wa_rpipe *rpipe, struct wahc *wa,
 	/* FIXME: compute so seg_size > ep->maxpktsize */
 	rpipe->descr.wBlocks = cpu_to_le16(16);		/* given */
 	/* ep0 maxpktsize is 0x200 (WUSB1.0[4.8.1]) */
-	rpipe->descr.wMaxPacketSize = cpu_to_le16(ep->desc.wMaxPacketSize);
+	if (usb_endpoint_xfer_isoc(&ep->desc))
+		rpipe->descr.wMaxPacketSize = epcd->wOverTheAirPacketSize;
+	else
+		rpipe->descr.wMaxPacketSize = ep->desc.wMaxPacketSize;
 	rpipe->descr.bHSHubAddress = 0;			/* reserved: zero */
 	rpipe->descr.bHSHubPort = wusb_port_no_to_idx(urb->dev->portnum);
 	/* FIXME: use maximum speed as supported or recommended by device */
-- 
1.8.3.2

