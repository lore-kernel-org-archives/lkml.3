Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932185AbaFIUD0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 16:03:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50180 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753930AbaFIUDX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 16:03:23 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Peter Zijlstra <peterz@infradead.org>, Don Zickus <dzickus@redhat.com>,
        Jiri Olsa <jolsa@kernel.org>
Subject: [PATCH 08/15] perf: Pass protection and flags bits through mmap2 interface
Date: Mon,  9 Jun 2014 22:02:23 +0200
Message-Id: <1402344150-14860-9-git-send-email-jolsa@kernel.org>
In-Reply-To: <1402344150-14860-1-git-send-email-jolsa@kernel.org>
References: <1402344150-14860-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra <a.p.zijlstra@chello.nl>

The mmap2 interface was missing the protection and flags bits needed to
accurately determine if a mmap memory area was shared or private and
if it was readable or not.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
[tweaked patch to compile and wrote changelog]
Signed-off-by: Don Zickus <dzickus@redhat.com>
Link: http://lkml.kernel.org/r/1400526833-141779-2-git-send-email-dzickus@redhat.com
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 include/uapi/linux/perf_event.h |  1 +
 kernel/events/core.c            | 33 +++++++++++++++++++++++++++++++++
 2 files changed, 34 insertions(+)

diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
index 5312fae..9269de2 100644
--- a/include/uapi/linux/perf_event.h
+++ b/include/uapi/linux/perf_event.h
@@ -705,6 +705,7 @@ enum perf_event_type {
 	 *	u32				min;
 	 *	u64				ino;
 	 *	u64				ino_generation;
+	 *	u32				prot, flags;
 	 *	char				filename[];
 	 * 	struct sample_id		sample_id;
 	 * };
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 7da5e56..eea1955 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -40,6 +40,7 @@
 #include <linux/mm_types.h>
 #include <linux/cgroup.h>
 #include <linux/module.h>
+#include <linux/mman.h>
 
 #include "internal.h"
 
@@ -5127,6 +5128,7 @@ struct perf_mmap_event {
 	int			maj, min;
 	u64			ino;
 	u64			ino_generation;
+	u32			prot, flags;
 
 	struct {
 		struct perf_event_header	header;
@@ -5168,6 +5170,8 @@ static void perf_event_mmap_output(struct perf_event *event,
 		mmap_event->event_id.header.size += sizeof(mmap_event->min);
 		mmap_event->event_id.header.size += sizeof(mmap_event->ino);
 		mmap_event->event_id.header.size += sizeof(mmap_event->ino_generation);
+		mmap_event->event_id.header.size += sizeof(mmap_event->prot);
+		mmap_event->event_id.header.size += sizeof(mmap_event->flags);
 	}
 
 	perf_event_header__init_id(&mmap_event->event_id.header, &sample, event);
@@ -5186,6 +5190,8 @@ static void perf_event_mmap_output(struct perf_event *event,
 		perf_output_put(&handle, mmap_event->min);
 		perf_output_put(&handle, mmap_event->ino);
 		perf_output_put(&handle, mmap_event->ino_generation);
+		perf_output_put(&handle, mmap_event->prot);
+		perf_output_put(&handle, mmap_event->flags);
 	}
 
 	__output_copy(&handle, mmap_event->file_name,
@@ -5204,6 +5210,7 @@ static void perf_event_mmap_event(struct perf_mmap_event *mmap_event)
 	struct file *file = vma->vm_file;
 	int maj = 0, min = 0;
 	u64 ino = 0, gen = 0;
+	u32 prot = 0, flags = 0;
 	unsigned int size;
 	char tmp[16];
 	char *buf = NULL;
@@ -5234,6 +5241,28 @@ static void perf_event_mmap_event(struct perf_mmap_event *mmap_event)
 		gen = inode->i_generation;
 		maj = MAJOR(dev);
 		min = MINOR(dev);
+
+		if (vma->vm_flags & VM_READ)
+			prot |= PROT_READ;
+		if (vma->vm_flags & VM_WRITE)
+			prot |= PROT_WRITE;
+		if (vma->vm_flags & VM_EXEC)
+			prot |= PROT_EXEC;
+
+		if (vma->vm_flags & VM_MAYSHARE)
+			flags = MAP_SHARED;
+		else
+			flags = MAP_PRIVATE;
+
+		if (vma->vm_flags & VM_DENYWRITE)
+			flags |= MAP_DENYWRITE;
+		if (vma->vm_flags & VM_MAYEXEC)
+			flags |= MAP_EXECUTABLE;
+		if (vma->vm_flags & VM_LOCKED)
+			flags |= MAP_LOCKED;
+		if (vma->vm_flags & VM_HUGETLB)
+			flags |= MAP_HUGETLB;
+
 		goto got_name;
 	} else {
 		name = (char *)arch_vma_name(vma);
@@ -5274,6 +5303,8 @@ got_name:
 	mmap_event->min = min;
 	mmap_event->ino = ino;
 	mmap_event->ino_generation = gen;
+	mmap_event->prot = prot;
+	mmap_event->flags = flags;
 
 	if (!(vma->vm_flags & VM_EXEC))
 		mmap_event->event_id.header.misc |= PERF_RECORD_MISC_MMAP_DATA;
@@ -5314,6 +5345,8 @@ void perf_event_mmap(struct vm_area_struct *vma)
 		/* .min (attr_mmap2 only) */
 		/* .ino (attr_mmap2 only) */
 		/* .ino_generation (attr_mmap2 only) */
+		/* .prot (attr_mmap2 only) */
+		/* .flags (attr_mmap2 only) */
 	};
 
 	perf_event_mmap_event(&mmap_event);
-- 
1.8.3.1

