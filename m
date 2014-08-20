Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753751AbaHTMjl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 08:39:41 -0400
Received: from mga11.intel.com ([192.55.52.93]:58542 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753684AbaHTMjj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 08:39:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,902,1400050800"; 
   d="scan'208";a="587436091"
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Robert Richter <rric@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        kan.liang@intel.com,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>
Subject: [PATCH v4 01/22] perf: Add data_{offset,size} to user_page
Date: Wed, 20 Aug 2014 15:35:58 +0300
Message-Id: <1408538179-792-2-git-send-email-alexander.shishkin@linux.intel.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1408538179-792-1-git-send-email-alexander.shishkin@linux.intel.com>
References: <1408538179-792-1-git-send-email-alexander.shishkin@linux.intel.com>
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
index 9269de2548..f7d18c2cb7 100644
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
index 2d7363adf6..1e208bfe89 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -3879,6 +3879,8 @@ static void perf_event_init_userpage(struct perf_event *event)
 	/* Allow new userspace to detect that bit 0 is deprecated */
 	userpg->cap_bit0_is_deprecated = 1;
 	userpg->size = offsetof(struct perf_event_mmap_page, __reserved);
+	userpg->data_offset = PAGE_SIZE;
+	userpg->data_size = perf_data_size(rb);
 
 unlock:
 	rcu_read_unlock();
-- 
2.1.0

