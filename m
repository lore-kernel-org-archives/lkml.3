Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754686Ab3LMWky (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 17:40:54 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:37687 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753797Ab3LMW1V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 17:27:21 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Jesse Barker <jesse.barker@arm.com>, Colin Cross <ccross@android.com>,
        Rebecca Schultz Zavin <rebecca@android.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 046/115] gpu: ion: Fix bug in zeroing pages in system heap
Date: Fri, 13 Dec 2013 14:24:20 -0800
Message-Id: <1386973529-4884-47-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
References: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rebecca Schultz Zavin <rebecca@android.com>

Pages are zeroed for security purposes when returned to the
ion heap.  There was a bug in this code preventing this
from happening.

Bug: 7573871
Signed-off-by: Rebecca Schultz Zavin <rebecca@android.com>
[jstultz: modified patch to apply to staging directory]
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/ion/ion_system_heap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/android/ion/ion_system_heap.c b/drivers/staging/android/ion/ion_system_heap.c
index df08469..9327a32 100644
--- a/drivers/staging/android/ion/ion_system_heap.c
+++ b/drivers/staging/android/ion/ion_system_heap.c
@@ -103,7 +103,7 @@ static void free_buffer_page(struct ion_system_heap *heap,
 		   security.  This uses vmap as we want to set the pgprot so
 		   the writes to occur to noncached mappings, as the pool's
 		   purpose is to keep the pages out of the cache */
-		for (i = 0; i < order / PAGE_SIZE; i++) {
+		for (i = 0; i < (1 << order); i++) {
 			struct page *sub_page = page + i;
 			void *addr = vmap(&sub_page, 1, VM_MAP,
 					  pgprot_writecombine(PAGE_KERNEL));
-- 
1.8.3.2

