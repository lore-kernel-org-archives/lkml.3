Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757598Ab3ANWJV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 17:09:21 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:34198 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756152Ab3ANWJU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 17:09:20 -0500
Message-ID: <50F4820C.2050806@wwwdotorg.org>
Date: Mon, 14 Jan 2013 15:09:16 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFT 3/3] ARM: tegra: dts: seaboard: enable keyboard
References: <1357911185-11048-1-git-send-email-ldewangan@nvidia.com> <1357911185-11048-3-git-send-email-ldewangan@nvidia.com> <50F09BC7.90607@wwwdotorg.org> <50F134C9.1040203@nvidia.com>
In-Reply-To: <50F134C9.1040203@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/12/2013 03:02 AM, Laxman Dewangan wrote:
> On Saturday 12 January 2013 04:39 AM, Stephen Warren wrote:
>> On 01/11/2013 06:33 AM, Laxman Dewangan wrote:
>>> Enable tegra based keyboard controller and populate the key matrix for
>>> seaboard. The key matrix was originally on driver code which is removed
>>> to have clean driver. The key mapping is now passed through dts file.
>>>
>>> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
>>> ---
>>> Requesting for testing on seaboard.
>>> I generated this patch as Stephen suggested to have one patch for dt
>>> file
>>> entry for keys on seaboard.
> 
> Thanks for testing.

>> Oh, and the KBC clock is marked TEGRA_PERIPH_NO_RESET for Tegra30, and
>> also for Tegra20 in the ChromeOS kernel; why is the driver trying to
>> assert reset on a clock that doesn't support it?
>
> This is something our kbc controller reset and clock design.
> KBC controller is on Always Power ON domain so that it can work even
> when system is in sleep.
> The KBC clock is enabled through two places, PMC control register and
> CAR register set.
> KBC controller is only reset through PMC control register.
> This is not well implemented either on our downstream or in mainline.
> Sometime back I tried to implement it in downstream but was having lots
> of comment and not able to complete this. Possibly we will talk
> internally that how can we implement this.

I guess there's little point in the KBC driver calling the Tegra clock
reset APIs then. Still, since the code is already there and it's not
doing any harm, I guess it's fine to leave it there; if we ever enhance
the clock driver to implement reset for those clocks via the PMC, it
will all just magically work.

>> Once I hacked around the above issues, the driver doesn't work very well
>> at all. There is a *long* delay between when I press a key and when it
>> shows up (e.g. echo'd to the HDMI console). When I release the key the
>> same keypress is generated twice. Or perhaps it's a repeat, but since
>> it's *always* 2 extra keypresses and I doubt I always hold my finger on
>> the key the exact same amount of time, I think it's key release that
>> does this not repeat. I assume this would repro on any board, so you
>> won't need Seaboard to debug it. Harmony is able to read the keyboard
>> using the KBC.
>>
>> Even with the above, I was able to validate that the keymap in the
>> Seaboard .dts file looks reasonable.
>>
>> However, please fix the KBC driver...
> 
> I did not see any issue with the 3x3 matrix. I think all these about is
> to tuning debaunce and other parameter also. Another thing is that to
> make sure that all pinmuxes are properly configured.

OK, I'll go look at some downstream kernels for Seaboard and see if the
debounce etc. parameters all match up.

> However, again I will try to enable kbc on harmony and run it.

That would be extremely useful; I worry that if you tested it on
Tegra114, that means using a downstream kernel only, and also whether
there are any HW differences between SoC versions. That's quite a lot of
variables that could explain the issues I'm seeing.
