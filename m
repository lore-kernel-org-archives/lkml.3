Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758082Ab3APDB3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 22:01:29 -0500
Received: from mail.windriver.com ([147.11.1.11]:43917 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757654Ab3APDB1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 22:01:27 -0500
From: Tiejun Chen <tiejun.chen@windriver.com>
To: <benh@kernel.crashing.org>, <galak@kernel.crashing.org>
CC: <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>
Subject: [v1][PATCH 1/1] ppc64: max next_tb to prevent from replaying timer interrupt
Date: Wed, 16 Jan 2013 11:01:19 +0800
Message-ID: <1358305279-19068-1-git-send-email-tiejun.chen@windriver.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With lazy interrupt, we always call __check_irq_replaysome with
decrementers_next_tb to check if we need to replay timer interrupt.
So in hotplug case we also need to set decrementers_next_tb as MAX
to make sure __check_irq_replay don't replay timer interrupt
when return as we expect, otherwise we'll trap here infinitely.

Signed-off-by: Tiejun Chen <tiejun.chen@windriver.com>
---
v1:

* In hotplug case we max decrementers_next_tb to prevent from
replaying timer interrupt for any offline CPU.

 arch/powerpc/kernel/time.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kernel/time.c b/arch/powerpc/kernel/time.c
index 6f6b1cc..127361e 100644
--- a/arch/powerpc/kernel/time.c
+++ b/arch/powerpc/kernel/time.c
@@ -494,10 +494,15 @@ void timer_interrupt(struct pt_regs * regs)
 	set_dec(DECREMENTER_MAX);
 
 	/* Some implementations of hotplug will get timer interrupts while
-	 * offline, just ignore these
+	 * offline, just ignore these and we also need to set
+	 * decrementers_next_tb as MAX to make sure __check_irq_replay
+	 * don't replay timer interrupt when return, otherwise we'll trap
+	 * here infinitely :(
 	 */
-	if (!cpu_online(smp_processor_id()))
+	if (!cpu_online(smp_processor_id())) {
+		*next_tb = ~(u64)0;
 		return;
+	}
 
 	/* Conditionally hard-enable interrupts now that the DEC has been
 	 * bumped to its maximum value
-- 
1.7.9.5

