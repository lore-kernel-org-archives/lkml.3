Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753870AbaKYKm6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 05:42:58 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58914 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753777AbaKYKmw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:42:52 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Geert Uytterhoeven <geert+renesas@glider.be>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 181/254] cpufreq: Avoid crash in resume on SMP without OPP
Date: Tue, 25 Nov 2014 10:38:51 +0000
Message-Id: <1416912004-5928-182-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
References: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert+renesas@glider.be>

commit 09712f557b31838092e1f22a5f2dd131a843a3de upstream.

When resuming from s2ram on an SMP system without cpufreq operating
points (e.g. there's no "operating-points" property for the CPU node in
DT, or the platform doesn't use DT yet), the kernel crashes when
bringing CPU 1 online:

    Enabling non-boot CPUs ...
    CPU1: Booted secondary processor
    Unable to handle kernel NULL pointer dereference at virtual address 0000003c
    pgd = ee5e6b00
    [0000003c] *pgd=6e579003, *pmd=6e588003, *pte=00000000
    Internal error: Oops: a07 [#1] SMP ARM
    Modules linked in:
    CPU: 0 PID: 1246 Comm: s2ram Tainted: G        W      3.18.0-rc3-koelsch-01614-g0377af242bb175c8-dirty #589
    task: eeec5240 ti: ee704000 task.ti: ee704000
    PC is at __cpufreq_add_dev.isra.24+0x24c/0x77c
    LR is at __cpufreq_add_dev.isra.24+0x244/0x77c
    pc : [<c0298efc>]    lr : [<c0298ef4>]    psr: 60000153
    sp : ee705d48  ip : ee705d48  fp : ee705d84
    r10: c04e0450  r9 : 00000000  r8 : 00000001
    r7 : c05426a8  r6 : 00000001  r5 : 00000001  r4 : 00000000
    r3 : 00000000  r2 : 00000000  r1 : 20000153  r0 : c0542734

Verify that policy is not NULL before dereferencing it to fix this.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Fixes: 8414809c6a1e (cpufreq: Preserve policy structure across suspend/resume)
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/cpufreq/cpufreq.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index c06668f4e8c1..8daa0c95aa21 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1022,7 +1022,8 @@ static struct cpufreq_policy *cpufreq_policy_restore(unsigned int cpu)
 
 	read_unlock_irqrestore(&cpufreq_driver_lock, flags);
 
-	policy->governor = NULL;
+	if (policy)
+		policy->governor = NULL;
 
 	return policy;
 }
-- 
2.1.0

