Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757275AbaAFXDb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 18:03:31 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:48520 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933193AbaAFWl4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 17:41:56 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Kirill Tkhai <tkhai@yandex.ru>, Mark Brown <broonie@kernel.org>
Subject: [PATCH 3.10 119/129] arm64: Only enable local interrupts after the CPU is marked online
Date: Mon,  6 Jan 2014 14:39:08 -0800
Message-Id: <20140106223903.000103029@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140106223859.589799655@linuxfoundation.org>
References: <20140106223859.589799655@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Catalin Marinas <catalin.marinas@arm.com>

commit 53ae3acd4390ffeecb3a11dbd5be347b5a3d98f2 upstream.

There is a slight chance that (timer) interrupts are triggered before a
secondary CPU has been marked online with implications on softirq thread
affinity.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Reported-by: Kirill Tkhai <tkhai@yandex.ru>
Cc: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/kernel/smp.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

--- a/arch/arm64/kernel/smp.c
+++ b/arch/arm64/kernel/smp.c
@@ -200,13 +200,6 @@ asmlinkage void __cpuinit secondary_star
 	raw_spin_unlock(&boot_lock);
 
 	/*
-	 * Enable local interrupts.
-	 */
-	notify_cpu_starting(cpu);
-	local_irq_enable();
-	local_fiq_enable();
-
-	/*
 	 * OK, now it's safe to let the boot CPU continue.  Wait for
 	 * the CPU migration code to notice that the CPU is online
 	 * before we continue.
@@ -215,6 +208,14 @@ asmlinkage void __cpuinit secondary_star
 	complete(&cpu_running);
 
 	/*
+	 * Enable GIC and timers.
+	 */
+	notify_cpu_starting(cpu);
+
+	local_irq_enable();
+	local_fiq_enable();
+
+	/*
 	 * OK, it's off to the idle thread for us
 	 */
 	cpu_startup_entry(CPUHP_ONLINE);


