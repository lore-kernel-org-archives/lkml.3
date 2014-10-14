Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932638AbaJNW6C (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 18:58:02 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:44501 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932583AbaJNW56 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 18:57:58 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Kees Cook <keescook@chromium.org>,
        Andrea Arcangeli <aarcange@redhat.com>, Erik Bosman <ebn310@few.vu.nl>,
        Andy Lutomirski <luto@amacapital.net>
Subject: [RFC 4/5] perf: Add pmu callbacks to track event mapping and unmapping
Date: Tue, 14 Oct 2014 15:57:38 -0700
Message-Id: <35c57984f52e88358d003fe716404f2b308d7bac.1413323612.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <cover.1413323611.git.luto@amacapital.net>
References: <cover.1413323611.git.luto@amacapital.net>
In-Reply-To: <cover.1413323611.git.luto@amacapital.net>
References: <cover.1413323611.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 include/linux/perf_event.h | 7 +++++++
 kernel/events/core.c       | 9 +++++++++
 2 files changed, 16 insertions(+)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 707617a8c0f6..88069e319a3f 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -206,6 +206,13 @@ struct pmu {
 	 */
 	int (*event_init)		(struct perf_event *event);
 
+	/*
+	 * Notification that the event was mapped or unmapped.  Called
+	 * in the context of the mapping task.
+	 */
+	void (*event_mapped)		(struct perf_event *event); /*optional*/
+	void (*event_unmapped)		(struct perf_event *event); /*optional*/
+
 #define PERF_EF_START	0x01		/* start the counter when adding    */
 #define PERF_EF_RELOAD	0x02		/* reload the counter when starting */
 #define PERF_EF_UPDATE	0x04		/* update the counter when stopping */
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 963bf139e2b2..dc73e9723748 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -4008,6 +4008,9 @@ static void perf_mmap_open(struct vm_area_struct *vma)
 
 	atomic_inc(&event->mmap_count);
 	atomic_inc(&event->rb->mmap_count);
+
+	if (event->pmu->event_mapped)
+		event->pmu->event_mapped(event);
 }
 
 /*
@@ -4027,6 +4030,9 @@ static void perf_mmap_close(struct vm_area_struct *vma)
 	int mmap_locked = rb->mmap_locked;
 	unsigned long size = perf_data_size(rb);
 
+	if (event->pmu->event_unmapped)
+		event->pmu->event_unmapped(event);
+
 	atomic_dec(&rb->mmap_count);
 
 	if (!atomic_dec_and_mutex_lock(&event->mmap_count, &event->mmap_mutex))
@@ -4228,6 +4234,9 @@ unlock:
 	vma->vm_flags |= VM_DONTCOPY | VM_DONTEXPAND | VM_DONTDUMP;
 	vma->vm_ops = &perf_mmap_vmops;
 
+	if (event->pmu->event_mapped)
+		event->pmu->event_mapped(event);
+
 	return ret;
 }
 
-- 
1.9.3

