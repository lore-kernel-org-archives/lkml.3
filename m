Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751920AbaABMIv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 07:08:51 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:56372 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751870AbaABMIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 07:08:38 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org
Subject: [PATCH, RFC 27/30] oss: remove last sleep_on users
Date: Thu,  2 Jan 2014 13:07:51 +0100
Message-Id: <1388664474-1710039-28-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1388664474-1710039-1-git-send-email-arnd@arndb.de>
References: <1388664474-1710039-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:21nyjhhYUdc9TOmUMFnS8E02B+qp25Kc+JayYL6QpN4
 MTYAIdNgyYyX64v0QXAsDsSv8NK6UPGX9Br6A5gDWtd3fAuTmX
 oKHz2grW5RIfMl4kFyqIB7FI3fUdcOTFJOoOqfi0KQ9dl1aVjN
 e2OgwUbLXmY/a2P/GRuS24rjWx2jjakYiCmwYJOWZ44O21aw0j
 u/1gJ5+CZIkhK4EsAXaqnAF6mr9ZjoK6tycXE1hpBYLt0jo8+Q
 53OAAYmpZyqMfPAiJQX60KPOfhih6fWjZXZzkRX1YIVidj9tqD
 jnBhqEmB9KbkG0LMNByIEX0FviHjlBDfQdHAXeY/qowxOHqTxn
 dD0C5T/IZLeIRLgyb6ReMmBp7wfFIQCjpO2kMkRxc
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are three files in oss for which I could not find an easy way to
replace interruptible_sleep_on_timeout with a non-racy version. This
patch instead just adds a private implementation of the function, now
named oss_broken_sleep_on, and changes over the remaining users in
sound/oss/ so we can remove the global interface.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.de>
Cc: alsa-devel@alsa-project.org
---
 sound/oss/dmabuf.c        | 14 ++++++--------
 sound/oss/sequencer.c     | 16 +++++++---------
 sound/oss/sleep.h         | 18 ++++++++++++++++++
 sound/oss/swarm_cs4297a.c | 14 ++++++++------
 4 files changed, 39 insertions(+), 23 deletions(-)
 create mode 100644 sound/oss/sleep.h

diff --git a/sound/oss/dmabuf.c b/sound/oss/dmabuf.c
index 461d94c..e3f2913 100644
--- a/sound/oss/dmabuf.c
+++ b/sound/oss/dmabuf.c
@@ -28,6 +28,7 @@
 #include <linux/mm.h>
 #include <linux/gfp.h>
 #include "sound_config.h"
+#include "sleep.h"
 
 #define DMAP_FREE_ON_CLOSE      0
 #define DMAP_KEEP_ON_CLOSE      1
@@ -351,8 +352,7 @@ static void dma_reset_output(int dev)
 	if (!signal_pending(current) && adev->dmap_out->qlen && 
 	    adev->dmap_out->underrun_count == 0){
 		spin_unlock_irqrestore(&dmap->lock,flags);
-		interruptible_sleep_on_timeout(&adev->out_sleeper,
-					       dmabuf_timeout(dmap));
+		oss_broken_sleep_on(&adev->out_sleeper, dmabuf_timeout(dmap));
 		spin_lock_irqsave(&dmap->lock,flags);
 	}
 	adev->dmap_out->flags &= ~(DMA_SYNCING | DMA_ACTIVE);
@@ -446,7 +446,7 @@ int DMAbuf_sync(int dev)
 			long t = dmabuf_timeout(dmap);
 			spin_unlock_irqrestore(&dmap->lock,flags);
 			/* FIXME: not safe may miss events */
-			t = interruptible_sleep_on_timeout(&adev->out_sleeper, t);
+			t = oss_broken_sleep_on(&adev->out_sleeper, t);
 			spin_lock_irqsave(&dmap->lock,flags);
 			if (!t) {
 				adev->dmap_out->flags &= ~DMA_SYNCING;
@@ -466,7 +466,7 @@ int DMAbuf_sync(int dev)
 			while (!signal_pending(current) &&
 			       adev->d->local_qlen(dev)){
 				spin_unlock_irqrestore(&dmap->lock,flags);
-				interruptible_sleep_on_timeout(&adev->out_sleeper,
+				oss_broken_sleep_on(&adev->out_sleeper,
 							       dmabuf_timeout(dmap));
 				spin_lock_irqsave(&dmap->lock,flags);
 			}
@@ -587,8 +587,7 @@ int DMAbuf_getrdbuffer(int dev, char **buf, int *len, int dontblock)
 			timeout = dmabuf_timeout(dmap);
 
 		spin_unlock_irqrestore(&dmap->lock,flags);
-		timeout = interruptible_sleep_on_timeout(&adev->in_sleeper,
-							 timeout);
+		timeout = oss_broken_sleep_on(&adev->in_sleeper, timeout);
 		if (!timeout) {
 			/* FIXME: include device name */
 			err = -EIO;
@@ -768,8 +767,7 @@ static int output_sleep(int dev, int dontblock)
 		timeout_value = dmabuf_timeout(dmap);
 	else
 		timeout_value = MAX_SCHEDULE_TIMEOUT;
-	timeout_value = interruptible_sleep_on_timeout(&adev->out_sleeper,
-						       timeout_value);
+	timeout_value = oss_broken_sleep_on(&adev->out_sleeper, timeout_value);
 	if (timeout != MAX_SCHEDULE_TIMEOUT && !timeout_value) {
 		printk(KERN_WARNING "Sound: DMA (output) timed out - IRQ/DRQ config error?\n");
 		dma_reset_output(dev);
diff --git a/sound/oss/sequencer.c b/sound/oss/sequencer.c
index 4ff60a6..c855a75 100644
--- a/sound/oss/sequencer.c
+++ b/sound/oss/sequencer.c
@@ -19,6 +19,7 @@
 #include "sound_config.h"
 
 #include "midi_ctrl.h"
+#include "sleep.h"
 
 static int      sequencer_ok;
 static struct sound_timer_operations *tmr;
@@ -100,8 +101,7 @@ int sequencer_read(int dev, struct file *file, char __user *buf, int count)
   			return -EAGAIN;
   		}
 
- 		interruptible_sleep_on_timeout(&midi_sleeper,
-					       pre_event_timeout);
+ 		oss_broken_sleep_on(&midi_sleeper, pre_event_timeout);
 		spin_lock_irqsave(&lock,flags);
 		if (!iqlen)
 		{
@@ -343,7 +343,7 @@ static int seq_queue(unsigned char *note, char nonblock)
 		/*
 		 * Sleep until there is enough space on the queue
 		 */
-		interruptible_sleep_on(&seq_sleeper);
+		oss_broken_sleep_on(&seq_sleeper, MAX_SCHEDULE_TIMEOUT);
 	}
 	if (qlen >= SEQ_MAX_QUEUE)
 	{
@@ -1122,8 +1122,7 @@ static void seq_drain_midi_queues(void)
 		 */
 
  		if (n)
- 			interruptible_sleep_on_timeout(&seq_sleeper,
-						       HZ/10);
+ 			oss_broken_sleep_on(&seq_sleeper, HZ/10);
 	}
 }
 
@@ -1145,8 +1144,7 @@ void sequencer_release(int dev, struct file *file)
 		while (!signal_pending(current) && qlen > 0)
 		{
   			seq_sync();
- 			interruptible_sleep_on_timeout(&seq_sleeper,
-						       3*HZ);
+ 			oss_broken_sleep_on(&seq_sleeper, 3*HZ);
  			/* Extra delay */
 		}
 	}
@@ -1201,7 +1199,7 @@ static int seq_sync(void)
 		seq_startplay();
 
  	if (qlen > 0)
- 		interruptible_sleep_on_timeout(&seq_sleeper, HZ);
+ 		oss_broken_sleep_on(&seq_sleeper, HZ);
 	return qlen;
 }
 
@@ -1224,7 +1222,7 @@ static void midi_outc(int dev, unsigned char data)
 
 	spin_lock_irqsave(&lock,flags);
  	while (n && !midi_devs[dev]->outputc(dev, data)) {
- 		interruptible_sleep_on_timeout(&seq_sleeper, HZ/25);
+ 		oss_broken_sleep_on(&seq_sleeper, HZ/25);
   		n--;
   	}
 	spin_unlock_irqrestore(&lock,flags);
diff --git a/sound/oss/sleep.h b/sound/oss/sleep.h
new file mode 100644
index 0000000..a20fc92
--- /dev/null
+++ b/sound/oss/sleep.h
@@ -0,0 +1,18 @@
+#include <linux/wait.h>
+
+/*
+ * Do not use. This is a replacement for the old
+ * "interruptible_sleep_on_timeout" function that has been
+ * deprecated for ages. All users should instead try to use
+ * wait_event_interruptible_timeout.
+ */
+
+static inline long
+oss_broken_sleep_on(wait_queue_head_t *q, long timeout)
+{
+	DEFINE_WAIT(wait);
+	prepare_to_wait(q, &wait, TASK_INTERRUPTIBLE);
+	timeout = schedule_timeout(timeout);
+	finish_wait(q, &wait);
+	return timeout;
+}
diff --git a/sound/oss/swarm_cs4297a.c b/sound/oss/swarm_cs4297a.c
index 7d8803a..59defdc 100644
--- a/sound/oss/swarm_cs4297a.c
+++ b/sound/oss/swarm_cs4297a.c
@@ -90,6 +90,8 @@
 #include <asm/sibyte/sb1250_mac.h>
 #include <asm/sibyte/sb1250.h>
 
+#include "sleep.h"
+
 struct cs4297a_state;
 
 static DEFINE_MUTEX(swarm_cs4297a_mutex);
@@ -748,7 +750,7 @@ static int serdma_reg_access(struct cs4297a_state *s, u64 data)
                 /* Since a writer has the DSP open, we have to mux the
                    request in */
                 s->reg_request = data;
-                interruptible_sleep_on(&s->dma_dac.reg_wait);
+                oss_broken_sleep_on(&s->dma_dac.reg_wait, MAX_SCHEDULE_TIMEOUT);
                 /* XXXKW how can I deal with the starvation case where
                    the opener isn't writing? */
         } else {
@@ -790,7 +792,7 @@ static int cs4297a_read_ac97(struct cs4297a_state *s, u32 offset,
         if (serdma_reg_access(s, (0xCLL << 60) | (1LL << 47) | ((u64)(offset & 0x7F) << 40)))
                 return -1;
 
-        interruptible_sleep_on(&s->dma_adc.reg_wait);
+        oss_broken_sleep_on(&s->dma_adc.reg_wait, MAX_SCHEDULE_TIMEOUT);
         *value = s->read_value;
         CS_DBGOUT(CS_AC97, 2,
                   printk(KERN_INFO "cs4297a: rdr reg %x -> %x\n", s->read_reg, s->read_value));
@@ -1740,7 +1742,7 @@ static ssize_t cs4297a_read(struct file *file, char *buffer, size_t count,
 			start_adc(s);
 			if (file->f_flags & O_NONBLOCK)
 				return ret ? ret : -EAGAIN;
-			interruptible_sleep_on(&s->dma_adc.wait);
+			oss_broken_sleep_on(&s->dma_adc.wait, MAX_SCHEDULE_TIMEOUT);
 			if (signal_pending(current))
 				return ret ? ret : -ERESTARTSYS;
 			continue;
@@ -1836,7 +1838,7 @@ static ssize_t cs4297a_write(struct file *file, const char *buffer,
 			start_dac(s);
 			if (file->f_flags & O_NONBLOCK)
 				return ret ? ret : -EAGAIN;
-			interruptible_sleep_on(&d->wait);
+			oss_broken_sleep_on(&d->wait, MAX_SCHEDULE_TIMEOUT);
 			if (signal_pending(current))
 				return ret ? ret : -ERESTARTSYS;
 			continue;
@@ -2452,7 +2454,7 @@ static int cs4297a_locked_open(struct inode *inode, struct file *file)
 				return -EBUSY;
 			}
 			mutex_unlock(&s->open_sem_dac);
-			interruptible_sleep_on(&s->open_wait_dac);
+			oss_broken_sleep_on(&s->open_wait_dac, MAX_SCHEDULE_TIMEOUT);
 
 			if (signal_pending(current)) {
                                 printk("open - sig pending\n");
@@ -2469,7 +2471,7 @@ static int cs4297a_locked_open(struct inode *inode, struct file *file)
 				return -EBUSY;
 			}
 			mutex_unlock(&s->open_sem_adc);
-			interruptible_sleep_on(&s->open_wait_adc);
+			oss_broken_sleep_on(&s->open_wait_adc, MAX_SCHEDULE_TIMEOUT);
 
 			if (signal_pending(current)) {
                                 printk("open - sig pending\n");
-- 
1.8.3.2

