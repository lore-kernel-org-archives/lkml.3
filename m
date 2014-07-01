Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755217AbaGAAMo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 20:12:44 -0400
Received: from mail-bl2lp0205.outbound.protection.outlook.com ([207.46.163.205]:46479
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752011AbaGAAMm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 20:12:42 -0400
Date: Mon, 30 Jun 2014 17:12:23 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Boris BREZILLON <boris.brezillon@free-electrons.com>
CC: Mike Turquette <mturquette@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, <linux-pm@vger.kernel.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Michal Simek <michal.simek@xilinx.com>, <cpufreq@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/4] clk: Introduce 'clk_find_nearest_rate()'
References: <1404147396-8041-1-git-send-email-soren.brinkmann@xilinx.com>
 <1404147396-8041-2-git-send-email-soren.brinkmann@xilinx.com>
 <20140630212707.1eb44db6@bbrezillon>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140630212707.1eb44db6@bbrezillon>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <475a8ee0-11aa-4fad-94dc-9e5360f298d2@BL2FFO11FD028.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(438002)(189002)(199002)(24454002)(51704005)(377424004)(164054003)(85852003)(83072002)(99396002)(50986999)(79102001)(87936001)(85306003)(77096002)(74316001)(33646001)(31696002)(92566001)(83506001)(85182001)(15975445006)(53416004)(1496007)(107046002)(76176999)(102836001)(85202003)(106466001)(561944003)(50466002)(54356999)(77982001)(64706001)(20776003)(47776003)(92726001)(23676002)(19580405001)(44976005)(19580395003)(83322001)(21056001)(76482001)(80022001)(95666004)(86362001)(104016002)(70736001)(74502001)(46102001)(4396001)(81542001)(74662001)(6806004)(31966008)(81342001)(107986001);DIR:OUT;SFP:;SCL:1;SRVR:BL2FFO11HUB059;H:xsj-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-60-83.xilinx.com;MX:1;A:1;LANG:en;
X-OriginatorOrg: xilinx.onmicrosoft.com
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 02596AB7DA
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=soren.brinkmann@xilinx.com; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Boris,

On Mon, 2014-06-30 at 09:27PM +0200, Boris BREZILLON wrote:
> Hello Soren,
> 
> On Mon, 30 Jun 2014 09:56:33 -0700
> Soren Brinkmann <soren.brinkmann@xilinx.com> wrote:
> 
> > Introduce a new API function to find the rate a clock can provide
> > which is closest to a given rate.
> > 
> > clk_round_rate() leaves it to the clock driver how rounding is done.
> > Commonly implementations round down due to use-cases that have a
> > certain frequency maximum that must not be exceeded.
> 
> I had the same concern (how could a driver decide whether it should
> round up, down or to the closest value), but had a slightly different
> approach in mind.
> 
> AFAIU, you're assuming the clock is always a power of two (which is
> true most of the time, but some clock implementation might differ,
> i.e. a PLL accept any kind of multiplier not necessarily a power of 2).

No, the idea is to always work. There should not be any such limitation.
Where do you see that?

> 
> How about improving the clk_ops interface instead by adding a new method
> 
> 	long (*round_rate_with_constraint)(struct clk_hw *hw,
> 					   unsigned long requested_rate,
> 					   unsigned long *parent_rate,
> 					   enum clk_round_type type);
> 
> with
> 
> enum clk_round_type {
> 	CLK_ROUND_DOWN,
> 	CLK_ROUND_UP,
> 	CLK_ROUND_CLOSEST,
> };

I thought about that, but the find_nearest() did already exist more or
less and in the end it is not much of a difference, IMHO. If it turns out that
the others are needed as well and somebody implements it, they could be
added as another convenience function like I did, and/or it could be
wrapped in the function you propose here.

> 
> or just adding these 3 methods:
> 
> 	long (*round_rate_up)(struct clk_hw *hw,
> 			      unsigned long requested_rate,
> 			      unsigned long *parent_rate);
> 
> 	long (*round_rate_down)(struct clk_hw *hw,
> 				unsigned long requested_rate,
> 				unsigned long *parent_rate);
> 
> 	long (*round_rate_closest)(struct clk_hw *hw,
> 				   unsigned long requested_rate,
> 				   unsigned long *parent_rate);

That would be quite a change for clock drivers. So far, there are not many
restrictions on round_rate. I think there has already been a discussion
in this direction that went nowhere. https://lkml.org/lkml/2010/7/14/260

> 
> and let the round_rate method implement the default behaviour.

There is no real default. Rounding is not specified for the current API.

> 
> This way you could add 3 functions to the API:
> 
> clk_round_closest (or clk_find_nearest_rate as you called it),
> clk_round_up and clk_round_down, and let the clk driver implementation
> return the appropriate rate.

I'd say the current patch set does kind of align with that, doesn't it?
We can add the find_nearest_rate() (there was a discussion on the name,
ane we decided against round_closest in favor of the current proposal)
now and the other functions could be added later if people find them to
be useful. And if they all get added we can think about consolidating
them if it made sense.

	Thanks,
	Sören

