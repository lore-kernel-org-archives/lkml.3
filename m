Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751755Ab3HUInQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 04:43:16 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:46855 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751629Ab3HUInN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 04:43:13 -0400
Message-ID: <1377074587.4530.8.camel@chimera>
Subject: [PATCH 1/2] hso: Earlier catch of error condition
From: Daniel Gimpelevich <daniel@gimpelevich.san-francisco.ca.us>
To: gregkh@linuxfoundation.org, j.dumon@option.com, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 21 Aug 2013 01:43:07 -0700
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no need to get an interface specification if we know it's the
wrong one. 

Signed-off-by: Daniel Gimpelevich <daniel@gimpelevich.san-francisco.ca.us>
---
 drivers/net/usb/hso.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/usb/hso.c b/drivers/net/usb/hso.c
index cba1d46..5fb36ed 100644
--- a/drivers/net/usb/hso.c
+++ b/drivers/net/usb/hso.c
@@ -2886,6 +2886,11 @@ static int hso_probe(struct usb_interface *interface,
 	struct hso_shared_int *shared_int;
 	struct hso_device *tmp_dev = NULL;
 
+	if (interface->cur_altsetting->desc.bInterfaceClass != 0xFF) {
+		dev_err(&interface->dev, "Not our interface\n");
+		return -ENODEV;
+	}
+
 	if_num = interface->altsetting->desc.bInterfaceNumber;
 
 	/* Get the interface/port specification from either driver_info or from
@@ -2895,10 +2900,6 @@ static int hso_probe(struct usb_interface *interface,
 	else
 		port_spec = hso_get_config_data(interface);
 
-	if (interface->cur_altsetting->desc.bInterfaceClass != 0xFF) {
-		dev_err(&interface->dev, "Not our interface\n");
-		return -ENODEV;
-	}
 	/* Check if we need to switch to alt interfaces prior to port
 	 * configuration */
 	if (interface->num_altsetting > 1)
-- 
1.7.9.5

