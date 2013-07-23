Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756037Ab3GWJDa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 05:03:30 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:36867 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752639Ab3GWJD1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 05:03:27 -0400
Subject: [PATCH 2/3] cpuidle/powernv: Enable idle powernv cpu to call into
 the cpuidle framework.
To: linuxppc-dev@lists.ozlabs.org
From: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
Cc: benh@kernel.crashing.org, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Date: Tue, 23 Jul 2013 14:31:53 +0530
Message-ID: <20130723090150.7291.89879.stgit@deepthi.in.ibm.com>
In-Reply-To: <20130723090111.7291.99479.stgit@deepthi.in.ibm.com>
References: <20130723090111.7291.99479.stgit@deepthi.in.ibm.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13072308-3864-0000-0000-00000935D5B2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enables idle powernv cpu to hook on to the cpuidle
framework, if available, else call on to default idle platform
code.

Signed-off-by: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
---
 arch/powerpc/platforms/powernv/setup.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/platforms/powernv/setup.c b/arch/powerpc/platforms/powernv/setup.c
index 84438af..97d0951 100644
--- a/arch/powerpc/platforms/powernv/setup.c
+++ b/arch/powerpc/platforms/powernv/setup.c
@@ -25,6 +25,7 @@
 #include <linux/of.h>
 #include <linux/interrupt.h>
 #include <linux/bug.h>
+#include <linux/cpuidle.h>
 
 #include <asm/machdep.h>
 #include <asm/firmware.h>
@@ -196,6 +197,15 @@ static int __init pnv_probe(void)
 	return 1;
 }
 
+void powernv_idle(void)
+{
+	/* Hook to cpuidle framework if available, else
+	 * call on default platform idle code
+	 */
+	if (cpuidle_idle_call())
+		power7_idle();
+}
+
 define_machine(powernv) {
 	.name			= "PowerNV",
 	.probe			= pnv_probe,
@@ -205,7 +215,7 @@ define_machine(powernv) {
 	.show_cpuinfo		= pnv_show_cpuinfo,
 	.progress		= pnv_progress,
 	.machine_shutdown	= pnv_shutdown,
-	.power_save             = power7_idle,
+	.power_save             = powernv_idle,
 	.calibrate_decr		= generic_calibrate_decr,
 #ifdef CONFIG_KEXEC
 	.kexec_cpu_down		= pnv_kexec_cpu_down,

