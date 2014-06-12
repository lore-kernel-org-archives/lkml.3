Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933597AbaFLQGv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 12:06:51 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:51691 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756228AbaFLQGV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 12:06:21 -0400
From: Grygorii Strashko <grygorii.strashko@ti.com>
To: <geert+renesas@glider.be>
CC: <laurent.pinchart@ideasonboard.com>, <ulf.hansson@linaro.org>,
        <khilman@linaro.org>, <grant.likely@secretlab.ca>,
        <mturquette@linaro.org>, <tomasz.figa@gmail.com>,
        <ben.dooks@codethink.co.uk>, <horms@verge.net.au>,
        <magnus.damm@gmail.com>, <rjw@rjwysocki.net>,
        <linux-sh@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [RFC PATCH 0/2] use named clocks list to register clocks for PM clock domain
Date: Thu, 12 Jun 2014 19:53:41 +0300
Message-ID: <1402592023-13416-1-git-send-email-grygorii.strashko@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1398334403-26181-1-git-send-email-geert+renesas@glider.be>
References: <1398334403-26181-1-git-send-email-geert+renesas@glider.be>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Geert,

I've spent some time testing your patches on Keystone 2 SoC as I am interested 
in these patches.

The Keystone 2 is pure DT platform, but we reuse some Drivers from Davinci SoC.
Now I have to dial with following problem:
- Some modules on Keystone need more then one clock to be managed by PM clock.
  As result, I can solve this by filling cond_id list in  structure
  pm_clk_notifier_block.
  For example:
  static struct pm_clk_notifier_block platform_domain_notifier = {
	.pm_domain = &keystone_pm_domain,
	.con_ids = { "fck", "master", "slave", NULL },
	};
  But, in this case I'll need to add names for all clocks or rename existed
  clock's names in DT to be compatible with above list, like: 
	clock-names = "gpio"; -> clock-names = "fck";
    - or -
    clocks = <&clkspi>;
	+ clock-names = "fck";

Your series gracefully solves this problem for me, but I'd like to avoid
to use new CLK flag CLK_RUNTIME_PM, because:
 - The same driver is used for all gated clocks for Keystone (and probably for
   other SoCs)
 - Some gated clocks can be optional.
Taking into account above, driver for gated clock will need to maintain additional
information internally about clocks which are suitable for Runtime PM - 
it is too hard to support :(.

Therefore, I propose a solution which allows to specify clocks suitable for
Runtime PM in DT using special property "clkops-clocks" (name can be changed:).

Another possible option is to use DT definition like this:
	spi2: spi@21000800 {
		compatible = "ti,dm6441-spi";
		reg = <0x21000800 0x200>;
		num-cs = <4>;
		ti,davinci-spi-intr-line = <0>;
		interrupts = <GIC_SPI 300 IRQ_TYPE_EDGE_RISING>;
->		clkops-clocks {
->			clocks = <&clkspi>;
->		}
	}

Regarding supporting of EPROBE_DEFER, in my opinion simplest solution would be to
call of_clk_register_runtime_pm_clocks() directly from drivers.
Another option 1, call of_clk_register_runtime_pm_clocks() before driver's probing 
seems will be banned by Greg and Rafael.
Another option 2, continue to use Bus notifiers, but then error path need to be
handled somehow. Now BUS_NOTIFY_BIND_DRIVER even is sent before probing, but 
it seems that nothing is sent in case if probe was failed.

Grygorii Strashko (2):
  clk: of: introduce of_clk_get_from_set()
  of/clk: use "clkops-clocks" to specify clocks handled by clock_ops
    domain

 drivers/clk/clkdev.c |   24 ++++++++++++++++++++++--
 drivers/of/of_clk.c  |    7 ++-----
 include/linux/clk.h  |    7 +++++++
 3 files changed, 31 insertions(+), 7 deletions(-)

-- 
1.7.9.5

