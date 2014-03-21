Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966889AbaCUBRd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 21:17:33 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36613 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760492AbaCUADy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 20:03:54 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Julius Werner <jwerner@chromium.org>
Subject: [PATCH 3.13 067/149] usb: Make DELAY_INIT quirk wait 100ms between Get Configuration requests
Date: Thu, 20 Mar 2014 17:03:50 -0700
Message-Id: <20140321000439.281636567@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140321000436.377902063@linuxfoundation.org>
References: <20140321000436.377902063@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Julius Werner <jwerner@chromium.org>

commit d86db25e53fa69e3e97f3b55dd82a70689787c5d upstream.

The DELAY_INIT quirk only reduces the frequency of enumeration failures
with the Logitech HD Pro C920 and C930e webcams, but does not quite
eliminate them. We have found that adding a delay of 100ms between the
first and second Get Configuration request makes the device enumerate
perfectly reliable even after several weeks of extensive testing. The
reasons for that are anyone's guess, but since the DELAY_INIT quirk
already delays enumeration by a whole second, wating for another 10th of
that isn't really a big deal for the one other device that uses it, and
it will resolve the problems with these webcams.

Signed-off-by: Julius Werner <jwerner@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/core/config.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/usb/core/config.c
+++ b/drivers/usb/core/config.c
@@ -718,6 +718,10 @@ int usb_get_configuration(struct usb_dev
 			result = -ENOMEM;
 			goto err;
 		}
+
+		if (dev->quirks & USB_QUIRK_DELAY_INIT)
+			msleep(100);
+
 		result = usb_get_descriptor(dev, USB_DT_CONFIG, cfgno,
 		    bigbuffer, length);
 		if (result < 0) {


