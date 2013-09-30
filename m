Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756900Ab3I3Kig (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 06:38:36 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43372 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754806Ab3I3KLo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 06:11:44 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Hans de Goede <hdegoede@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 011/104] usb: config->desc.bLength may not exceed amount of data returned by the device
Date: Mon, 30 Sep 2013 11:09:48 +0100
Message-Id: <1380535881-9239-12-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1380535881-9239-1-git-send-email-luis.henriques@canonical.com>
References: <1380535881-9239-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.22 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

commit b4f17a488ae2e09bfcf95c0e0b4219c246f1116a upstream.

While reading the config parsing code I noticed this check is missing, without
this check config->desc.wTotalLength can end up with a value larger then the
dev->rawdescriptors length for the config, and when userspace then tries to
get the rawdescriptors bad things may happen.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/core/config.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/core/config.c b/drivers/usb/core/config.c
index f4bdd0c..78609d3 100644
--- a/drivers/usb/core/config.c
+++ b/drivers/usb/core/config.c
@@ -424,7 +424,8 @@ static int usb_parse_configuration(struct usb_device *dev, int cfgidx,
 
 	memcpy(&config->desc, buffer, USB_DT_CONFIG_SIZE);
 	if (config->desc.bDescriptorType != USB_DT_CONFIG ||
-	    config->desc.bLength < USB_DT_CONFIG_SIZE) {
+	    config->desc.bLength < USB_DT_CONFIG_SIZE ||
+	    config->desc.bLength > size) {
 		dev_err(ddev, "invalid descriptor for config index %d: "
 		    "type = 0x%X, length = %d\n", cfgidx,
 		    config->desc.bDescriptorType, config->desc.bLength);
-- 
1.8.3.2

