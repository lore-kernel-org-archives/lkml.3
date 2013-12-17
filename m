Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751485Ab3LQFII (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 00:08:08 -0500
Received: from mail-pb0-f51.google.com ([209.85.160.51]:45841 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113Ab3LQFID (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 00:08:03 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Colin Cross <ccross@android.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        kbuild test robot <fengguang.wu@intel.com>
Subject: [PATCH 2/3] staging: ion: Fix possible null pointer dereference
Date: Mon, 16 Dec 2013 21:07:52 -0800
Message-Id: <1387256873-21350-3-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387256873-21350-1-git-send-email-john.stultz@linaro.org>
References: <1387256873-21350-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kbuild test robot reported:

drivers/staging/android/ion/ion_system_heap.c:122 alloc_largest_available() error: potential null dereference 'info'.  (kmalloc returns null)

Where the pointer returned from kmalloc goes unchecked for failure.

This patch checks the return for NULL, and reworks the logic, as
suggested by Colin, so we allocate the page_info structure first.

Cc: Colin Cross <ccross@android.com>
Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: Android Kernel Team <kernel-team@android.com>
Cc: kbuild test robot <fengguang.wu@intel.com>
Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/ion/ion_system_heap.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/android/ion/ion_system_heap.c b/drivers/staging/android/ion/ion_system_heap.c
index 144b2272..7f07291 100644
--- a/drivers/staging/android/ion/ion_system_heap.c
+++ b/drivers/staging/android/ion/ion_system_heap.c
@@ -108,6 +108,10 @@ static struct page_info *alloc_largest_available(struct ion_system_heap *heap,
 	struct page_info *info;
 	int i;
 
+	info = kmalloc(sizeof(struct page_info), GFP_KERNEL);
+	if (!info)
+		return NULL;
+
 	for (i = 0; i < num_orders; i++) {
 		if (size < order_to_size(orders[i]))
 			continue;
@@ -118,11 +122,12 @@ static struct page_info *alloc_largest_available(struct ion_system_heap *heap,
 		if (!page)
 			continue;
 
-		info = kmalloc(sizeof(struct page_info), GFP_KERNEL);
 		info->page = page;
 		info->order = orders[i];
 		return info;
 	}
+	kfree(info);
+
 	return NULL;
 }
 
-- 
1.8.3.2

