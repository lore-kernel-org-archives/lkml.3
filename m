Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754874Ab3HPRTS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 13:19:18 -0400
Received: from mail.tpi.com ([74.45.170.26]:33654 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752751Ab3HPRTO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 13:19:14 -0400
From: Tim Gardner <tim.gardner@canonical.com>
To: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Cc: Tim Gardner <tim.gardner@canonical.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Yacine Belkadi <yacine.belkadi.1@gmail.com>
Subject: [PATCH 3.11-rc5 1/2] ALSA: pcm: Add snd_printd_ratelimit()
Date: Fri, 16 Aug 2013 11:18:59 -0600
Message-Id: <1376673540-2201-1-git-send-email-tim.gardner@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Direct calls to printk_limit() will emit log noise even when CONFIG_SND_DEBUG is not
defined. Add a wrapper macro around printk_limit() that is conditionally defined by
CONFIG_SND_DEBUG.

Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.de>
Cc: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Cc: Lars-Peter Clausen <lars@metafoo.de>
Cc: Yacine Belkadi <yacine.belkadi.1@gmail.com>
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---

checkpatch is moaning about the use of printk_ratelimit(), but
printk_ratelimited() seems like overkill for a debug feature.

WARNING: Prefer printk_ratelimited or pr_<level>_ratelimited to printk_ratelimit
#38: FILE: include/sound/core.h:382:
+#define snd_printd_ratelimit() printk_ratelimit()

 include/sound/core.h |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/include/sound/core.h b/include/sound/core.h
index c586617..2a14f1f 100644
--- a/include/sound/core.h
+++ b/include/sound/core.h
@@ -27,6 +27,7 @@
 #include <linux/rwsem.h>		/* struct rw_semaphore */
 #include <linux/pm.h>			/* pm_message_t */
 #include <linux/stringify.h>
+#include <linux/printk.h>
 
 /* number of supported soundcards */
 #ifdef CONFIG_SND_DYNAMIC_MINORS
@@ -376,6 +377,11 @@ void __snd_printk(unsigned int level, const char *file, int line,
 #define snd_BUG()		WARN(1, "BUG?\n")
 
 /**
+ * Suppress high rates of output when CONFIG_SND_DEBUG is enabled.
+ */
+#define snd_printd_ratelimit() printk_ratelimit()
+
+/**
  * snd_BUG_ON - debugging check macro
  * @cond: condition to evaluate
  *
@@ -398,6 +404,8 @@ static inline void _snd_printd(int level, const char *format, ...) {}
 	unlikely(__ret_warn_on); \
 })
 
+static inline bool snd_printd_ratelimit(void) { return false; }
+
 #endif /* CONFIG_SND_DEBUG */
 
 #ifdef CONFIG_SND_DEBUG_VERBOSE
-- 
1.7.9.5

