Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754290Ab3LMWga (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 17:36:30 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:58367 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753930Ab3LMW1o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 17:27:44 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Jesse Barker <jesse.barker@arm.com>, Colin Cross <ccross@android.com>,
        JP Abgrall <jpa@google.com>, John Stultz <john.stultz@linaro.org>
Subject: [PATCH 062/115] gpu: ion: fix kfree/list_del order
Date: Fri, 13 Dec 2013 14:24:36 -0800
Message-Id: <1386973529-4884-63-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
References: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: JP Abgrall <jpa@google.com>

With CONFIG_SLUB_DEBUG_ON it would panic during
ion_alloc()
 ion_buffer_create()
   io_heap_drain_freelist()

Signed-off-by: JP Abgrall <jpa@google.com>
[jstultz: modified patch to apply to staging directory]
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/ion/ion.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/android/ion/ion.c b/drivers/staging/android/ion/ion.c
index b965f15..b2dcee5 100644
--- a/drivers/staging/android/ion/ion.c
+++ b/drivers/staging/android/ion/ion.c
@@ -1342,8 +1342,8 @@ static bool ion_heap_drain_freelist(struct ion_heap *heap)
 		return false;
 	rt_mutex_lock(&heap->lock);
 	list_for_each_entry_safe(buffer, tmp, &heap->free_list, list) {
-		_ion_buffer_destroy(buffer);
 		list_del(&buffer->list);
+		_ion_buffer_destroy(buffer);
 	}
 	BUG_ON(!list_empty(&heap->free_list));
 	rt_mutex_unlock(&heap->lock);
-- 
1.8.3.2

