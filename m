Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423096Ab3FUOWA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 10:22:00 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:37905 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423023Ab3FUOV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 10:21:56 -0400
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, ak@linux.intel.com, acme@redhat.com,
        jolsa@redhat.com, namhyung.kim@lge.com
Subject: [PATCH 4/8] perf: add PERF_SAMPLE_PHYS_ADDR sample type
Date: Fri, 21 Jun 2013 16:20:44 +0200
Message-Id: <1371824448-7306-5-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1371824448-7306-1-git-send-email-eranian@google.com>
References: <1371824448-7306-1-git-send-email-eranian@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the ability to sample physical data addresses.
Useful when used in combination with PERF_SAMPLE_ADDR
and memory access sampling. Physical address help
disambiguate sharing between processes.

Signed-off-by: Stephane Eranian <eranian@google.com>
---
 include/linux/perf_event.h      | 2 ++
 include/uapi/linux/perf_event.h | 3 ++-
 kernel/events/core.c            | 6 ++++++
 3 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 535d89c..4fe89e1 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -570,6 +570,7 @@ struct perf_sample_data {
 	}				tid_entry;
 	u64				time;
 	u64				addr;
+	u64				phys_addr;
 	u64				id;
 	u64				stream_id;
 	struct {
@@ -599,6 +600,7 @@ static inline void perf_sample_data_init(struct perf_sample_data *data,
 	data->stack_user_size = 0;
 	data->weight = 0;
 	data->data_src.val = 0;
+	data->phys_addr = 0;
 }
 
 extern void perf_output_sample(struct perf_output_handle *handle,
diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
index 0b1df41..a1b4fad 100644
--- a/include/uapi/linux/perf_event.h
+++ b/include/uapi/linux/perf_event.h
@@ -134,8 +134,9 @@ enum perf_event_sample_format {
 	PERF_SAMPLE_STACK_USER			= 1U << 13,
 	PERF_SAMPLE_WEIGHT			= 1U << 14,
 	PERF_SAMPLE_DATA_SRC			= 1U << 15,
+	PERF_SAMPLE_PHYS_ADDR			= 1U << 16,
 
-	PERF_SAMPLE_MAX = 1U << 16,		/* non-ABI */
+	PERF_SAMPLE_MAX = 1U << 17,		/* non-ABI */
 };
 
 /*
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 9c89207..294b439 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -1104,6 +1104,9 @@ static void perf_event__header_size(struct perf_event *event)
 	if (sample_type & PERF_SAMPLE_DATA_SRC)
 		size += sizeof(data->data_src.val);
 
+	if (sample_type & PERF_SAMPLE_PHYS_ADDR)
+		size += sizeof(data->phys_addr);
+
 	event->header_size = size;
 }
 
@@ -4415,6 +4418,9 @@ void perf_output_sample(struct perf_output_handle *handle,
 
 	if (sample_type & PERF_SAMPLE_DATA_SRC)
 		perf_output_put(handle, data->data_src.val);
+
+	if (sample_type & PERF_SAMPLE_PHYS_ADDR)
+		perf_output_put(handle, data->phys_addr);
 }
 
 void perf_prepare_sample(struct perf_event_header *header,
-- 
1.8.1.2

