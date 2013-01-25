Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756015Ab3AYKDV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 05:03:21 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:48152 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754947Ab3AYKDS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 05:03:18 -0500
Message-ID: <1359108196.2686.6.camel@joe-AO722>
Subject: Re: [PATCH next-20130124] Sound: pci: Fix unused variable warning
 in patch_sigmatel.c
From: Joe Perches <joe@perches.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Stratos Karafotis <stratosk@semaphore.gr>,
        Jaroslav Kysela <perex@perex.cz>,
        David Henningsson <david.henningsson@canonical.com>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org
Date: Fri, 25 Jan 2013 02:03:16 -0800
In-Reply-To: <s5hehh9d3x7.wl%tiwai@suse.de>
References: <5101B7CE.4070102@semaphore.gr> <s5hehh9d3x7.wl%tiwai@suse.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-01-25 at 10:09 +0100, Takashi Iwai wrote:
> At Fri, 25 Jan 2013 00:38:06 +0200,
> Stratos Karafotis wrote:
> > Fix the following build warnings
> > sound/pci/hda/patch_sigmatel.c: In function ‘stac92hd71bxx_fixup_hp’:
> > sound/pci/hda/patch_sigmatel.c:2434:24: warning: unused variable ‘spec’ [-Wunused-variable]
[]
> I'm going to fix the definition of snd_printd() itself for fixing this
> kind of warnings.  We can use inline functions instead of empty macros
> to achieve the same but without triggering compiler warnings.

It's probably better to use a macro like:

do {						\
	if (0)					\
		printk(fmt, ##__VA_ARGS__);	\
} while (0)

to allow the compiler to avoid any argument evaluation
while still doing fmt/arg matching.

Something like:

 include/sound/core.h | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/include/sound/core.h b/include/sound/core.h
index 93896ad..ce5d224 100644
--- a/include/sound/core.h
+++ b/include/sound/core.h
@@ -394,8 +394,17 @@ void __snd_printk(unsigned int level, const char *file, int line,
 
 #else /* !CONFIG_SND_DEBUG */
 
-#define snd_printd(fmt, args...)	do { } while (0)
-#define _snd_printd(level, fmt, args...) do { } while (0)
+#define snd_printd(fmt, ...)						\
+do {									\
+	if (0)								\
+		__snd_printk(1, __FILE__, __LINE__, fmt, ##__VA_ARGS__); \
+} while (0)
+#define _snd_printd(level, fmt, ...)					\
+do {									\
+	if (0)								\
+		__snd_printk(level, __FILE__, __LINE__, fmt, ##__VA_ARGS__); \
+} while (0)
+
 #define snd_BUG()			do { } while (0)
 static inline int __snd_bug_on(int cond)
 {


