Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760357Ab3B1PPd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 10:15:33 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42065 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756850Ab3B1Orc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 09:47:32 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Olaf Hering <olaf@aepfle.de>, "K. Y. Srinivasan" <kys@microsoft.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 042/139] x86: Hyper-V: register clocksource only if its advertised
Date: Thu, 28 Feb 2013 14:43:12 +0000
Message-Id: <1362062689-2567-43-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
References: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Olaf Hering <[mailto:olaf@aepfle.de]>

commit 32068f6527b8f1822a30671dedaf59c567325026 upstream.

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
Link: http://lkml.kernel.org/r/1359940959-32168-1-git-send-email-kys@microsoft.com
Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Cc: Greg KH <gregkh@linuxfoundation.org>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
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
1.8.1.2

