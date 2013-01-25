Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756270Ab3AYM0O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 07:26:14 -0500
Received: from terminus.zytor.com ([198.137.202.10]:42614 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754841Ab3AYM0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 07:26:10 -0500
Date: Fri, 25 Jan 2013 04:25:55 -0800
From: tip-bot for Stephane Eranian <eranian@google.com>
Message-ID: <tip-59e1a00ac0e4d33ffc46814a3509b5cc2c94c56f@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@kernel.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de
In-Reply-To: <1359040242-8269-16-git-send-email-eranian@google.com>
References: <1359040242-8269-16-git-send-email-eranian@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/x86] perf:
  Add PERF_RECORD_MISC_MMAP_DATA to RECORD_MMAP
Git-Commit-ID: 59e1a00ac0e4d33ffc46814a3509b5cc2c94c56f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 25 Jan 2013 04:26:00 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  59e1a00ac0e4d33ffc46814a3509b5cc2c94c56f
Gitweb:     http://git.kernel.org/tip/59e1a00ac0e4d33ffc46814a3509b5cc2c94c56f
Author:     Stephane Eranian <eranian@google.com>
AuthorDate: Thu, 24 Jan 2013 16:10:39 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 25 Jan 2013 10:19:05 +0100

perf: Add PERF_RECORD_MISC_MMAP_DATA to RECORD_MMAP

Type of mapping was lost and made it hard for a tool
to distinguish code vs. data mmaps. Perf has the ability
to distinguish the two.

Use a bit in the header->misc bitmask to keep track of
the mmap type. If PERF_RECORD_MISC_MMAP_DATA is set then
the mapping is not executable (!VM_EXEC). If not set, then
the mapping is executable.

Signed-off-by: Stephane Eranian <eranian@google.com>
Cc: peterz@infradead.org
Cc: ak@linux.intel.com
Cc: acme@redhat.com
Cc: jolsa@redhat.com
Cc: namhyung.kim@lge.com
Link: http://lkml.kernel.org/r/1359040242-8269-16-git-send-email-eranian@google.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/uapi/linux/perf_event.h | 1 +
 kernel/events/core.c            | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
index 0c46659..62e9f25 100644
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
index 4661009..dd1c130 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -4764,6 +4764,9 @@ got_name:
 	mmap_event->file_name = name;
 	mmap_event->file_size = size;
 
+	if (!(vma->vm_flags & VM_EXEC))
+		mmap_event->event_id.header.misc |= PERF_RECORD_MISC_MMAP_DATA;
+
 	mmap_event->event_id.header.size = sizeof(mmap_event->event_id) + size;
 
 	rcu_read_lock();
