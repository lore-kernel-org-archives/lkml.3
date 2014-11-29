Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751686AbaK2U6S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2014 15:58:18 -0500
Received: from smtprelay0018.hostedemail.com ([216.40.44.18]:58286 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751623AbaK2U6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2014 15:58:17 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:69:355:379:541:560:800:960:966:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1535:1544:1593:1594:1605:1711:1730:1747:1777:1792:2196:2199:2393:2559:2562:2828:3138:3139:3140:3141:3142:3865:3866:3868:3871:3872:4250:4321:4385:4605:5007:6119:6261:7875:10004:10848:11026:11473:11658:11914:12043:12296:12438:12517:12519:12555:12679:13095:13161:13229:14096:14097:14394:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: geese08_6520fdc480b46
X-Filterd-Recvd-Size: 5074
Message-ID: <1417294692.818.3.camel@perches.com>
Subject: [PATCH] sound: use enum names instead of magic numbers
From: Joe Perches <joe@perches.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Date: Sat, 29 Nov 2014 12:58:12 -0800
In-Reply-To: <s5h7fydbv6w.wl-tiwai@suse.de>
References: <1417201196-12392-1-git-send-email-KyleChamberlin@project20million.org>
	 <s5h7fydbv6w.wl-tiwai@suse.de>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's an enum defined for these magic numbers,
might as well use it.

Miscellanea:
o Use ##__VA_ARGS__

Signed-off-by: Joe Perches <joe@perches.com>
---
 include/sound/core.h | 28 +++++++++++++++-------------
 sound/core/misc.c    |  6 +++---
 2 files changed, 18 insertions(+), 16 deletions(-)

diff --git a/include/sound/core.h b/include/sound/core.h
index 1df3f2f..40418e7 100644
--- a/include/sound/core.h
+++ b/include/sound/core.h
@@ -325,7 +325,7 @@ void release_and_free_resource(struct resource *res);
 /* --- */
 
 /* sound printk debug levels */
-enum {
+enum snd_level {
 	SND_PR_ALWAYS,
 	SND_PR_DEBUG,
 	SND_PR_VERBOSE,
@@ -333,11 +333,11 @@ enum {
 
 #if defined(CONFIG_SND_DEBUG) || defined(CONFIG_SND_VERBOSE_PRINTK)
 __printf(4, 5)
-void __snd_printk(unsigned int level, const char *file, int line,
+void __snd_printk(enum snd_level snd_level, const char *file, int line,
 		  const char *format, ...);
 #else
-#define __snd_printk(level, file, line, format, args...) \
-	printk(format, ##args)
+#define __snd_printk(snd_level, file, line, format, ...) \
+	printk(format, ##__VA_ARGS__)
 #endif
 
 /**
@@ -347,8 +347,8 @@ void __snd_printk(unsigned int level, const char *file, int line,
  * Works like printk() but prints the file and the line of the caller
  * when configured with CONFIG_SND_VERBOSE_PRINTK.
  */
-#define snd_printk(fmt, args...) \
-	__snd_printk(0, __FILE__, __LINE__, fmt, ##args)
+#define snd_printk(fmt, ...) \
+	__snd_printk(SND_PR_ALWAYS, __FILE__, __LINE__, fmt, ##__VA_ARGS__)
 
 #ifdef CONFIG_SND_DEBUG
 /**
@@ -358,10 +358,10 @@ void __snd_printk(unsigned int level, const char *file, int line,
  * Works like snd_printk() for debugging purposes.
  * Ignored when CONFIG_SND_DEBUG is not set.
  */
-#define snd_printd(fmt, args...) \
-	__snd_printk(1, __FILE__, __LINE__, fmt, ##args)
-#define _snd_printd(level, fmt, args...) \
-	__snd_printk(level, __FILE__, __LINE__, fmt, ##args)
+#define snd_printd(fmt, ...) \
+	__snd_printk(SND_PR_DEBUG, __FILE__, __LINE__, fmt, ##__VA_ARGS__)
+#define _snd_printd(level, fmt, ...) \
+	__snd_printk(level, __FILE__, __LINE__, fmt, ##__VA_ARGS__)
 
 /**
  * snd_BUG - give a BUG warning message and stack trace
@@ -390,7 +390,8 @@ void __snd_printk(unsigned int level, const char *file, int line,
 __printf(1, 2)
 static inline void snd_printd(const char *format, ...) {}
 __printf(2, 3)
-static inline void _snd_printd(int level, const char *format, ...) {}
+static inline void _snd_printd(enum snd_level snd_level,
+			       const char *format, ...) {}
 
 #define snd_BUG()			do { } while (0)
 
@@ -411,8 +412,9 @@ static inline bool snd_printd_ratelimit(void) { return false; }
  * Works like snd_printk() for debugging purposes.
  * Ignored when CONFIG_SND_DEBUG_VERBOSE is not set.
  */
-#define snd_printdd(format, args...) \
-	__snd_printk(2, __FILE__, __LINE__, format, ##args)
+#define snd_printdd(format, ...)				\
+	__snd_printk(SND_PR_VERBOSE, __FILE__, __LINE__,	\
+		     format, ##__VA_ARGS__)
 #else
 __printf(1, 2)
 static inline void snd_printdd(const char *format, ...) {}
diff --git a/sound/core/misc.c b/sound/core/misc.c
index f2e8226..03b3f56 100644
--- a/sound/core/misc.c
+++ b/sound/core/misc.c
@@ -63,7 +63,7 @@ static const char *sanity_file_name(const char *path)
 #endif
 
 #if defined(CONFIG_SND_DEBUG) || defined(CONFIG_SND_VERBOSE_PRINTK)
-void __snd_printk(unsigned int level, const char *path, int line,
+void __snd_printk(enum snd_level snd_level, const char *path, int line,
 		  const char *format, ...)
 {
 	va_list args;
@@ -74,7 +74,7 @@ void __snd_printk(unsigned int level, const char *path, int line,
 #endif
 
 #ifdef CONFIG_SND_DEBUG
-	if (debug < level)
+	if (debug < snd_level)
 		return;
 #endif
 
@@ -88,7 +88,7 @@ void __snd_printk(unsigned int level, const char *path, int line,
 		const char *end_of_header = printk_skip_level(format);
 		memcpy(verbose_fmt, format, end_of_header - format);
 		vaf.fmt = end_of_header;
-	} else if (level)
+	} else if (snd_level)
 		memcpy(verbose_fmt, KERN_DEBUG, sizeof(KERN_DEBUG) - 1);
 	printk(verbose_fmt, sanity_file_name(path), line, &vaf);
 


