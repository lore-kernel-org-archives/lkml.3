Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031199AbaLLRiJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 12:38:09 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:58457 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030898AbaLLRiG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 12:38:06 -0500
Message-ID: <548B27E5.4090108@ti.com>
Date: Fri, 12 Dec 2014 11:37:41 -0600
From: Nishanth Menon <nm@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
CC: <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: ARM: OMAP5/DRA7: Fix counter frequency drift for AM572x errata
 i856
References: <20141211204116.GT24110@csclub.uwaterloo.ca> <20141211204308.GU24110@csclub.uwaterloo.ca>
In-Reply-To: <20141211204308.GU24110@csclub.uwaterloo.ca>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-sricharan, as the email ID is defunct.

On 12/11/2014 02:43 PM, Lennart Sorensen wrote:
> On Thu, Dec 11, 2014 at 03:41:16PM -0500, Lennart Sorensen wrote:
>> Errata i856 for the AM572x (DRA7xx) points out that the 32.768KHz external
>> crystal is not enabled at power up.  Instead the CPU falls back to using
>> an emulation for the 32KHz clock which is SYSCLK1/610.  SYSCLK1 is usually
>> 20MHz on boards so far (which gives an emulated frequency of 32.786KHz),
>> but can also be 19.2 or 27MHz which result in much larger drift.

Why not just change the clock parent to something that is more
accurate like the 32k clk?

>>
>> Since this is used to drive the master counter at 32.768KHz * 375 /
>> 2 = 6.144MHz, the emulated speed for 20MHz is of by 570ppm, or about 43
>> seconds per day, and more than the 500ppm NTP is able to tolerate.
>>
>> Checking the CTRL_CORE_BOOTSTRAP register can determine if the CPU
>> is using the real 32.768KHz crystal or the emulated SYSCLK1/610, and
Without digging into docs, This is just the boot configuration, right?
are we not able to reconfigure?

>> by known that the real counter frequency can be determined and used.
>> The real speed is then SYSCLK1 / 610 * 375 / 2 or SYSCLK1 * 375 / 1220.
>> This is unfortunately not integer math so the actual arch_timer_freq
>> needs to be precalculated.
>>
>> Also the SYSCLK1 frequencies that have never been used by an omap
>> evaluation board were all missing a 0.
>>

Please sign-off on you patch. use git format-patch -M -s to generate
patches. and when posting a series, use --cover-letter. Will also be
good to provide tests that show that this is indeed an issue on OMAP5
and DRA7 (considering the $subject here).

>> diff --git a/arch/arm/mach-omap2/timer.c b/arch/arm/mach-omap2/timer.c
>> index 4f61148..2e81511 100644
>> --- a/arch/arm/mach-omap2/timer.c
>> +++ b/arch/arm/mach-omap2/timer.c
>> @@ -513,11 +513,11 @@ static void __init realtime_counter_init(void)
>>  	rate = clk_get_rate(sys_clk);
>>  	/* Numerator/denumerator values refer TRM Realtime Counter section */
>>  	switch (rate) {
>> -	case 1200000:
>> +	case 12000000:
>>  		num = 64;
>>  		den = 125;
>>  		break;
>> -	case 1300000:
>> +	case 13000000:
>>  		num = 768;
>>  		den = 1625;
>>  		break;
>> @@ -529,11 +529,11 @@ static void __init realtime_counter_init(void)
>>  		num = 192;
>>  		den = 625;
>>  		break;
>> -	case 2600000:
>> +	case 26000000:
>>  		num = 384;
>>  		den = 1625;
>>  		break;
>> -	case 2700000:
>> +	case 27000000:
>>  		num = 256;
>>  		den = 1125;
>>  		break;

These should probably fall in as a separate patch.

>> @@ -557,6 +557,73 @@ static void __init realtime_counter_init(void)
>>  	writel_relaxed(reg, base + INCREMENTER_DENUMERATOR_RELOAD_OFFSET);
>>  
>>  	arch_timer_freq = (rate / den) * num;
>> +
>> +	if (soc_is_dra7xx()) {
>> +		#define CTRL_CORE_BOOTSTRAP 0x4A0026C4
>> +		#define SPEEDSELECT_MASK 0x00000300

we dont usually define it like this.

>> +		void __iomem *corebase;
>> +		corebase = ioremap(CTRL_CORE_BOOTSTRAP, SZ_4);
>> +		if (!corebase)
>> +			pr_err("%s: ioremap failed\n", __func__);
>> +		else {

also run ./scripts/checkpatch.pl --strict on your patch prior to
posting. try to ensure there are 0 warnings or checks.

>> +			reg = readl_relaxed(corebase) & SPEEDSELECT_MASK;
>> +			iounmap(corebase);
>> +			/*
>> +			 * Errata i856 says the 32.768KHz crystal does
>> +			 * not start at power on, so the CPU falls back in
>> +			 * an emulated 32KHz clock instead.  This causes
>> +			 * the master counter frequency to not be what it
>> +			 * was expected to be.	This affects at least
>> +			 * the AM572x 1.0 and 1.1 revisions.
>> +			 * Of course any board built without a populated
>> +			 * 32.768KHz crystal would also need this fix
>> +			 * even if the CPU is fixed later.
>> +			 *
>> +			 * If the two speedselect bits are not 0, then the
>> +			 * 32.768KHz clock driving the course counter that
>> +			 * corrects the fine counter every time it ticks is
>> +			 * actually rate/610 rather than 32.768KHz and we
>> +			 * should compensate to avoid the 570ppm (At 20MHz,
>> +			 * much worse at other rates) too fast system time.
>> +			 *
>> +			 * Precalculate the arch_timer_freq, since
>> +			 * rate/610 isn't integer math and accuracy is
>> +			 * desirable here.
>> +			 */
>> +			if (reg) {
>> +				switch (rate) {
>> +				case 19200000:
>> +					num = 375;
>> +					den = 1220;
>> +					arch_timer_freq = 5901639;
>> +					break;
>> +				case 27000000:
>> +					num = 375;
>> +					den = 1220;
>> +					arch_timer_freq = 8299180;
>> +					break;
>> +				case 20000000:

>> +				default:
>> +					num = 375;
>> +					den = 1220;
>> +					arch_timer_freq = 6147541;
>> +					break;
>> +				}
>> +				reg = readl_relaxed(base + INCREMENTER_NUMERATOR_OFFSET) &
>> +						NUMERATOR_DENUMERATOR_MASK;
>> +				reg |= num;
>> +				writel_relaxed(reg, base + INCREMENTER_NUMERATOR_OFFSET);
>> +
>> +				reg = readl_relaxed(base + INCREMENTER_DENUMERATOR_RELOAD_OFFSET) &
>> +						NUMERATOR_DENUMERATOR_MASK;
>> +				reg |= den;
>> +				writel_relaxed(reg, base + INCREMENTER_DENUMERATOR_RELOAD_OFFSET);
>> +
>> +				printk(KERN_WARNING "DRA7xx CP15 compensated for sloppy internal 32KHz clock.\n");

we would want to reuse the configuration code previously done, not
repeat the logic.

in general we want the flow to be common - so the point in logic where
num, den is decided is also the place you want this logic to fit in..


>> +			}
>> +		}
>> +	}
>> +
>>  	set_cntfreq();
>>  
>>  	iounmap(base);
> 
> I am perfectly willing to split this into two patches it prefered (one
> for the counter frequency fix and one for the rate typos).
> 
> Other cleanups needed would be great too, since I am still not too
> pleased with how this looks.
> 
> With this fix however many boards have run ntp with drift less than 3ppm,
> so it works very well.
> 


-- 
Regards,
Nishanth Menon
