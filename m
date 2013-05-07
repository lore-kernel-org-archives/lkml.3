Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754587Ab3EGOco (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 10:32:44 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56281 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753857Ab3EGOcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 10:32:39 -0400
Date: Tue, 7 May 2013 07:32:16 -0700
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-97a5b81fa4d3a11dcdf224befc577f2e0abadc0b@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        markus@trippelsdorf.de, tglx@linutronix.de, bp@alien8.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        markus@trippelsdorf.de, tglx@linutronix.de, bp@alien8.de
In-Reply-To: <alpine.LFD.2.02.1305021557030.3972@ionos>
References: <alpine.LFD.2.02.1305021557030.3972@ionos>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: Fix idle consolidation fallout
Git-Commit-ID: 97a5b81fa4d3a11dcdf224befc577f2e0abadc0b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  97a5b81fa4d3a11dcdf224befc577f2e0abadc0b
Gitweb:     http://git.kernel.org/tip/97a5b81fa4d3a11dcdf224befc577f2e0abadc0b
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Thu, 2 May 2013 16:21:15 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 7 May 2013 16:24:03 +0200

x86: Fix idle consolidation fallout

The core code expects the arch idle code to return with interrupts
enabled. The conversion missed two x86 cases which fail to do that.

Reported-and-tested-by: Markus Trippelsdorf <markus@trippelsdorf.de>
Tested-by: Borislav Petkov <bp@alien8.de>
Link: http://lkml.kernel.org/r/alpine.LFD.2.02.1305021557030.3972@ionos
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/process.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 607af0d..4e7a37f 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -312,6 +312,8 @@ void arch_cpu_idle(void)
 {
 	if (cpuidle_idle_call())
 		x86_idle();
+	else
+		local_irq_enable();
 }
 
 /*
@@ -368,9 +370,6 @@ void amd_e400_remove_cpu(int cpu)
  */
 static void amd_e400_idle(void)
 {
-	if (need_resched())
-		return;
-
 	if (!amd_e400_c1e_detected) {
 		u32 lo, hi;
 
