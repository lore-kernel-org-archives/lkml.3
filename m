Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752936AbaEMQuM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 12:50:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20494 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752376AbaEMQtY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 12:49:24 -0400
From: Don Zickus <dzickus@redhat.com>
To: acme@ghostprotocols.net, peterz@infradead.org
Cc: LKML <linux-kernel@vger.kernel.org>, jolsa@redhat.com, namhyung@gmail.com,
        eranian@google.com, Andi Kleen <andi@firstfloor.org>,
        Don Zickus <dzickus@redhat.com>
Subject: [PATCH 1/6] events, perf: Pass protection and flags bits through mmap2 interface
Date: Tue, 13 May 2014 12:48:12 -0400
Message-Id: <1399999697-65875-2-git-send-email-dzickus@redhat.com>
In-Reply-To: <1399999697-65875-1-git-send-email-dzickus@redhat.com>
References: <1399999697-65875-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra <a.p.zijlstra@chello.nl>

The mmap2 interface was missing the protection and flags bits needed to
accurately determine if a mmap memory area was shared or private and
if it was readable or not.

[tweaked patch to compile and wrote changelog]
Signed-off-by: Don Zickus <dzickus@redhat.com>

--
Peter you mentioned writing up a changelog for this patch, but you
seemed busy, so I jumped the gun a little bit.  Let me know how you
want to do this patch if this approach is wrong.
---
 include/uapi/linux/perf_event.h |  1 +
 kernel/events/core.c            | 33 +++++++++++++++++++++++++++++++++
 2 files changed, 34 insertions(+)

diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
index 853bc1c..2ed502f 100644
--- a/include/uapi/linux/perf_event.h
+++ b/include/uapi/linux/perf_event.h
@@ -699,6 +699,7 @@ enum perf_event_type {
 	 *	u32				min;
 	 *	u64				ino;
 	 *	u64				ino_generation;
+	 *	u32				prot, flags;
 	 *	char				filename[];
 	 * 	struct sample_id		sample_id;
 	 * };
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 5129b12..0711cc9 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -40,6 +40,7 @@
 #include <linux/mm_types.h>
 #include <linux/cgroup.h>
 #include <linux/module.h>
+#include <linux/mman.h>
 
 #include "internal.h"
 
@@ -5089,6 +5090,7 @@ struct perf_mmap_event {
 	int			maj, min;
 	u64			ino;
 	u64			ino_generation;
+	u32			prot, flags;
 
 	struct {
 		struct perf_event_header	header;
@@ -5130,6 +5132,8 @@ static void perf_event_mmap_output(struct perf_event *event,
 		mmap_event->event_id.header.size += sizeof(mmap_event->min);
 		mmap_event->event_id.header.size += sizeof(mmap_event->ino);
 		mmap_event->event_id.header.size += sizeof(mmap_event->ino_generation);
+		mmap_event->event_id.header.size += sizeof(mmap_event->prot);
+		mmap_event->event_id.header.size += sizeof(mmap_event->flags);
 	}
 
 	perf_event_header__init_id(&mmap_event->event_id.header, &sample, event);
@@ -5148,6 +5152,8 @@ static void perf_event_mmap_output(struct perf_event *event,
 		perf_output_put(&handle, mmap_event->min);
 		perf_output_put(&handle, mmap_event->ino);
 		perf_output_put(&handle, mmap_event->ino_generation);
+		perf_output_put(&handle, mmap_event->prot);
+		perf_output_put(&handle, mmap_event->flags);
 	}
 
 	__output_copy(&handle, mmap_event->file_name,
@@ -5166,6 +5172,7 @@ static void perf_event_mmap_event(struct perf_mmap_event *mmap_event)
 	struct file *file = vma->vm_file;
 	int maj = 0, min = 0;
 	u64 ino = 0, gen = 0;
+	u32 prot = 0, flags = 0;
 	unsigned int size;
 	char tmp[16];
 	char *buf = NULL;
@@ -5196,6 +5203,28 @@ static void perf_event_mmap_event(struct perf_mmap_event *mmap_event)
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
@@ -5236,6 +5265,8 @@ got_name:
 	mmap_event->min = min;
 	mmap_event->ino = ino;
 	mmap_event->ino_generation = gen;
+	mmap_event->prot = prot;
+	mmap_event->flags = flags;
 
 	if (!(vma->vm_flags & VM_EXEC))
 		mmap_event->event_id.header.misc |= PERF_RECORD_MISC_MMAP_DATA;
@@ -5276,6 +5307,8 @@ void perf_event_mmap(struct vm_area_struct *vma)
 		/* .min (attr_mmap2 only) */
 		/* .ino (attr_mmap2 only) */
 		/* .ino_generation (attr_mmap2 only) */
+		/* .prot (attr_mmap2 only) */
+		/* .flags (attr_mmap2 only) */
 	};
 
 	perf_event_mmap_event(&mmap_event);
-- 
1.7.11.7

