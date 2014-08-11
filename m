Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754862AbaHKWog (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 18:44:36 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:37700 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752591AbaHKWoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 18:44:34 -0400
From: Gregory Fong <gregory.0xf0@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Russell King <linux@arm.linux.org.uk>, Will Deacon <will.deacon@arm.com>,
        Matt Porter <mporter@linaro.org>, Christian Daudt <bcm@fixthebug.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Brian Norris <computersforpeace@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Marc Carino <marc.ceeeee@gmail.com>,
        Kevin Cernekee <cernekee@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Gregory Fong <gregory.0xf0@gmail.com>
Subject: [PATCH] ARM: Explain workaround for faulty ISAR0 register on B15
Date: Mon, 11 Aug 2014 15:44:13 -0700
Message-Id: <1407797053-12544-1-git-send-email-gregory.0xf0@gmail.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Brahma-B15 CPU design, like Krait, incorrectly indicates that it
only supports UDIV and SDIV instructions in Thumb mode when it
actually supports them in ARM and Thumb mode.  This is apparently
because it follows the DDI0406B ARM ARM which has two values for the
divide instruction field, instead of the DDI0406C ARM ARM which has
three values.

Work around this problem by forcing the hwcaps to indicate support for
UDIV and SDIV in both ARM and Thumb modes.

Signed-off-by: Gregory Fong <gregory.0xf0@gmail.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
---

Will and Mark had both asked whether Brahma-B15 has a wrong value for ISAR0:
http://lists.infradead.org/pipermail/linux-arm-kernel/2014-January/225895.html
http://lists.infradead.org/pipermail/linux-arm-kernel/2014-January/227916.html

This should clear up the matter, sorry it took so long!

 arch/arm/mm/proc-v7.S | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm/mm/proc-v7.S b/arch/arm/mm/proc-v7.S
index b5d67db..7706986 100644
--- a/arch/arm/mm/proc-v7.S
+++ b/arch/arm/mm/proc-v7.S
@@ -570,6 +570,11 @@ __v7_ca15mp_proc_info:
 __v7_b15mp_proc_info:
 	.long	0x420f00f0
 	.long	0xff0ffff0
+	/*
+	 * Brahma-B15 processors don't indicate support for SDIV and UDIV
+	 * instructions in the ARM instruction set, even though they actually
+	 * do support them.
+	 */
 	__v7_proc __v7_b15mp_setup, hwcaps = HWCAP_IDIV
 	.size	__v7_b15mp_proc_info, . - __v7_b15mp_proc_info
 
-- 
1.8.3.2

