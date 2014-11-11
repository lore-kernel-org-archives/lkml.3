Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752227AbaKKL1i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 06:27:38 -0500
Received: from mga11.intel.com ([192.55.52.93]:2187 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751328AbaKKL1f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 06:27:35 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="414765769"
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Robert Richter <rric@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        kan.liang@intel.com, adrian.hunter@intel.com,
        markus.t.metzger@intel.com, mathieu.poirier@linaro.org,
        acme@infradead.org,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>
Subject: [PATCH v6 01/14] perf: Add data_{offset,size} to user_page
Date: Tue, 11 Nov 2014 13:26:47 +0200
Message-Id: <1415705221-182873-2-git-send-email-alexander.shishkin@linux.intel.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1415705221-182873-1-git-send-email-alexander.shishkin@linux.intel.com>
References: <1415705221-182873-1-git-send-email-alexander.shishkin@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, the actual perf ring buffer is one page into the mmap area,
following the user page and the userspace follows this convention. This
patch adds data_{offset,size} fields to user_page that can be used by
userspace instead for locating perf data in the mmap area. This is also
helpful when mapping existing or shared buffers if their size is not
known in advance.

Right now, it is made to follow the existing convention that

	data_offset == PAGE_SIZE and
	data_offset + data_size == mmap_size.

Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
---
 include/uapi/linux/perf_event.h | 5 +++++
 kernel/events/core.c            | 2 ++
 2 files changed, 7 insertions(+)

diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
index 9d845404d8..dbb50c31c7 100644
--- a/include/uapi/linux/perf_event.h
+++ b/include/uapi/linux/perf_event.h
@@ -489,9 +489,14 @@ struct perf_event_mmap_page {
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
index 2b02c9fda7..96105bb6b1 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -3942,6 +3942,8 @@ static void perf_event_init_userpage(struct perf_event *event)
 	/* Allow new userspace to detect that bit 0 is deprecated */
 	userpg->cap_bit0_is_deprecated = 1;
 	userpg->size = offsetof(struct perf_event_mmap_page, __reserved);
+	userpg->data_offset = PAGE_SIZE;
+	userpg->data_size = perf_data_size(rb);
 
 unlock:
 	rcu_read_unlock();
-- 
2.1.1

