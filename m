Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753493AbaLUWkd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 17:40:33 -0500
Received: from mail-wi0-f173.google.com ([209.85.212.173]:41793 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752458AbaLUWkc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 17:40:32 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jerry Snitselaar <dev@snitselaar.org>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Fabian Mewes <architekt@coding4coffee.org>,
        Stefan Hajnoczi <stefanha@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: line6: toneport.c:  Fix for possible null pointer dereference
Date: Sun, 21 Dec 2014 23:43:16 +0100
Message-Id: <1419201796-13790-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The NULL check was done to late, and there it was a risk
of a possible null pointer dereference.

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/staging/line6/toneport.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/line6/toneport.c b/drivers/staging/line6/toneport.c
index 6943715..660dc3f 100644
--- a/drivers/staging/line6/toneport.c
+++ b/drivers/staging/line6/toneport.c
@@ -433,12 +433,16 @@ void line6_toneport_reset_resume(struct usb_line6_toneport *toneport)
 void line6_toneport_disconnect(struct usb_interface *interface)
 {
 	struct usb_line6_toneport *toneport;
+	struct snd_line6_pcm *line6pcm;
 	u16 idProduct;
 
 	if (interface == NULL)
 		return;
 
 	toneport = usb_get_intfdata(interface);
+	if (NULL == toneport)
+		return;
+
 	del_timer_sync(&toneport->timer);
 	idProduct = le16_to_cpu(toneport->line6.usbdev->descriptor.idProduct);
 
@@ -447,13 +451,10 @@ void line6_toneport_disconnect(struct usb_interface *interface)
 		device_remove_file(&interface->dev, &dev_attr_led_green);
 	}
 
-	if (toneport != NULL) {
-		struct snd_line6_pcm *line6pcm = toneport->line6.line6pcm;
-
-		if (line6pcm != NULL) {
-			line6_pcm_release(line6pcm, LINE6_BITS_PCM_MONITOR);
-			line6_pcm_disconnect(line6pcm);
-		}
+	line6pcm = toneport->line6.line6pcm;
+	if (line6pcm != NULL) {
+		line6_pcm_release(line6pcm, LINE6_BITS_PCM_MONITOR);
+		line6_pcm_disconnect(line6pcm);
 	}
 
 	toneport_destruct(interface);
-- 
1.7.10.4

