Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751561Ab3EIFSy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 01:18:54 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:47201 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864Ab3EIFSw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 01:18:52 -0400
X-IronPort-AV: E=Sophos;i="4.87,638,1363158000"; 
   d="scan'208";a="45617293"
From: Saravana Kannan <skannan@codeaurora.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Mike Turquette <mturquette@linaro.org>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, Stephen Boyd <sboyd@codeaurora.org>
Subject: [PATCH 0/3] Fix disable of unused clk/regulator with deferred probe
Date: Wed,  8 May 2013 22:18:43 -0700
Message-Id: <1368076726-11492-1-git-send-email-skannan@codeaurora.org>
X-Mailer: git-send-email 1.7.8.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clock and regulator frameworks have support for disabling unused clocks and
regulators at system init to save power when bootloaders leave them in a less
than desirable state. If no driver has requested for a clock/regulator to be
ON by the time kernel init reaches late_initcall level, they were considered
unused.

This worked well/good enough for compiled in drivers before deferred probe
was introduced. But with deferred probe, it's quite likely that devices that
match with compiled in drivers will continue to probe well past late_initcall
(at least as far as I can understand). So, we need to wait for deferred
probing during kernel init to complete before we do the disable of unused
clocks/regulators.

If there's a better or more obvious solution, I'm all ears. Another approach
would have been to add a "probe_done_initcall" level. But that seems overkill
and I don't think adding yet another initcall level is a great idea.

Thanks,
Saravana

Saravana Kannan (3):
  driver core: Add API to wait for deferred probe to complete during
    init
  clk: Disable unused clocks after deferred probing is done
  regulator: core: Disable unused regulators after deferred probing is
    done

 drivers/base/dd.c        |    8 ++++++++
 drivers/clk/clk.c        |    4 +++-
 drivers/regulator/core.c |    4 +++-
 include/linux/device.h   |    1 +
 4 files changed, 15 insertions(+), 2 deletions(-)

-- 
1.7.8.3

The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
