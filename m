Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933681Ab3B0A3j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 19:29:39 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42660 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933442Ab3B0AIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 19:08:42 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Olaf Hering <olaf@aepfle.de>, "K. Y. Srinivasan" <kys@microsoft.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [ 09/86] x86: Hyper-V: register clocksource only if its advertised
Date: Tue, 26 Feb 2013 16:07:17 -0800
Message-Id: <20130226235913.874567531@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130226235912.881663118@linuxfoundation.org>
References: <20130226235912.881663118@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/cpu/mshyperv.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/x86/kernel/cpu/mshyperv.c
+++ b/arch/x86/kernel/cpu/mshyperv.c
@@ -68,7 +68,8 @@ static void __init ms_hyperv_init_platfo
 	printk(KERN_INFO "HyperV: features 0x%x, hints 0x%x\n",
 	       ms_hyperv.features, ms_hyperv.hints);
 
-	clocksource_register_hz(&hyperv_cs, NSEC_PER_SEC/100);
+	if (ms_hyperv.features & HV_X64_MSR_TIME_REF_COUNT_AVAILABLE)
+		clocksource_register_hz(&hyperv_cs, NSEC_PER_SEC/100);
 }
 
 const __refconst struct hypervisor_x86 x86_hyper_ms_hyperv = {


