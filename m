Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756275AbaJCVpa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 17:45:30 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45325 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755389AbaJCVnT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:43:19 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Shawn Guo <shawn.guo@freescale.com>, Olof Johansson <olof@lixom.net>
Subject: [PATCH 3.16 189/357] ARM: imx: fix .is_enabled() of shared gate clock
Date: Fri,  3 Oct 2014 14:29:35 -0700
Message-Id: <20141003212939.147371877@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212933.458851516@linuxfoundation.org>
References: <20141003212933.458851516@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shawn Guo <shawn.guo@freescale.com>

commit 9e1ac462b982f496ed3b491f02c417dcc8e40347 upstream.

Commit 63288b721a80 ("ARM: imx: fix shared gate clock") attempted to fix
an issue with particular enable/disable sequence from two shared gate
clocks.  But unfortunately, while it partially fixed the issue, it also
did something wrong in .is_enabled() function hook.  In case of shared
gate, the function shouldn't really query the hardware state via
share_count, because the function is trying to query the enabling state
of the clock in question, not the hardware state which is shared by
multiple clocks.

Fix the issue by returning the enable_count of the clock itself which is
maintained by clock core, in case it's a clock sharing hardware gate
with others.  As the result, the initialization of share_count per
hardware state is not needed now.  So remove it.

Reported-by: Fabio Estevam <fabio.estevam@freescale.com>
Fixes: 63288b721a80 ("ARM: imx: fix shared gate clock")
Signed-off-by: Shawn Guo <shawn.guo@freescale.com>
Tested-by: Fabio Estevam <fabio.estevam@freescale.com>
Signed-off-by: Olof Johansson <olof@lixom.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mach-imx/clk-gate2.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/arch/arm/mach-imx/clk-gate2.c
+++ b/arch/arm/mach-imx/clk-gate2.c
@@ -97,7 +97,7 @@ static int clk_gate2_is_enabled(struct c
 	struct clk_gate2 *gate = to_clk_gate2(hw);
 
 	if (gate->share_count)
-		return !!(*gate->share_count);
+		return !!__clk_get_enable_count(hw->clk);
 	else
 		return clk_gate2_reg_is_enabled(gate->reg, gate->bit_idx);
 }
@@ -127,10 +127,6 @@ struct clk *clk_register_gate2(struct de
 	gate->bit_idx = bit_idx;
 	gate->flags = clk_gate2_flags;
 	gate->lock = lock;
-
-	/* Initialize share_count per hardware state */
-	if (share_count)
-		*share_count = clk_gate2_reg_is_enabled(reg, bit_idx) ? 1 : 0;
 	gate->share_count = share_count;
 
 	init.name = name;


