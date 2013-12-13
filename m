Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753651Ab3LMW0o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 17:26:44 -0500
Received: from mail-pd0-f173.google.com ([209.85.192.173]:60272 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753582Ab3LMW0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 17:26:41 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Jesse Barker <jesse.barker@arm.com>, Colin Cross <ccross@android.com>,
        Laura Abbott <lauraa@codeaurora.org>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 023/115] gpu: ion: Don't call ion_buffer_put on error path
Date: Fri, 13 Dec 2013 14:23:57 -0800
Message-Id: <1386973529-4884-24-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
References: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Laura Abbott <lauraa@codeaurora.org>

If dma_buf_fd fails, the dma_buf needs to be cleaned up by
calling dma_buf_put. dma_buf_put will call ion_dma_buf_release
which in turn calls ion_buffer_put to clean up the buffer
reference. Calling ion_buffer_put after dma_buf_put drops the
reference count by one more which is incorrect. Fix this by
getting rid of the extra ion_buffer_put call.

Signed-off-by: Laura Abbott <lauraa@codeaurora.org>
[jstultz: modified patch to apply to staging directory]
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/ion/ion.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/android/ion/ion.c b/drivers/staging/android/ion/ion.c
index a054edd..4d91d20 100644
--- a/drivers/staging/android/ion/ion.c
+++ b/drivers/staging/android/ion/ion.c
@@ -925,10 +925,9 @@ int ion_share_dma_buf(struct ion_client *client, struct ion_handle *handle)
 		return PTR_ERR(dmabuf);
 	}
 	fd = dma_buf_fd(dmabuf, O_CLOEXEC);
-	if (fd < 0) {
+	if (fd < 0)
 		dma_buf_put(dmabuf);
-		ion_buffer_put(buffer);
-	}
+
 	return fd;
 }
 EXPORT_SYMBOL(ion_share_dma_buf);
-- 
1.8.3.2

