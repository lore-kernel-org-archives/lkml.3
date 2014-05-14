Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754000AbaENWdI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 18:33:08 -0400
Received: from mail-qg0-f43.google.com ([209.85.192.43]:44504 "EHLO
	mail-qg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752694AbaENWdG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 18:33:06 -0400
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Mike Turquette <mturquette@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Russell King <linux@arm.linux.org.uk>
Cc: Michal Simek <michal.simek@xilinx.com>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        cpufreq@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Soren Brinkmann <soren.brinkmann@xilinx.com>
Subject: [RFC PATCH 0/5] Frequency resolution in CCF vs. cpufreq
Date: Wed, 14 May 2014 15:30:50 -0700
Message-Id: <1400106655-22465-1-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 1.9.3.1.ga73a6ad
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have one or two problems with cpufreq and the CCF, which are caused by
rounding/different frequency resolutions.

cpufreq works with kHz, while the CCF uses Hz. On Zynq our default frequency is
666666666 Hz which the CCF, due to rounding, reports as 666666660. And for
cpufreq, which simply divides values it obtains through clk_round_rate() by
1000, 666666.
Since passing 666666 to clk_round_rate() does not result in 666666660
(clk_round_rate() always rounds down!), we chose to put 666667 in the OPP. This
causes issue 1: cpufreq stats are broken.
The OPP is 666667 but clk_get_rate(CPU)/1000 is 666666. Hence the stats module
cannot match the frequency to an OPP.
This is what I address in patch 1, by allowing small deviations when matching a
frequency to an OPP.

Then when looking at our second OPP: 333334. Similar, due to rounding problems
the frequency ends on 4 instead of 3. I think it would be nice if I could
specify the 333333 directly (the 4 there does not really make sense).
That is addressed in patches 2 and 3. Those introduce a new API call for the
CCF (I revived some really old code) which rounds to the closest possible
frequency, as opposed to the closest possible one that does not exceed the
requested. And then we use this function in the cpufreq-cpu0 driver instead.

And finally patch 5, another case where the new API call makes sense.

	Thanks,
	Sören


Soren Brinkmann (5):
  cpufreq: stats: Allow small rounding errors
  clk: Introduce 'clk_round_rate_nearest()'
  cpufreq: cpu0: Use clk_round_rate_nearest()
  ARM: zynq: dt: Use properly rounded frequencies in OPPs
  net: macb: Use clk_round_rate_nearest() API

 arch/arm/boot/dts/zynq-7000.dtsi    |  4 ++--
 drivers/clk/clk.c                   | 26 ++++++++++++++++++++++++--
 drivers/cpufreq/cpufreq-cpu0.c      |  3 ++-
 drivers/cpufreq/cpufreq_stats.c     |  2 +-
 drivers/net/ethernet/cadence/macb.c |  2 +-
 include/linux/clk.h                 | 14 ++++++++++++--
 6 files changed, 42 insertions(+), 9 deletions(-)

-- 
1.9.3.1.ga73a6ad

