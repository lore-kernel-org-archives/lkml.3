Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932748AbaCDVFy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 16:05:54 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41144 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756564AbaCDUDv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 15:03:51 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Tony Breeds <tony@bakeyournoodle.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH 3.13 100/172] powerpc/le: Ensure that the stop-self RTAS token is handled correctly
Date: Tue,  4 Mar 2014 12:03:04 -0800
Message-Id: <20140304200302.903643396@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140304200259.626667112@linuxfoundation.org>
References: <20140304200259.626667112@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/platforms/pseries/hotplug-cpu.c |   22 +++++++++++-----------
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
@@ -392,10 +392,10 @@ static int __init pseries_cpu_hotplug_in
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


