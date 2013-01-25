Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757294Ab3AYNht (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 08:37:49 -0500
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:29067 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751275Ab3AYNhr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 08:37:47 -0500
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+zrwiavkK6tmQaLfmztM8TOFGji0LFus=
X-RZG-CLASS-ID: mo00
From: Olaf Hering <olaf@aepfle.de>
To: linux-kernel@vger.kernel.org
Cc: Olaf Hering <olaf@aepfle.de>, stable@kernel.org,
        KY Srinivasan <kys@microsoft.com>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: [PATCH] x86: Hyper-V: register clocksource only if its advertised
Date: Fri, 25 Jan 2013 14:37:16 +0100
Message-Id: <1359121036-16309-1-git-send-email-olaf@aepfle.de>
X-Mailer: git-send-email 1.8.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable hyperv_clocksource only if its advertised as a feature.
XenServer 6 returns the signature which is checked in
ms_hyperv_platform(), but it does not offer all features. Currently the
clocksource is enabled unconditionally in ms_hyperv_init_platform(), and
the result is a hanging guest.

Hyper-V spec Bit 1 indicates the availability of Partition Reference
Counter.  Register the clocksource only if this bit is set.

The guest in question prints this in dmesg:
 [    0.000000] Hypervisor detected: Microsoft HyperV
 [    0.000000] HyperV: features 0x70, hints 0x0

This bug can be reproduced easily be setting 'viridian=1' in a HVM domU
.cfg file. A workaround without this patch is to boot the HVM guest with
'clocksource=jiffies'.

Signed-off-by: Olaf Hering <olaf@aepfle.de>
Cc: stable@kernel.org
Cc: KY Srinivasan <kys@microsoft.com>
Cc: Greg KH <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/mshyperv.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/mshyperv.c b/arch/x86/kernel/cpu/mshyperv.c
index 0a630dd..646d192 100644
--- a/arch/x86/kernel/cpu/mshyperv.c
+++ b/arch/x86/kernel/cpu/mshyperv.c
@@ -68,7 +68,8 @@ static void __init ms_hyperv_init_platform(void)
 	printk(KERN_INFO "HyperV: features 0x%x, hints 0x%x\n",
 	       ms_hyperv.features, ms_hyperv.hints);
 
-	clocksource_register_hz(&hyperv_cs, NSEC_PER_SEC/100);
+	if (ms_hyperv.features & HV_X64_MSR_TIME_REF_COUNT_AVAILABLE)
+		clocksource_register_hz(&hyperv_cs, NSEC_PER_SEC/100);
 }
 
 const __refconst struct hypervisor_x86 x86_hyper_ms_hyperv = {
-- 
1.8.1.1

