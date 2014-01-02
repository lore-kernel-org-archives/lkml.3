Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753452AbaABRJN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 12:09:13 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40425 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751988AbaABRJL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 12:09:11 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Laxman Dewangan <ldewangan@nvidia.com>, <ian.campbell@citrix.com>,
        <rjw@rjwysocki.net>, <len.brown@intel.com>,
        <gregkh@linuxfoundation.org>, Thomas Gleixner <tglx@linutronix.de>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 66/91] irq: Enable all irqs unconditionally in irq_resume
Date: Thu,  2 Jan 2014 09:04:41 -0800
Message-Id: <1388682306-30859-67-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1388682306-30859-1-git-send-email-kamal@canonical.com>
References: <1388682306-30859-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Laxman Dewangan <ldewangan@nvidia.com>

commit ac01810c9d2814238f08a227062e66a35a0e1ea2 upstream.

When the system enters suspend, it disables all interrupts in
suspend_device_irqs(), including the interrupts marked EARLY_RESUME.

On the resume side things are different. The EARLY_RESUME interrupts
are reenabled in sys_core_ops->resume and the non EARLY_RESUME
interrupts are reenabled in the normal system resume path.

When suspend_noirq() failed or suspend is aborted for any other
reason, we might omit the resume side call to sys_core_ops->resume()
and therefor the interrupts marked EARLY_RESUME are not reenabled and
stay disabled forever.

To solve this, enable all irqs unconditionally in irq_resume()
regardless whether interrupts marked EARLY_RESUMEhave been already
enabled or not.

This might try to reenable already enabled interrupts in the non
failure case, but the only affected platform is XEN and it has been
confirmed that it does not cause any side effects.

[ tglx: Massaged changelog. ]

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
Acked-by-and-tested-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Acked-by: Heiko Stuebner <heiko@sntech.de>
Reviewed-by: Pavel Machek <pavel@ucw.cz>
Cc: <ian.campbell@citrix.com>
Cc: <rjw@rjwysocki.net>
Cc: <len.brown@intel.com>
Cc: <gregkh@linuxfoundation.org>
Link: http://lkml.kernel.org/r/1385388587-16442-1-git-send-email-ldewangan@nvidia.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 kernel/irq/pm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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
1.8.3.2

