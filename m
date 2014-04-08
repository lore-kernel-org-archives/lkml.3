Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757333AbaDHWaz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 18:30:55 -0400
Received: from mail-ig0-f169.google.com ([209.85.213.169]:45825 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756210AbaDHWax (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 18:30:53 -0400
From: Alex Elder <elder@linaro.org>
To: viresh.linux@gmail.com, shiraz.hashim@gmail.com
Cc: spear-devel@list.st.com, vk.vipin@gmail.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [RFC PATCH RESEND] ARM: spear: send SGI to trigger secondary CPU start
Date: Tue,  8 Apr 2014 17:31:28 -0500
Message-Id: <1396996288-32020-1-git-send-email-elder@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ARM spear machine uses the "holding pen" mechanism for starting
secondary CPUs.  Most implementations indicate it's a secondary
core's time to start by writing its CPU id into a location and
then signaling the core with a software-generated interrupt.

The spear code does not send the signal.  Comments elsewhere
in the code seem to indicate it should:
    The BootMonitor waits until it receives a soft interrupt, and
    then the secondary CPU branches to this address.

I suspect this is an oversight, and this patch proposes a remedy.

  *** I need the attention of a maintainer to verify this
  *** because I am unable to test this proposed change.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 arch/arm/mach-spear/platsmp.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/mach-spear/platsmp.c b/arch/arm/mach-spear/platsmp.c
index 5c4a198..c9064fe 100644
--- a/arch/arm/mach-spear/platsmp.c
+++ b/arch/arm/mach-spear/platsmp.c
@@ -62,6 +62,8 @@ static int spear13xx_boot_secondary(unsigned int cpu, struct task_struct *idle)
 	flush_cache_all();
 	outer_flush_all();
 
+	arch_send_wakeup_ipi_mask(cpumask_of(cpu));
+
 	timeout = jiffies + (1 * HZ);
 	while (time_before(jiffies, timeout)) {
 		smp_rmb();
-- 
1.7.9.5

