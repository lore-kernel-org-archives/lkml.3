Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965443AbaDJDxb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 23:53:31 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41221 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934981AbaDJDWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 23:22:43 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Thomas Pugliese <thomas.pugliese@gmail.com>,
        Ben Hutchings <ben@decadent.org.uk>,
        Yang Yingliang <yangyingliang@huawei.com>
Subject: [PATCH 3.4 089/134] usb: wusbcore: set the RPIPE wMaxPacketSize value correctly
Date: Wed,  9 Apr 2014 20:23:25 -0700
Message-Id: <20140410032311.220662979@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140410032259.587501440@linuxfoundation.org>
References: <20140410032259.587501440@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Pugliese <thomas.pugliese@gmail.com>

commit 7b6bc07ab554e929c85d51b3d5b26cf7f12c6a3b upstream.

For isochronous endpoints, set the RPIPE wMaxPacketSize value using
wOverTheAirPacketSize from the endpoint companion descriptor instead of
wMaxPacketSize from the normal endpoint descriptor.

Signed-off-by: Thomas Pugliese <thomas.pugliese@gmail.com>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/wusbcore/wa-rpipe.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/usb/wusbcore/wa-rpipe.c
+++ b/drivers/usb/wusbcore/wa-rpipe.c
@@ -332,7 +332,10 @@ static int rpipe_aim(struct wa_rpipe *rp
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


