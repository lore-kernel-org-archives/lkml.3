Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751897AbaKDIDv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 03:03:51 -0500
Received: from smtprelay0193.hostedemail.com ([216.40.44.193]:56226 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750819AbaKDIDt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 03:03:49 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:69:355:379:541:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1373:1437:1515:1516:1518:1535:1544:1593:1594:1605:1711:1730:1747:1777:1792:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3865:3870:4250:4321:4605:5007:6119:6261:7903:8603:10004:10848:11026:11473:11658:11914:12043:12291:12296:12438:12517:12519:12555:12683:13548:14394:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: bone33_2128f5ca85f57
X-Filterd-Recvd-Size: 5177
Message-ID: <1415088226.24560.1.camel@perches.com>
Subject: [PATCH] drm: Reduce code size of drm_err and DRM_DEBUG[_<FOO>] uses
From: Joe Perches <joe@perches.com>
To: David Airlie <airlied@linux.ie>
Cc: dri-devel <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Tue, 04 Nov 2014 00:03:46 -0800
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using %pf, __builtin_return_address(0) instead ofy 
"%s", __func__ reduces code size by eliminating
a function argument.

(allyesconfig)
$ size drivers/gpu/drm/built-in.o*
   text	   data	    bss	    dec	    hex	filename
4656061	1321947	1669536	7647544	 74b138	drivers/gpu/drm/built-in.o.new
4737680	1321947	1669472	7729099	 75efcb	drivers/gpu/drm/built-in.o.old

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/gpu/drm/drm_drv.c | 10 ++++++----
 include/drm/drmP.h        | 45 ++++++++++++++++++++++-----------------------
 2 files changed, 28 insertions(+), 27 deletions(-)

diff --git a/drivers/gpu/drm/drm_drv.c b/drivers/gpu/drm/drm_drv.c
index bc3da32..22f76a2 100644
--- a/drivers/gpu/drm/drm_drv.c
+++ b/drivers/gpu/drm/drm_drv.c
@@ -56,7 +56,7 @@ static struct idr drm_minors_idr;
 struct class *drm_class;
 static struct dentry *drm_debugfs_root;
 
-void drm_err(const char *func, const char *format, ...)
+void drm_err(const char *format, ...)
 {
 	struct va_format vaf;
 	va_list args;
@@ -66,13 +66,14 @@ void drm_err(const char *func, const char *format, ...)
 	vaf.fmt = format;
 	vaf.va = &args;
 
-	printk(KERN_ERR "[" DRM_NAME ":%s] *ERROR* %pV", func, &vaf);
+	printk(KERN_ERR "[" DRM_NAME ":%pf] *ERROR* %pV",
+	       __builtin_return_address(0), &vaf);
 
 	va_end(args);
 }
 EXPORT_SYMBOL(drm_err);
 
-void drm_ut_debug_printk(const char *function_name, const char *format, ...)
+void drm_ut_debug_printk(const char *format, ...)
 {
 	struct va_format vaf;
 	va_list args;
@@ -81,7 +82,8 @@ void drm_ut_debug_printk(const char *function_name, const char *format, ...)
 	vaf.fmt = format;
 	vaf.va = &args;
 
-	printk(KERN_DEBUG "[" DRM_NAME ":%s] %pV", function_name, &vaf);
+	printk(KERN_DEBUG "[" DRM_NAME ":%pf] %pV",
+	       __builtin_return_address(0), &vaf);
 
 	va_end(args);
 }
diff --git a/include/drm/drmP.h b/include/drm/drmP.h
index 53ed876..02aaa1a 100644
--- a/include/drm/drmP.h
+++ b/include/drm/drmP.h
@@ -122,11 +122,10 @@ struct dma_buf_attachment;
 #define DRM_UT_KMS		0x04
 #define DRM_UT_PRIME		0x08
 
-extern __printf(2, 3)
-void drm_ut_debug_printk(const char *function_name,
-			 const char *format, ...);
-extern __printf(2, 3)
-void drm_err(const char *func, const char *format, ...);
+__printf(1, 2)
+void drm_ut_debug_printk(const char *format, ...);
+__printf(1, 2)
+void drm_err(const char *format, ...);
 
 /***********************************************************************/
 /** \name DRM template customization defaults */
@@ -155,7 +154,7 @@ void drm_err(const char *func, const char *format, ...);
  * \param arg arguments
  */
 #define DRM_ERROR(fmt, ...)				\
-	drm_err(__func__, fmt, ##__VA_ARGS__)
+	drm_err(fmt, ##__VA_ARGS__)
 
 /**
  * Rate limited error output.  Like DRM_ERROR() but won't flood the log.
@@ -170,7 +169,7 @@ void drm_err(const char *func, const char *format, ...);
 				      DEFAULT_RATELIMIT_BURST);		\
 									\
 	if (__ratelimit(&_rs))						\
-		drm_err(__func__, fmt, ##__VA_ARGS__);			\
+		drm_err(fmt, ##__VA_ARGS__);			\
 })
 
 #define DRM_INFO(fmt, ...)				\
@@ -186,26 +185,26 @@ void drm_err(const char *func, const char *format, ...);
  * \param arg arguments
  */
 #define DRM_DEBUG(fmt, args...)						\
-	do {								\
-		if (unlikely(drm_debug & DRM_UT_CORE))			\
-			drm_ut_debug_printk(__func__, fmt, ##args);	\
-	} while (0)
+do {									\
+	if (unlikely(drm_debug & DRM_UT_CORE))				\
+		drm_ut_debug_printk(fmt, ##args);			\
+} while (0)
 
 #define DRM_DEBUG_DRIVER(fmt, args...)					\
-	do {								\
-		if (unlikely(drm_debug & DRM_UT_DRIVER))		\
-			drm_ut_debug_printk(__func__, fmt, ##args);	\
-	} while (0)
+do {									\
+	if (unlikely(drm_debug & DRM_UT_DRIVER))			\
+		drm_ut_debug_printk(fmt, ##args);			\
+} while (0)
 #define DRM_DEBUG_KMS(fmt, args...)					\
-	do {								\
-		if (unlikely(drm_debug & DRM_UT_KMS))			\
-			drm_ut_debug_printk(__func__, fmt, ##args);	\
-	} while (0)
+do {									\
+	if (unlikely(drm_debug & DRM_UT_KMS))				\
+		drm_ut_debug_printk(fmt, ##args);			\
+} while (0)
 #define DRM_DEBUG_PRIME(fmt, args...)					\
-	do {								\
-		if (unlikely(drm_debug & DRM_UT_PRIME))			\
-			drm_ut_debug_printk(__func__, fmt, ##args);	\
-	} while (0)
+do {									\
+	if (unlikely(drm_debug & DRM_UT_PRIME))				\
+		drm_ut_debug_printk(fmt, ##args);			\
+} while (0)
 
 /*@}*/
 


