Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755134Ab3IYAIf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 20:08:35 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38437 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754953Ab3IYAIK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 20:08:10 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Hans de Goede <hdegoede@redhat.com>
Subject: [ 12/28] usb: config->desc.bLength may not exceed amount of data returned by the device
Date: Tue, 24 Sep 2013 17:07:43 -0700
Message-Id: <20130925000651.407725246@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130925000648.404447782@linuxfoundation.org>
References: <20130925000648.404447782@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

commit b4f17a488ae2e09bfcf95c0e0b4219c246f1116a upstream.

While reading the config parsing code I noticed this check is missing, without
this check config->desc.wTotalLength can end up with a value larger then the
dev->rawdescriptors length for the config, and when userspace then tries to
get the rawdescriptors bad things may happen.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/core/config.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/usb/core/config.c
+++ b/drivers/usb/core/config.c
@@ -424,7 +424,8 @@ static int usb_parse_configuration(struc
 
 	memcpy(&config->desc, buffer, USB_DT_CONFIG_SIZE);
 	if (config->desc.bDescriptorType != USB_DT_CONFIG ||
-	    config->desc.bLength < USB_DT_CONFIG_SIZE) {
+	    config->desc.bLength < USB_DT_CONFIG_SIZE ||
+	    config->desc.bLength > size) {
 		dev_err(ddev, "invalid descriptor for config index %d: "
 		    "type = 0x%X, length = %d\n", cfgidx,
 		    config->desc.bDescriptorType, config->desc.bLength);


