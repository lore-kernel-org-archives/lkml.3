Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759455AbaIOVPq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 17:15:46 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54579 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754768AbaIOT0q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 15:26:46 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        "Gautham R. Shenoy" <ego@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH 3.16 018/158] powerpc/cpufreq: Add pr_warn() on OPAL firmware failures
Date: Mon, 15 Sep 2014 12:24:17 -0700
Message-Id: <20140915192543.425059094@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140915192542.872134685@linuxfoundation.org>
References: <20140915192542.872134685@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>

commit 6174bac8c7ff73a86ae9a967d1c9cadc478023ae upstream.

Cpufreq depends on platform firmware to implement PStates.  In case of
platform firmware failure, cpufreq should not panic host kernel with
BUG_ON().  Less severe pr_warn() will suffice.

Add firmware_has_feature(FW_FEATURE_OPALv3) check to
skip probing for device-tree on non-powernv platforms.

Signed-off-by: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Acked-by: Gautham R. Shenoy <ego@linux.vnet.ibm.com>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/cpufreq/powernv-cpufreq.c |   18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

--- a/drivers/cpufreq/powernv-cpufreq.c
+++ b/drivers/cpufreq/powernv-cpufreq.c
@@ -28,6 +28,7 @@
 #include <linux/of.h>
 
 #include <asm/cputhreads.h>
+#include <asm/firmware.h>
 #include <asm/reg.h>
 #include <asm/smp.h> /* Required for cpu_sibling_mask() in UP configs */
 
@@ -98,7 +99,11 @@ static int init_powernv_pstates(void)
 		return -ENODEV;
 	}
 
-	WARN_ON(len_ids != len_freqs);
+	if (len_ids != len_freqs) {
+		pr_warn("Entries in ibm,pstate-ids and "
+			"ibm,pstate-frequencies-mhz does not match\n");
+	}
+
 	nr_pstates = min(len_ids, len_freqs) / sizeof(u32);
 	if (!nr_pstates) {
 		pr_warn("No PStates found\n");
@@ -131,7 +136,12 @@ static unsigned int pstate_id_to_freq(in
 	int i;
 
 	i = powernv_pstate_info.max - pstate_id;
-	BUG_ON(i >= powernv_pstate_info.nr_pstates || i < 0);
+	if (i >= powernv_pstate_info.nr_pstates || i < 0) {
+		pr_warn("PState id %d outside of PState table, "
+			"reporting nominal id %d instead\n",
+			pstate_id, powernv_pstate_info.nominal);
+		i = powernv_pstate_info.max - powernv_pstate_info.nominal;
+	}
 
 	return powernv_freqs[i].frequency;
 }
@@ -321,6 +331,10 @@ static int __init powernv_cpufreq_init(v
 {
 	int rc = 0;
 
+	/* Don't probe on pseries (guest) platforms */
+	if (!firmware_has_feature(FW_FEATURE_OPALv3))
+		return -ENODEV;
+
 	/* Discover pstates from device tree and init */
 	rc = init_powernv_pstates();
 	if (rc) {


