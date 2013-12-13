Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754272Ab3LMW22 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 17:28:28 -0500
Received: from mail-pd0-f173.google.com ([209.85.192.173]:45585 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754103Ab3LMW2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 17:28:22 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Jesse Barker <jesse.barker@arm.com>, Colin Cross <ccross@android.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 086/115] ion: fix crash when alloc len is -1
Date: Fri, 13 Dec 2013 14:25:00 -0800
Message-Id: <1386973529-4884-87-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
References: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Colin Cross <ccross@android.com>

If userspace passes a length between -4095 and -1 to allocate it
will pass the len != 0 check, but when len is page aligned it will
be 0.  Check len after page aligning.

Drop the warning as well, userspace shouldn't be able to trigger
a warning in the kernel.

Signed-off-by: Colin Cross <ccross@android.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/ion/ion.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/android/ion/ion.c b/drivers/staging/android/ion/ion.c
index cf9fc78..2e7be70 100644
--- a/drivers/staging/android/ion/ion.c
+++ b/drivers/staging/android/ion/ion.c
@@ -485,11 +485,11 @@ struct ion_handle *ion_alloc(struct ion_client *client, size_t len,
 	 * request of the caller allocate from it.  Repeat until allocate has
 	 * succeeded or all heaps have been tried
 	 */
-	if (WARN_ON(!len))
-		return ERR_PTR(-EINVAL);
-
 	len = PAGE_ALIGN(len);
 
+	if (!len)
+		return ERR_PTR(-EINVAL);
+
 	down_read(&dev->lock);
 	plist_for_each_entry(heap, &dev->heaps, node) {
 		/* if the caller didn't specify this heap id */
-- 
1.8.3.2

