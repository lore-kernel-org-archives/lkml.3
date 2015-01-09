Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757553AbbAIKcb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 05:32:31 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44483 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751726AbbAIKc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 05:32:28 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 17/78] mm/vmpressure.c: fix race in vmpressure_work_fn()
Date: Fri,  9 Jan 2015 11:31:26 +0100
Message-Id: <5a40e10cc3479a28bac0d4ca3134df7052cb46df.1420799385.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <72002f1f248c28d1715d10454190e209d5a20fe1.1420799385.git.jslaby@suse.cz>
References: <72002f1f248c28d1715d10454190e209d5a20fe1.1420799385.git.jslaby@suse.cz>
In-Reply-To: <cover.1420799385.git.jslaby@suse.cz>
References: <cover.1420799385.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 91b57191cfd152c02ded0745250167d0263084f8 upstream.

In some android devices, there will be a "divide by zero" exception.
vmpr->scanned could be zero before spin_lock(&vmpr->sr_lock).

Addresses https://bugzilla.kernel.org/show_bug.cgi?id=88051

[akpm@linux-foundation.org: neaten]
Reported-by: ji_ang <ji_ang@163.com>
Cc: Anton Vorontsov <anton.vorontsov@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 mm/vmpressure.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/mm/vmpressure.c b/mm/vmpressure.c
index e0f62837c3f4..c98b14ee69d6 100644
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
2.2.1

