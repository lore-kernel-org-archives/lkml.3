Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754676AbaC3Xnd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 19:43:33 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:37332 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754644AbaC3Xna (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 19:43:30 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Benjamin Herrenschmidt" <benh@kernel.crashing.org>,
        "Tony Breeds" <tony@bakeyournoodle.com>
Date: Mon, 31 Mar 2014 00:23:35 +0100
Message-ID: <lsq.1396221815.799153951@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 153/200] powerpc/le: Ensure that the 'stop-self' RTAS
 token is handled correctly
In-Reply-To: <lsq.1396221814.369444335@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.56-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Tony Breeds <tony@bakeyournoodle.com>

commit 41dd03a94c7d408d2ef32530545097f7d1befe5c upstream.

Currently we're storing a host endian RTAS token in
rtas_stop_self_args.token.  We then pass that directly to rtas.  This is
fine on big endian however on little endian the token is not what we
expect.

This will typically result in hitting:
	panic("Alas, I survived.\n");

To fix this we always use the stop-self token in host order and always
convert it to be32 before passing this to rtas.

Signed-off-by: Tony Breeds <tony@bakeyournoodle.com>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/powerpc/platforms/pseries/hotplug-cpu.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

--- a/arch/powerpc/platforms/pseries/hotplug-cpu.c
+++ b/arch/powerpc/platforms/pseries/hotplug-cpu.c
@@ -35,12 +35,7 @@
 #include "offline_states.h"
 
 /* This version can't take the spinlock, because it never returns */
-static struct rtas_args rtas_stop_self_args = {
-	.token = RTAS_UNKNOWN_SERVICE,
-	.nargs = 0,
-	.nret = 1,
-	.rets = &rtas_stop_self_args.args[0],
-};
+static int rtas_stop_self_token = RTAS_UNKNOWN_SERVICE;
 
 static DEFINE_PER_CPU(enum cpu_state_vals, preferred_offline_state) =
 							CPU_STATE_OFFLINE;
@@ -93,15 +88,20 @@ void set_default_offline_state(int cpu)
 
 static void rtas_stop_self(void)
 {
-	struct rtas_args *args = &rtas_stop_self_args;
+	struct rtas_args args = {
+		.token = cpu_to_be32(rtas_stop_self_token),
+		.nargs = 0,
+		.nret = 1,
+		.rets = &args.args[0],
+	};
 
 	local_irq_disable();
 
-	BUG_ON(args->token == RTAS_UNKNOWN_SERVICE);
+	BUG_ON(rtas_stop_self_token == RTAS_UNKNOWN_SERVICE);
 
 	printk("cpu %u (hwid %u) Ready to die...\n",
 	       smp_processor_id(), hard_smp_processor_id());
-	enter_rtas(__pa(args));
+	enter_rtas(__pa(&args));
 
 	panic("Alas, I survived.\n");
 }
@@ -384,10 +384,10 @@ static int __init pseries_cpu_hotplug_in
 		}
 	}
 
-	rtas_stop_self_args.token = rtas_token("stop-self");
+	rtas_stop_self_token = rtas_token("stop-self");
 	qcss_tok = rtas_token("query-cpu-stopped-state");
 
-	if (rtas_stop_self_args.token == RTAS_UNKNOWN_SERVICE ||
+	if (rtas_stop_self_token == RTAS_UNKNOWN_SERVICE ||
 			qcss_tok == RTAS_UNKNOWN_SERVICE) {
 		printk(KERN_INFO "CPU Hotplug not supported by firmware "
 				"- disabling.\n");

