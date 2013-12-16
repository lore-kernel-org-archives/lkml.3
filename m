Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752954Ab3LPVc5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 16:32:57 -0500
Received: from mail-pd0-f179.google.com ([209.85.192.179]:63181 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752888Ab3LPVcz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 16:32:55 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Colin Cross <ccross@android.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        kbuild test robot <fengguang.wu@intel.com>
Subject: [RFC][PATCH 2/3] staging: ion: Fix possible null pointer dereference
Date: Mon, 16 Dec 2013 13:32:43 -0800
Message-Id: <1387229564-19517-3-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387229564-19517-1-git-send-email-john.stultz@linaro.org>
References: <1387229564-19517-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kbuild test robot reported:

drivers/staging/android/ion/ion_system_heap.c:122 alloc_largest_available() error: potential null dereference 'info'.  (kmalloc returns null)

Where the pointer returned from kmalloc goes unchecked for failure.

This patch adds a simple check for a null return, and handles the error.

XXX: Not sure if continue or 'return NULL' is the right thing to do.

Cc: Colin Cross <ccross@android.com>
Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: Android Kernel Team <kernel-team@android.com>
Cc: kbuild test robot <fengguang.wu@intel.com>
Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/ion/ion_system_heap.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/staging/android/ion/ion_system_heap.c b/drivers/staging/android/ion/ion_system_heap.c
index 144b2272..cc2e4da 100644
--- a/drivers/staging/android/ion/ion_system_heap.c
+++ b/drivers/staging/android/ion/ion_system_heap.c
@@ -119,6 +119,11 @@ static struct page_info *alloc_largest_available(struct ion_system_heap *heap,
 			continue;
 
 		info = kmalloc(sizeof(struct page_info), GFP_KERNEL);
+		if(!info) {
+			free_buffer_page(heap, buffer, page, orders[i]);
+			continue;
+		}
+
 		info->page = page;
 		info->order = orders[i];
 		return info;
-- 
1.8.3.2

