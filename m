Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754354AbaF1AEu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 20:04:50 -0400
Received: from mail-qc0-f201.google.com ([209.85.216.201]:58137 "EHLO
	mail-qc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754276AbaF1AEs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 20:04:48 -0400
From: Derek Basehore <dbasehore@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: linux-pm@vger.kernel.org, Laxman Dewangan <ldewangan@nvidia.com>,
        Ian Campbell <ian.campbell@citrix.com>, xen-devel@lists.xenproject.org,
        Derek Basehore <dbasehore@chromium.org>
Subject: [PATCH v1 2/2] Revert "irq: Enable all irqs unconditionally in irq_resume"
Date: Fri, 27 Jun 2014 17:04:25 -0700
Message-Id: <1403913865-31614-2-git-send-email-dbasehore@chromium.org>
X-Mailer: git-send-email 2.0.0.526.g5318336
In-Reply-To: <1403913865-31614-1-git-send-email-dbasehore@chromium.org>
References: <1403913865-31614-1-git-send-email-dbasehore@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts the fix to IRQF_EARLY_RESUME irqs staying disabled after a suspend
failure. It incorrectly stated that Xen is the only platform that uses this
feature. Some rtc drivers such as rtc-as3722.c use the feature and can have its
irq permanently enabled with the change. The driver does disable/enable the irq
for the rtc alarm, so it needs a different fix which is in "genirq: Fix error
path for resuming irqs"

We should also keep correct enable/disable parity for irqs.

This reverts commit ac01810c9d2814238f08a227062e66a35a0e1ea2.

Signed-off-by: Derek Basehore <dbasehore@chromium.org>
---
 kernel/irq/pm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/irq/pm.c b/kernel/irq/pm.c
index b07dc9c..a5eaf1f 100644
--- a/kernel/irq/pm.c
+++ b/kernel/irq/pm.c
@@ -50,7 +50,7 @@ static void resume_irqs(bool want_early)
 		bool is_early = desc->action &&
 			desc->action->flags & IRQF_EARLY_RESUME;
 
-		if (!is_early && want_early)
+		if (is_early != want_early)
 			continue;
 
 		raw_spin_lock_irqsave(&desc->lock, flags);
-- 
2.0.0.526.g5318336

