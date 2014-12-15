Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753594AbaLOOfA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 09:35:00 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38930 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753024AbaLOO3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 09:29:06 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Anton Vorontsov <anton.vorontsov@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 142/168] mm/vmpressure.c: fix race in vmpressure_work_fn()
Date: Mon, 15 Dec 2014 14:26:36 +0000
Message-Id: <1418653622-21105-143-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
References: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt3 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 mm/vmpressure.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/mm/vmpressure.c b/mm/vmpressure.c
index d4042e75f7c7..c5afd573d7da 100644
--- a/mm/vmpressure.c
+++ b/mm/vmpressure.c
@@ -165,6 +165,7 @@ static void vmpressure_work_fn(struct work_struct *work)
 	unsigned long scanned;
 	unsigned long reclaimed;
 
+	spin_lock(&vmpr->sr_lock);
 	/*
 	 * Several contexts might be calling vmpressure(), so it is
 	 * possible that the work was rescheduled again before the old
@@ -173,11 +174,12 @@ static void vmpressure_work_fn(struct work_struct *work)
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
2.1.3

