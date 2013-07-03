Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755266Ab3GCCaJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 22:30:09 -0400
Received: from mailxx.hitachi.co.jp ([133.145.228.50]:34169 "EHLO
	mailxx.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753138Ab3GCCaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 22:30:05 -0400
X-Greylist: delayed 978 seconds by postgrey-1.27 at vger.kernel.org; Tue, 02 Jul 2013 22:30:05 EDT
X-AuditID: 85900ec0-d1ac5b900000151e-79-51d388d8b641
X-Mailbox-Line: From nobody Wed Jul  3 10:46:16 2013
From: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Subject: [RFC PATCH 2/5] printk: add message hash values in /dev/kmsg output
To: linux-kernel@vger.kernel.org
Cc: yrl.pp-manager.tt@hitachi.com, akpm@linux-foundation.org,
        gregkh@linuxfoundation.org, kay@vrfy.org, davem@davemloft.net,
        Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kay Sievers <kay@vrfy.org>, "David S. Miller" <davem@davemloft.net>
Date: Wed, 03 Jul 2013 10:46:16 +0900
Message-ID: <20130703014616.18745.95801.stgit@localhost.localdomain>
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

This patch adds the hash value for each printk line when reading
/dev/kmsg as bellow:

	6,154,325061,-,b7db707c@kernel/smp.c:554;Brought up 4 CPUs

Here, the 5th field is the 32-bit hash value followed by
@<filename>:<lineno>.  If this feature is disabled, i.e.
CONFIG_KMSG_HASH=n, or the hash value hasn't be calculated, the 5th
field simply shows '-'.  Hash values don't appear in other than
/dev/kmsg, thus they are not't displayed on the console and won't be
written to /var/log/messages.

A metadata table which includes pointers to the format strings and
location info of printk is placed between __start___kmsg_meta to
__stop___kmsg_meta.  Since the kernel doesn't calculate hash values
dynamically, userland tools need to calculate hash values and place
them into the table before running the kernel.  To save the space,
the pointers to the format strings are replaced with the calculated
hash values.

In the current implementation, KERN_CONT cases are not dealt with
well.  Only a hash value of the first printk in the sequence is
printed.

Signed-off-by: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Kay Sievers <kay@vrfy.org>
Cc: "David S. Miller" <davem@davemloft.net>
---

 drivers/base/core.c               |    3 +-
 include/asm-generic/vmlinux.lds.h |    4 ++
 include/linux/kmsghash.h          |   19 ++++++++++
 include/linux/printk.h            |   29 ++++++++++++++--
 kernel/printk.c                   |   69 ++++++++++++++++++++++++++++---------
 lib/Kconfig.debug                 |   17 +++++++++
 6 files changed, 122 insertions(+), 19 deletions(-)
 create mode 100644 include/linux/kmsghash.h

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 2499cef..558017d 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -1959,7 +1959,8 @@ int dev_vprintk_emit(int level, const struct device *dev,
 
 	hdrlen = create_syslog_header(dev, hdr, sizeof(hdr));
 
-	return vprintk_emit(0, level, hdrlen ? hdr : NULL, hdrlen, fmt, args);
+	return vprintk_emit(0, level, hdrlen ? hdr : NULL, hdrlen,
+			    fmt, args, NULL);
 }
 EXPORT_SYMBOL(dev_vprintk_emit);
 
diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 0380add..3d82844 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -200,6 +200,10 @@
 	VMLINUX_SYMBOL(__start___verbose) = .;                          \
 	*(__verbose)                                                    \
 	VMLINUX_SYMBOL(__stop___verbose) = .;				\
+	. = ALIGN(8);							\
+	VMLINUX_SYMBOL(__start___kmsg_meta) = .;			\
+	*(__kmsg_meta)							\
+	VMLINUX_SYMBOL(__stop___kmsg_meta) = .;				\
 	LIKELY_PROFILE()		       				\
 	BRANCH_PROFILE()						\
 	TRACE_PRINTKS()
diff --git a/include/linux/kmsghash.h b/include/linux/kmsghash.h
new file mode 100644
index 0000000..6cfe373
--- /dev/null
+++ b/include/linux/kmsghash.h
@@ -0,0 +1,19 @@
+#ifndef _LINUX_KMSGHASH_H
+#define _LINUX_KMSGHASH_H
+
+/* kernel message metadata flags */
+#define KMSG_FLAGS_HASH_VALID	(1<<0)
+#define KMSG_FLAGS_DEFAULT	0
+
+struct kmsg_meta {
+	const char *filename;
+	union {
+		/* format is replaced with hash at build time */
+		const char *format;
+		u32 hash;
+	} u;
+	unsigned int lineno:18;
+	unsigned int flags:8;
+} __attribute__((aligned(8)));
+
+#endif
diff --git a/include/linux/printk.h b/include/linux/printk.h
index c7a8c6b..fe6b350 100644
--- a/include/linux/printk.h
+++ b/include/linux/printk.h
@@ -5,6 +5,7 @@
 #include <linux/init.h>
 #include <linux/kern_levels.h>
 #include <linux/linkage.h>
+#include <linux/kmsghash.h>
 
 extern const char linux_banner[];
 extern const char linux_proc_banner[];
@@ -110,7 +111,7 @@ void early_printk(const char *s, ...) { }
 asmlinkage __printf(5, 0)
 int vprintk_emit(int facility, int level,
 		 const char *dict, size_t dictlen,
-		 const char *fmt, va_list args);
+		 const char *fmt, va_list args, struct kmsg_meta *meta);
 
 asmlinkage __printf(1, 0)
 int vprintk(const char *fmt, va_list args);
@@ -123,7 +124,31 @@ asmlinkage int printk_emit(int facility, int level,
 asmlinkage __printf(1, 2) __cold
 int _printk(const char *fmt, ...);
 
-#define printk(fmt, args...) _printk(fmt, ## args)
+__printf(2, 3) __cold
+int __printk(struct kmsg_meta *meta, const char *fmt, ...);
+
+#ifdef CONFIG_KMSG_HASH
+#define DEFINE_KMSG_METADATA(name, fmt)					\
+	static struct kmsg_meta __aligned(8)				\
+	__attribute__((section("__kmsg_meta"))) name = {		\
+		.filename = __FILE__,					\
+		.u.format = __builtin_constant_p(fmt) ? (fmt) : 0,	\
+		.lineno = __LINE__,					\
+		.flags = KMSG_FLAGS_DEFAULT,				\
+	}
+
+#define printk_(fmt, args...)				\
+({							\
+	DEFINE_KMSG_METADATA(_meta, (fmt));		\
+	__printk(&_meta, (fmt), ##args);		\
+})
+
+#define printk(fmt, args...) printk_(fmt, ##args)
+
+#else
+
+#define printk(fmt, args...) __printk(0, fmt, ##args)
+#endif /* CONFIG_KMSG_HASH */
 
 /*
  * Special printk facility for scheduler use only, _DO_NOT_USE_ !
diff --git a/kernel/printk.c b/kernel/printk.c
index 1ec264e..239a159 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -208,6 +208,7 @@ struct log {
 	u8 facility;		/* syslog facility */
 	u8 flags:5;		/* internal record flags */
 	u8 level:3;		/* syslog level */
+	struct kmsg_meta *meta;	/* kmsg metadata */
 };
 
 /*
@@ -306,7 +307,7 @@ static u32 log_next(u32 idx)
 static void log_store(int facility, int level,
 		      enum log_flags flags, u64 ts_nsec,
 		      const char *dict, u16 dict_len,
-		      const char *text, u16 text_len)
+		      const char *text, u16 text_len, struct kmsg_meta *meta)
 {
 	struct log *msg;
 	u32 size, pad_len;
@@ -357,6 +358,7 @@ static void log_store(int facility, int level,
 		msg->ts_nsec = local_clock();
 	memset(log_dict(msg) + dict_len, 0, pad_len);
 	msg->len = sizeof(struct log) + text_len + dict_len + pad_len;
+	msg->meta = meta;
 
 	/* insert message */
 	log_next_idx += msg->len;
@@ -535,9 +537,16 @@ static ssize_t devkmsg_read(struct file *file, char __user *buf,
 		 ((user->prev & LOG_CONT) && !(msg->flags & LOG_PREFIX)))
 		cont = '+';
 
-	len = sprintf(user->buf, "%u,%llu,%llu,%c;",
-		      (msg->facility << 3) | msg->level,
-		      user->seq, ts_usec, cont);
+	if (msg->meta && (msg->meta->flags & KMSG_FLAGS_HASH_VALID))
+		len = sprintf(user->buf, "%u,%llu,%llu,%c,%08x@%s:%d;",
+			      (msg->facility << 3) | msg->level,
+			      user->seq, ts_usec, cont, msg->meta->u.hash,
+			      msg->meta->filename, msg->meta->lineno);
+	else
+		len = sprintf(user->buf, "%u,%llu,%llu,%c,-;",
+			      (msg->facility << 3) | msg->level,
+			      user->seq, ts_usec, cont);
+
 	user->prev = msg->flags;
 
 	/* escape non-printable characters */
@@ -1405,6 +1414,7 @@ static struct cont {
 	u8 facility;			/* log level of first message */
 	enum log_flags flags;		/* prefix, newline flags */
 	bool flushed:1;			/* buffer sealed and committed */
+	struct kmsg_meta *meta;		/* kmsg metadata */
 } cont;
 
 static void cont_flush(enum log_flags flags)
@@ -1421,7 +1431,8 @@ static void cont_flush(enum log_flags flags)
 		 * line. LOG_NOCONS suppresses a duplicated output.
 		 */
 		log_store(cont.facility, cont.level, flags | LOG_NOCONS,
-			  cont.ts_nsec, NULL, 0, cont.buf, cont.len);
+			  cont.ts_nsec, NULL, 0, cont.buf, cont.len,
+			  cont.meta);
 		cont.flags = flags;
 		cont.flushed = true;
 	} else {
@@ -1430,12 +1441,13 @@ static void cont_flush(enum log_flags flags)
 		 * just submit it to the store and free the buffer.
 		 */
 		log_store(cont.facility, cont.level, flags, 0,
-			  NULL, 0, cont.buf, cont.len);
+			  NULL, 0, cont.buf, cont.len, cont.meta);
 		cont.len = 0;
 	}
 }
 
-static bool cont_add(int facility, int level, const char *text, size_t len)
+static bool cont_add(int facility, int level, const char *text, size_t len,
+	struct kmsg_meta *meta)
 {
 	if (cont.len && cont.flushed)
 		return false;
@@ -1454,6 +1466,7 @@ static bool cont_add(int facility, int level, const char *text, size_t len)
 		cont.flags = 0;
 		cont.cons = 0;
 		cont.flushed = false;
+		cont.meta = meta;
 	}
 
 	memcpy(cont.buf + cont.len, text, len);
@@ -1489,13 +1502,15 @@ static size_t cont_print_text(char *text, size_t size)
 			text[textlen++] = '\n';
 		/* got everything, release buffer */
 		cont.len = 0;
+		cont.meta = NULL;
 	}
 	return textlen;
 }
 
 asmlinkage int vprintk_emit(int facility, int level,
 			    const char *dict, size_t dictlen,
-			    const char *fmt, va_list args)
+			    const char *fmt, va_list args,
+			    struct kmsg_meta *meta)
 {
 	static int recursion_bug;
 	static char textbuf[LOG_LINE_MAX];
@@ -1543,7 +1558,7 @@ asmlinkage int vprintk_emit(int facility, int level,
 		printed_len += strlen(recursion_msg);
 		/* emit KERN_CRIT message */
 		log_store(0, 2, LOG_PREFIX|LOG_NEWLINE, 0,
-			  NULL, 0, recursion_msg, printed_len);
+			  NULL, 0, recursion_msg, printed_len, NULL);
 	}
 
 	/*
@@ -1593,9 +1608,9 @@ asmlinkage int vprintk_emit(int facility, int level,
 			cont_flush(LOG_NEWLINE);
 
 		/* buffer line if possible, otherwise store it right away */
-		if (!cont_add(facility, level, text, text_len))
+		if (!cont_add(facility, level, text, text_len, meta))
 			log_store(facility, level, lflags | LOG_CONT, 0,
-				  dict, dictlen, text, text_len);
+				  dict, dictlen, text, text_len, meta);
 	} else {
 		bool stored = false;
 
@@ -1607,13 +1622,14 @@ asmlinkage int vprintk_emit(int facility, int level,
 		 */
 		if (cont.len && cont.owner == current) {
 			if (!(lflags & LOG_PREFIX))
-				stored = cont_add(facility, level, text, text_len);
+				stored = cont_add(facility, level, text,
+						  text_len, meta);
 			cont_flush(LOG_NEWLINE);
 		}
 
 		if (!stored)
 			log_store(facility, level, lflags, 0,
-				  dict, dictlen, text, text_len);
+				  dict, dictlen, text, text_len, meta);
 	}
 	printed_len += text_len;
 
@@ -1638,7 +1654,7 @@ EXPORT_SYMBOL(vprintk_emit);
 
 asmlinkage int vprintk(const char *fmt, va_list args)
 {
-	return vprintk_emit(0, -1, NULL, 0, fmt, args);
+	return vprintk_emit(0, -1, NULL, 0, fmt, args, NULL);
 }
 EXPORT_SYMBOL(vprintk);
 
@@ -1650,7 +1666,7 @@ asmlinkage int printk_emit(int facility, int level,
 	int r;
 
 	va_start(args, fmt);
-	r = vprintk_emit(facility, level, dict, dictlen, fmt, args);
+	r = vprintk_emit(facility, level, dict, dictlen, fmt, args, NULL);
 	va_end(args);
 
 	return r;
@@ -1696,13 +1712,34 @@ asmlinkage int _printk(const char *fmt, ...)
 	}
 #endif
 	va_start(args, fmt);
-	r = vprintk_emit(0, -1, NULL, 0, fmt, args);
+	r = vprintk_emit(0, -1, NULL, 0, fmt, args, NULL);
 	va_end(args);
 
 	return r;
 }
 EXPORT_SYMBOL(_printk);
 
+int __printk(struct kmsg_meta *meta, const char *fmt, ...)
+{
+	va_list args;
+	int r;
+
+#ifdef CONFIG_KGDB_KDB
+	if (unlikely(kdb_trap_printk)) {
+		va_start(args, fmt);
+		r = vkdb_printf(fmt, args);
+		va_end(args);
+		return r;
+	}
+#endif
+	va_start(args, fmt);
+	r = vprintk_emit(0, -1, NULL, 0, fmt, args, meta);
+	va_end(args);
+
+	return r;
+}
+EXPORT_SYMBOL(__printk);
+
 #else /* CONFIG_PRINTK */
 
 #define LOG_LINE_MAX		0
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 566cf2b..9302ece 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -14,6 +14,23 @@ config PRINTK_TIME
 	  The behavior is also controlled by the kernel command line
 	  parameter printk.time=1. See Documentation/kernel-parameters.txt
 
+config KMSG_HASH
+	bool "Show the hash value of each printk message format"
+	depends on PRINTK
+	default n
+	help
+	  If you say y here, the hash value of each printk message
+	  format is displayed when reading /dev/kmsg as bellow:
+
+	    6,154,325061,-,b7db707c@kernel/smp.c:554;Brought up 4 CPUs
+
+	  Here, the 5th field is the 32-bit hash value followed by
+	  @<location>.  If this feature is disabled or the hash value
+	  couldn't be calculated, the 5th field simply shows '-'.
+
+	  Please note that the kernel image size gets larger by
+	  hundres Kbytes when this feature is enabled.
+
 config DEFAULT_MESSAGE_LOGLEVEL
 	int "Default message log level (1-7)"
 	range 1 7


