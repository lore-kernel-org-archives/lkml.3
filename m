Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933558AbaGVWtJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 18:49:09 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44484 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932592AbaGVWXX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 18:23:23 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Michael Neuling <mikey@neuling.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 078/116] powerpc: Don't setup CPUs with bad status
Date: Tue, 22 Jul 2014 15:21:29 -0700
Message-Id: <1406067727-19683-79-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406067727-19683-1-git-send-email-kamal@canonical.com>
References: <1406067727-19683-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.27 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/powerpc/kernel/setup-common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/kernel/setup-common.c b/arch/powerpc/kernel/setup-common.c
index bdc499c..b050263 100644
--- a/arch/powerpc/kernel/setup-common.c
+++ b/arch/powerpc/kernel/setup-common.c
@@ -457,7 +457,7 @@ void __init smp_setup_cpu_maps(void)
 		for (j = 0; j < nthreads && cpu < nr_cpu_ids; j++) {
 			DBG("    thread %d -> cpu %d (hard id %d)\n",
 			    j, cpu, intserv[j]);
-			set_cpu_present(cpu, true);
+			set_cpu_present(cpu, of_device_is_available(dn));
 			set_hard_smp_processor_id(cpu, intserv[j]);
 			set_cpu_possible(cpu, true);
 			cpu++;
-- 
1.9.1

