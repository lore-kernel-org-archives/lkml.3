Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755006Ab3KKSDF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 13:03:05 -0500
Received: from mga09.intel.com ([134.134.136.24]:61731 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754885Ab3KKSC4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 13:02:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="406953384"
From: Andi Kleen <andi@firstfloor.org>
To: mingo@kernel.org
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        eranian@google.com, peterz@infradead.org
Subject: [PATCH] perf: Document perf event data padding
Date: Mon, 11 Nov 2013 10:02:49 -0800
Message-Id: <1384192969-2562-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

__output_copy always pads byte sized fields to a multiple
of u64. This was not documented in the perf_event.h documentation.
Explicitly mention this in the comments.

Also add notes that the strings are 0 terminated.

Only comments are changed.

Cc: eranian@google.com
Cc: peterz@infradead.org
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 include/uapi/linux/perf_event.h | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
index 2fc1602..06b2c8a 100644
--- a/include/uapi/linux/perf_event.h
+++ b/include/uapi/linux/perf_event.h
@@ -525,6 +525,7 @@ enum perf_event_type {
 	/*
 	 * The MMAP events record the PROT_EXEC mappings so that we can
 	 * correlate userspace IPs to code. They have the following structure:
+	 * filename is zero terminated and padded to 8 bytes.
 	 *
 	 * struct {
 	 *	struct perf_event_header	header;
@@ -533,7 +534,7 @@ enum perf_event_type {
 	 *	u64				addr;
 	 *	u64				len;
 	 *	u64				pgoff;
-	 *	char				filename[];
+	 *	char				filename[ALIGN(len, 8)];
 	 * 	struct sample_id		sample_id;
 	 * };
 	 */
@@ -549,12 +550,13 @@ enum perf_event_type {
 	 */
 	PERF_RECORD_LOST			= 2,
 
-	/*
+	/* comm is 0 terminated and padded to 8 bytes.
+	 *
 	 * struct {
 	 *	struct perf_event_header	header;
 	 *
 	 *	u32				pid, tid;
-	 *	char				comm[];
+	 *	char				comm[ALIGN(len, 8)];
 	 * 	struct sample_id		sample_id;
 	 * };
 	 */
@@ -637,12 +639,14 @@ enum perf_event_type {
 	 *	# the stability of its content, it may vary depending
 	 *	# on event, hardware, kernel version and phase of
 	 *	# the moon.
+	 * 	# 
+	 * 	# data[size] is padded to 8 bytes.
 	 *	#
 	 *	# In other words, PERF_SAMPLE_RAW contents are not an ABI.
 	 *	#
 	 *
 	 *	{ u32			size;
-	 *	  char                  data[size];}&& PERF_SAMPLE_RAW
+	 *	  char                  data[ALIGN(size, 8)];}&& PERF_SAMPLE_RAW
 	 *
 	 *	{ u64                   nr;
 	 *        { u64 from, to, flags } lbr[nr];} && PERF_SAMPLE_BRANCH_STACK
@@ -651,7 +655,7 @@ enum perf_event_type {
 	 * 	  u64			regs[weight(mask)]; } && PERF_SAMPLE_REGS_USER
 	 *
 	 * 	{ u64			size;
-	 * 	  char			data[size];
+	 * 	  char			data[ALIGN(size, 8)];
 	 * 	  u64			dyn_size; } && PERF_SAMPLE_STACK_USER
 	 *
 	 *	{ u64			weight;   } && PERF_SAMPLE_WEIGHT
@@ -663,6 +667,7 @@ enum perf_event_type {
 	/*
 	 * The MMAP2 records are an augmented version of MMAP, they add
 	 * maj, min, ino numbers to be used to uniquely identify each mapping
+	 * filename is 0 terminated and padded to 8 bytes.
 	 *
 	 * struct {
 	 *	struct perf_event_header	header;
@@ -675,7 +680,7 @@ enum perf_event_type {
 	 *	u32				min;
 	 *	u64				ino;
 	 *	u64				ino_generation;
-	 *	char				filename[];
+	 *	char				filename[ALIGN(len, 8)];
 	 * 	struct sample_id		sample_id;
 	 * };
 	 */
-- 
1.8.3.1

