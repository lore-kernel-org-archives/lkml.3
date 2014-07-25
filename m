Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753817AbaGYRq5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 13:46:57 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:48337 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753217AbaGYRq4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 13:46:56 -0400
From: Grygorii Strashko <grygorii.strashko@ti.com>
To: <santosh.shilimkar@ti.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        <khilman@linaro.org>, Geert Uytterhoeven <geert+renesas@glider.be>,
        <linux-pm@vger.kernel.org>
CC: <ben.dooks@codethink.co.uk>, <laurent.pinchart@ideasonboard.com>,
        <grant.likely@secretlab.ca>, <ulf.hansson@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-sh@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [RFC PATCH 2/3] PM / clock_ops: allow to specify custom pm_clk_notifier callback
Date: Fri, 25 Jul 2014 21:31:35 +0300
Message-ID: <1406313096-29761-3-git-send-email-grygorii.strashko@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1406313096-29761-1-git-send-email-grygorii.strashko@ti.com>
References: <1406313096-29761-1-git-send-email-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The CLK PM domain assumes that platform code should always provide
list of Connection IDs of the clock (con_id) in
pm_clk_notifier_block structure. Then CLK PM domain uses these con_ids
to setup list of clocks per device.

Such approach is inconvenient when devices can have different number
of clocks. For example, if maximum number of clocks used by
device is 4 the pm_clk_notifier_block structure will look like:

static struct pm_clk_notifier_block platform_domain_notifier = {
	.pm_domain = &keystone_pm_domain,
	.con_ids = { "fck", "opt1", "opt2", "opt3", NULL },
};

More over, clocks in DT have to be named using only con_ids:
	clocks = <&paclk13>, <&clkcpgmac>, <&chipclk12>;
	clock-names = "fck", "opt1", "opt2";

This patch allow to specify custom pm_clk_notifier callback from
platform code and in such way makes CLK PM domain initialization
more flexible. For example, Keystone 2 will provide custom callback
to fill list of clocks for Device with all clocks assigned to this
Device in DT.

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 drivers/base/power/clock_ops.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/base/power/clock_ops.c b/drivers/base/power/clock_ops.c
index 2d5c9c1..c103598 100644
--- a/drivers/base/power/clock_ops.c
+++ b/drivers/base/power/clock_ops.c
@@ -520,6 +520,7 @@ void pm_clk_add_notifier(struct bus_type *bus,
 	if (!bus || !clknb)
 		return;
 
-	clknb->nb.notifier_call = pm_clk_notify;
+	if (!clknb->nb.notifier_call)
+		clknb->nb.notifier_call = pm_clk_notify;
 	bus_register_notifier(bus, &clknb->nb);
 }
-- 
1.7.9.5

