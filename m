Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932186Ab3IBHmd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 03:42:33 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52468 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932172Ab3IBHm3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 03:42:29 -0400
Date: Mon, 2 Sep 2013 00:41:58 -0700
From: tip-bot for Stephane Eranian <tipbot@zytor.com>
Message-ID: <tip-13d7a2410fa637f450a29ecb515ac318ee40c741@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, tglx@linutronix.de,
        viro@zeniv.linux.org.uk
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, peterz@infradead.org, tglx@linutronix.de,
        viro@zeniv.linux.org.uk
In-Reply-To: <1377079825-19057-2-git-send-email-eranian@google.com>
References: <1377079825-19057-2-git-send-email-eranian@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Add attr->mmap2 attribute to an event
Git-Commit-ID: 13d7a2410fa637f450a29ecb515ac318ee40c741
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 02 Sep 2013 00:42:04 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  13d7a2410fa637f450a29ecb515ac318ee40c741
Gitweb:     http://git.kernel.org/tip/13d7a2410fa637f450a29ecb515ac318ee40c741
Author:     Stephane Eranian <eranian@google.com>
AuthorDate: Wed, 21 Aug 2013 12:10:24 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 2 Sep 2013 08:42:48 +0200

perf: Add attr->mmap2 attribute to an event

Adds a new PERF_RECORD_MMAP2 record type which is essence
an expanded version of PERF_RECORD_MMAP.

Used to request mmap records with more information about
the mapping, including device major, minor and the inode
number and generation for mappings associated with files
or shared memory segments. Works for code and data
(with attr->mmap_data set).

Existing PERF_RECORD_MMAP record is unmodified by this patch.

Signed-off-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Link: http://lkml.kernel.org/r/1377079825-19057-2-git-send-email-eranian@google.com
[ Added Al to the Cc:. Are the ino, maj/min exports of vma->vm_file OK? ]
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/uapi/linux/perf_event.h | 24 ++++++++++++++++++++-
 kernel/events/core.c            | 46 +++++++++++++++++++++++++++++++++++++----
 2 files changed, 65 insertions(+), 5 deletions(-)

diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
index 42cb7b6..a77f43a 100644
--- a/include/uapi/linux/perf_event.h
+++ b/include/uapi/linux/perf_event.h
@@ -276,8 +276,9 @@ struct perf_event_attr {
 
 				exclude_callchain_kernel : 1, /* exclude kernel callchains */
 				exclude_callchain_user   : 1, /* exclude user callchains */
+				mmap2          :  1, /* include mmap with inode data     */
 
-				__reserved_1   : 41;
+				__reserved_1   : 40;
 
 	union {
 		__u32		wakeup_events;	  /* wakeup every n events */
@@ -651,6 +652,27 @@ enum perf_event_type {
 	 */
 	PERF_RECORD_SAMPLE			= 9,
 
+	/*
+	 * The MMAP2 records are an augmented version of MMAP, they add
+	 * maj, min, ino numbers to be used to uniquely identify each mapping
+	 *
+	 * struct {
+	 *	struct perf_event_header	header;
+	 *
+	 *	u32				pid, tid;
+	 *	u64				addr;
+	 *	u64				len;
+	 *	u64				pgoff;
+	 *	u32				maj;
+	 *	u32				min;
+	 *	u64				ino;
+	 *	u64				ino_generation;
+	 *	char				filename[];
+	 * 	struct sample_id		sample_id;
+	 * };
+	 */
+	PERF_RECORD_MMAP2			= 10,
+
 	PERF_RECORD_MAX,			/* non-ABI */
 };
 
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 15d0f24..c7ee497 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -4776,7 +4776,7 @@ next:
 /*
  * task tracking -- fork/exit
  *
- * enabled by: attr.comm | attr.mmap | attr.mmap_data | attr.task
+ * enabled by: attr.comm | attr.mmap | attr.mmap2 | attr.mmap_data | attr.task
  */
 
 struct perf_task_event {
@@ -4796,8 +4796,9 @@ struct perf_task_event {
 
 static int perf_event_task_match(struct perf_event *event)
 {
-	return event->attr.comm || event->attr.mmap ||
-	       event->attr.mmap_data || event->attr.task;
+	return event->attr.comm  || event->attr.mmap ||
+	       event->attr.mmap2 || event->attr.mmap_data ||
+	       event->attr.task;
 }
 
 static void perf_event_task_output(struct perf_event *event,
@@ -4992,6 +4993,9 @@ struct perf_mmap_event {
 
 	const char		*file_name;
 	int			file_size;
+	int			maj, min;
+	u64			ino;
+	u64			ino_generation;
 
 	struct {
 		struct perf_event_header	header;
@@ -5012,7 +5016,7 @@ static int perf_event_mmap_match(struct perf_event *event,
 	int executable = vma->vm_flags & VM_EXEC;
 
 	return (!executable && event->attr.mmap_data) ||
-	       (executable && event->attr.mmap);
+	       (executable && (event->attr.mmap || event->attr.mmap2));
 }
 
 static void perf_event_mmap_output(struct perf_event *event,
@@ -5027,6 +5031,13 @@ static void perf_event_mmap_output(struct perf_event *event,
 	if (!perf_event_mmap_match(event, data))
 		return;
 
+	if (event->attr.mmap2) {
+		mmap_event->event_id.header.type = PERF_RECORD_MMAP2;
+		mmap_event->event_id.header.size += sizeof(mmap_event->maj);
+		mmap_event->event_id.header.size += sizeof(mmap_event->min);
+		mmap_event->event_id.header.size += sizeof(mmap_event->ino);
+	}
+
 	perf_event_header__init_id(&mmap_event->event_id.header, &sample, event);
 	ret = perf_output_begin(&handle, event,
 				mmap_event->event_id.header.size);
@@ -5037,6 +5048,14 @@ static void perf_event_mmap_output(struct perf_event *event,
 	mmap_event->event_id.tid = perf_event_tid(event, current);
 
 	perf_output_put(&handle, mmap_event->event_id);
+
+	if (event->attr.mmap2) {
+		perf_output_put(&handle, mmap_event->maj);
+		perf_output_put(&handle, mmap_event->min);
+		perf_output_put(&handle, mmap_event->ino);
+		perf_output_put(&handle, mmap_event->ino_generation);
+	}
+
 	__output_copy(&handle, mmap_event->file_name,
 				   mmap_event->file_size);
 
@@ -5051,6 +5070,8 @@ static void perf_event_mmap_event(struct perf_mmap_event *mmap_event)
 {
 	struct vm_area_struct *vma = mmap_event->vma;
 	struct file *file = vma->vm_file;
+	int maj = 0, min = 0;
+	u64 ino = 0, gen = 0;
 	unsigned int size;
 	char tmp[16];
 	char *buf = NULL;
@@ -5059,6 +5080,8 @@ static void perf_event_mmap_event(struct perf_mmap_event *mmap_event)
 	memset(tmp, 0, sizeof(tmp));
 
 	if (file) {
+		struct inode *inode;
+		dev_t dev;
 		/*
 		 * d_path works from the end of the rb backwards, so we
 		 * need to add enough zero bytes after the string to handle
@@ -5074,6 +5097,13 @@ static void perf_event_mmap_event(struct perf_mmap_event *mmap_event)
 			name = strncpy(tmp, "//toolong", sizeof(tmp));
 			goto got_name;
 		}
+		inode = file_inode(vma->vm_file);
+		dev = inode->i_sb->s_dev;
+		ino = inode->i_ino;
+		gen = inode->i_generation;
+		maj = MAJOR(dev);
+		min = MINOR(dev);
+
 	} else {
 		if (arch_vma_name(mmap_event->vma)) {
 			name = strncpy(tmp, arch_vma_name(mmap_event->vma),
@@ -5104,6 +5134,10 @@ got_name:
 
 	mmap_event->file_name = name;
 	mmap_event->file_size = size;
+	mmap_event->maj = maj;
+	mmap_event->min = min;
+	mmap_event->ino = ino;
+	mmap_event->ino_generation = gen;
 
 	if (!(vma->vm_flags & VM_EXEC))
 		mmap_event->event_id.header.misc |= PERF_RECORD_MISC_MMAP_DATA;
@@ -5140,6 +5174,10 @@ void perf_event_mmap(struct vm_area_struct *vma)
 			.len    = vma->vm_end - vma->vm_start,
 			.pgoff  = (u64)vma->vm_pgoff << PAGE_SHIFT,
 		},
+		/* .maj (attr_mmap2 only) */
+		/* .min (attr_mmap2 only) */
+		/* .ino (attr_mmap2 only) */
+		/* .ino_generation (attr_mmap2 only) */
 	};
 
 	perf_event_mmap_event(&mmap_event);
