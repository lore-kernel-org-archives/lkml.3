Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756049AbaGHTgf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 15:36:35 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54778 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754200AbaGHTeY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 15:34:24 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Anton Blanchard" <anton@samba.org>,
        "Michael Neuling" <mikey@neuling.org>,
        "Benjamin Herrenschmidt" <benh@kernel.crashing.org>
Date: Tue, 08 Jul 2014 20:01:50 +0100
Message-ID: <lsq.1404846110.449655037@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 075/125] powerpc: Don't setup CPUs with bad status
In-Reply-To: <lsq.1404846109.699842714@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.61-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/powerpc/kernel/setup-common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/powerpc/kernel/setup-common.c
+++ b/arch/powerpc/kernel/setup-common.c
@@ -449,7 +449,7 @@ void __init smp_setup_cpu_maps(void)
 		for (j = 0; j < nthreads && cpu < nr_cpu_ids; j++) {
 			DBG("    thread %d -> cpu %d (hard id %d)\n",
 			    j, cpu, intserv[j]);
-			set_cpu_present(cpu, true);
+			set_cpu_present(cpu, of_device_is_available(dn));
 			set_hard_smp_processor_id(cpu, intserv[j]);
 			set_cpu_possible(cpu, true);
 			cpu++;

