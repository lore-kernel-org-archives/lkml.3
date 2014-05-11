Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758166AbaEKT4d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 15:56:33 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48044 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932751AbaEKTVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 15:21:40 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Li Zhong <zhong@linux.vnet.ibm.com>, Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH 3.14 20/83] powerpc: Fix Oops in rtas_stop_self()
Date: Sun, 11 May 2014 21:19:21 +0200
Message-Id: <20140511191909.838857845@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140511191907.024339448@linuxfoundation.org>
References: <20140511191907.024339448@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li Zhong <zhong@linux.vnet.ibm.com>

commit 4fb8d027dca0236c811272d342cf185569d91311 upstream.

commit 41dd03a9 may cause Oops in rtas_stop_self().

The reason is that the rtas_args was moved into stack space. For a box
with more that 4GB RAM, the stack could easily be outside 32bit range,
but RTAS is 32bit.

So the patch moves rtas_args away from stack by adding static before
it.

Signed-off-by: Li Zhong <zhong@linux.vnet.ibm.com>
Signed-off-by: Anton Blanchard <anton@samba.org>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/platforms/pseries/hotplug-cpu.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

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


