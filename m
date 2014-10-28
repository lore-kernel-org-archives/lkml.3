Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932157AbaJ1LaE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 07:30:04 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:59495 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113AbaJ1LaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 07:30:00 -0400
Date: Tue, 28 Oct 2014 13:29:56 +0200
From: Aya Mahfouz <mahfouz.saif.elyazal@gmail.com>
To: perex@perex.cz, tiwai@suse.de, bhelgaas@google.com, benoit.taine@lip6.fr
Cc: arnd@arndb.de, opw-kernel@googlegroups.com, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] sound: pci: pcxhr: convert timeval to ktime_t
Message-ID: <20141028112955.GA2365@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is concerned with migrating the time variables in the pcxhr
module found in the sound driver. The changes are concerend with the
y2038 problem where timeval will overflow in the year 2038. ktime_t
was used instead of timeval to get the wall time. The difference
is displayed now in nanoseconds instead of microseconds.

Signed-off-by: Aya Mahfouz <mahfouz.saif.elyazal@gmail.com>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
---
 sound/pci/pcxhr/pcxhr.c      | 10 ++++++----
 sound/pci/pcxhr/pcxhr_core.c | 10 ++++++----
 2 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/sound/pci/pcxhr/pcxhr.c b/sound/pci/pcxhr/pcxhr.c
index b854fc5..3f4607c 100644
--- a/sound/pci/pcxhr/pcxhr.c
+++ b/sound/pci/pcxhr/pcxhr.c
@@ -711,8 +711,9 @@ static void pcxhr_start_linked_stream(struct pcxhr_mgr *mgr)
 	int playback_mask = 0;
 
 #ifdef CONFIG_SND_DEBUG_VERBOSE
-	struct timeval my_tv1, my_tv2;
-	do_gettimeofday(&my_tv1);
+	ktime_t start, stop, diff;
+
+	start = ktime_get();
 #endif
 	mutex_lock(&mgr->setup_mutex);
 
@@ -823,9 +824,10 @@ static void pcxhr_start_linked_stream(struct pcxhr_mgr *mgr)
 	mutex_unlock(&mgr->setup_mutex);
 
 #ifdef CONFIG_SND_DEBUG_VERBOSE
-	do_gettimeofday(&my_tv2);
+	stop = ktime_get();
+	diff = ktime_sub(stop, start);
 	dev_dbg(&mgr->pci->dev, "***TRIGGER START*** TIME = %ld (err = %x)\n",
-		    (long)(my_tv2.tv_usec - my_tv1.tv_usec), err);
+			(long)(ktime_to_ns(diff)), err);
 #endif
 }
 
diff --git a/sound/pci/pcxhr/pcxhr_core.c b/sound/pci/pcxhr/pcxhr_core.c
index a584acb..be3c003 100644
--- a/sound/pci/pcxhr/pcxhr_core.c
+++ b/sound/pci/pcxhr/pcxhr_core.c
@@ -910,8 +910,9 @@ int pcxhr_set_pipe_state(struct pcxhr_mgr *mgr, int playback_mask,
 	int audio_mask;
 
 #ifdef CONFIG_SND_DEBUG_VERBOSE
-	struct timeval my_tv1, my_tv2;
-	do_gettimeofday(&my_tv1);
+	ktime_t start, stop, diff;
+
+	start = ktime_get();
 #endif
 	audio_mask = (playback_mask |
 		      (capture_mask << PCXHR_PIPE_STATE_CAPTURE_OFFSET));
@@ -960,9 +961,10 @@ int pcxhr_set_pipe_state(struct pcxhr_mgr *mgr, int playback_mask,
 			return err;
 	}
 #ifdef CONFIG_SND_DEBUG_VERBOSE
-	do_gettimeofday(&my_tv2);
+	stop = ktime_get();
+	diff = ktime_sub(stop, start);
 	dev_dbg(&mgr->pci->dev, "***SET PIPE STATE*** TIME = %ld (err = %x)\n",
-		    (long)(my_tv2.tv_usec - my_tv1.tv_usec), err);
+			(long)(ktime_to_ns(diff)), err);
 #endif
 	return 0;
 }
-- 
1.9.3

