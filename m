Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755338Ab3GCCaM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 22:30:12 -0400
Received: from fallback.hitachi.co.jp ([133.145.228.50]:34172 "EHLO
	mailxx.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754343Ab3GCCaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 22:30:06 -0400
X-AuditID: 85900ec0-d42c9b900000151e-7c-51d388d9309d
X-Mailbox-Line: From nobody Wed Jul  3 10:46:16 2013
From: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Subject: [RFC PATCH 5/5] printk: Add msghash support for dev_printk
To: linux-kernel@vger.kernel.org
Cc: yrl.pp-manager.tt@hitachi.com, akpm@linux-foundation.org,
        gregkh@linuxfoundation.org, kay@vrfy.org, davem@davemloft.net,
        Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kay Sievers <kay@vrfy.org>, "David S. Miller" <davem@davemloft.net>
Date: Wed, 03 Jul 2013 10:46:16 +0900
Message-ID: <20130703014616.18745.22959.stgit@localhost.localdomain>
In-Reply-To: <20130703014616.18745.34699.stgit@localhost.localdomain>
References: <20130703014616.18745.34699.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add msghash support for dev_printk and its variants (dev_xxx).
Without this patch, no kmsg_meta data are passed to vprintk_emit,
and this means no hash value is output.

To pass the metadata, this patch changes dev_printk and its
variants to macros which construct the metadata in the similar way
of printk.  No API of those functions are changed.

Signed-off-by: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Kay Sievers <kay@vrfy.org>
Cc: "David S. Miller" <davem@davemloft.net>
---

 drivers/base/core.c         |   56 +++++++++------------------------
 drivers/usb/storage/debug.c |    2 +
 include/linux/device.h      |   73 +++++++++++++++++++++++++------------------
 lib/dynamic_debug.c         |    4 +-
 net/core/dev.c              |    2 +
 5 files changed, 62 insertions(+), 75 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 558017d..4b12e8a1 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -1951,8 +1951,8 @@ create_syslog_header(const struct device *dev, char *hdr, size_t hdrlen)
 }
 EXPORT_SYMBOL(create_syslog_header);
 
-int dev_vprintk_emit(int level, const struct device *dev,
-		     const char *fmt, va_list args)
+int dev_vprintk_emit(struct kmsg_meta *meta, int level,
+		     const struct device *dev, const char *fmt, va_list args)
 {
 	char hdr[128];
 	size_t hdrlen;
@@ -1960,18 +1960,19 @@ int dev_vprintk_emit(int level, const struct device *dev,
 	hdrlen = create_syslog_header(dev, hdr, sizeof(hdr));
 
 	return vprintk_emit(0, level, hdrlen ? hdr : NULL, hdrlen,
-			    fmt, args, NULL);
+			    fmt, args, meta);
 }
 EXPORT_SYMBOL(dev_vprintk_emit);
 
-int dev_printk_emit(int level, const struct device *dev, const char *fmt, ...)
+int dev_printk_emit(struct kmsg_meta *meta, int level,
+		    const struct device *dev, const char *fmt, ...)
 {
 	va_list args;
 	int r;
 
 	va_start(args, fmt);
 
-	r = dev_vprintk_emit(level, dev, fmt, args);
+	r = dev_vprintk_emit(meta, level, dev, fmt, args);
 
 	va_end(args);
 
@@ -1979,19 +1980,20 @@ int dev_printk_emit(int level, const struct device *dev, const char *fmt, ...)
 }
 EXPORT_SYMBOL(dev_printk_emit);
 
-static int __dev_printk(const char *level, const struct device *dev,
-			struct va_format *vaf)
+static int __dev_printk(struct kmsg_meta *meta, const char *level,
+			const struct device *dev, struct va_format *vaf)
 {
 	if (!dev)
-		return printk("%s(NULL device *): %pV", level, vaf);
+		return __printk(meta, "%s(NULL device *): %pV", level, vaf);
 
-	return dev_printk_emit(level[1] - '0', dev,
+	return dev_printk_emit(meta, level[1] - '0', dev,
 			       "%s %s: %pV",
 			       dev_driver_string(dev), dev_name(dev), vaf);
 }
 
-int dev_printk(const char *level, const struct device *dev,
-	       const char *fmt, ...)
+__printf(4, 5)
+int _dev_printk(struct kmsg_meta *meta, const char *level,
+		const struct device *dev, const char *fmt, ...)
 {
 	struct va_format vaf;
 	va_list args;
@@ -2002,40 +2004,12 @@ int dev_printk(const char *level, const struct device *dev,
 	vaf.fmt = fmt;
 	vaf.va = &args;
 
-	r = __dev_printk(level, dev, &vaf);
+	r = __dev_printk(meta, level, dev, &vaf);
 
 	va_end(args);
 
 	return r;
 }
-EXPORT_SYMBOL(dev_printk);
-
-#define define_dev_printk_level(func, kern_level)		\
-int func(const struct device *dev, const char *fmt, ...)	\
-{								\
-	struct va_format vaf;					\
-	va_list args;						\
-	int r;							\
-								\
-	va_start(args, fmt);					\
-								\
-	vaf.fmt = fmt;						\
-	vaf.va = &args;						\
-								\
-	r = __dev_printk(kern_level, dev, &vaf);		\
-								\
-	va_end(args);						\
-								\
-	return r;						\
-}								\
-EXPORT_SYMBOL(func);
-
-define_dev_printk_level(dev_emerg, KERN_EMERG);
-define_dev_printk_level(dev_alert, KERN_ALERT);
-define_dev_printk_level(dev_crit, KERN_CRIT);
-define_dev_printk_level(dev_err, KERN_ERR);
-define_dev_printk_level(dev_warn, KERN_WARNING);
-define_dev_printk_level(dev_notice, KERN_NOTICE);
-define_dev_printk_level(_dev_info, KERN_INFO);
+EXPORT_SYMBOL(_dev_printk);
 
 #endif
diff --git a/drivers/usb/storage/debug.c b/drivers/usb/storage/debug.c
index e08f647..22e1115 100644
--- a/drivers/usb/storage/debug.c
+++ b/drivers/usb/storage/debug.c
@@ -186,7 +186,7 @@ int usb_stor_dbg(const struct us_data *us, const char *fmt, ...)
 
 	va_start(args, fmt);
 
-	r = dev_vprintk_emit(7, &us->pusb_dev->dev, fmt, args);
+	r = dev_vprintk_emit(NULL, 7, &us->pusb_dev->dev, fmt, args);
 
 	va_end(args);
 
diff --git a/include/linux/device.h b/include/linux/device.h
index c0a1261..89bcce8 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -938,42 +938,55 @@ extern const char *dev_driver_string(const struct device *dev);
 
 #ifdef CONFIG_PRINTK
 
-extern __printf(3, 0)
-int dev_vprintk_emit(int level, const struct device *dev,
-		     const char *fmt, va_list args);
-extern __printf(3, 4)
-int dev_printk_emit(int level, const struct device *dev, const char *fmt, ...);
-
-extern __printf(3, 4)
-int dev_printk(const char *level, const struct device *dev,
-	       const char *fmt, ...);
-extern __printf(2, 3)
-int dev_emerg(const struct device *dev, const char *fmt, ...);
-extern __printf(2, 3)
-int dev_alert(const struct device *dev, const char *fmt, ...);
-extern __printf(2, 3)
-int dev_crit(const struct device *dev, const char *fmt, ...);
-extern __printf(2, 3)
-int dev_err(const struct device *dev, const char *fmt, ...);
-extern __printf(2, 3)
-int dev_warn(const struct device *dev, const char *fmt, ...);
-extern __printf(2, 3)
-int dev_notice(const struct device *dev, const char *fmt, ...);
-extern __printf(2, 3)
-int _dev_info(const struct device *dev, const char *fmt, ...);
+extern __printf(4, 0)
+int dev_vprintk_emit(struct kmsg_meta *meta, int level,
+		     const struct device *dev, const char *fmt, va_list args);
+extern __printf(4, 5)
+int dev_printk_emit(struct kmsg_meta *meta, int level,
+		    const struct device *dev, const char *fmt, ...);
+
+extern __printf(4, 5)
+int _dev_printk(struct kmsg_meta *_meta, const char *level,
+		const struct device *dev, const char *fmt, ...);
+
+#ifdef CONFIG_KMSG_HASH
+#define dev_printk(level, dev, fmt, args...)			\
+({								\
+	DEFINE_KMSG_METADATA(_meta, (fmt));			\
+	_dev_printk(&_meta, (level), (dev), (fmt), ##args);	\
+})
+#else
+#define dev_printk(level, dev, fmt, args...) \
+	_dev_printk(NULL, (level), (dev), (fmt), ##args)
+#endif
 
+#define dev_emerg(dev, fmt, args...) \
+	dev_printk(KERN_EMERG, (dev), (fmt), ##args)
+#define dev_alert(dev, fmt, args...) \
+	dev_printk(KERN_ALERT, (dev), (fmt), ##args)
+#define dev_crit(dev, fmt, args...) \
+	dev_printk(KERN_CRIT, (dev), (fmt), ##args)
+#define dev_err(dev, fmt, args...) \
+	dev_printk(KERN_ERR, (dev), (fmt), ##args)
+#define dev_warn(dev, fmt, args...) \
+	dev_printk(KERN_WARNING, (dev), (fmt), ##args)
+#define dev_notice(dev, fmt, args...) \
+	dev_printk(KERN_NOTICE, (dev), (fmt), ##args)
+#define _dev_info(dev, fmt, args...) \
+	dev_printk(KERN_INFO, (dev), (fmt), ##args)
 #else
 
-static inline __printf(3, 0)
-int dev_vprintk_emit(int level, const struct device *dev,
-		     const char *fmt, va_list args)
+static inline __printf(4, 0)
+int dev_vprintk_emit(struct kmsg_meta *meta, int level,
+		     const struct device *dev, const char *fmt, va_list args)
 { return 0; }
-static inline __printf(3, 4)
-int dev_printk_emit(int level, const struct device *dev, const char *fmt, ...)
+static inline __printf(4, 5)
+int dev_printk_emit(struct kmsg_meta *meta, int level,
+		    const struct device *dev, const char *fmt, ...)
 { return 0; }
 
-static inline int __dev_printk(const char *level, const struct device *dev,
-			       struct va_format *vaf)
+static inline int __dev_printk(struct kmsg_meta *meta, const char *level,
+			       const struct device *dev, struct va_format *vaf)
 { return 0; }
 static inline __printf(3, 4)
 int dev_printk(const char *level, const struct device *dev,
diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index 99fec3a..46283dd 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -578,7 +578,7 @@ int __dynamic_dev_dbg(struct _ddebug *descriptor,
 	} else {
 		char buf[PREFIX_SIZE];
 
-		res = dev_printk_emit(7, dev, "%s%s %s: %pV",
+		res = dev_printk_emit(NULL, 7, dev, "%s%s %s: %pV",
 				      dynamic_emit_prefix(descriptor, buf),
 				      dev_driver_string(dev), dev_name(dev),
 				      &vaf);
@@ -610,7 +610,7 @@ int __dynamic_netdev_dbg(struct _ddebug *descriptor,
 	if (dev && dev->dev.parent) {
 		char buf[PREFIX_SIZE];
 
-		res = dev_printk_emit(7, dev->dev.parent,
+		res = dev_printk_emit(NULL, 7, dev->dev.parent,
 				      "%s%s %s %s: %pV",
 				      dynamic_emit_prefix(descriptor, buf),
 				      dev_driver_string(dev->dev.parent),
diff --git a/net/core/dev.c b/net/core/dev.c
index faebb39..2a16898 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -6111,7 +6111,7 @@ static int __netdev_printk(const char *level, const struct net_device *dev,
 	int r;
 
 	if (dev && dev->dev.parent) {
-		r = dev_printk_emit(level[1] - '0',
+		r = dev_printk_emit(NULL, level[1] - '0',
 				    dev->dev.parent,
 				    "%s %s %s: %pV",
 				    dev_driver_string(dev->dev.parent),


