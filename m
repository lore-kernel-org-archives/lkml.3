Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934036Ab3B0Ary (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 19:47:54 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42207 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932959Ab3BZX6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 18:58:24 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Greg Suarez <gsuarez@smithmicro.com>,
        Alexey Orishko <alexey.orishko@stericsson.com>,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 122/150] net: cdc_ncm: fix probing of devices with multiple control interface altsettings
Date: Tue, 26 Feb 2013 15:56:19 -0800
Message-Id: <20130226235536.770770131@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130226235523.930663721@linuxfoundation.org>
References: <20130226235523.930663721@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Bjørn Mork <bjorn@mork.no>

[ Upstream commit f350ca03703133c94fe742f6fa6ff0fd8f5a9a09 ]

commit bd329e1 ("net: cdc_ncm: do not bind to NCM compatible MBIM devices")
added a test for a CDC MBIM altsetting, implementing the cdc_ncm part of
MBIM backward compatibility support.  This intentionally made the driver
behave differently for CDC NCM devices with 2 alternate settings for the
Communication interface, depending on whether or not CONFIG_USB_NET_CDC_MBIM
was enabled.  This is correct iff alternate setting #1 really *is* a MBIM
setting.  If not, then NCM probing will use a different altsetting than before,
possibly causing probing failures depending on CONFIG_USB_NET_CDC_MBIM.

Fix by setting the altsetting back to default after the test, restoring the
previous behaviour for non MBIM devices.

This bug causes probing of Huawei E3276 devices to fail when the MBIM driver
is enabled, because these devices have a second alternate setting with no CDC
functional descriptors.

Reported-and-tested-by: Jonathan A. <yo.natan@hotmail.com>
Cc: Greg Suarez <gsuarez@smithmicro.com>
Cc: Alexey Orishko <alexey.orishko@stericsson.com>
Signed-off-by: Bjørn Mork <bjorn@mork.no>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/cdc_ncm.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/drivers/net/usb/cdc_ncm.c
+++ b/drivers/net/usb/cdc_ncm.c
@@ -576,9 +576,14 @@ static int cdc_ncm_bind(struct usbnet *d
 	if ((intf->num_altsetting == 2) &&
 	    !usb_set_interface(dev->udev,
 			       intf->cur_altsetting->desc.bInterfaceNumber,
-			       CDC_NCM_COMM_ALTSETTING_MBIM) &&
-	    cdc_ncm_comm_intf_is_mbim(intf->cur_altsetting))
-		return -ENODEV;
+			       CDC_NCM_COMM_ALTSETTING_MBIM)) {
+		if (cdc_ncm_comm_intf_is_mbim(intf->cur_altsetting))
+			return -ENODEV;
+		else
+			usb_set_interface(dev->udev,
+					  intf->cur_altsetting->desc.bInterfaceNumber,
+					  CDC_NCM_COMM_ALTSETTING_NCM);
+	}
 #endif
 
 	/* NCM data altsetting is always 1 */


