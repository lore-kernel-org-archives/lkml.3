Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752552AbaESAx0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2014 20:53:26 -0400
Received: from mail-bl2lp0207.outbound.protection.outlook.com ([207.46.163.207]:51942
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752221AbaESAxZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2014 20:53:25 -0400
Date: Sun, 18 May 2014 17:51:05 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
CC: Mike Turquette <mturquette@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Michal Simek <michal.simek@xilinx.com>, <linux-pm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <cpufreq@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC PATCH 2/5] clk: Introduce 'clk_round_rate_nearest()'
References: <1400106655-22465-1-git-send-email-soren.brinkmann@xilinx.com>
 <1400106655-22465-3-git-send-email-soren.brinkmann@xilinx.com>
 <20140515073816.GI16662@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140515073816.GI16662@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <91822600-39d0-4e71-b0f5-9eda35b76ec0@BN1AFFO11FD016.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(438001)(189002)(199002)(164054003)(85852003)(46102001)(99396002)(85182001)(23676002)(19580395003)(74662001)(83072002)(47776003)(80022001)(74502001)(31696002)(83506001)(87936001)(92566001)(53416003)(77982001)(74316001)(20776003)(19580405001)(92726001)(83322001)(79102001)(76482001)(76176999)(50986999)(70736001)(85202002)(44976005)(86362001)(31966008)(81542001)(54356999)(81342001)(50466002)(33646001)(4396001)(217873001);DIR:OUT;SFP:;SCL:1;SRVR:BN1AFFO11HUB042;H:xsj-gw1;FPR:;MLV:sfv;PTR:unknown-60-83.xilinx.com;MX:1;A:1;LANG:en;
X-OriginatorOrg: xilinx.onmicrosoft.com
X-Forefront-PRVS: 021670B4D2
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=soren.brinkmann@xilinx.com; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I spent some time finding an alternative implementation for
clk_round_rate_nearest, the result can be found below.
I hope this is closer to a working implementation.

	Thanks,
	Sören


------------------8<-----------------8<---------------------8<-------------8<---
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
Date: Tue, 2 Apr 2013 10:08:13 -0700
Subject: [PATCH] clk: Introduce 'clk_round_rate_nearest()'

Introduce a new API function to round a rate to the closest possible
rate the HW clock can generate.
In contrast to 'clk_round_rate()' which works similar, but always returns
a frequency <= its input rate.

Cc: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
---
 drivers/clk/clk.c   | 43 +++++++++++++++++++++++++++++++++++++++++--
 include/linux/clk.h | 14 ++++++++++++--
 2 files changed, 53 insertions(+), 4 deletions(-)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index dff0373f53c1..faf24d0569df 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -1011,8 +1011,9 @@ unsigned long __clk_round_rate(struct clk *clk, unsigned long rate)
  * @rate: the rate which is to be rounded
  *
  * Takes in a rate as input and rounds it to a rate that the clk can actually
- * use which is then returned.  If clk doesn't support round_rate operation
- * then the parent rate is returned.
+ * use and does not exceed the requested frequency, which is then returned.
+ * If clk doesn't support round_rate operation then the parent rate
+ * is returned.
  */
 long clk_round_rate(struct clk *clk, unsigned long rate)
 {
@@ -1027,6 +1028,44 @@ long clk_round_rate(struct clk *clk, unsigned long rate)
 EXPORT_SYMBOL_GPL(clk_round_rate);
 
 /**
+ * clk_round_rate_nearest - round the given rate for a clk
+ * @clk: the clk for which we are rounding a rate
+ * @rate: the rate which is to be rounded
+ *
+ * Takes in a rate as input and rounds it to the closest rate that the clk
+ * can actually use which is then returned. If clk doesn't support
+ * round_rate operation then the parent rate is returned.
+ */
+long clk_round_rate_nearest(struct clk *clk, unsigned long rate)
+{
+	unsigned long lower, upper, cur, lower_last, upper_last;
+
+	lower = clk_round_rate(clk, rate);
+	if (lower >= rate)
+		return lower;
+
+	upper = clk_round_rate(clk, rate + rate - lower);
+	if (upper == lower)
+		return upper;
+
+	lower = rate + 1;
+	do {
+		upper_last = upper;
+		lower_last = lower;
+
+		cur = clk_round_rate(clk, lower + ((upper - lower) >> 1));
+		if (cur < lower)
+			lower += (upper - lower) >> 1;
+		else
+			upper = cur;
+
+	} while (lower_last != lower && upper_last != upper);
+
+	return upper;
+}
+EXPORT_SYMBOL_GPL(clk_round_rate_nearest);
+
+/**
  * __clk_notify - call clk notifier chain
  * @clk: struct clk * that is changing rate
  * @msg: clk notifier type (see include/linux/clk.h)
diff --git a/include/linux/clk.h b/include/linux/clk.h
index fb5e097d8f72..2f83bf030ac6 100644
--- a/include/linux/clk.h
+++ b/include/linux/clk.h
@@ -255,15 +255,25 @@ void devm_clk_put(struct device *dev, struct clk *clk);
 
 
 /**
- * clk_round_rate - adjust a rate to the exact rate a clock can provide
+ * clk_round_rate - round a rate to the exact rate a clock can provide not
+ *		    exceeding @rate
  * @clk: clock source
  * @rate: desired clock rate in Hz
  *
- * Returns rounded clock rate in Hz, or negative errno.
+ * Returns rounded clock rate in Hz, or parent rate
  */
 long clk_round_rate(struct clk *clk, unsigned long rate);
 
 /**
+ * clk_round_rate_nearest - round a rate to the exact rate a clock can provide
+ * @clk: the clk for which we are rounding a rate
+ * @rate: the rate which is to be rounded
+ *
+ * Returns rounded clock rate in Hz, or parent rate
+ */
+long clk_round_rate_nearest(struct clk *clk, unsigned long rate);
+
+/**
  * clk_set_rate - set the clock rate for a clock source
  * @clk: clock source
  * @rate: desired clock rate in Hz
-- 
1.9.3.1.ga73a6ad


