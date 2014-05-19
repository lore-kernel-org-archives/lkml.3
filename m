Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751485AbaESViN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 17:38:13 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:61514 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750712AbaESViL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 17:38:11 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rashika Kheria <rashika.kheria@gmail.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Stefan Hajnoczi <stefanha@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: line6: toneport.c:  Fix for possible null pointer dereference
Date: Mon, 19 May 2014 23:39:00 +0200
Message-Id: <1400535540-5959-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is otherwise a risk of a possible null pointer dereference.

Was largely found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/staging/line6/toneport.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/line6/toneport.c b/drivers/staging/line6/toneport.c
index af2e7e5..36fe76d 100644
--- a/drivers/staging/line6/toneport.c
+++ b/drivers/staging/line6/toneport.c
@@ -431,11 +431,15 @@ void line6_toneport_disconnect(struct usb_interface *interface)
 {
 	struct usb_line6_toneport *toneport;
 	u16 idProduct;
+	struct snd_line6_pcm *line6pcm;
 
 	if (interface == NULL)
 		return;
 
 	toneport = usb_get_intfdata(interface);
+	if (toneport == NULL)
+		return;
+
 	del_timer_sync(&toneport->timer);
 	idProduct = le16_to_cpu(toneport->line6.usbdev->descriptor.idProduct);
 
@@ -444,13 +448,11 @@ void line6_toneport_disconnect(struct usb_interface *interface)
 		device_remove_file(&interface->dev, &dev_attr_led_green);
 	}
 
-	if (toneport != NULL) {
-		struct snd_line6_pcm *line6pcm = toneport->line6.line6pcm;
+	line6pcm = toneport->line6.line6pcm;
 
-		if (line6pcm != NULL) {
-			line6_pcm_release(line6pcm, LINE6_BITS_PCM_MONITOR);
-			line6_pcm_disconnect(line6pcm);
-		}
+	if (line6pcm != NULL) {
+		line6_pcm_release(line6pcm, LINE6_BITS_PCM_MONITOR);
+		line6_pcm_disconnect(line6pcm);
 	}
 
 	toneport_destruct(interface);
-- 
1.7.10.4

