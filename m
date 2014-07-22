Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933004AbaGVWZN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 18:25:13 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44623 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932945AbaGVWZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 18:25:08 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Scott Wood <scottwood@freescale.com>, Michael Neuling <mikey@neuling.org>,
        Emil Medve <Emilian.Medve@freescale.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 110/116] powerpc: Don't skip ePAPR spin-table CPUs
Date: Tue, 22 Jul 2014 15:22:01 -0700
Message-Id: <1406067727-19683-111-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406067727-19683-1-git-send-email-kamal@canonical.com>
References: <1406067727-19683-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.27 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Scott Wood <scottwood@freescale.com>

commit 6663a4fa6711050036562ddfd2086edf735fae21 upstream.

Commit 59a53afe70fd530040bdc69581f03d880157f15a "powerpc: Don't setup
CPUs with bad status" broke ePAPR SMP booting.  ePAPR says that CPUs
that aren't presently running shall have status of disabled, with
enable-method being used to determine whether the CPU can be enabled.

Fix by checking for spin-table, which is currently the only supported
enable-method.

Signed-off-by: Scott Wood <scottwood@freescale.com>
Cc: Michael Neuling <mikey@neuling.org>
Cc: Emil Medve <Emilian.Medve@Freescale.com>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/powerpc/kernel/setup-common.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/kernel/setup-common.c b/arch/powerpc/kernel/setup-common.c
index b050263..069f857 100644
--- a/arch/powerpc/kernel/setup-common.c
+++ b/arch/powerpc/kernel/setup-common.c
@@ -455,9 +455,17 @@ void __init smp_setup_cpu_maps(void)
 		}
 
 		for (j = 0; j < nthreads && cpu < nr_cpu_ids; j++) {
+			bool avail;
+
 			DBG("    thread %d -> cpu %d (hard id %d)\n",
 			    j, cpu, intserv[j]);
-			set_cpu_present(cpu, of_device_is_available(dn));
+
+			avail = of_device_is_available(dn);
+			if (!avail)
+				avail = !of_property_match_string(dn,
+						"enable-method", "spin-table");
+
+			set_cpu_present(cpu, avail);
 			set_hard_smp_processor_id(cpu, intserv[j]);
 			set_cpu_possible(cpu, true);
 			cpu++;
-- 
1.9.1

