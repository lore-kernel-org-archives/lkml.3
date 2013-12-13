Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753574Ab3LMW0e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 17:26:34 -0500
Received: from mail-pb0-f41.google.com ([209.85.160.41]:56586 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753397Ab3LMW02 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 17:26:28 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Jesse Barker <jesse.barker@arm.com>, Colin Cross <ccross@android.com>,
        Laura Abbott <lauraa@codeaurora.org>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 014/115] gpu: ion: Loop on the handle count when destroying
Date: Fri, 13 Dec 2013 14:23:48 -0800
Message-Id: <1386973529-4884-15-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
References: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Laura Abbott <lauraa@codeaurora.org>

When destroying a handle, all kernel mappings to that handle
should be destroyed. Other handles may still have references
and valid mappings to the buffer underneath which should not
be destroyed. Loop on the handle reference count, not the buffer
reference count to get rid of all kernel mappings for the handle.

Signed-off-by: Laura Abbott <lauraa@codeaurora.org>
[jstultz: modified patch to apply to staging directory]
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/ion/ion.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/android/ion/ion.c b/drivers/staging/android/ion/ion.c
index ddfe49a..dc7174d 100644
--- a/drivers/staging/android/ion/ion.c
+++ b/drivers/staging/android/ion/ion.c
@@ -232,7 +232,7 @@ static void ion_handle_destroy(struct kref *kref)
 	mutex_lock(&client->lock);
 
 	mutex_lock(&buffer->lock);
-	while (buffer->kmap_cnt)
+	while (handle->kmap_cnt)
 		ion_handle_kmap_put(handle);
 	mutex_unlock(&buffer->lock);
 
-- 
1.8.3.2

