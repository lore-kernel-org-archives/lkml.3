Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753066Ab3KYV2m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 16:28:42 -0500
Received: from terminus.zytor.com ([198.137.202.10]:46086 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751887Ab3KYV2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 16:28:39 -0500
Date: Mon, 25 Nov 2013 13:28:02 -0800
From: tip-bot for Laxman Dewangan <tipbot@zytor.com>
Message-ID: <tip-ac01810c9d2814238f08a227062e66a35a0e1ea2@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, heiko@sntech.de, hpa@zytor.com,
        mingo@kernel.org, konrad.wilk@oracle.com, ian.campbell@citrix.com,
        pavel@ucw.cz, gregkh@linuxfoundation.org, ldewangan@nvidia.com,
        rjw@rjwysocki.net, tglx@linutronix.de, len.brown@intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, heiko@sntech.de,
        linux-kernel@vger.kernel.org, konrad.wilk@oracle.com,
        ian.campbell@citrix.com, pavel@ucw.cz, gregkh@linuxfoundation.org,
        ldewangan@nvidia.com, tglx@linutronix.de, rjw@rjwysocki.net,
        len.brown@intel.com
In-Reply-To: <1385388587-16442-1-git-send-email-ldewangan@nvidia.com>
References: <1385388587-16442-1-git-send-email-ldewangan@nvidia.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/urgent] irq:
  Enable all irqs unconditionally in irq_resume
Git-Commit-ID: ac01810c9d2814238f08a227062e66a35a0e1ea2
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 25 Nov 2013 13:28:09 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ac01810c9d2814238f08a227062e66a35a0e1ea2
Gitweb:     http://git.kernel.org/tip/ac01810c9d2814238f08a227062e66a35a0e1ea2
Author:     Laxman Dewangan <ldewangan@nvidia.com>
AuthorDate: Mon, 25 Nov 2013 19:39:47 +0530
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 25 Nov 2013 22:20:02 +0100

irq: Enable all irqs unconditionally in irq_resume

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
Cc: stable@vger.kernel.org
Link: http://lkml.kernel.org/r/1385388587-16442-1-git-send-email-ldewangan@nvidia.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
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
