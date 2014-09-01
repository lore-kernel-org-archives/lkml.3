Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753796AbaIAMrm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 08:47:42 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:45512 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753417AbaIAMrk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 08:47:40 -0400
Message-ID: <54046AE7.6060805@canonical.com>
Date: Mon, 01 Sep 2014 14:47:35 +0200
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Sumit Semwal <sumit.semwal@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
        LKML <linux-kernel@vger.kernel.org>
CC: Daniel Vetter <daniel.vetter@ffwll.ch>, Colin Cross <ccross@google.com>,
        John Stultz <john.stultz@linaro.org>, devel@driverdev.osuosl.org,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH] android: fix reference leak in sync_fence_create
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to the documentation sync_fence_create takes ownership of the point,
not a reference on the point.

This fixes a memory leak introduced in 3.17's android fence rework.

Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: Colin Cross <ccross@google.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/staging/android/sync.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/android/sync.c b/drivers/staging/android/sync.c
index e7b2e0234196..69139ce7420d 100644
--- a/drivers/staging/android/sync.c
+++ b/drivers/staging/android/sync.c
@@ -199,7 +199,6 @@ struct sync_fence *sync_fence_create(const char *name, struct sync_pt *pt)
 	fence->num_fences = 1;
 	atomic_set(&fence->status, 1);
 
-	fence_get(&pt->base);
 	fence->cbs[0].sync_pt = &pt->base;
 	fence->cbs[0].fence = fence;
 	if (fence_add_callback(&pt->base, &fence->cbs[0].cb,
-- 
2.0.4


