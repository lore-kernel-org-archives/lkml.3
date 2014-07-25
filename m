Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935044AbaGYRrs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 13:47:48 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:48340 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753254AbaGYRq4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
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
Subject: [RFC PATCH 0/3] PM / clock_ops: allow to specify custom pm_clk_notifier callback
Date: Fri, 25 Jul 2014 21:31:33 +0300
Message-ID: <1406313096-29761-1-git-send-email-grygorii.strashko@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The CLK PM domain (clock_ops.c) assumes that platform code should always provide
list of Connection IDs of the clock (con_id) in pm_clk_notifier_block structure.
Then CLK PM domain uses these con_ids to setup list of clocks per device.

Such approach is inconvenient when devices can have different number
of clocks. For example, if maximum number of clocks used by
devices is 4 the pm_clk_notifier_block structure will look like:

static struct pm_clk_notifier_block platform_domain_notifier = {
	.pm_domain = &keystone_pm_domain,
	.con_ids = { "fck", "opt1", "opt2", "opt3", NULL },
};

More over, clocks in DT have to be named using only above con_ids:
	clocks = <&paclk13>, <&clkcpgmac>, <&chipclk12>;
	clock-names = "fck", "opt1", "opt2";

It makes hard to enable/support Runtime PM in case when some HW modules are used
by different SoCs or there are few version of the same SoC, because clock trees
can be changed significantly in all such cases.

This patch set allows to specify custom pm_clk_notifier callback from
platform code and in such way makes CLK PM domain initialization
more flexible. Also, It updates Keystone 2 platform code to provide custom
callback which fills list of clocks for Device with all clocks assigned to this
Device in DT.
More over, It's safe for Keystone 2 to perform CLK PM domain initialization
at device's binding time instead of device's creation time.

I've posted these patches because I need fully enable Runtime PM on Keystone 2
where all HW modules are controlled using clocks only. That's why CLK PM domain 
fits our needs perfectly. Also, on Keystone 2 clocks are initialized early and
they are available at device creation time. The main problems from my side are:
 - every time when support for new HW modules is added the ".con_ids" array 
   need to be checked and updated;
 - restriction for clock's names in DT - to be named using only above con_ids
   It's ugly.

I hope, this approach to be accepted at least as temporal solution until 
the generic solution is not found.

Thanks for your comments!

PS: patch 1 was reused from [1].

Regards,
-grygorii

[1] Previously, same problem was discussed in, but no final solution was accepted:
 "[PATCH/RFC 0/4] of: Register clocks for Runtime PM with PM core"
 https://lkml.org/lkml/2014/4/24/1118

Geert Uytterhoeven (1):
  PM / clock_ops: Add pm_clk_add_clk()

Grygorii Strashko (2):
  PM / clock_ops: allow to specify custom pm_clk_notifier callback
  ARM: keystone: pm_domain: setup clk pm domain clocks from DT

 arch/arm/mach-keystone/pm_domain.c |   46 ++++++++++++++++++++++++++++++++++++
 drivers/base/power/clock_ops.c     |   43 ++++++++++++++++++++++++---------
 include/linux/pm_clock.h           |    3 +++
 3 files changed, 81 insertions(+), 11 deletions(-)

-- 
1.7.9.5

