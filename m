Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751947Ab3ASI7R (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2013 03:59:17 -0500
Received: from mail-bk0-f52.google.com ([209.85.214.52]:37788 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751637Ab3ASI7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2013 03:59:16 -0500
From: Stefan Hajnoczi <stefanha@gmail.com>
To: devel@driverdev.osuosl.org
Cc: Markus Grabner <grabner@icg.tugraz.at>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        line6linux-devel@lists.sourceforge.net, <linux-kernel@vger.kernel.org>,
        Stefan Hajnoczi <stefanha@gmail.com>
Subject: [PATCH] staging: line6: drop CONFIG_LINE6_USB_DUMP_PCM
Date: Sat, 19 Jan 2013 09:59:00 +0100
Message-Id: <1358585940-29991-1-git-send-email-stefanha@gmail.com>
X-Mailer: git-send-email 1.8.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The CONFIG_LINE6_USB_DUMP_PCM config option prints a hexdump of PCM
audio data as URBs are sent and received.  The usbmon feature should be
used instead of manually dumping PCM URBs.  There are a few advantages
to using usbmon:

 * Can be turned on/off at runtime
 * Provides full USB-level traffic
 * tcpdump and wireshark support for powerful analysis
 * No driver-specific code is required

This is the last user of line6_write_hexdump() so we drop it too.

Signed-off-by: Stefan Hajnoczi <stefanha@gmail.com>
---
Applies on linux-next/master.

 drivers/staging/line6/Kconfig    | 10 ----------
 drivers/staging/line6/capture.c  | 10 ----------
 drivers/staging/line6/driver.c   | 41 ----------------------------------------
 drivers/staging/line6/driver.h   |  9 ---------
 drivers/staging/line6/playback.c |  9 ---------
 5 files changed, 79 deletions(-)

diff --git a/drivers/staging/line6/Kconfig b/drivers/staging/line6/Kconfig
index b635436..4f1219b 100644
--- a/drivers/staging/line6/Kconfig
+++ b/drivers/staging/line6/Kconfig
@@ -23,16 +23,6 @@ menuconfig LINE6_USB
 
 if LINE6_USB
 
-config LINE6_USB_DUMP_PCM
-	bool "dump PCM data"
-	default n
-	help
-	  Say Y here to write PCM data sent to and received from Line6
-	  devices to the syslog. This will produce a huge amount of
-	  syslog data during playback and capture.
-
-	  If unsure, say N.
-
 config LINE6_USB_IMPULSE_RESPONSE
 	bool "measure impulse response"
 	default n
diff --git a/drivers/staging/line6/capture.c b/drivers/staging/line6/capture.c
index 389c41f..f8316b7 100644
--- a/drivers/staging/line6/capture.c
+++ b/drivers/staging/line6/capture.c
@@ -216,16 +216,6 @@ static void audio_in_callback(struct urb *urb)
 		if (urb == line6pcm->urb_audio_in[index])
 			break;
 
-#ifdef CONFIG_LINE6_USB_DUMP_PCM
-	for (i = 0; i < LINE6_ISO_PACKETS; ++i) {
-		struct usb_iso_packet_descriptor *fout =
-		    &urb->iso_frame_desc[i];
-		line6_write_hexdump(line6pcm->line6, 'C',
-				    urb->transfer_buffer + fout->offset,
-				    fout->length);
-	}
-#endif
-
 	spin_lock_irqsave(&line6pcm->lock_audio_in, flags);
 
 	for (i = 0; i < LINE6_ISO_PACKETS; ++i) {
diff --git a/drivers/staging/line6/driver.c b/drivers/staging/line6/driver.c
index 1b05633..9f9a21a 100644
--- a/drivers/staging/line6/driver.c
+++ b/drivers/staging/line6/driver.c
@@ -135,47 +135,6 @@ static void line6_stop_listen(struct usb_line6 *line6)
 	usb_kill_urb(line6->urb_listen);
 }
 
-#ifdef CONFIG_LINE6_USB_DUMP_ANY
-/*
-	Write hexdump to syslog.
-*/
-void line6_write_hexdump(struct usb_line6 *line6, char dir,
-			 const unsigned char *buffer, int size)
-{
-	static const int BYTES_PER_LINE = 8;
-	char hexdump[100];
-	char asc[BYTES_PER_LINE + 1];
-	int i, j;
-
-	for (i = 0; i < size; i += BYTES_PER_LINE) {
-		int hexdumpsize = sizeof(hexdump);
-		char *p = hexdump;
-		int n = min(size - i, BYTES_PER_LINE);
-		asc[n] = 0;
-
-		for (j = 0; j < BYTES_PER_LINE; ++j) {
-			int bytes;
-
-			if (j < n) {
-				unsigned char val = buffer[i + j];
-				bytes = snprintf(p, hexdumpsize, " %02X", val);
-				asc[j] = ((val >= 0x20)
-					  && (val < 0x7f)) ? val : '.';
-			} else
-				bytes = snprintf(p, hexdumpsize, "   ");
-
-			if (bytes > hexdumpsize)
-				break;	/* buffer overflow */
-
-			p += bytes;
-			hexdumpsize -= bytes;
-		}
-
-		dev_info(line6->ifcdev, "%c%04X:%s %s\n", dir, i, hexdump, asc);
-	}
-}
-#endif
-
 /*
 	Send raw message in pieces of wMaxPacketSize bytes.
 */
diff --git a/drivers/staging/line6/driver.h b/drivers/staging/line6/driver.h
index 2e0f134..a8341f9 100644
--- a/drivers/staging/line6/driver.h
+++ b/drivers/staging/line6/driver.h
@@ -20,10 +20,6 @@
 
 #define DRIVER_NAME "line6usb"
 
-#if defined(CONFIG_LINE6_USB_DUMP_PCM)
-#define CONFIG_LINE6_USB_DUMP_ANY
-#endif
-
 #define LINE6_TIMEOUT 1
 #define LINE6_BUFSIZE_LISTEN 32
 #define LINE6_MESSAGE_MAXLEN 256
@@ -219,9 +215,4 @@ extern int line6_version_request_async(struct usb_line6 *line6);
 extern int line6_write_data(struct usb_line6 *line6, int address, void *data,
 			    size_t datalen);
 
-#ifdef CONFIG_LINE6_USB_DUMP_ANY
-extern void line6_write_hexdump(struct usb_line6 *line6, char dir,
-				const unsigned char *buffer, int size);
-#endif
-
 #endif
diff --git a/drivers/staging/line6/playback.c b/drivers/staging/line6/playback.c
index 4cf23af..f9135c7 100644
--- a/drivers/staging/line6/playback.c
+++ b/drivers/staging/line6/playback.c
@@ -264,15 +264,6 @@ static int submit_audio_out_urb(struct snd_line6_pcm *line6pcm)
 		}
 #endif
 	}
-#ifdef CONFIG_LINE6_USB_DUMP_PCM
-	for (i = 0; i < LINE6_ISO_PACKETS; ++i) {
-		struct usb_iso_packet_descriptor *fout =
-		    &urb_out->iso_frame_desc[i];
-		line6_write_hexdump(line6pcm->line6, 'P',
-				    urb_out->transfer_buffer + fout->offset,
-				    fout->length);
-	}
-#endif
 
 	ret = usb_submit_urb(urb_out, GFP_ATOMIC);
 
-- 
1.8.0.2

