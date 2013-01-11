Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755924Ab3AKWIg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 17:08:36 -0500
Received: from mail-bk0-f50.google.com ([209.85.214.50]:40243 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755624Ab3AKWIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 17:08:34 -0500
From: Stefan Hajnoczi <stefanha@gmail.com>
To: devel@driverdev.osuosl.org
Cc: Markus Grabner <grabner@icg.tugraz.at>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        line6linux-devel@lists.sourceforge.net, <linux-kernel@vger.kernel.org>,
        Laurent Navet <laurent_navet@yahoo.com>,
        Stefan Hajnoczi <stefanha@gmail.com>
Subject: [PATCH 1/6] staging: line6: rename MidiBuffer to avoid CamelCase
Date: Fri, 11 Jan 2013 23:08:09 +0100
Message-Id: <1357942094-11495-2-git-send-email-stefanha@gmail.com>
X-Mailer: git-send-email 1.8.0.2
In-Reply-To: <1357942094-11495-1-git-send-email-stefanha@gmail.com>
References: <1357942094-11495-1-git-send-email-stefanha@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix checkpatch.pl warnings related to MidiBuffer:

  WARNING: Avoid CamelCase: <MidiBuffer>
  #947: FILE: staging/line6/driver.c:363:
  +       struct MidiBuffer *mb = &line6->line6midi->midibuf_in;

Rename MidiBuffer to midi_buffer.

Note that "midibuf" would be another good name but sound/oss/midibuf.c
already uses it for a different concept.  Avoid possible confusion by
using "midi_buffer" instead.

Signed-off-by: Stefan Hajnoczi <stefanha@gmail.com>
---
 drivers/staging/line6/driver.c  |  2 +-
 drivers/staging/line6/midi.c    |  2 +-
 drivers/staging/line6/midi.h    |  4 ++--
 drivers/staging/line6/midibuf.c | 25 +++++++++++++------------
 drivers/staging/line6/midibuf.h | 22 +++++++++++-----------
 5 files changed, 28 insertions(+), 27 deletions(-)

diff --git a/drivers/staging/line6/driver.c b/drivers/staging/line6/driver.c
index ecb461e..96cfbc9 100644
--- a/drivers/staging/line6/driver.c
+++ b/drivers/staging/line6/driver.c
@@ -360,7 +360,7 @@ char *line6_alloc_sysex_buffer(struct usb_line6 *line6, int code1, int code2,
 static void line6_data_received(struct urb *urb)
 {
 	struct usb_line6 *line6 = (struct usb_line6 *)urb->context;
-	struct MidiBuffer *mb = &line6->line6midi->midibuf_in;
+	struct midi_buffer *mb = &line6->line6midi->midibuf_in;
 	int done;
 
 	if (urb->status == -ESHUTDOWN)
diff --git a/drivers/staging/line6/midi.c b/drivers/staging/line6/midi.c
index 6982eca..e3f9a53 100644
--- a/drivers/staging/line6/midi.c
+++ b/drivers/staging/line6/midi.c
@@ -45,7 +45,7 @@ static void line6_midi_transmit(struct snd_rawmidi_substream *substream)
 	struct usb_line6 *line6 =
 	    line6_rawmidi_substream_midi(substream)->line6;
 	struct snd_line6_midi *line6midi = line6->line6midi;
-	struct MidiBuffer *mb = &line6midi->midibuf_out;
+	struct midi_buffer *mb = &line6midi->midibuf_out;
 	unsigned long flags;
 	unsigned char chunk[line6->max_packet_size];
 	int req, done;
diff --git a/drivers/staging/line6/midi.h b/drivers/staging/line6/midi.h
index 19dabd5..78f903f 100644
--- a/drivers/staging/line6/midi.h
+++ b/drivers/staging/line6/midi.h
@@ -57,12 +57,12 @@ struct snd_line6_midi {
 	/**
 		 Buffer for incoming MIDI stream.
 	*/
-	struct MidiBuffer midibuf_in;
+	struct midi_buffer midibuf_in;
 
 	/**
 		 Buffer for outgoing MIDI stream.
 	*/
-	struct MidiBuffer midibuf_out;
+	struct midi_buffer midibuf_out;
 };
 
 extern int line6_init_midi(struct usb_line6 *line6);
diff --git a/drivers/staging/line6/midibuf.c b/drivers/staging/line6/midibuf.c
index 968e0de..f0adb7b 100644
--- a/drivers/staging/line6/midibuf.c
+++ b/drivers/staging/line6/midibuf.c
@@ -33,23 +33,23 @@ static int midibuf_message_length(unsigned char code)
 	}
 }
 
-static int midibuf_is_empty(struct MidiBuffer *this)
+static int midibuf_is_empty(struct midi_buffer *this)
 {
 	return (this->pos_read == this->pos_write) && !this->full;
 }
 
-static int midibuf_is_full(struct MidiBuffer *this)
+static int midibuf_is_full(struct midi_buffer *this)
 {
 	return this->full;
 }
 
-void line6_midibuf_reset(struct MidiBuffer *this)
+void line6_midibuf_reset(struct midi_buffer *this)
 {
 	this->pos_read = this->pos_write = this->full = 0;
 	this->command_prev = -1;
 }
 
-int line6_midibuf_init(struct MidiBuffer *this, int size, int split)
+int line6_midibuf_init(struct midi_buffer *this, int size, int split)
 {
 	this->buf = kmalloc(size, GFP_KERNEL);
 
@@ -62,14 +62,14 @@ int line6_midibuf_init(struct MidiBuffer *this, int size, int split)
 	return 0;
 }
 
-void line6_midibuf_status(struct MidiBuffer *this)
+void line6_midibuf_status(struct midi_buffer *this)
 {
 	pr_debug("midibuf size=%d split=%d pos_read=%d pos_write=%d full=%d command_prev=%02x\n",
 		 this->size, this->split, this->pos_read, this->pos_write,
 		 this->full, this->command_prev);
 }
 
-int line6_midibuf_bytes_free(struct MidiBuffer *this)
+int line6_midibuf_bytes_free(struct midi_buffer *this)
 {
 	return
 	    midibuf_is_full(this) ?
@@ -78,7 +78,7 @@ int line6_midibuf_bytes_free(struct MidiBuffer *this)
 	    1;
 }
 
-int line6_midibuf_bytes_used(struct MidiBuffer *this)
+int line6_midibuf_bytes_used(struct midi_buffer *this)
 {
 	return
 	    midibuf_is_empty(this) ?
@@ -87,7 +87,7 @@ int line6_midibuf_bytes_used(struct MidiBuffer *this)
 	    1;
 }
 
-int line6_midibuf_write(struct MidiBuffer *this, unsigned char *data,
+int line6_midibuf_write(struct midi_buffer *this, unsigned char *data,
 			int length)
 {
 	int bytes_free;
@@ -130,7 +130,8 @@ int line6_midibuf_write(struct MidiBuffer *this, unsigned char *data,
 	return length + skip_active_sense;
 }
 
-int line6_midibuf_read(struct MidiBuffer *this, unsigned char *data, int length)
+int line6_midibuf_read(struct midi_buffer *this, unsigned char *data,
+		       int length)
 {
 	int bytes_used;
 	int length1, length2;
@@ -234,7 +235,7 @@ int line6_midibuf_read(struct MidiBuffer *this, unsigned char *data, int length)
 	return length + repeat;
 }
 
-int line6_midibuf_ignore(struct MidiBuffer *this, int length)
+int line6_midibuf_ignore(struct midi_buffer *this, int length)
 {
 	int bytes_used = line6_midibuf_bytes_used(this);
 
@@ -246,7 +247,7 @@ int line6_midibuf_ignore(struct MidiBuffer *this, int length)
 	return length;
 }
 
-int line6_midibuf_skip_message(struct MidiBuffer *this, unsigned short mask)
+int line6_midibuf_skip_message(struct midi_buffer *this, unsigned short mask)
 {
 	int cmd = this->command_prev;
 
@@ -257,7 +258,7 @@ int line6_midibuf_skip_message(struct MidiBuffer *this, unsigned short mask)
 	return 0;
 }
 
-void line6_midibuf_destroy(struct MidiBuffer *this)
+void line6_midibuf_destroy(struct midi_buffer *this)
 {
 	kfree(this->buf);
 	this->buf = NULL;
diff --git a/drivers/staging/line6/midibuf.h b/drivers/staging/line6/midibuf.h
index 444cb3a..707482b 100644
--- a/drivers/staging/line6/midibuf.h
+++ b/drivers/staging/line6/midibuf.h
@@ -12,7 +12,7 @@
 #ifndef MIDIBUF_H
 #define MIDIBUF_H
 
-struct MidiBuffer {
+struct midi_buffer {
 	unsigned char *buf;
 	int size;
 	int split;
@@ -21,18 +21,18 @@ struct MidiBuffer {
 	int command_prev;
 };
 
-extern int line6_midibuf_bytes_used(struct MidiBuffer *mb);
-extern int line6_midibuf_bytes_free(struct MidiBuffer *mb);
-extern void line6_midibuf_destroy(struct MidiBuffer *mb);
-extern int line6_midibuf_ignore(struct MidiBuffer *mb, int length);
-extern int line6_midibuf_init(struct MidiBuffer *mb, int size, int split);
-extern int line6_midibuf_read(struct MidiBuffer *mb, unsigned char *data,
+extern int line6_midibuf_bytes_used(struct midi_buffer *mb);
+extern int line6_midibuf_bytes_free(struct midi_buffer *mb);
+extern void line6_midibuf_destroy(struct midi_buffer *mb);
+extern int line6_midibuf_ignore(struct midi_buffer *mb, int length);
+extern int line6_midibuf_init(struct midi_buffer *mb, int size, int split);
+extern int line6_midibuf_read(struct midi_buffer *mb, unsigned char *data,
 			      int length);
-extern void line6_midibuf_reset(struct MidiBuffer *mb);
-extern int line6_midibuf_skip_message(struct MidiBuffer *mb,
+extern void line6_midibuf_reset(struct midi_buffer *mb);
+extern int line6_midibuf_skip_message(struct midi_buffer *mb,
 				      unsigned short mask);
-extern void line6_midibuf_status(struct MidiBuffer *mb);
-extern int line6_midibuf_write(struct MidiBuffer *mb, unsigned char *data,
+extern void line6_midibuf_status(struct midi_buffer *mb);
+extern int line6_midibuf_write(struct midi_buffer *mb, unsigned char *data,
 			       int length);
 
 #endif
-- 
1.8.0.2

