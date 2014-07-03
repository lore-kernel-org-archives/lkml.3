Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030245AbaGCJXx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 05:23:53 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52186 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030193AbaGCJXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 05:23:43 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Michael Neuling <mikey@neuling.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 121/198] powerpc: Don't setup CPUs with bad status
Date: Thu,  3 Jul 2014 10:19:24 +0100
Message-Id: <1404379241-8590-122-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
References: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Neuling <mikey@neuling.org>

commit 59a53afe70fd530040bdc69581f03d880157f15a upstream.

OPAL will mark a CPU that is guarded as "bad" in the status property of the CPU
node.

Unfortunatley Linux doesn't check this property and will put the bad CPU in the
present map.  This has caused hangs on booting when we try to unsplit the core.

This patch checks the CPU is avaliable via this status property before putting
it in the present map.

Signed-off-by: Michael Neuling <mikey@neuling.org>
Tested-by: Anton Blanchard <anton@samba.org>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/powerpc/kernel/setup-common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/kernel/setup-common.c b/arch/powerpc/kernel/setup-common.c
index ee0e0553ae0e..b12be98e0972 100644
--- a/arch/powerpc/kernel/setup-common.c
+++ b/arch/powerpc/kernel/setup-common.c
@@ -457,7 +457,7 @@ void __init smp_setup_cpu_maps(void)
 		for (j = 0; j < nthreads && cpu < nr_cpu_ids; j++) {
 			DBG("    thread %d -> cpu %d (hard id %d)\n",
 			    j, cpu, be32_to_cpu(intserv[j]));
-			set_cpu_present(cpu, true);
+			set_cpu_present(cpu, of_device_is_available(dn));
 			set_hard_smp_processor_id(cpu, be32_to_cpu(intserv[j]));
 			set_cpu_possible(cpu, true);
 			cpu++;
-- 
1.9.1

