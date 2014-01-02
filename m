Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752263AbaABMMf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 07:12:35 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:50468 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818AbaABMIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 07:08:32 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org
Subject: [PATCH, RFC 24/30] oss: midibuf: fix sleep_on races
Date: Thu,  2 Jan 2014 13:07:48 +0100
Message-Id: <1388664474-1710039-25-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1388664474-1710039-1-git-send-email-arnd@arndb.de>
References: <1388664474-1710039-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:Pk1zjfMQMhqFRxctgw1JDY696Fuu2S9X31YpuHSvYcd
 ko72IWC+CSGxZcNOPtW/kjb+rJB+ZiouMWrUQt4ATKFPpQZxDb
 dAeXvc/OyuckYMhlbSd0qOfYM8P2wE5Anrl8oXWgdXRAAWMZEC
 wna3stO5UOX4F8lqjqUKZyqL/sOJrtwrufIka1LRil1tAjHOW5
 bgaw83U57dP19URT+Jv4/QHR6+AwRoOb/OgSw7sV4fOQ8pCXu7
 kZYrX+LPrSR/zLU2YX4PPeGbIfQNJUKr0Zerr+ZO478Gt+763S
 iwfTboMuTiylgKx9s/FFyugbFaCdoUklHWJSoLJgUc44V5UqGi
 nB+C5nqheYNOB9AHuN5rnlGPwD4UJEP4BrlrZpqim
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sleep_on is known to be racy and going away because of this. All instances
of interruptible_sleep_on and interruptible_sleep_on_timeout in the midibuf
driver can trivially be replaced with wait_event_interruptible and
wait_event_interruptible_timeout.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.de>
Cc: alsa-devel@alsa-project.org
---
 sound/oss/midibuf.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/sound/oss/midibuf.c b/sound/oss/midibuf.c
index 8cdb2cf..79615cf 100644
--- a/sound/oss/midibuf.c
+++ b/sound/oss/midibuf.c
@@ -86,9 +86,8 @@ static void drain_midi_queue(int dev)
 	 */
 
 	if (midi_devs[dev]->buffer_status != NULL)
-		while (!signal_pending(current) && midi_devs[dev]->buffer_status(dev)) 
-			interruptible_sleep_on_timeout(&midi_sleeper[dev],
-						       HZ/10);
+		wait_event_interruptible_timeout(midi_sleeper[dev],
+				!midi_devs[dev]->buffer_status(dev), HZ/10);
 }
 
 static void midi_input_intr(int dev, unsigned char data)
@@ -233,8 +232,8 @@ void MIDIbuf_release(int dev, struct file *file)
 							   * devices
 							 */
 
-		while (!signal_pending(current) && DATA_AVAIL(midi_out_buf[dev]))
-			  interruptible_sleep_on(&midi_sleeper[dev]);
+		wait_event_interruptible(midi_sleeper[dev],
+					 !DATA_AVAIL(midi_out_buf[dev]));
 		/*
 		 *	Sync
 		 */
@@ -282,8 +281,8 @@ int MIDIbuf_write(int dev, struct file *file, const char __user *buf, int count)
 				goto out;
 			}
 
-			interruptible_sleep_on(&midi_sleeper[dev]);
-			if (signal_pending(current)) 
+			if (wait_event_interruptible(midi_sleeper[dev],
+						SPACE_AVAIL(midi_out_buf[dev])))
 			{
 				c = -EINTR;
 				goto out;
@@ -325,8 +324,9 @@ int MIDIbuf_read(int dev, struct file *file, char __user *buf, int count)
  			c = -EAGAIN;
 			goto out;
  		}
-		interruptible_sleep_on_timeout(&input_sleeper[dev],
-					       parms[dev].prech_timeout);
+		wait_event_interruptible_timeout(input_sleeper[dev],
+						 DATA_AVAIL(midi_in_buf[dev]),
+					         parms[dev].prech_timeout);
 
 		if (signal_pending(current))
 			c = -EINTR;	/* The user is getting restless */
-- 
1.8.3.2

