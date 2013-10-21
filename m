Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751518Ab3JUQ6T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 12:58:19 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:48653 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751025Ab3JUQ6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 12:58:17 -0400
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Greg KH <gregkh@linuxfoundation.org>,
        Colin Cross <ccross@android.com>,
        Android Kernel Team <kernel-team@android.com>,
        Dave Chinner <dchinner@redhat.com>, Glauber Costa <glommer@openvz.org>
Subject: [PATCH] staging: ashmem: Fix ASHMEM_PURGE_ALL_CACHES return value
Date: Mon, 21 Oct 2013 09:58:07 -0700
Message-Id: <1382374687-4831-1-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hopefully this isn't too late for 3.12.

In commit 7dc19d5aff (convert shrinkers to new count/scan API)
the return value to PURGE_ALL_CACHES was dropped, causing -EPERM
to always be returned.

This patch re-adds the ret assignment, setting it to the the
ashmem_shrink_count(), which is the lru_count.

(Sorry this was missed in the review!)

Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: Colin Cross <ccross@android.com>
Cc: Android Kernel Team <kernel-team@android.com>
Cc: Dave Chinner <dchinner@redhat.com>
Cc: Glauber Costa <glommer@openvz.org>
Reported-by: YongQin Liu <yongqin.liu@linaro.org>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/ashmem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/android/ashmem.c b/drivers/staging/android/ashmem.c
index 8e76ddc..5a5e9c9 100644
--- a/drivers/staging/android/ashmem.c
+++ b/drivers/staging/android/ashmem.c
@@ -706,7 +706,7 @@ static long ashmem_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 				.gfp_mask = GFP_KERNEL,
 				.nr_to_scan = LONG_MAX,
 			};
-
+			ret = ashmem_shrink_count(&ashmem_shrinker, &sc);
 			nodes_setall(sc.nodes_to_scan);
 			ashmem_shrink_scan(&ashmem_shrinker, &sc);
 		}
-- 
1.8.1.2

