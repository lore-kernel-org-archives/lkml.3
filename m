Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758956AbaIOVGz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 17:06:55 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54565 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754945AbaIOT05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 15:26:57 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        "Preeti U. Murthy" <preeti@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH 3.16 035/158] powerpc/cpuidle: Fix parsing of idle state flags from device-tree
Date: Mon, 15 Sep 2014 12:24:34 -0700
Message-Id: <20140915192543.939603064@linuxfoundation.org>
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

commit 95707d852856aec1cbdad1873ff2dc5161a5cb91 upstream.

Flags from device-tree need to be parsed with accessors for
interpreting correct value in little-endian.

Signed-off-by: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Reviewed-by: Preeti U. Murthy <preeti@linux.vnet.ibm.com>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/cpuidle/cpuidle-powernv.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/drivers/cpuidle/cpuidle-powernv.c
+++ b/drivers/cpuidle/cpuidle-powernv.c
@@ -160,10 +160,10 @@ static int powernv_cpuidle_driver_init(v
 static int powernv_add_idle_states(void)
 {
 	struct device_node *power_mgt;
-	struct property *prop;
 	int nr_idle_states = 1; /* Snooze */
 	int dt_idle_states;
-	u32 *flags;
+	const __be32 *idle_state_flags;
+	u32 len_flags, flags;
 	int i;
 
 	/* Currently we have snooze statically defined */
@@ -174,18 +174,18 @@ static int powernv_add_idle_states(void)
 		return nr_idle_states;
 	}
 
-	prop = of_find_property(power_mgt, "ibm,cpu-idle-state-flags", NULL);
-	if (!prop) {
+	idle_state_flags = of_get_property(power_mgt, "ibm,cpu-idle-state-flags", &len_flags);
+	if (!idle_state_flags) {
 		pr_warn("DT-PowerMgmt: missing ibm,cpu-idle-state-flags\n");
 		return nr_idle_states;
 	}
 
-	dt_idle_states = prop->length / sizeof(u32);
-	flags = (u32 *) prop->value;
+	dt_idle_states = len_flags / sizeof(u32);
 
 	for (i = 0; i < dt_idle_states; i++) {
 
-		if (flags[i] & IDLE_USE_INST_NAP) {
+		flags = be32_to_cpu(idle_state_flags[i]);
+		if (flags & IDLE_USE_INST_NAP) {
 			/* Add NAP state */
 			strcpy(powernv_states[nr_idle_states].name, "Nap");
 			strcpy(powernv_states[nr_idle_states].desc, "Nap");
@@ -196,7 +196,7 @@ static int powernv_add_idle_states(void)
 			nr_idle_states++;
 		}
 
-		if (flags[i] & IDLE_USE_INST_SLEEP) {
+		if (flags & IDLE_USE_INST_SLEEP) {
 			/* Add FASTSLEEP state */
 			strcpy(powernv_states[nr_idle_states].name, "FastSleep");
 			strcpy(powernv_states[nr_idle_states].desc, "FastSleep");


