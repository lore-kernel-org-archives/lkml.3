Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753814Ab3BDAzP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 19:55:15 -0500
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:44168
	"EHLO p3plsmtps2ded01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753489Ab3BDAzN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 19:55:13 -0500
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: x86@kernel.org, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com, tglx@linutronix.de, hpa@zytor.com,
        JBeulich@suse.com, bp@alien8.de
Cc: Olaf Hering <"[mailto:olaf@aepfle.de]"@linuxonhyperv.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>, stable@kernel.org
Subject: [PATCH 1/3] x86: Hyper-V: register clocksource only if its advertised
Date: Sun,  3 Feb 2013 17:22:37 -0800
Message-Id: <1359940959-32168-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1359940910-32114-1-git-send-email-kys@microsoft.com>
References: <1359940910-32114-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Olaf Hering <[mailto:olaf@aepfle.de]>

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
Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Cc: stable@kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/mshyperv.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

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
1.7.4.1

