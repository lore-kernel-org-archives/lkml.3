Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752349AbaJLFJF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 01:09:05 -0400
Received: from smtprelay0249.hostedemail.com ([216.40.44.249]:55393 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750826AbaJLFJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 01:09:00 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3353:3865:3866:3868:4250:4321:4605:5007:6119:7652:7903:8603:10004:10400:10450:10455:10848:11026:11473:11658:11914:12043:12296:12438:12517:12519:12555:12683:13161:13229:14394:19904:19999:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: rest63_4e581ceb5651b
X-Filterd-Recvd-Size: 3486
Message-ID: <1413090537.22149.16.camel@joe-AO725>
Subject: [PATCH] drm: drm_err: Remove unnecessary __func__ argument
From: Joe Perches <joe@perches.com>
To: Daniel Vetter <daniel@ffwll.ch>
Cc: Jani Nikula <jani.nikula@linux.intel.com>, David Airlie <airlied@linux.ie>,
        LKML <linux-kernel@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>
Date: Sat, 11 Oct 2014 22:08:57 -0700
In-Reply-To: <20140923135256.GG15734@phenom.ffwll.local>
References: <1411403411.2952.36.camel@joe-AO725> <87lhpa5w5f.fsf@intel.com>
	 <20140923135256.GG15734@phenom.ffwll.local>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removing the unnecessary drm_err __func__ argument by using
the equivalent %pf and __builtin_return_address(0) makes the
code smaller for every use of the DRM_ERROR macro.

For instance: (allmodconfig)

$ size drivers/gpu/drm/i915/i915.o*
   text	   data	    bss	    dec	    hex	filename
 922447	 193257	 296736	1412440	 158d58	drivers/gpu/drm/i915/i915.o.new
 928111	 193257	 296736	1418104	 15a378	drivers/gpu/drm/i915/i915.o.old

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/gpu/drm/drm_drv.c | 5 +++--
 include/drm/drmP.h        | 8 ++++----
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/drm_drv.c b/drivers/gpu/drm/drm_drv.c
index 9f0e1b9..e9263d9 100644
--- a/drivers/gpu/drm/drm_drv.c
+++ b/drivers/gpu/drm/drm_drv.c
@@ -68,7 +68,7 @@ static struct idr drm_minors_idr;
 struct class *drm_class;
 static struct dentry *drm_debugfs_root;
 
-void drm_err(const char *func, const char *format, ...)
+void drm_err(const char *format, ...)
 {
 	struct va_format vaf;
 	va_list args;
@@ -78,7 +78,8 @@ void drm_err(const char *func, const char *format, ...)
 	vaf.fmt = format;
 	vaf.va = &args;
 
-	printk(KERN_ERR "[" DRM_NAME ":%s] *ERROR* %pV", func, &vaf);
+	printk(KERN_ERR "[" DRM_NAME ":%pf] *ERROR* %pV",
+	       __builtin_return_address(0), &vaf);
 
 	va_end(args);
 }
diff --git a/include/drm/drmP.h b/include/drm/drmP.h
index ca374ac..5e9ff52 100644
--- a/include/drm/drmP.h
+++ b/include/drm/drmP.h
@@ -125,8 +125,8 @@ struct reservation_object;
 extern __printf(2, 3)
 void drm_ut_debug_printk(const char *function_name,
 			 const char *format, ...);
-extern __printf(2, 3)
-void drm_err(const char *func, const char *format, ...);
+extern __printf(1, 2)
+void drm_err(const char *format, ...);
 
 /***********************************************************************/
 /** \name DRM template customization defaults */
@@ -168,7 +168,7 @@ void drm_err(const char *func, const char *format, ...);
  * \param arg arguments
  */
 #define DRM_ERROR(fmt, ...)				\
-	drm_err(__func__, fmt, ##__VA_ARGS__)
+	drm_err(fmt, ##__VA_ARGS__)
 
 /**
  * Rate limited error output.  Like DRM_ERROR() but won't flood the log.
@@ -183,7 +183,7 @@ void drm_err(const char *func, const char *format, ...);
 				      DEFAULT_RATELIMIT_BURST);		\
 									\
 	if (__ratelimit(&_rs))						\
-		drm_err(__func__, fmt, ##__VA_ARGS__);			\
+		drm_err(fmt, ##__VA_ARGS__);				\
 })
 
 #define DRM_INFO(fmt, ...)				\


