Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752792Ab3BRLiH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 06:38:07 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:33211 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752463Ab3BRLiD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 06:38:03 -0500
From: Afzal Mohammed <afzal@ti.com>
To: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: Russell King <linux@arm.linux.org.uk>, Tony Lindgren <tony@atomide.com>,
        Marc Zyngier <marc.zyngier@arm.com>, Nicolas Pitre <nico@linaro.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Will Deacon <will.deacon@arm.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Landley <rob@landley.net>, Sekhar Nori <nsekhar@ti.com>,
        Syed Mohammed Khasim <khasim@ti.com>
Subject: [PATCH, RFC 2/8] ARM: twd: register clock event for 1 core SMP
Date: Mon, 18 Feb 2013 17:07:47 +0530
Message-ID: <a7f62b8580aa4b33d5658f4f03371a453adaea9b.1361186097.git.afzal@ti.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <cover.1361186097.git.afzal@ti.com>
References: <cover.1361186097.git.afzal@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Register percpu local timer for scheduler tick in the case of one core
SMP configuration. In other cases - secondary cpu's as well as boot
cpu's having more than one core, this is being registered as per
existing boot flow, with a difference that they happens after delay
calibration. Registering the clock for tick in case of one core should
be done before Kernel calibrates delay (this is required to boot,
unless local timer is the only one registered for tick). Registering
twd local timer at init_time (which platforms are doing now) helps
achieve that with the proposed change.

This helps in an almost booting Kernel (minimal) by only relying on
ARM parts for an A9 one core SMP.

Signed-off-by: Afzal Mohammed <afzal@ti.com>
---
 arch/arm/kernel/smp_twd.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm/kernel/smp_twd.c b/arch/arm/kernel/smp_twd.c
index 616268c..118f4f2 100644
--- a/arch/arm/kernel/smp_twd.c
+++ b/arch/arm/kernel/smp_twd.c
@@ -335,6 +335,9 @@ static int __init twd_local_timer_common_register(struct device_node *np)
 
 	twd_get_clock(np);
 
+	if (num_possible_cpus() == 1)
+		twd_timer_setup(evt);
+
 	return 0;
 
 out_irq:
-- 
1.7.12

