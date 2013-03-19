Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753351Ab3CSLlz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 07:41:55 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45622 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752058Ab3CSLlx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 07:41:53 -0400
Date: Tue, 19 Mar 2013 04:40:40 -0700
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-35b61edb41ffee58711850e76215b852386ddb10@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, arjan@infradead.org, john.stultz@linaro.org,
        hpa@zytor.com, mingo@kernel.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, john.stultz@linaro.org,
        arjan@infradead.org, linux-kernel@vger.kernel.org, tglx@linutronix.de
In-Reply-To: <20130306111537.702278273@linutronix.de>
References: <20130306111537.702278273@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] x86: Use tick broadcast expired check
Git-Commit-ID: 35b61edb41ffee58711850e76215b852386ddb10
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 19 Mar 2013 04:40:47 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  35b61edb41ffee58711850e76215b852386ddb10
Gitweb:     http://git.kernel.org/tip/35b61edb41ffee58711850e76215b852386ddb10
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Wed, 6 Mar 2013 11:18:37 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 13 Mar 2013 11:39:40 +0100

x86: Use tick broadcast expired check

Avoid going back into deep idle if the tick broadcast IPI is about to
fire.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Arjan van de Veen <arjan@infradead.org>
Cc: x86@kernel.org
Link: http://lkml.kernel.org/r/20130306111537.702278273@linutronix.de
---
 arch/x86/kernel/process.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 14ae100..aa524da 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -336,6 +336,18 @@ void cpu_idle(void)
 			local_touch_nmi();
 			local_irq_disable();
 
+			/*
+			 * We detected in the wakeup path that the
+			 * tick broadcast device expired for us, but
+			 * we raced with the other CPU and came back
+			 * here before it was able to fire the IPI.
+			 * No point in going idle.
+			 */
+			if (tick_check_broadcast_expired()) {
+				local_irq_enable();
+				continue;
+			}
+
 			enter_idle();
 
 			/* Don't trace irqs off for idle */
