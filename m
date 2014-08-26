Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757959AbaHZNy1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 09:54:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29896 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754634AbaHZNyZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 09:54:25 -0400
Date: Tue, 26 Aug 2014 09:54:17 -0400
From: Don Zickus <dzickus@redhat.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ulrich Obergfell <uobergfe@redhat.com>,
        Andrew Jones <drjones@redhat.com>
Subject: Re: linux-next: build failure after merge of the akpm tree
Message-ID: <20140826135417.GK49576@redhat.com>
References: <20140826171818.719c4e6a@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140826171818.719c4e6a@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 26, 2014 at 05:18:18PM +1000, Stephen Rothwell wrote:
> Hi Andrew,
> 
> After merging the akpm tree, today's linux-next build (sparc64
> defconfig) failed like this:
> 
> kernel/built-in.o: In function `proc_dowatchdog':
> (.text+0x6a620): undefined reference to `watchdog_hardlockup_detector_is_enabled'
> kernel/built-in.o: In function `proc_dowatchdog':
> (.text+0x6a6a8): undefined reference to `watchdog_enable_hardlockup_detector'
> kernel/built-in.o: In function `proc_dowatchdog':
> (.text+0x6a79c): undefined reference to `watchdog_enable_hardlockup_detector'
> 
> Caused by commit 72355eed4bd7 ("kernel/watchdog.c: control hard lockup
> detection default").  This build has CONFIG_HAVE_NMI_WATCHDOG=y,
> CONFIG_HARDLOCKUP_DETECTOR not set.

:-(  I was trying to figure out why touch_nmi_watchdog doesn't break the
same way until I noticed sparc has its own personal implementation of this
function (instead of using kernel/watchdog.c's version).

We are going to have to split the include/linux/nmi.h changes out into its
own #ifdef area.  I am not sure my brain is quite ready to untangle the
sparc implementation of the watchdog stuff and try to make it use the
generic one yet.

This patch I believe fixes the compile problem for now.

Not sure the proper way to post this or who to send this too.

------8<------
From: Don Zickus <dzickus@redhat.com>
Date: Tue, 26 Aug 2014 09:50:21 -0400
Subject: [PATCH] watchdog, nmi: Fix compile issues on sparc

Sparc doesn't use HARDLOCKUP_DETECTOR the same way x86 does.  As a result break
out the new functions

watchdog_hardlockup_detector_is_enabled
watchdog_enable_hardlockup_detector

into their own #if defined area.  This resolves the compile issue where
CONFIG_NMI_WATCHDOG=y and CONFIG_HARDLOCKUP_DETECTOR is not set on sparc.

Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 include/linux/nmi.h |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/include/linux/nmi.h b/include/linux/nmi.h
index 72aacf4..f82a5bf 100644
--- a/include/linux/nmi.h
+++ b/include/linux/nmi.h
@@ -17,14 +17,18 @@
 #if defined(CONFIG_HAVE_NMI_WATCHDOG) || defined(CONFIG_HARDLOCKUP_DETECTOR)
 #include <asm/nmi.h>
 extern void touch_nmi_watchdog(void);
-extern void watchdog_enable_hardlockup_detector(bool val);
-extern bool watchdog_hardlockup_detector_is_enabled(void);
 #else
 static inline void touch_nmi_watchdog(void)
 {
 	touch_softlockup_watchdog();
 }
-static inline void watchdog_enable_hardlockup_detector(bool)
+#endif
+
+#if defined(CONFIG_HARDLOCKUP_DETECTOR)
+extern void watchdog_enable_hardlockup_detector(bool val);
+extern bool watchdog_hardlockup_detector_is_enabled(void);
+#else
+static inline void watchdog_enable_hardlockup_detector(bool val)
 {
 }
 static inline bool watchdog_hardlockup_detector_is_enabled(void)
-- 
1.7.1

