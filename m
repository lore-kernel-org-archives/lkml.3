Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751487AbaCaULt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 16:11:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:65480 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751398AbaCaULp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 16:11:45 -0400
From: Igor Mammedov <imammedo@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        imammedo@redhat.com, bp@suse.de, paul.gortmaker@windriver.com,
        JBeulich@suse.com, prarit@redhat.com, drjones@redhat.com,
        toshi.kani@hp.com, riel@redhat.com, gong.chen@linux.intel.com
Subject: [PATCH v2 5/5] x86: fix memory corruption in acpi_unmap_lsapic()
Date: Mon, 31 Mar 2014 22:09:25 +0200
Message-Id: <1396296565-19709-6-git-send-email-imammedo@redhat.com>
In-Reply-To: <1396296565-19709-1-git-send-email-imammedo@redhat.com>
References: <1396296565-19709-1-git-send-email-imammedo@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

if during CPU hotplug master CPU failed to wake up AP
it set percpu x86_cpu_to_apicid to BAD_APICID=0xFFFF for AP.

However following attempt to unplug that CPU will lead to
out of bound write access to __apicid_to_node[] which is
32768 items long on x86_64 kernel.

So drop setting x86_cpu_to_apicid to BAD_APICID in do_boot_cpu()
and allow acpi_processor_remove()->acpi_unmap_lsapic() cleanly
remove CPU.

Signed-off-by: Igor Mammedov <imammedo@redhat.com>
---
 arch/x86/kernel/smpboot.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 0400418..2b0b8ee 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -796,8 +796,6 @@ static int do_boot_cpu(int apicid, int cpu, struct task_struct *idle)
 			 */
 			schedule();
 		}
-	} else {
-		per_cpu(x86_cpu_to_apicid, cpu) = BAD_APICID;
 	}
 
 	/* mark "stuck" area as not stuck */
-- 
1.7.1

