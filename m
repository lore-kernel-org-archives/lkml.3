Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753886AbaCaNYE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 09:24:04 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35622 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753654AbaCaNX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 09:23:56 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Julius Werner <jwerner@chromium.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 24/71] usb: Make DELAY_INIT quirk wait 100ms between Get Configuration requests
Date: Mon, 31 Mar 2014 14:22:30 +0100
Message-Id: <1396272197-13394-25-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396272197-13394-1-git-send-email-luis.henriques@canonical.com>
References: <1396272197-13394-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.33 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/core/config.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/usb/core/config.c b/drivers/usb/core/config.c
index 6ed7e7c..c120b6f 100644
--- a/drivers/usb/core/config.c
+++ b/drivers/usb/core/config.c
@@ -716,6 +716,10 @@ int usb_get_configuration(struct usb_device *dev)
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
-- 
1.9.1

