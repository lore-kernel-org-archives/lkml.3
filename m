Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753591AbaC3XgN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 19:36:13 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36476 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753130AbaC3XZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 19:25:04 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Julius Werner" <jwerner@chromium.org>
Date: Mon, 31 Mar 2014 00:23:35 +0100
Message-ID: <lsq.1396221815.656479349@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 168/200] usb: Make DELAY_INIT quirk wait 100ms between
 Get Configuration requests
In-Reply-To: <lsq.1396221814.369444335@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.56-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/core/config.c | 4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/usb/core/config.c
+++ b/drivers/usb/core/config.c
@@ -722,6 +722,10 @@ int usb_get_configuration(struct usb_dev
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

