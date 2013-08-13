Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932513Ab3HMNg5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 09:36:57 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:9071 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932463Ab3HMNgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 09:36:53 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 13 Aug 2013 06:36:53 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <tglx@linutronix.de>
CC: <linux-kernel@vger.kernel.org>, <swarren@nvidia.com>, <rjw@sisk.pl>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH V2] irq: enable all irqs unconditionally in irq_resume
Date: Tue, 13 Aug 2013 19:20:56 +0530
Message-ID: <1376401856-29605-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When system enters into suspend, it disable all irqs in single
function call. This disables EARLY_RESUME irqs also along with
normal irqs.

The EARLY_RESUME irqs get enabled in sys_core_ops->resume and
non-EARLY_RESUME irqs get enabled in normal system resume path.

When suspend_noirq failed or suspend is aborted for any reason,
the EARLY_RESUME irqs do not get enabled as sys_core_ops->resume()
call did not happen. It only enables the non-EARLY_RESUME irqs in normal
disable for remaining life of system.

Enable all irqs unconditionally in normal irq_resume() regardless of
EARLY_RESUME irqs have been already enabled or not.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
Acked-by-and-tested-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
Creating this patch based on disucssion on patch
 [PATCH] irq: enable suspended EARLY_RESUME irqs forcefully if not resumed

Making simple change as susggested by Thomas.


 kernel/irq/pm.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/irq/pm.c b/kernel/irq/pm.c
index cb228bf..abcd6ca 100644
--- a/kernel/irq/pm.c
+++ b/kernel/irq/pm.c
@@ -50,7 +50,7 @@ static void resume_irqs(bool want_early)
 		bool is_early = desc->action &&
 			desc->action->flags & IRQF_EARLY_RESUME;
 
-		if (is_early != want_early)
+		if (!is_early && want_early)
 			continue;
 
 		raw_spin_lock_irqsave(&desc->lock, flags);
-- 
1.7.1.1

