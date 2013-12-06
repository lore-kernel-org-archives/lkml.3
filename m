Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162164Ab3LFNF7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 08:05:59 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44778 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161381Ab3LFNFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 08:05:55 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Vinod Koul <vinod.koul@intel.com>, Takashi Iwai <tiwai@suse.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 256/272] ALSA: compress: fix drain calls blocking other compress functions (v6)
Date: Fri,  6 Dec 2013 12:59:05 +0000
Message-Id: <1386334761-25517-257-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
References: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vinod Koul <vinod.koul@intel.com>

commit f44f2a5417b2968a8724b352cc0b2545a6bcb1f4 upstream.

The drain and drain_notify callback were blocked by low level driver
until the draining was complete. Due to this being invoked with big
fat mutex held, others ops like reading timestamp, calling pause, drop
were blocked.

So to fix this we add a new snd_compr_drain_notify() API. This would
be required to be invoked by low level driver when drain or partial
drain has been completed by the DSP. Thus we make the drain and
partial_drain callback as non blocking and driver returns immediately
after notifying DSP.  The waiting is done while releasing the lock so
that other ops can go ahead.

[ The commit 917f4b5cba78 was wrongly applied from the preliminary
  patch.  This commit corrects to the final version.
  Sorry for inconvenience!  -- tiwai ]

Signed-off-by: Vinod Koul <vinod.koul@intel.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 include/sound/compress_driver.h | 11 ++++-------
 sound/core/compress_offload.c   | 31 +++++++++++++++++++------------
 2 files changed, 23 insertions(+), 19 deletions(-)

diff --git a/include/sound/compress_driver.h b/include/sound/compress_driver.h
index 175ab32..ae6c3b8 100644
--- a/include/sound/compress_driver.h
+++ b/include/sound/compress_driver.h
@@ -48,8 +48,6 @@ struct snd_compr_ops;
  *	the ring buffer
  * @total_bytes_transferred: cumulative bytes transferred by offload DSP
  * @sleep: poll sleep
- * @wait: drain wait queue
- * @drain_wake: condition for drain wake
  */
 struct snd_compr_runtime {
 	snd_pcm_state_t state;
@@ -61,8 +59,6 @@ struct snd_compr_runtime {
 	u64 total_bytes_available;
 	u64 total_bytes_transferred;
 	wait_queue_head_t sleep;
-	wait_queue_head_t wait;
-	unsigned int drain_wake;
 	void *private_data;
 };
 
@@ -177,10 +173,11 @@ static inline void snd_compr_fragment_elapsed(struct snd_compr_stream *stream)
 
 static inline void snd_compr_drain_notify(struct snd_compr_stream *stream)
 {
-	snd_BUG_ON(!stream);
+	if (snd_BUG_ON(!stream))
+		return;
 
-	stream->runtime->drain_wake = 1;
-	wake_up(&stream->runtime->wait);
+	stream->runtime->state = SNDRV_PCM_STATE_SETUP;
+	wake_up(&stream->runtime->sleep);
 }
 
 #endif
diff --git a/sound/core/compress_offload.c b/sound/core/compress_offload.c
index 68d3ffca..1979993 100644
--- a/sound/core/compress_offload.c
+++ b/sound/core/compress_offload.c
@@ -123,7 +123,6 @@ static int snd_compr_open(struct inode *inode, struct file *f)
 	}
 	runtime->state = SNDRV_PCM_STATE_OPEN;
 	init_waitqueue_head(&runtime->sleep);
-	init_waitqueue_head(&runtime->wait);
 	data->stream.runtime = runtime;
 	f->private_data = (void *)data;
 	mutex_lock(&compr->lock);
@@ -669,8 +668,6 @@ static int snd_compr_stop(struct snd_compr_stream *stream)
 		return -EPERM;
 	retval = stream->ops->trigger(stream, SNDRV_PCM_TRIGGER_STOP);
 	if (!retval) {
-		stream->runtime->state = SNDRV_PCM_STATE_SETUP;
-		wake_up(&stream->runtime->sleep);
 		snd_compr_drain_notify(stream);
 		stream->runtime->total_bytes_available = 0;
 		stream->runtime->total_bytes_transferred = 0;
@@ -680,6 +677,8 @@ static int snd_compr_stop(struct snd_compr_stream *stream)
 
 static int snd_compress_wait_for_drain(struct snd_compr_stream *stream)
 {
+	int ret;
+
 	/*
 	 * We are called with lock held. So drop the lock while we wait for
 	 * drain complete notfication from the driver
@@ -691,12 +690,24 @@ static int snd_compress_wait_for_drain(struct snd_compr_stream *stream)
 	stream->runtime->state = SNDRV_PCM_STATE_DRAINING;
 	mutex_unlock(&stream->device->lock);
 
-	wait_event(stream->runtime->wait, stream->runtime->drain_wake);
+	/* we wait for drain to complete here, drain can return when
+	 * interruption occurred, wait returned error or success.
+	 * For the first two cases we don't do anything different here and
+	 * return after waking up
+	 */
+
+	ret = wait_event_interruptible(stream->runtime->sleep,
+			(stream->runtime->state != SNDRV_PCM_STATE_DRAINING));
+	if (ret == -ERESTARTSYS)
+		pr_debug("wait aborted by a signal");
+	else if (ret)
+		pr_debug("wait for drain failed with %d\n", ret);
+
 
 	wake_up(&stream->runtime->sleep);
 	mutex_lock(&stream->device->lock);
 
-	return 0;
+	return ret;
 }
 
 static int snd_compr_drain(struct snd_compr_stream *stream)
@@ -707,17 +718,14 @@ static int snd_compr_drain(struct snd_compr_stream *stream)
 			stream->runtime->state == SNDRV_PCM_STATE_SETUP)
 		return -EPERM;
 
-	stream->runtime->drain_wake = 0;
 	retval = stream->ops->trigger(stream, SND_COMPR_TRIGGER_DRAIN);
 	if (retval) {
-		pr_err("SND_COMPR_TRIGGER_DRAIN failed %d\n", retval);
+		pr_debug("SND_COMPR_TRIGGER_DRAIN failed %d\n", retval);
 		wake_up(&stream->runtime->sleep);
 		return retval;
 	}
 
-	retval = snd_compress_wait_for_drain(stream);
-	stream->runtime->state = SNDRV_PCM_STATE_SETUP;
-	return retval;
+	return snd_compress_wait_for_drain(stream);
 }
 
 static int snd_compr_next_track(struct snd_compr_stream *stream)
@@ -752,10 +760,9 @@ static int snd_compr_partial_drain(struct snd_compr_stream *stream)
 	if (stream->next_track == false)
 		return -EPERM;
 
-	stream->runtime->drain_wake = 0;
 	retval = stream->ops->trigger(stream, SND_COMPR_TRIGGER_PARTIAL_DRAIN);
 	if (retval) {
-		pr_err("Partial drain returned failure\n");
+		pr_debug("Partial drain returned failure\n");
 		wake_up(&stream->runtime->sleep);
 		return retval;
 	}
-- 
1.8.3.2

