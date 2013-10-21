Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755862Ab3JUJYA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 05:24:00 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39454 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753617Ab3JUIvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 04:51:19 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Hans de Goede" <hdegoede@redhat.com>
Date: Mon, 21 Oct 2013 09:46:28 +0100
Message-ID: <lsq.1382345188.441559254@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 022/149] usb: config->desc.bLength may not exceed
 amount of data returned by the device
In-Reply-To: <lsq.1382345187.199780875@decadent.org.uk>
X-SA-Exim-Connect-IP: 212.20.242.100
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.52-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

commit b4f17a488ae2e09bfcf95c0e0b4219c246f1116a upstream.

While reading the config parsing code I noticed this check is missing, without
this check config->desc.wTotalLength can end up with a value larger then the
dev->rawdescriptors length for the config, and when userspace then tries to
get the rawdescriptors bad things may happen.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/core/config.c | 3 ++-
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

