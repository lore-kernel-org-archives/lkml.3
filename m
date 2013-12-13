Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754297Ab3LMW2b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 17:28:31 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:53943 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754253Ab3LMW21 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 17:28:27 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Jesse Barker <jesse.barker@arm.com>, Colin Cross <ccross@android.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 089/115] ion: check invalid values in ion_system_heap
Date: Fri, 13 Dec 2013 14:25:03 -0800
Message-Id: <1386973529-4884-90-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
References: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Colin Cross <ccross@android.com>

ion_system_heap can only satisfy page alignment, and
ion_system_contig_heap can only satisify alignment to the
allocation size.  Neither can support faulting user mappings
because they use slab pages.

Signed-off-by: Colin Cross <ccross@android.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/ion/ion_system_heap.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/staging/android/ion/ion_system_heap.c b/drivers/staging/android/ion/ion_system_heap.c
index 967eedc..62a07ec 100644
--- a/drivers/staging/android/ion/ion_system_heap.c
+++ b/drivers/staging/android/ion/ion_system_heap.c
@@ -150,6 +150,12 @@ static int ion_system_heap_allocate(struct ion_heap *heap,
 	long size_remaining = PAGE_ALIGN(size);
 	unsigned int max_order = orders[0];
 
+	if (align > PAGE_SIZE)
+		return -EINVAL;
+
+	if (ion_buffer_fault_user_mappings(buffer))
+		return -EINVAL;
+
 	INIT_LIST_HEAD(&pages);
 	while (size_remaining > 0) {
 		info = alloc_largest_available(sys_heap, buffer, size_remaining, max_order);
@@ -362,6 +368,14 @@ static int ion_system_contig_heap_allocate(struct ion_heap *heap,
 					   unsigned long align,
 					   unsigned long flags)
 {
+	int order = get_order(len);
+
+	if (align > (PAGE_SIZE << order))
+		return -EINVAL;
+
+	if (ion_buffer_fault_user_mappings(buffer))
+		return -EINVAL;
+
 	buffer->priv_virt = kzalloc(len, GFP_KERNEL);
 	if (!buffer->priv_virt)
 		return -ENOMEM;
-- 
1.8.3.2

