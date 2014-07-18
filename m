Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422782AbaGRNr0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 09:47:26 -0400
Received: from bband-dyn38.178-41-141.t-com.sk ([178.41.141.38]:17546 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1030610AbaGRNLN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 09:11:13 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Scott Wood <scottwood@freescale.com>,
        Michael Neuling <mikey@neuling.org>,
        Emil Medve <Emilian.Medve@freescale.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 048/170] powerpc: Don't skip ePAPR spin-table CPUs
Date: Fri, 18 Jul 2014 14:10:53 +0200
Message-Id: <24cba162f91747b0a52a82fb685d2315f8da9661.1405685481.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
References: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
In-Reply-To: <cover.1405685481.git.jslaby@suse.cz>
References: <cover.1405685481.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Scott Wood <scottwood@freescale.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/powerpc/kernel/setup-common.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/kernel/setup-common.c b/arch/powerpc/kernel/setup-common.c
index 0623cf3f8a61..5b86d6a47a1a 100644
--- a/arch/powerpc/kernel/setup-common.c
+++ b/arch/powerpc/kernel/setup-common.c
@@ -458,9 +458,17 @@ void __init smp_setup_cpu_maps(void)
 		}
 
 		for (j = 0; j < nthreads && cpu < nr_cpu_ids; j++) {
+			bool avail;
+
 			DBG("    thread %d -> cpu %d (hard id %d)\n",
 			    j, cpu, be32_to_cpu(intserv[j]));
-			set_cpu_present(cpu, of_device_is_available(dn));
+
+			avail = of_device_is_available(dn);
+			if (!avail)
+				avail = !of_property_match_string(dn,
+						"enable-method", "spin-table");
+
+			set_cpu_present(cpu, avail);
 			set_hard_smp_processor_id(cpu, be32_to_cpu(intserv[j]));
 			set_cpu_possible(cpu, true);
 			cpu++;
-- 
2.0.0

