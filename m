Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755275Ab3AXPL5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 10:11:57 -0500
Received: from mail-wi0-f175.google.com ([209.85.212.175]:56090 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755130Ab3AXPLy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 10:11:54 -0500
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, ak@linux.intel.com, acme@redhat.com,
        jolsa@redhat.com, namhyung.kim@lge.com
Subject: [PATCH v7 15/18] perf: add PERF_RECORD_MISC_MMAP_DATA to RECORD_MMAP
Date: Thu, 24 Jan 2013 16:10:39 +0100
Message-Id: <1359040242-8269-16-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1359040242-8269-1-git-send-email-eranian@google.com>
References: <1359040242-8269-1-git-send-email-eranian@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Type of mapping was lost and made it hard for a tool
to distinguish code vs. data mmaps. Perf has the ability
to distinguish the two.

Use a bit in the header->misc bitmask to keep track of
the mmap type. If PERF_RECORD_MISC_MMAP_DATA is set then
the mapping is not executable (!VM_EXEC). If not set, then
the mapping is executable.

Signed-off-by: Stephane Eranian <eranian@google.com>
---
 include/uapi/linux/perf_event.h |    1 +
 kernel/events/core.c            |    3 +++
 2 files changed, 4 insertions(+)

diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
index 3e4844c..3907b29 100644
--- a/include/uapi/linux/perf_event.h
+++ b/include/uapi/linux/perf_event.h
@@ -445,6 +445,7 @@ struct perf_event_mmap_page {
 #define PERF_RECORD_MISC_GUEST_KERNEL		(4 << 0)
 #define PERF_RECORD_MISC_GUEST_USER		(5 << 0)
 
+#define PERF_RECORD_MISC_MMAP_DATA		(1 << 13)
 /*
  * Indicates that the content of PERF_SAMPLE_IP points to
  * the actual instruction that triggered the event. See also
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 56ca60b..966069d 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -4764,6 +4764,9 @@ static void perf_event_mmap_event(struct perf_mmap_event *mmap_event)
 	mmap_event->file_name = name;
 	mmap_event->file_size = size;
 
+	if (!(vma->vm_flags & VM_EXEC))
+		mmap_event->event_id.header.misc |= PERF_RECORD_MISC_MMAP_DATA;
+
 	mmap_event->event_id.header.size = sizeof(mmap_event->event_id) + size;
 
 	rcu_read_lock();
-- 
1.7.9.5

