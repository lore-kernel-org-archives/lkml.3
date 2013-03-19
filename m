Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753326Ab3CSLkw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 07:40:52 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45613 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752058Ab3CSLku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 07:40:50 -0400
Date: Tue, 19 Mar 2013 04:39:29 -0700
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-80bbe9f273a38f83ecfc50fe384a57f8428887bd@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        linux-arm-kernel@lists.infradead.org, santosh.shilimkar@ti.com,
        john.stultz@linaro.org, arjan@infradead.org, liu.h.jason@gmail.com,
        tglx@linutronix.de, lorenzo.pieralisi@arm.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, santosh.shilimkar@ti.com,
        john.stultz@linaro.org, arjan@infradead.org, liu.h.jason@gmail.com,
        tglx@linutronix.de, lorenzo.pieralisi@arm.com
In-Reply-To: <20130306111537.640722922@linutronix.de>
References: <20130306111537.640722922@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] arm: Use tick broadcast expired check
Git-Commit-ID: 80bbe9f273a38f83ecfc50fe384a57f8428887bd
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 19 Mar 2013 04:39:35 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  80bbe9f273a38f83ecfc50fe384a57f8428887bd
Gitweb:     http://git.kernel.org/tip/80bbe9f273a38f83ecfc50fe384a57f8428887bd
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Wed, 6 Mar 2013 11:18:37 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 13 Mar 2013 11:39:40 +0100

arm: Use tick broadcast expired check

Avoid going back into deep idle if the tick broadcast IPI is about to
fire.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: LAK <linux-arm-kernel@lists.infradead.org>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Arjan van de Veen <arjan@infradead.org>
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Tested-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Jason Liu <liu.h.jason@gmail.com>
Link: http://lkml.kernel.org/r/20130306111537.640722922@linutronix.de

---
 arch/arm/kernel/process.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/arm/kernel/process.c b/arch/arm/kernel/process.c
index 047d3e4..db4ffd0 100644
--- a/arch/arm/kernel/process.c
+++ b/arch/arm/kernel/process.c
@@ -199,7 +199,16 @@ void cpu_idle(void)
 #ifdef CONFIG_PL310_ERRATA_769419
 			wmb();
 #endif
-			if (hlt_counter) {
+			/*
+			 * In poll mode we reenable interrupts and spin.
+			 *
+			 * Also if we detected in the wakeup from idle
+			 * path that the tick broadcast device expired
+			 * for us, we don't want to go deep idle as we
+			 * know that the IPI is going to arrive right
+			 * away
+			 */
+			if (hlt_counter || tick_check_broadcast_expired()) {
 				local_irq_enable();
 				cpu_relax();
 			} else if (!need_resched()) {
