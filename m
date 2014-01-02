Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752217AbaABMLr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 07:11:47 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:50222 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751820AbaABMId (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 07:08:33 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org
Subject: [PATCH, RFC 26/30] oss: dmasound: kill SLEEP() macro to avoid race
Date: Thu,  2 Jan 2014 13:07:50 +0100
Message-Id: <1388664474-1710039-27-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1388664474-1710039-1-git-send-email-arnd@arndb.de>
References: <1388664474-1710039-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:pipcHylConGBpB2XTOy8dOAHajo3LfmrTh+AiVqUj29
 3SKwgNNpk6IVe9OUz7Dsfn2RKtbt3PZ9vfyEqeiRxV+dF9QB1F
 ttHANvhsmyC1F0S51Ljnmdjhb51TPIGezaYPYS/Jsf84gPYxQF
 LnfmAmmCQzgSQUBRGHkSXfI/rJcFg8YIwYEE59DSlU3mHM83Vk
 eQuHsi+4g8qB1uko6eHtX0L283mU6OBynGPSlczBTgRWDFTPwR
 GZHaK6kasdbXetARNstxs4F1JnSbz1+GovdemVFVCIApXwbRKv
 t/jizG66o6oUd8iB51w+4TUR0R9w4QI9qWizj0taqF77t/tYZw
 rkt9pVXWsnTSfkT3tcRK8yRymy5n2DPH2GXXfvBPE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The use of interruptible_sleep_on_timeout in the dmasound driver
is questionable and we want to kill off all sleep_on variants.
This replaces the calls with wait_event_interruptible_timeout
where possible, to wait for a particular event instead of blocking
in a racy way. In the sq_write function, the easiest solution is
an open-coded prepare_to_wait loop.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.de>
Cc: alsa-devel@alsa-project.org
---
 sound/oss/dmasound/dmasound.h      |  1 -
 sound/oss/dmasound/dmasound_core.c | 28 +++++++++++++++++++---------
 2 files changed, 19 insertions(+), 10 deletions(-)

diff --git a/sound/oss/dmasound/dmasound.h b/sound/oss/dmasound/dmasound.h
index 1308d8d..01019f0 100644
--- a/sound/oss/dmasound/dmasound.h
+++ b/sound/oss/dmasound/dmasound.h
@@ -239,7 +239,6 @@ struct sound_queue {
     int busy, syncing, xruns, died;
 };
 
-#define SLEEP(queue)		interruptible_sleep_on_timeout(&queue, HZ)
 #define WAKE_UP(queue)		(wake_up_interruptible(&queue))
 
 extern struct sound_queue dmasound_write_sq;
diff --git a/sound/oss/dmasound/dmasound_core.c b/sound/oss/dmasound/dmasound_core.c
index bac43b5..f4ee85a 100644
--- a/sound/oss/dmasound/dmasound_core.c
+++ b/sound/oss/dmasound/dmasound_core.c
@@ -619,15 +619,27 @@ static ssize_t sq_write(struct file *file, const char __user *src, size_t uLeft,
 	}
 
 	while (uLeft) {
+		DEFINE_WAIT(wait);
+
 		while (write_sq.count >= write_sq.max_active) {
+			prepare_to_wait(&write_sq.action_queue, &wait, TASK_INTERRUPTIBLE);
 			sq_play();
-			if (write_sq.non_blocking)
+			if (write_sq.non_blocking) {
+				finish_wait(&write_sq.action_queue, &wait);
 				return uWritten > 0 ? uWritten : -EAGAIN;
-			SLEEP(write_sq.action_queue);
-			if (signal_pending(current))
+			}
+			if (write_sq.count < write_sq.max_active)
+				break;
+
+			schedule_timeout(HZ);
+			if (signal_pending(current)) {
+				finish_wait(&write_sq.action_queue, &wait);
 				return uWritten > 0 ? uWritten : -EINTR;
+			}
 		}
 
+		finish_wait(&write_sq.action_queue, &wait);
+
 		/* Here, we can avoid disabling the interrupt by first
 		 * copying and translating the data, and then updating
 		 * the write_sq variables. Until this is done, the interrupt
@@ -707,11 +719,8 @@ static int sq_open2(struct sound_queue *sq, struct file *file, fmode_t mode,
 			if (file->f_flags & O_NONBLOCK)
 				return rc;
 			rc = -EINTR;
-			while (sq->busy) {
-				SLEEP(sq->open_queue);
-				if (signal_pending(current))
-					return rc;
-			}
+			if (wait_event_interruptible(sq->open_queue, !sq->busy))
+				return rc;
 			rc = 0;
 #else
 			/* OSS manual says we will return EBUSY regardless
@@ -844,7 +853,8 @@ static int sq_fsync(void)
 	sq_play();	/* there may be an incomplete frame waiting */
 
 	while (write_sq.active) {
-		SLEEP(write_sq.sync_queue);
+		wait_event_interruptible_timeout(write_sq.sync_queue,
+						 !write_sq.active, HZ);
 		if (signal_pending(current)) {
 			/* While waiting for audio output to drain, an
 			 * interrupt occurred.  Stop audio output immediately
-- 
1.8.3.2

