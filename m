Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757346Ab3JQP3e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 11:29:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24289 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755326Ab3JQP3d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 11:29:33 -0400
Date: Thu, 17 Oct 2013 17:22:23 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 3/2] perf: Optimize the fill/align code in
	perf_event_mmap_event()
Message-ID: <20131017152223.GB14098@redhat.com>
References: <20131012192203.GA21738@redhat.com> <20131014102426.GX3081@twins.programming.kicks-ass.net> <20131016200924.GA23214@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131016200924.GA23214@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1. memset(tmp, 0) and especially kzalloc(PATH_MAX) are suboptimal,
   we only need to zero-fill the alignment.

   Remove this memset/__GFP_ZERO and fill the extra bytes by hand.

2. The usage of strncpy(tmp) is not optimal too, we can add the new
   label and do this in one place.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/events/core.c |   47 +++++++++++++++++++++++------------------------
 1 files changed, 23 insertions(+), 24 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 4a1e7b8..777a268 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -5098,20 +5098,17 @@ static void perf_event_mmap_event(struct perf_mmap_event *mmap_event)
 	int maj = 0, min = 0;
 	u64 ino = 0, gen = 0;
 	unsigned int size;
-	char tmp[16];
-	char *buf = NULL;
-	const char *name;
-
-	memset(tmp, 0, sizeof(tmp));
+	char tmp[16], *name, *buf = NULL;
+	const char *str;
 
 	if (file) {
 		struct inode *inode;
 		dev_t dev;
 
-		buf = kzalloc(PATH_MAX, GFP_KERNEL);
+		buf = kmalloc(PATH_MAX, GFP_KERNEL);
 		if (!buf) {
-			name = strncpy(tmp, "//enomem", sizeof(tmp));
-			goto got_name;
+			str = "//enomem";
+			goto cpy_name;
 		}
 		/*
 		 * d_path works from the end of the rb backwards, so we
@@ -5120,8 +5117,8 @@ static void perf_event_mmap_event(struct perf_mmap_event *mmap_event)
 		 */
 		name = d_path(&file->f_path, buf, PATH_MAX - sizeof(u64));
 		if (IS_ERR(name)) {
-			name = strncpy(tmp, "//toolong", sizeof(tmp));
-			goto got_name;
+			str = "//toolong";
+			goto cpy_name;
 		}
 		inode = file_inode(vma->vm_file);
 		dev = inode->i_sb->s_dev;
@@ -5129,32 +5126,34 @@ static void perf_event_mmap_event(struct perf_mmap_event *mmap_event)
 		gen = inode->i_generation;
 		maj = MAJOR(dev);
 		min = MINOR(dev);
-
+		goto got_name;
 	} else {
-		name = arch_vma_name(vma);
-		if (name) {
-			name = strncpy(tmp, name, sizeof(tmp) - 1);
-			tmp[sizeof(tmp) - 1] = '\0';
-			goto got_name;
-		}
+		str = arch_vma_name(vma);
+		if (str)
+			goto cpy_name;
 
 		if (vma->vm_start <= vma->vm_mm->start_brk &&
 				vma->vm_end >= vma->vm_mm->brk) {
-			name = strncpy(tmp, "[heap]", sizeof(tmp));
-			goto got_name;
+			str = "[heap]";
+			goto cpy_name;
 		}
 		if (vma->vm_start <= vma->vm_mm->start_stack &&
 				vma->vm_end >= vma->vm_mm->start_stack) {
-			name = strncpy(tmp, "[stack]", sizeof(tmp));
-			goto got_name;
+			str = "[stack]";
+			goto cpy_name;
 		}
 
-		name = strncpy(tmp, "//anon", sizeof(tmp));
-		goto got_name;
+		str = "//anon";
+		goto cpy_name;
 	}
 
+cpy_name:
+	strlcpy(tmp, str, sizeof(tmp));
+	name = tmp;
 got_name:
-	size = ALIGN(strlen(name)+1, sizeof(u64));
+	size = strlen(name) + 1;
+	while (size % sizeof(u64))
+		name[size++] = '\0';
 
 	mmap_event->file_name = name;
 	mmap_event->file_size = size;
-- 
1.5.5.1


