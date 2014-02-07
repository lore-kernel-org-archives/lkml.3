Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752319AbaBGQS1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 11:18:27 -0500
Received: from yotta.elopez.com.ar ([31.220.24.173]:33155 "EHLO
	yotta.elopez.com.ar" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751463AbaBGQS0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 11:18:26 -0500
Message-ID: <52F506E4.8070900@elopez.com.ar>
Date: Fri, 07 Feb 2014 13:16:36 -0300
From: =?UTF-8?B?RW1pbGlvIEzDs3Bleg==?= <emilio@elopez.com.ar>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Jason Cooper <jason@lakedaemon.net>
CC: Mike Turquette <mturquette@linaro.org>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Andrew Lunn <andrew@lunn.ch>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: Re: [PATCH] clk: respect the clock dependencies in of_clk_init
References: <1391554766-11285-1-git-send-email-gregory.clement@free-electrons.com> <52F4DA40.4090804@elopez.com.ar> <20140207142430.GU8533@titan.lakedaemon.net> <20140207144325.GA8218@localhost> <52F4F279.6010006@free-electrons.com> <52F4F502.2010703@elopez.com.ar> <52F4F7EF.7090900@free-electrons.com>
In-Reply-To: <52F4F7EF.7090900@free-electrons.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gregory,

El 07/02/14 12:12, Gregory CLEMENT escribió:
> On 07/02/2014 16:00, Emilio López wrote:
>> El 07/02/14 11:49, Gregory CLEMENT escribió:
>>> On 07/02/2014 15:43, Ezequiel Garcia wrote:
>>>> On Fri, Feb 07, 2014 at 09:24:30AM -0500, Jason Cooper wrote:
>>>>> On Fri, Feb 07, 2014 at 10:06:08AM -0300, Emilio López wrote:
>>>>>
>>>>> [snip a great explanation]
>>>>>
>>>>> Guys, can I get some Tested-by's on this?
>>>>>
>>>>
>>>> In case someone missed Emilio's comment about it, I gave his oneliner
>>>> a test on A370 Reference Design. It worked just as well as Sebastian's.
>>>
>>> Well ok it's working but this patch is not better than Sebastian, it is
>>> even worth. I don't think it is a good idea at all to totally ignore the
>>> information given by the device tree.
>>
>> With a bit more work, you can replace the clk_get magic with a call to
>> of_clk_get_parent_name() or similar to be able to keep overriding stuff
>> from DT. This way it would completely match the behaviour on
>> mvebu_coreclk_setup (default to "tclk", allow overriding with DT).
>>
>
> I think you didn't have a look on our implementation:

I did, several times in fact.

> the name of the clock
> are created by the driver during the initialization.

The name of the clock is always "tclk", as hardcoded on the driver, 
unless overridden via clock-output-names from DT (see 
mvebu_coreclk_setup). Currently none of your DT that I can see does 
this, so in practice it's always "tclk".

> That's why we need that
> the parent clock are initialized before the gating clock.

You don't really *need* that. The driver just does that because it may 
have been convenient at the time and it worked. Defaulting to "tclk" on 
mvebu_clk_gating_setup and overriding it if it turns out it has some 
other name on the DT (just like on mvebu_coreclk_setup!) should work as 
well, and doesn't require complex, bloaty, dependency management.

Rough, untested patch below, so you get the idea.

Cheers,

Emilio



---
  drivers/clk/mvebu/common.c | 13 +++++++------
  1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/clk/mvebu/common.c b/drivers/clk/mvebu/common.c
index 25ceccf..730625b 100644
--- a/drivers/clk/mvebu/common.c
+++ b/drivers/clk/mvebu/common.c
@@ -119,19 +119,20 @@ void __init mvebu_clk_gating_setup(struct 
device_node *np,
  				   const struct clk_gating_soc_desc *desc)
  {
  	struct clk_gating_ctrl *ctrl;
-	struct clk *clk;
  	void __iomem *base;
-	const char *default_parent = NULL;
+	struct of_phandle_args clkspec;
+	const char *default_parent = "tclk";
  	int n;

  	base = of_iomap(np, 0);
  	if (WARN_ON(!base))
  		return;

-	clk = of_clk_get(np, 0);
-	if (!IS_ERR(clk)) {
-		default_parent = __clk_get_name(clk);
-		clk_put(clk);
+	if (!of_parse_phandle_with_args(np, "clocks", "#clock-cells", 0, 
&clkspec)) {
+		of_property_read_string_index(clkspec.np, "clock-output-names",
+					      clkspec.args_count ? clkspec.args[0] : 0,
+					      &default_parent);
+		of_node_put(clkspec.np);
  	}

  	ctrl = kzalloc(sizeof(*ctrl), GFP_KERNEL);
-- 
1.8.5.3
