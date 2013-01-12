Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753255Ab3ALKDR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2013 05:03:17 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:12117 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752665Ab3ALKDP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2013 05:03:15 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Sat, 12 Jan 2013 02:02:14 -0800
Message-ID: <50F134C9.1040203@nvidia.com>
Date: Sat, 12 Jan 2013 15:32:49 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFT 3/3] ARM: tegra: dts: seaboard: enable keyboard
References: <1357911185-11048-1-git-send-email-ldewangan@nvidia.com> <1357911185-11048-3-git-send-email-ldewangan@nvidia.com> <50F09BC7.90607@wwwdotorg.org>
In-Reply-To: <50F09BC7.90607@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 12 January 2013 04:39 AM, Stephen Warren wrote:
> On 01/11/2013 06:33 AM, Laxman Dewangan wrote:
>> Enable tegra based keyboard controller and populate the key matrix for
>> seaboard. The key matrix was originally on driver code which is removed
>> to have clean driver. The key mapping is now passed through dts file.
>>
>> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
>> ---
>> Requesting for testing on seaboard.
>> I generated this patch as Stephen suggested to have one patch for dt file
>> entry for keys on seaboard.

Thanks for testing.

> To some extent this works; at least this patch series is probably almost
> OK, but there are a bunch of issues in the KBC driver obviously:
>
> This series won't work on its own with the current Tegra for-next
> content, because:
>
> a) The clock driver doesn't provide any KBC clock for Tegra20, either in
> the old Tegra clock driver, or the first conversion to the common clock
> framework, nor the most recent complete conversion to the common clock
> framework. Was the driver tested at all on the upstream kernel? I
> suppose it's just possible it was tested on Tegra30, although see below...

I have cardhu and Ventana and unfortunately both does not support the 
key pad matrix. Both are on gpio keys.
I tested this patch series (along with recent kbc patches) on t114 
platform Dalmore, it is 3x3 matrix.
Yes I made a hack on the board-dt-* file for getting proper clock. I did 
not send similar change as this will not be very much used when we will 
we in CCF.


> This brings up the point that the clk_get() call in the KBC driver is
> probably wrong. At least with Prashant's latest common clock framework
> patches applied, clk_get() returns NULL, not an error pointer for a
> non-existent clock. As such, the following driver code succeeds:
>
>> 	kbc->clk = clk_get(&pdev->dev, NULL);
>> 	if (IS_ERR(kbc->clk)) {
>> 		dev_err(&pdev->dev, "failed to get keyboard clock\n");
>> 		err = PTR_ERR(kbc->clk);
>> 		goto err_iounmap;
>> 	}
> Should that check be if (!kbc-clk) instead? Or does the common clock
> framework require if (IS_ERR_OR_NULL(kbc->clk)); hopefully not since
> IS_ERR_OR_NULL shouldn't be used any more.

If clk_get() failed then it should be return ptr_err. if not then it 
need to change almost all driver i.e. i2c/spi.
If clk_get(0 returns NULL then should be part of the clock CCF changes 
series to change here also.


> This then causes the later call to tegra_periph_reset_{de,}assert() to
> crash since it generates a bogus pointer from the NULL pointer and
> dereferences it. I assume similar things happen before Prashant's latest
> clock patches.

No, Currently clk_get() returns the PTR_ERR and probe fail. This is well 
tested till now. Something changed with CCF.


>
> Oh, and the KBC clock is marked TEGRA_PERIPH_NO_RESET for Tegra30, and
> also for Tegra20 in the ChromeOS kernel; why is the driver trying to
> assert reset on a clock that doesn't support it?
This is something our kbc controller reset and clock design.
KBC controller is on Always Power ON domain so that it can work even 
when system is in sleep.
The KBC clock is enabled through two places, PMC control register and 
CAR register set.
KBC controller is only reset through PMC control register.
This is not well implemented either on our downstream or in mainline. 
Sometime back I tried to implement it in downstream but was having lots 
of comment and not able to complete this. Possibly we will talk 
internally that how can we implement this.


>
> I hacked around this by adding the following to clk-tegra20.c on top of
> Prashant's latest patches:
>
>> 	/* kbc */
>> 	clk = tegra_clk_periph_gate("kbc", "clk_32k", TEGRA_PERIPH_NO_RESET |
>> 				    TEGRA_PERIPH_ON_APB, clk_base, 0,
>> 				    36, &periph_h_regs, periph_clk_enb_refcnt);
>> 	clk_register_clkdev(clk, NULL, "tegra-kbc");
>> 	clks[kbc] = clk;
>>
> b) There is no AUXDATA in the board file, nor clocks properties in the
> .dts files, in this series to actually hook the KBC driver up to be able
> to get the correct clock. This leads me to suspect the driver was never
> tested upstream on either Tegra20 /or/ Tegra30.

I have my local change for the AUXDATA board file which I did not sent. 
I think CCF does not require and this is the reason. I can sent this if 
it needed.

> I hacked around this by applying the following:

Yes, hack is required here. Either hack in the board file for auxdata or 
in dts file for clock entry when you have ccf ready.

> I guess I can fold that fix into this series when I apply it, after
> Prashant's clock patches are merged.
>
> Once I hacked around the above issues, the driver doesn't work very well
> at all. There is a *long* delay between when I press a key and when it
> shows up (e.g. echo'd to the HDMI console). When I release the key the
> same keypress is generated twice. Or perhaps it's a repeat, but since
> it's *always* 2 extra keypresses and I doubt I always hold my finger on
> the key the exact same amount of time, I think it's key release that
> does this not repeat. I assume this would repro on any board, so you
> won't need Seaboard to debug it. Harmony is able to read the keyboard
> using the KBC.
>
> Even with the above, I was able to validate that the keymap in the
> Seaboard .dts file looks reasonable.
>
> However, please fix the KBC driver...

I did not see any issue with the 3x3 matrix. I think all these about is 
to tuning debaunce and other parameter also. Another thing is that to 
make sure that all pinmuxes are properly configured.

However, again I will try to enable kbc on harmony and run it.



