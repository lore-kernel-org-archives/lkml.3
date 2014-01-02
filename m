Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752190AbaABMLq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 07:11:46 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:54890 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823AbaABMIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 07:08:34 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Andrew Veliath <andrewtv@usa.net>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org
Subject: [PATCH, RFC 23/30] oss: msnd_pinnacle: avoid interruptible_sleep_on_timeout
Date: Thu,  2 Jan 2014 13:07:47 +0100
Message-Id: <1388664474-1710039-24-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1388664474-1710039-1-git-send-email-arnd@arndb.de>
References: <1388664474-1710039-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:o7raW/dMSfHlc3AjEuBNMvt81sgQDsvG8aMl+crs5pj
 9+v2nGzWBTRgwv7v6/BLT0wEvpxlBMOUzGYQvmr367mh16LLU5
 1BtoJF+dVO2P92wGU3B2/Xtm0EtAYMBcQAoczKpy17Jfzf5w2d
 YRAhTU7pV79RMvSt4Cclr3hgX4DAlSAVlNCSTENg3qSqjt9Ivr
 dRrLeKv7/RoOy9qPaCBaauZPTzNco9mwnmN8ZIrpSl72kydt6O
 k4jh166vvRGv8XlENQsn7LLP5iV/Z0bp7qvGwDYiwyhdLBYo/Q
 Xzrrd/R/MVBWVaHGrm8wgTGJbrh8zo6Itai/XGgMWNfKg1bPHJ
 LdgRqWso6vdrACXuknUMRkZLAU+IDUurB+7DNjg4x
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We want to remove all sleep_on variants from the kernel because they are
racy. In case of the pinnacle driver, we can replace
interruptible_sleep_on_timeout with wait_event_interruptible_timeout
by changing the meaning of a few flags used in the driver so they
are cleared at wakeup time, which is a somewhat more appropriate
way to do the same, although probably still racy.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Andrew Veliath <andrewtv@usa.net>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.de>
Cc: alsa-devel@alsa-project.org
---
 sound/oss/msnd_pinnacle.c | 31 ++++++++++++++++++-------------
 1 file changed, 18 insertions(+), 13 deletions(-)

diff --git a/sound/oss/msnd_pinnacle.c b/sound/oss/msnd_pinnacle.c
index 11ff7c5..c23f9f9 100644
--- a/sound/oss/msnd_pinnacle.c
+++ b/sound/oss/msnd_pinnacle.c
@@ -664,12 +664,15 @@ static long dev_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 
 static void dsp_write_flush(void)
 {
+	int timeout = get_play_delay_jiffies(dev.DAPF.len);
+
 	if (!(dev.mode & FMODE_WRITE) || !test_bit(F_WRITING, &dev.flags))
 		return;
 	set_bit(F_WRITEFLUSH, &dev.flags);
-	interruptible_sleep_on_timeout(
-		&dev.writeflush,
-		get_play_delay_jiffies(dev.DAPF.len));
+	wait_event_interruptible_timeout(
+		dev.writeflush,
+		!test_bit(F_WRITEFLUSH, &dev.flags),
+		timeout);
 	clear_bit(F_WRITEFLUSH, &dev.flags);
 	if (!signal_pending(current)) {
 		current->state = TASK_INTERRUPTIBLE;
@@ -897,6 +900,7 @@ static int dsp_read(char __user *buf, size_t len)
 {
 	int count = len;
 	char *page = (char *)__get_free_page(GFP_KERNEL);
+	int timeout = get_rec_delay_jiffies(DAR_BUFF_SIZE);
 
 	if (!page)
 		return -ENOMEM;
@@ -936,11 +940,11 @@ static int dsp_read(char __user *buf, size_t len)
 
 		if (count > 0) {
 			set_bit(F_READBLOCK, &dev.flags);
-			if (!interruptible_sleep_on_timeout(
-				&dev.readblock,
-				get_rec_delay_jiffies(DAR_BUFF_SIZE)))
+			if (wait_event_interruptible_timeout(
+					dev.readblock,
+					test_bit(F_READBLOCK, &dev.flags),
+					timeout) <= 0)
 				clear_bit(F_READING, &dev.flags);
-			clear_bit(F_READBLOCK, &dev.flags);
 			if (signal_pending(current)) {
 				free_page((unsigned long)page);
 				return -EINTR;
@@ -955,6 +959,7 @@ static int dsp_write(const char __user *buf, size_t len)
 {
 	int count = len;
 	char *page = (char *)__get_free_page(GFP_KERNEL);
+	int timeout = get_play_delay_jiffies(DAP_BUFF_SIZE);
 
 	if (!page)
 		return -ENOMEM;
@@ -995,10 +1000,10 @@ static int dsp_write(const char __user *buf, size_t len)
 
 		if (count > 0) {
 			set_bit(F_WRITEBLOCK, &dev.flags);
-			interruptible_sleep_on_timeout(
-				&dev.writeblock,
-				get_play_delay_jiffies(DAP_BUFF_SIZE));
-			clear_bit(F_WRITEBLOCK, &dev.flags);
+			wait_event_interruptible_timeout(
+				dev.writeblock,
+				test_bit(F_WRITEBLOCK, &dev.flags),
+				timeout);
 			if (signal_pending(current)) {
 				free_page((unsigned long)page);
 				return -EINTR;
@@ -1044,7 +1049,7 @@ static __inline__ void eval_dsp_msg(register WORD wMessage)
 			clear_bit(F_WRITING, &dev.flags);
 		}
 
-		if (test_bit(F_WRITEBLOCK, &dev.flags))
+		if (test_and_clear_bit(F_WRITEBLOCK, &dev.flags))
 			wake_up_interruptible(&dev.writeblock);
 		break;
 
@@ -1055,7 +1060,7 @@ static __inline__ void eval_dsp_msg(register WORD wMessage)
 
 		pack_DARQ_to_DARF(dev.last_recbank);
 
-		if (test_bit(F_READBLOCK, &dev.flags))
+		if (test_and_clear_bit(F_READBLOCK, &dev.flags))
 			wake_up_interruptible(&dev.readblock);
 		break;
 
-- 
1.8.3.2

