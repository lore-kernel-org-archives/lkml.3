Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753426Ab3DKQRh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 12:17:37 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:27898 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752270Ab3DKQRf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 12:17:35 -0400
X-AuditID: cbfec7f4-b7f4c6d0000018de-d1-5166e21d760e
Message-id: <5166E21C.7080009@samsung.com>
Date: Thu, 11 Apr 2013 18:17:32 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Kukjin Kim <kgene.kim@samsung.com>,
        Sangbeom Kim <sbkim73@samsung.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH 2/2] mfd: wm8994: Add some OF properties
References: <1365604763-13122-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1365604763-13122-2-git-send-email-broonie@opensource.wolfsonmicro.com>
 <5166BCCC.5020307@samsung.com>
 <20130411142100.GA24971@opensource.wolfsonmicro.com>
In-reply-to: <20130411142100.GA24971@opensource.wolfsonmicro.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLLMWRmVeSWpSXmKPExsVy+t/xy7qyj9ICDd4ukbb4N/sUm8WB2Q9Z
	LXoXXGWzuLxrDpvF8rf/2SxOd7NaXFzxhcmB3WPeyUCP8zMWMnq8nPibzaNvyypGj8+b5AJY
	o7hsUlJzMstSi/TtErgyLh6Zx1YwSaWi7+lc9gbGZbJdjJwcEgImEkfmtTND2GISF+6tZ+ti
	5OIQEljKKHHw0Rx2COcTo0T3pClgVbwCWhK97yeygtgsAqoS12dcYgex2QQMJXqP9jGC2KIC
	ARKLl5xjh6gXlPgx+R5LFyMHhwjQtt/3K0FmMgvcYZRo/3oDbI6wgI3E1htnmCGWfWeUWNR1
	H6yZU8BR4v6+W2BDmQV0JPa3TmODsOUlNq95yzyBUWAWkh2zkJTNQlK2gJF5FaNoamlyQXFS
	eq6hXnFibnFpXrpecn7uJkZIkH/Zwbj4mNUhRgEORiUeXoXm1EAh1sSy4srcQ4wSHMxKIrwx
	e9MChXhTEiurUovy44tKc1KLDzEycXBKNTCmvj03Ic7Z7hfzkotNq9f8fnk7VDOhQLD7ubPV
	ym+HZxkon1hgc6yJ0yaGc239xvM+Nz3XbCm6Kh9Ucu/bsRRWE/EbQV+eBgUldQV6t9RYr0mL
	nfTE1PQ8b0urCuOXz/7GgQuCFzbHBVsvOSKVxGXzs+SRv0vIXLd1EVqCn19djIyau9b21DYl
	luKMREMt5qLiRABXsZyBUAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11/2013 04:21 PM, Mark Brown wrote:
> On Thu, Apr 11, 2013 at 03:38:20PM +0200, Sylwester Nawrocki wrote:
>> On 04/10/2013 04:39 PM, Mark Brown wrote:
> 
>>> Untested at present.
> 
>> I've tested it with wm1811 codec and found a few issues/things that are 
>> a bit confusing to me.
> 
> Wasn't kidding about the lack of testing!

Anyway it worked pretty well! Just needed to add patches for the regulator
you pointed out and that small patch:

--8<-----------
>From e306f6683d17c3f6aafaae44395548f4703382c8 Mon Sep 17 00:00:00 2001
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Date: Thu, 11 Apr 2013 17:42:51 +0200
Subject: [PATCH] regulator: wm8994: Use GPIO parsed from DT when registering
 regulators

Ensure the regulators are registered with a GPIO parsed from the device
tree when available.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
---
 drivers/regulator/wm8994-regulator.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/regulator/wm8994-regulator.c
b/drivers/regulator/wm8994-regulator.c
index 086be66..dab41ae 100644
--- a/drivers/regulator/wm8994-regulator.c
+++ b/drivers/regulator/wm8994-regulator.c
@@ -149,9 +149,11 @@ static int wm8994_ldo_probe(struct platform_device *pdev)
 	config.init_data = &ldo->init_data;
 	if (pdata)
 		config.ena_gpio = pdata->ldo[id].enable;
+	else if (wm8994->dev->of_node)
+		config.ena_gpio = wm8994->pdata.ldo[id].enable;

 	/* Use default constraints if none set up */
-	if (!pdata || !pdata->ldo[id].init_data) {
+	if (!pdata || !pdata->ldo[id].init_data || wm8994->dev->of_node) {
 		dev_dbg(wm8994->dev, "Using default init data, supply %s %s\n",
 			ldo->supply.dev_name, ldo->supply.supply);

-- 
1.7.9.5
--8<-----------

If needed I can resend it to you. Or do suggest please anything more relevant.

>>> +  - AVDD2-supply, DBVDD1-supply, DBVDD2-supply, DBVDD3-supply, CPVDD-supply,
>>> +    SPKVDD1-supply, SPKVDD2-supply : power supplies for the device, as covered
> 
>> These capitalized regulator supply names look like standard ones. Sorry, 
>> I'm quite new to all this ASoC stuff. I was wondering, what about LDO1, LDO2
>> regulators that are present in the wm1811 chip for instance ? Are those
>> regulators supposed to be associated with some of the supply names above ?
> 
>> AFAICS LDO1, LDO2 need to be enabled before we can actually perform any I2C 
>> communication.
> 
> Since all designs I've ever seen for this chip use the internal
> regulators in a consistent fashion I've added support for setting up the
> standard hookup by default so users don't need to specify this by hand
> since that wound up being repetitive and boring.  This is in -next or
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regulator.git topic/wm8994
> 
> and should show up in v3.10.  The above list includes the supplies for
> LDO1 and LDO2.  If someone wants to support other configurations the
> binding can always be extended with optional properties.

So far I didn't need anything more than this.

>> Besides that, I needed to specify following regulator supplies in order to
>> to get the wm8994 codec successfully initialized:
> 
>>   DCVDD-supply
>>   AVDD1-supply
> 
>> That might be something specific to the sound machine driver though, I'm not
>> certain. 
> 
> No, it's not - it's the above regulator driver changes, those are the
> supplies normally supplied by the internal regulators.

Ok, I just removed the above two supplies after applying
"regulator: wm8994: Provide default init data".

>>> +	if (of_property_read_u32_array(np, "gpio-cfg", pdata->gpio_defaults,
>>> +				       ARRAY_SIZE(pdata->gpio_defaults)) >= 0) {
>>> +		for (i = 0; i < ARRAY_SIZE(pdata->gpio_defaults); i++) {
>>> +			if (wm8994->pdata.gpio_defaults[i] == 0) {
>>> +				pdata->gpio_defaults[i]
>>> +					= WM8994_CONFIGURE_GPIO;
> 
>> Hmm, that's not obvious from the binding, that 0 is replaced with 0x10000
>> by the implementation.
> 
> This is an implementation detail due to conversion to platform data.
> Since the idiom for platform data is that zero does nothing for platform
> data we made the user set an out of range bit (the registers are 16 bit)
> to set zero, otherwise we left the value untouched.  The result is that
> we rewrite to 0x10000 in the platform data which is then rewritten to
> zero.

Alright, I should have really checked what happens further to gpio_defaults[].

Now, when sound more or less works I need to fix up the irq and the gpio
chip registration.

