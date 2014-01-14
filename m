Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752737AbaANAWF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 19:22:05 -0500
Received: from mail1.windriver.com ([147.11.146.13]:61793 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752460AbaANAUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 19:20:33 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Russell King <linux@arm.linux.org.uk>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH 3/3] arm: don't use module_init in non-modular mach-vexpress/spc.c code
Date: Mon, 13 Jan 2014 19:19:43 -0500
Message-ID: <1389658783-9876-4-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1389658783-9876-1-git-send-email-paul.gortmaker@windriver.com>
References: <1389658783-9876-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The spc.o is built for ARCH_VEXPRESS_SPC -- which is bool, and hence
this code is either present or absent.  It will never be modular,
so using module_init as an alias for __initcall can be somewhat
misleading.

Fix this up now, so that we can relocate module_init from
init.h into module.h in the future.  If we don't do this, we'd
have to add module.h to obviously non-modular code, and that
would be a worse thing.

Note that direct use of __initcall is discouraged, vs. one
of the priority categorized subgroups.  As __initcall gets
mapped onto device_initcall, our use of device_initcall
directly in this change means that the runtime impact is
zero -- it will remain at level 6 in initcall ordering.

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/arm/mach-vexpress/spc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-vexpress/spc.c b/arch/arm/mach-vexpress/spc.c
index c26ef5b92ca7..9312a9b0405b 100644
--- a/arch/arm/mach-vexpress/spc.c
+++ b/arch/arm/mach-vexpress/spc.c
@@ -581,4 +581,4 @@ static int __init ve_spc_clk_init(void)
 	platform_device_register_simple("vexpress-spc-cpufreq", -1, NULL, 0);
 	return 0;
 }
-module_init(ve_spc_clk_init);
+device_initcall(ve_spc_clk_init);
-- 
1.8.5.2

