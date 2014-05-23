Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751792AbaEWAv7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 20:51:59 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:48413 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750959AbaEWAv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 20:51:58 -0400
From: Mitchel Humpherys <mitchelh@codeaurora.org>
To: linux-mm@kvack.org, Colin Cross <ccross@android.com>,
        John Stultz <john.stultz@linaro.org>
Cc: Android Kernel Team <kernel-team@android.com>,
        linux-kernel@vger.kernel.org,
        Mitchel Humpherys <mitchelh@codeaurora.org>
Subject: [PATCH] staging: ion: WARN when the handle kmap_cnt is going to wrap around
Date: Thu, 22 May 2014 17:51:21 -0700
Message-Id: <1400806281-32716-1-git-send-email-mitchelh@codeaurora.org>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are certain client bugs (double unmap, for example) that can cause
the handle->kmap_cnt (an unsigned int) to wrap around from zero. This
causes problems when the handle is destroyed because we have:

        while (handle->kmap_cnt)
                ion_handle_kmap_put(handle);

which takes a long time to complete when kmap_cnt starts at ~0 and can
result in a watchdog timeout.

WARN and bail when kmap_cnt is about to wrap around from zero.

Signed-off-by: Mitchel Humpherys <mitchelh@codeaurora.org>
---
 drivers/staging/android/ion/ion.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/staging/android/ion/ion.c b/drivers/staging/android/ion/ion.c
index 3d5bf14722..f55f61a4cc 100644
--- a/drivers/staging/android/ion/ion.c
+++ b/drivers/staging/android/ion/ion.c
@@ -626,6 +626,10 @@ static void ion_handle_kmap_put(struct ion_handle *handle)
 {
 	struct ion_buffer *buffer = handle->buffer;
 
+	if (!handle->kmap_cnt) {
+		WARN(1, "%s: Double unmap detected! bailing...\n", __func__);
+		return;
+	}
 	handle->kmap_cnt--;
 	if (!handle->kmap_cnt)
 		ion_buffer_kmap_put(buffer);
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

