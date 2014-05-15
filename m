Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754910AbaEOPLd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 11:11:33 -0400
Received: from mga01.intel.com ([192.55.52.88]:39959 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752179AbaEOPLc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 11:11:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1059,1389772800"; 
   d="scan'208";a="539622805"
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>
Subject: [RFC 1/2] perf: add data_{offset,size} to user_page
Date: Thu, 15 May 2014 18:08:29 +0300
Message-Id: <1400166510-9234-2-git-send-email-alexander.shishkin@linux.intel.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1400166510-9234-1-git-send-email-alexander.shishkin@linux.intel.com>
References: <1400166510-9234-1-git-send-email-alexander.shishkin@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, the actual perf ring buffer is one page into the mmap area,
following the user page and the userspace follows this convention. This
patch adds data_{offset,size} fields to user_page that can be used by
userspace instead for locating perf data in the mmap area.

Right now, it is made to follow the existing convention that

	data_offset == PAGE_SIZE and
	data_offset + data_size == mmap_size.

Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
---
 include/uapi/linux/perf_event.h | 5 +++++
 kernel/events/core.c            | 2 ++
 2 files changed, 7 insertions(+)

diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
index 853bc1c..ef95af4 100644
--- a/include/uapi/linux/perf_event.h
+++ b/include/uapi/linux/perf_event.h
@@ -488,9 +488,14 @@ struct perf_event_mmap_page {
 	 * In this case the kernel will not over-write unread data.
 	 *
 	 * See perf_output_put_handle() for the data ordering.
+	 *
+	 * data_{offset,size} indicate the location and size of the perf record
+	 * buffer within the mmapped area.
 	 */
 	__u64   data_head;		/* head in the data section */
 	__u64	data_tail;		/* user-space written tail */
+	__u64	data_offset;		/* where the buffer starts */
+	__u64	data_size;		/* data buffer size */
 };
 
 #define PERF_RECORD_MISC_CPUMODE_MASK		(7 << 0)
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 0b9309b..bbe8b48 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -3768,6 +3768,8 @@ static void perf_event_init_userpage(struct perf_event *event)
 	/* Allow new userspace to detect that bit 0 is deprecated */
 	userpg->cap_bit0_is_deprecated = 1;
 	userpg->size = offsetof(struct perf_event_mmap_page, __reserved);
+	userpg->data_offset = PAGE_SIZE;
+	userpg->data_size = perf_data_size(rb);
 
 unlock:
 	rcu_read_unlock();
-- 
2.0.0.rc2

