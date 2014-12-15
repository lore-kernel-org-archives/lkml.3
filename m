Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751665AbaLOTfQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 14:35:16 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41058 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751055AbaLOTeK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 14:34:10 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Anton Vorontsov <anton.vorontsov@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 78/96] mm/vmpressure.c: fix race in vmpressure_work_fn()
Date: Mon, 15 Dec 2014 11:26:38 -0800
Message-Id: <1418671616-25482-79-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1418671616-25482-1-git-send-email-kamal@canonical.com>
References: <1418671616-25482-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrew Morton <akpm@linux-foundation.org>

commit 91b57191cfd152c02ded0745250167d0263084f8 upstream.

In some android devices, there will be a "divide by zero" exception.
vmpr->scanned could be zero before spin_lock(&vmpr->sr_lock).

Addresses https://bugzilla.kernel.org/show_bug.cgi?id=88051

[akpm@linux-foundation.org: neaten]
Reported-by: ji_ang <ji_ang@163.com>
Cc: Anton Vorontsov <anton.vorontsov@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 mm/vmpressure.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/mm/vmpressure.c b/mm/vmpressure.c
index e0f6283..c98b14e 100644
--- a/mm/vmpressure.c
+++ b/mm/vmpressure.c
@@ -164,6 +164,7 @@ static void vmpressure_work_fn(struct work_struct *work)
 	unsigned long scanned;
 	unsigned long reclaimed;
 
+	spin_lock(&vmpr->sr_lock);
 	/*
 	 * Several contexts might be calling vmpressure(), so it is
 	 * possible that the work was rescheduled again before the old
@@ -172,11 +173,12 @@ static void vmpressure_work_fn(struct work_struct *work)
 	 * here. No need for any locks here since we don't care if
 	 * vmpr->reclaimed is in sync.
 	 */
-	if (!vmpr->scanned)
+	scanned = vmpr->scanned;
+	if (!scanned) {
+		spin_unlock(&vmpr->sr_lock);
 		return;
+	}
 
-	spin_lock(&vmpr->sr_lock);
-	scanned = vmpr->scanned;
 	reclaimed = vmpr->reclaimed;
 	vmpr->scanned = 0;
 	vmpr->reclaimed = 0;
-- 
1.9.1

