Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755642AbaF3MFq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 08:05:46 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:52040 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753791AbaF3LxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 07:53:25 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Li Zhong <zhong@linux.vnet.ibm.com>,
        Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 004/181] powerpc: Fix Oops in rtas_stop_self()
Date: Mon, 30 Jun 2014 13:50:25 +0200
Message-Id: <f116dbc9d877c8436f17fd3226c6d4695bbbb928.1404128997.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
References: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
In-Reply-To: <cover.1404128997.git.jslaby@suse.cz>
References: <cover.1404128997.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Li Zhong <zhong@linux.vnet.ibm.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 4fb8d027dca0236c811272d342cf185569d91311 upstream.

commit 41dd03a9 may cause Oops in rtas_stop_self().

The reason is that the rtas_args was moved into stack space. For a box
with more that 4GB RAM, the stack could easily be outside 32bit range,
but RTAS is 32bit.

So the patch moves rtas_args away from stack by adding static before
it.

Signed-off-by: Li Zhong <zhong@linux.vnet.ibm.com>
Signed-off-by: Anton Blanchard <anton@samba.org>
Cc: stable@vger.kernel.org # 3.14+
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/powerpc/platforms/pseries/hotplug-cpu.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/hotplug-cpu.c b/arch/powerpc/platforms/pseries/hotplug-cpu.c
index 0ea99e3d4815..2d6fe89ff89d 100644
--- a/arch/powerpc/platforms/pseries/hotplug-cpu.c
+++ b/arch/powerpc/platforms/pseries/hotplug-cpu.c
@@ -88,13 +88,14 @@ void set_default_offline_state(int cpu)
 
 static void rtas_stop_self(void)
 {
-	struct rtas_args args = {
-		.token = cpu_to_be32(rtas_stop_self_token),
+	static struct rtas_args args = {
 		.nargs = 0,
 		.nret = 1,
 		.rets = &args.args[0],
 	};
 
+	args.token = cpu_to_be32(rtas_stop_self_token);
+
 	local_irq_disable();
 
 	BUG_ON(rtas_stop_self_token == RTAS_UNKNOWN_SERVICE);
-- 
2.0.0

