Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755434Ab3HWKch (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 06:32:37 -0400
Received: from mail-bk0-f45.google.com ([209.85.214.45]:52886 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754903Ab3HWKcf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 06:32:35 -0400
Message-ID: <52173A3E.2040509@gmail.com>
Date: Fri, 23 Aug 2013 12:32:30 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Gregory CLEMENT <gregory.clement@free-electrons.com>
CC: Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC 08/17] ARM: mvebu: remove custom .init_time hook
References: <1376964271-22715-1-git-send-email-sebastian.hesselbarth@gmail.com> <1376964271-22715-9-git-send-email-sebastian.hesselbarth@gmail.com> <52173408.1000702@free-electrons.com>
In-Reply-To: <52173408.1000702@free-electrons.com>
Content-Type: multipart/mixed;
 boundary="------------000709030907080105060607"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000709030907080105060607
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 08/23/13 12:06, Gregory CLEMENT wrote:
> On 20/08/2013 04:04, Sebastian Hesselbarth wrote:
>> With arch/arm calling of_clk_init(NULL) from time_init(), we can now
>> remove custom .init_time hooks.
>
> As a feared it won't work on Armada XP. You moved coherency_init(), and
> l2x0_of_init() in the init_machine hook. However init_machine is an
> arch_initcall, and as all the initcall it is called at the end of the
> do_basic_setup() which is called after smp_prepare_cpus(). The issue is
> that smp_prepare_cpus need coherency (and I think L2 cache) already enable.

Ok, I see. I remember mvebu smp relies on mbus mappings also? Can you
try below as replacement for the mach-mvebu/armada-370-xp.c changes?

It will move coherency_init(), l2x0_of_init(), and mvebu_mbus_dt_init()
to .init_early hook.

Sebastian


--------------000709030907080105060607
Content-Type: text/x-patch;
 name="arm-of_clk_init-mvebu-proposal.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="arm-of_clk_init-mvebu-proposal.diff"

diff --git a/arch/arm/mach-mvebu/armada-370-xp.c b/arch/arm/mach-mvebu/armada-370-xp.c
index 829b573..82e3ec0 100644
--- a/arch/arm/mach-mvebu/armada-370-xp.c
+++ b/arch/arm/mach-mvebu/armada-370-xp.c
@@ -14,11 +14,9 @@
 
 #include <linux/kernel.h>
 #include <linux/init.h>
-#include <linux/clk-provider.h>
 #include <linux/of_address.h>
 #include <linux/of_platform.h>
 #include <linux/io.h>
-#include <linux/time-armada-370-xp.h>
 #include <linux/dma-mapping.h>
 #include <linux/mbus.h>
 #include <asm/hardware/cache-l2x0.h>
@@ -34,10 +32,8 @@ static void __init armada_370_xp_map_io(void)
 	debug_ll_io_init();
 }
 
-static void __init armada_370_xp_timer_and_clk_init(void)
+static void __init armada_370_xp_init_early(void)
 {
-	of_clk_init(NULL);
-	armada_370_xp_timer_init();
 	coherency_init();
 	BUG_ON(mvebu_mbus_dt_init());
 #ifdef CONFIG_CACHE_L2X0
@@ -58,8 +54,8 @@ static const char * const armada_370_xp_dt_compat[] = {
 DT_MACHINE_START(ARMADA_XP_DT, "Marvell Armada 370/XP (Device Tree)")
 	.smp		= smp_ops(armada_xp_smp_ops),
 	.init_machine	= armada_370_xp_dt_init,
+	.init_early	= armada_370_xp_init_early,
 	.map_io		= armada_370_xp_map_io,
-	.init_time	= armada_370_xp_timer_and_clk_init,
 	.restart	= mvebu_restart,
 	.dt_compat	= armada_370_xp_dt_compat,
 MACHINE_END

--------------000709030907080105060607--
