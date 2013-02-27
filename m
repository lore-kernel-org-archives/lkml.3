Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754675Ab3B0GJS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 01:09:18 -0500
Received: from mail-pb0-f48.google.com ([209.85.160.48]:55634 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753802Ab3B0GIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 01:08:07 -0500
From: John Stultz <john.stultz@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Nick Kralevich <nnk@google.com>,
        Android Kernel Team <kernel-team@android.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 4/5] staging: android: logger: Allow a UID to read it's own log entries
Date: Tue, 26 Feb 2013 22:07:37 -0800
Message-Id: <1361945258-24420-5-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1361945258-24420-1-git-send-email-john.stultz@linaro.org>
References: <1361945258-24420-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nick Kralevich <nnk@google.com>

Modify the kernel logger to record the UID associated with
the log entries. Always allow the same UID which generated a
log message to read the log message.

Allow anyone in the logs group, or anyone with CAP_SYSLOG, to
read all log entries.

In addition, allow the client to upgrade log formats, so they
can get additional information from the kernel.

Cc: Android Kernel Team <kernel-team@android.com>
Cc: Nick Kralevich <nnk@google.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Nick Kralevich <nnk@google.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/logger.c |  191 +++++++++++++++++++++++++++++++++-----
 drivers/staging/android/logger.h |   40 +++++++-
 2 files changed, 202 insertions(+), 29 deletions(-)

diff --git a/drivers/staging/android/logger.c b/drivers/staging/android/logger.c
index dbc63cb..cfa6061 100644
--- a/drivers/staging/android/logger.c
+++ b/drivers/staging/android/logger.c
@@ -68,6 +68,8 @@ static LIST_HEAD(log_list);
  * @log:	The associated log
  * @list:	The associated entry in @logger_log's list
  * @r_off:	The current read head offset.
+ * @r_all:	Reader can read all entries
+ * @r_ver:	Reader ABI version
  *
  * This object lives from open to release, so we don't need additional
  * reference counting. The structure is protected by log->mutex.
@@ -76,6 +78,8 @@ struct logger_reader {
 	struct logger_log	*log;
 	struct list_head	list;
 	size_t			r_off;
+	bool			r_all;
+	int			r_ver;
 };
 
 /* logger_offset - returns index 'n' into the log via (optimized) modulus */
@@ -109,8 +113,29 @@ static inline struct logger_log *file_get_log(struct file *file)
 }
 
 /*
- * get_entry_len - Grabs the length of the payload of the next entry starting
- * from 'off'.
+ * get_entry_header - returns a pointer to the logger_entry header within
+ * 'log' starting at offset 'off'. A temporary logger_entry 'scratch' must
+ * be provided. Typically the return value will be a pointer within
+ * 'logger->buf'.  However, a pointer to 'scratch' may be returned if
+ * the log entry spans the end and beginning of the circular buffer.
+ */
+static struct logger_entry *get_entry_header(struct logger_log *log,
+		size_t off, struct logger_entry *scratch)
+{
+	size_t len = min(sizeof(struct logger_entry), log->size - off);
+	if (len != sizeof(struct logger_entry)) {
+		memcpy(((void *) scratch), log->buffer + off, len);
+		memcpy(((void *) scratch) + len, log->buffer,
+			sizeof(struct logger_entry) - len);
+		return scratch;
+	}
+
+	return (struct logger_entry *) (log->buffer + off);
+}
+
+/*
+ * get_entry_msg_len - Grabs the length of the message of the entry
+ * starting from from 'off'.
  *
  * An entry length is 2 bytes (16 bits) in host endian order.
  * In the log, the length does not include the size of the log entry structure.
@@ -118,20 +143,45 @@ static inline struct logger_log *file_get_log(struct file *file)
  *
  * Caller needs to hold log->mutex.
  */
-static __u32 get_entry_len(struct logger_log *log, size_t off)
+static __u32 get_entry_msg_len(struct logger_log *log, size_t off)
 {
-	__u16 val;
+	struct logger_entry scratch;
+	struct logger_entry *entry;
 
-	/* copy 2 bytes from buffer, in memcpy order, */
-	/* handling possible wrap at end of buffer */
+	entry = get_entry_header(log, off, &scratch);
+	return entry->len;
+}
 
-	((__u8 *)&val)[0] = log->buffer[off];
-	if (likely(off+1 < log->size))
-		((__u8 *)&val)[1] = log->buffer[off+1];
+static size_t get_user_hdr_len(int ver)
+{
+	if (ver < 2)
+		return sizeof(struct user_logger_entry_compat);
 	else
-		((__u8 *)&val)[1] = log->buffer[0];
+		return sizeof(struct logger_entry);
+}
+
+static ssize_t copy_header_to_user(int ver, struct logger_entry *entry,
+					 char __user *buf)
+{
+	void *hdr;
+	size_t hdr_len;
+	struct user_logger_entry_compat v1;
+
+	if (ver < 2) {
+		v1.len      = entry->len;
+		v1.__pad    = 0;
+		v1.pid      = entry->pid;
+		v1.tid      = entry->tid;
+		v1.sec      = entry->sec;
+		v1.nsec     = entry->nsec;
+		hdr         = &v1;
+		hdr_len     = sizeof(struct user_logger_entry_compat);
+	} else {
+		hdr         = entry;
+		hdr_len     = sizeof(struct logger_entry);
+	}
 
-	return sizeof(struct logger_entry) + val;
+	return copy_to_user(buf, hdr, hdr_len);
 }
 
 /*
@@ -145,15 +195,31 @@ static ssize_t do_read_log_to_user(struct logger_log *log,
 				   char __user *buf,
 				   size_t count)
 {
+	struct logger_entry scratch;
+	struct logger_entry *entry;
 	size_t len;
+	size_t msg_start;
 
 	/*
-	 * We read from the log in two disjoint operations. First, we read from
-	 * the current read head offset up to 'count' bytes or to the end of
+	 * First, copy the header to userspace, using the version of
+	 * the header requested
+	 */
+	entry = get_entry_header(log, reader->r_off, &scratch);
+	if (copy_header_to_user(reader->r_ver, entry, buf))
+		return -EFAULT;
+
+	count -= get_user_hdr_len(reader->r_ver);
+	buf += get_user_hdr_len(reader->r_ver);
+	msg_start = logger_offset(log,
+		reader->r_off + sizeof(struct logger_entry));
+
+	/*
+	 * We read from the msg in two disjoint operations. First, we read from
+	 * the current msg head offset up to 'count' bytes or to the end of
 	 * the log, whichever comes first.
 	 */
-	len = min(count, log->size - reader->r_off);
-	if (copy_to_user(buf, log->buffer + reader->r_off, len))
+	len = min(count, log->size - msg_start);
+	if (copy_to_user(buf, log->buffer + msg_start, len))
 		return -EFAULT;
 
 	/*
@@ -164,9 +230,34 @@ static ssize_t do_read_log_to_user(struct logger_log *log,
 		if (copy_to_user(buf + len, log->buffer, count - len))
 			return -EFAULT;
 
-	reader->r_off = logger_offset(log, reader->r_off + count);
+	reader->r_off = logger_offset(log, reader->r_off +
+		sizeof(struct logger_entry) + count);
 
-	return count;
+	return count + get_user_hdr_len(reader->r_ver);
+}
+
+/*
+ * get_next_entry_by_uid - Starting at 'off', returns an offset into
+ * 'log->buffer' which contains the first entry readable by 'euid'
+ */
+static size_t get_next_entry_by_uid(struct logger_log *log,
+		size_t off, uid_t euid)
+{
+	while (off != log->w_off) {
+		struct logger_entry *entry;
+		struct logger_entry scratch;
+		size_t next_len;
+
+		entry = get_entry_header(log, off, &scratch);
+
+		if (entry->euid == euid)
+			return off;
+
+		next_len = sizeof(struct logger_entry) + entry->len;
+		off = logger_offset(log, off + next_len);
+	}
+
+	return off;
 }
 
 /*
@@ -178,7 +269,7 @@ static ssize_t do_read_log_to_user(struct logger_log *log,
  *	- If there are no log entries to read, blocks until log is written to
  *	- Atomically reads exactly one log entry
  *
- * Optimal read size is LOGGER_ENTRY_MAX_LEN. Will set errno to EINVAL if read
+ * Will set errno to EINVAL if read
  * buffer is insufficient to hold next entry.
  */
 static ssize_t logger_read(struct file *file, char __user *buf,
@@ -219,6 +310,10 @@ start:
 
 	mutex_lock(&log->mutex);
 
+	if (!reader->r_all)
+		reader->r_off = get_next_entry_by_uid(log,
+			reader->r_off, current_euid());
+
 	/* is there still something to read or did we race? */
 	if (unlikely(log->w_off == reader->r_off)) {
 		mutex_unlock(&log->mutex);
@@ -226,7 +321,8 @@ start:
 	}
 
 	/* get the size of the next entry */
-	ret = get_entry_len(log, reader->r_off);
+	ret = get_user_hdr_len(reader->r_ver) +
+		get_entry_msg_len(log, reader->r_off);
 	if (count < ret) {
 		ret = -EINVAL;
 		goto out;
@@ -252,7 +348,8 @@ static size_t get_next_entry(struct logger_log *log, size_t off, size_t len)
 	size_t count = 0;
 
 	do {
-		size_t nr = get_entry_len(log, off);
+		size_t nr = sizeof(struct logger_entry) +
+			get_entry_msg_len(log, off);
 		off = logger_offset(log, off + nr);
 		count += nr;
 	} while (count < len);
@@ -382,7 +479,9 @@ static ssize_t logger_aio_write(struct kiocb *iocb, const struct iovec *iov,
 	header.tid = current->pid;
 	header.sec = now.tv_sec;
 	header.nsec = now.tv_nsec;
+	header.euid = current_euid();
 	header.len = min_t(size_t, iocb->ki_left, LOGGER_ENTRY_MAX_PAYLOAD);
+	header.hdr_size = sizeof(struct logger_entry);
 
 	/* null writes succeed, return zero */
 	if (unlikely(!header.len))
@@ -463,6 +562,10 @@ static int logger_open(struct inode *inode, struct file *file)
 			return -ENOMEM;
 
 		reader->log = log;
+		reader->r_ver = 1;
+		reader->r_all = in_egroup_p(inode->i_gid) ||
+			capable(CAP_SYSLOG);
+
 		INIT_LIST_HEAD(&reader->list);
 
 		mutex_lock(&log->mutex);
@@ -522,6 +625,10 @@ static unsigned int logger_poll(struct file *file, poll_table *wait)
 	poll_wait(file, &log->wq, wait);
 
 	mutex_lock(&log->mutex);
+	if (!reader->r_all)
+		reader->r_off = get_next_entry_by_uid(log,
+			reader->r_off, current_euid());
+
 	if (log->w_off != reader->r_off)
 		ret |= POLLIN | POLLRDNORM;
 	mutex_unlock(&log->mutex);
@@ -529,11 +636,25 @@ static unsigned int logger_poll(struct file *file, poll_table *wait)
 	return ret;
 }
 
+static long logger_set_version(struct logger_reader *reader, void __user *arg)
+{
+	int version;
+	if (copy_from_user(&version, arg, sizeof(int)))
+		return -EFAULT;
+
+	if ((version < 1) || (version > 2))
+		return -EINVAL;
+
+	reader->r_ver = version;
+	return 0;
+}
+
 static long logger_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	struct logger_log *log = file_get_log(file);
 	struct logger_reader *reader;
-	long ret = -ENOTTY;
+	long ret = -EINVAL;
+	void __user *argp = (void __user *) arg;
 
 	mutex_lock(&log->mutex);
 
@@ -558,8 +679,14 @@ static long logger_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 			break;
 		}
 		reader = file->private_data;
+
+		if (!reader->r_all)
+			reader->r_off = get_next_entry_by_uid(log,
+				reader->r_off, current_euid());
+
 		if (log->w_off != reader->r_off)
-			ret = get_entry_len(log, reader->r_off);
+			ret = get_user_hdr_len(reader->r_ver) +
+				get_entry_msg_len(log, reader->r_off);
 		else
 			ret = 0;
 		break;
@@ -573,6 +700,22 @@ static long logger_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 		log->head = log->w_off;
 		ret = 0;
 		break;
+	case LOGGER_GET_VERSION:
+		if (!(file->f_mode & FMODE_READ)) {
+			ret = -EBADF;
+			break;
+		}
+		reader = file->private_data;
+		ret = reader->r_ver;
+		break;
+	case LOGGER_SET_VERSION:
+		if (!(file->f_mode & FMODE_READ)) {
+			ret = -EBADF;
+			break;
+		}
+		reader = file->private_data;
+		ret = logger_set_version(reader, argp);
+		break;
 	}
 
 	mutex_unlock(&log->mutex);
@@ -592,8 +735,8 @@ static const struct file_operations logger_fops = {
 };
 
 /*
- * Log size must be a power of two, greater than LOGGER_ENTRY_MAX_LEN,
- * and less than LONG_MAX minus LOGGER_ENTRY_MAX_LEN.
+ * Log size must must be a power of two, and greater than
+ * (LOGGER_ENTRY_MAX_PAYLOAD + sizeof(struct logger_entry)).
  */
 static int __init create_log(char *log_name, int size)
 {
diff --git a/drivers/staging/android/logger.h b/drivers/staging/android/logger.h
index 9b929a8..cc6bbd9 100644
--- a/drivers/staging/android/logger.h
+++ b/drivers/staging/android/logger.h
@@ -21,7 +21,7 @@
 #include <linux/ioctl.h>
 
 /**
- * struct logger_entry - defines a single entry that is given to a logger
+ * struct user_logger_entry_compat - defines a single entry that is given to a logger
  * @len:	The length of the payload
  * @__pad:	Two bytes of padding that appear to be required
  * @pid:	The generating process' process ID
@@ -29,8 +29,12 @@
  * @sec:	The number of seconds that have elapsed since the Epoch
  * @nsec:	The number of nanoseconds that have elapsed since @sec
  * @msg:	The message that is to be logged
+ *
+ * The userspace structure for version 1 of the logger_entry ABI.
+ * This structure is returned to userspace unless the caller requests
+ * an upgrade to a newer ABI version.
  */
-struct logger_entry {
+struct user_logger_entry_compat {
 	__u16		len;
 	__u16		__pad;
 	__s32		pid;
@@ -40,14 +44,38 @@ struct logger_entry {
 	char		msg[0];
 };
 
+/**
+ * struct logger_entry - defines a single entry that is given to a logger
+ * @len:	The length of the payload
+ * @hdr_size:	sizeof(struct logger_entry_v2)
+ * @pid:	The generating process' process ID
+ * @tid:	The generating process' thread ID
+ * @sec:	The number of seconds that have elapsed since the Epoch
+ * @nsec:	The number of nanoseconds that have elapsed since @sec
+ * @euid:	Effective UID of logger
+ * @msg:	The message that is to be logged
+ *
+ * The structure for version 2 of the logger_entry ABI.
+ * This structure is returned to userspace if ioctl(LOGGER_SET_VERSION)
+ * is called with version >= 2
+ */
+struct logger_entry {
+	__u16		len;
+	__u16		hdr_size;
+	__s32		pid;
+	__s32		tid;
+	__s32		sec;
+	__s32		nsec;
+	uid_t		euid;
+	char		msg[0];
+};
+
 #define LOGGER_LOG_RADIO	"log_radio"	/* radio-related messages */
 #define LOGGER_LOG_EVENTS	"log_events"	/* system/hardware events */
 #define LOGGER_LOG_SYSTEM	"log_system"	/* system/framework messages */
 #define LOGGER_LOG_MAIN		"log_main"	/* everything else */
 
-#define LOGGER_ENTRY_MAX_LEN		(4*1024)
-#define LOGGER_ENTRY_MAX_PAYLOAD	\
-	(LOGGER_ENTRY_MAX_LEN - sizeof(struct logger_entry))
+#define LOGGER_ENTRY_MAX_PAYLOAD	4076
 
 #define __LOGGERIO	0xAE
 
@@ -55,5 +83,7 @@ struct logger_entry {
 #define LOGGER_GET_LOG_LEN		_IO(__LOGGERIO, 2) /* used log len */
 #define LOGGER_GET_NEXT_ENTRY_LEN	_IO(__LOGGERIO, 3) /* next entry len */
 #define LOGGER_FLUSH_LOG		_IO(__LOGGERIO, 4) /* flush log */
+#define LOGGER_GET_VERSION		_IO(__LOGGERIO, 5) /* abi version */
+#define LOGGER_SET_VERSION		_IO(__LOGGERIO, 6) /* abi version */
 
 #endif /* _LINUX_LOGGER_H */
-- 
1.7.10.4

