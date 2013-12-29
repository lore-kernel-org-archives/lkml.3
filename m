Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755678Ab3L2Cf5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 21:35:57 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55391 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752705Ab3L2CKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 21:10:44 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "" <ian.campbell@citrix.com>,
        "Thomas Gleixner" <tglx@linutronix.de>, "Pavel Machek" <pavel@ucw.cz>,
        "" <gregkh@linuxfoundation.org>, "" <len.brown@intel.com>,
        "Heiko Stuebner" <heiko@sntech.de>, "" <rjw@rjwysocki.net>,
        "Laxman Dewangan" <ldewangan@nvidia.com>
Date: Sun, 29 Dec 2013 03:08:44 +0100
Message-ID: <lsq.1388282924.763420580@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 097/185] irq: Enable all irqs unconditionally in
 irq_resume
In-Reply-To: <lsq.1388282923.751256928@decadent.org.uk>
X-SA-Exim-Connect-IP: 31.18.200.85
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.54-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/irq/pm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/irq/pm.c
+++ b/kernel/irq/pm.c
@@ -50,7 +50,7 @@ static void resume_irqs(bool want_early)
 		bool is_early = desc->action &&
 			desc->action->flags & IRQF_EARLY_RESUME;
 
-		if (is_early != want_early)
+		if (!is_early && want_early)
 			continue;
 
 		raw_spin_lock_irqsave(&desc->lock, flags);

