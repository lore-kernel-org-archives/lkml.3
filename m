Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933749AbaGVWq4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 18:46:56 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44557 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932634AbaGVWYL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 18:24:11 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Takashi Iwai <tiwai@suse.de>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 111/116] ALSA: usb-audio: Fix races at disconnection and PCM closing
Date: Tue, 22 Jul 2014 15:22:02 -0700
Message-Id: <1406067727-19683-112-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406067727-19683-1-git-send-email-kamal@canonical.com>
References: <1406067727-19683-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.27 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 92a586bdc06de6629dae1b357dac221253f55ff8 upstream.

When a USB-audio device is disconnected while PCM is still running, we
still see some race: the disconnect callback calls
snd_usb_endpoint_free() that calls release_urbs() and then kfree()
while a PCM stream would be closed at the same time and calls
stop_endpoints() that leads to wait_clear_urbs().  That is, the EP
object might be deallocated while a PCM stream is syncing with
wait_clear_urbs() with the same EP.

Basically calling multiple wait_clear_urbs() would work fine, also
calling wait_clear_urbs() and release_urbs() would work, too, as
wait_clear_urbs() just reads some fields in ep.  The problem is the
succeeding kfree() in snd_pcm_endpoint_free().

This patch moves out the EP deallocation into the later point, the
destructor callback.  At this stage, all PCMs must have been already
closed, so it's safe to free the objects.

Reported-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 sound/usb/card.c     | 13 ++++++++++---
 sound/usb/endpoint.c | 17 ++++++++++++++---
 sound/usb/endpoint.h |  1 +
 3 files changed, 25 insertions(+), 6 deletions(-)

diff --git a/sound/usb/card.c b/sound/usb/card.c
index 3e4565f..3e42e2b 100644
--- a/sound/usb/card.c
+++ b/sound/usb/card.c
@@ -289,6 +289,11 @@ static int snd_usb_create_streams(struct snd_usb_audio *chip, int ctrlif)
 
 static int snd_usb_audio_free(struct snd_usb_audio *chip)
 {
+	struct list_head *p, *n;
+
+	list_for_each_safe(p, n, &chip->ep_list)
+		snd_usb_endpoint_free(p);
+
 	mutex_destroy(&chip->mutex);
 	kfree(chip);
 	return 0;
@@ -564,7 +569,7 @@ static void snd_usb_audio_disconnect(struct usb_device *dev,
 				     struct snd_usb_audio *chip)
 {
 	struct snd_card *card;
-	struct list_head *p, *n;
+	struct list_head *p;
 
 	if (chip == (void *)-1L)
 		return;
@@ -577,14 +582,16 @@ static void snd_usb_audio_disconnect(struct usb_device *dev,
 	mutex_lock(&register_mutex);
 	chip->num_interfaces--;
 	if (chip->num_interfaces <= 0) {
+		struct snd_usb_endpoint *ep;
+
 		snd_card_disconnect(card);
 		/* release the pcm resources */
 		list_for_each(p, &chip->pcm_list) {
 			snd_usb_stream_disconnect(p);
 		}
 		/* release the endpoint resources */
-		list_for_each_safe(p, n, &chip->ep_list) {
-			snd_usb_endpoint_free(p);
+		list_for_each_entry(ep, &chip->ep_list, list) {
+			snd_usb_endpoint_release(ep);
 		}
 		/* release the midi resources */
 		list_for_each(p, &chip->midi_list) {
diff --git a/sound/usb/endpoint.c b/sound/usb/endpoint.c
index f46a4e0..a86ccd7 100644
--- a/sound/usb/endpoint.c
+++ b/sound/usb/endpoint.c
@@ -950,19 +950,30 @@ int snd_usb_endpoint_deactivate(struct snd_usb_endpoint *ep)
 }
 
 /**
+ * snd_usb_endpoint_release: Tear down an snd_usb_endpoint
+ *
+ * @ep: the endpoint to release
+ *
+ * This function does not care for the endpoint's use count but will tear
+ * down all the streaming URBs immediately.
+ */
+void snd_usb_endpoint_release(struct snd_usb_endpoint *ep)
+{
+	release_urbs(ep, 1);
+}
+
+/**
  * snd_usb_endpoint_free: Free the resources of an snd_usb_endpoint
  *
  * @ep: the list header of the endpoint to free
  *
- * This function does not care for the endpoint's use count but will tear
- * down all the streaming URBs immediately and free all resources.
+ * This free all resources of the given ep.
  */
 void snd_usb_endpoint_free(struct list_head *head)
 {
 	struct snd_usb_endpoint *ep;
 
 	ep = list_entry(head, struct snd_usb_endpoint, list);
-	release_urbs(ep, 1);
 	kfree(ep);
 }
 
diff --git a/sound/usb/endpoint.h b/sound/usb/endpoint.h
index 447902d..b21f844 100644
--- a/sound/usb/endpoint.h
+++ b/sound/usb/endpoint.h
@@ -21,6 +21,7 @@ void snd_usb_endpoint_stop(struct snd_usb_endpoint *ep);
 void snd_usb_endpoint_sync_pending_stop(struct snd_usb_endpoint *ep);
 int  snd_usb_endpoint_activate(struct snd_usb_endpoint *ep);
 int  snd_usb_endpoint_deactivate(struct snd_usb_endpoint *ep);
+void snd_usb_endpoint_release(struct snd_usb_endpoint *ep);
 void snd_usb_endpoint_free(struct list_head *head);
 
 int snd_usb_endpoint_implict_feedback_sink(struct snd_usb_endpoint *ep);
-- 
1.9.1

