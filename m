Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754236AbbAUEhO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 23:37:14 -0500
Received: from mail-ob0-f169.google.com ([209.85.214.169]:61983 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754181AbbAUEhL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 23:37:11 -0500
MIME-Version: 1.0
In-Reply-To: <54BF2929.3090107@samsung.com>
References: <1420681257-3078-1-git-send-email-cw00.choi@samsung.com>
	<1420681257-3078-3-git-send-email-cw00.choi@samsung.com>
	<CAL_Jsq+5sdsm_-VW-ta+qV-NBao-XTHvsYWcbMdZmbP0Nw43Cw@mail.gmail.com>
	<CAKohpomqosqxeDANC=NLBVmOUHyUoqd7Zhph7r6f7+ufYN48EQ@mail.gmail.com>
	<54BE108F.8090506@samsung.com>
	<CAKohpokSuVhH3hHFF+mLtJXvjt=bmJy1oZRBOttCNXORBS1Y0A@mail.gmail.com>
	<54BE3E10.2080906@samsung.com>
	<CAKohpontEntV48XqNcJq+euT9SdEjkgn5Pa=sSUpgM8mfKKCUA@mail.gmail.com>
	<54BF2929.3090107@samsung.com>
Date: Wed, 21 Jan 2015 10:07:10 +0530
Message-ID: <CAKohpomrAtqedODuzaAe3qO_YppeOU+LYR45eEs0+KcHJKHcQA@mail.gmail.com>
Subject: Re: [PATCHv3 2/8] devfreq: exynos: Add documentation for generic
 exynos memory bus frequency driver
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: Rob Herring <robherring2@gmail.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>, Kukjin Kim <kgene@kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        Mark Rutland <mark.rutland@arm.com>, a.kesavan@samsung.com,
        Tomasz Figa <tomasz.figa@gmail.com>,
        =?UTF-8?Q?Krzysztof_Koz=C5=82owski?= <k.kozlowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Rob Herring <robh+dt@kernel.org>, InKi Dae <inki.dae@samsung.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21 January 2015 at 09:50, Chanwoo Choi <cw00.choi@samsung.com> wrote:
> If the clock will be stayed on highest voltage, will reduce
> the considerable benefit of power-consumption.

But this is exactly what you must be doing right now as well..
I think I didn't make it clear enough with an example. Let me
try..

This is how I feel it should look like:

       memory_bus_int: memory_bus@1 {
               // Regulator is shared for all below
               blocks {
                       peri_block: memory_bus_block1 {
                                operating-points = <
                                        100000 850000
                                        50000  850000>;
                       };

                       display_block: memory_bus_block2 {
                                operating-points = <
                                        200000 950000
                                        160000 950000
                                        100000 925000
                                        80000  850000
                                        50000  850000>;
                       };

                       isp_block: memory_bus_block3 {
                                operating-points = <
                                        200000 950000
                                        100000 925000
                                        80000  850000
                                        50000  850000>;
                       };

                       gps_block: memory_bus_block4 {
                                operating-points = <
                                        300000 950000
                                        200000 950000
                                        133000 925000
                                        100000 850000
                                        50000  850000>;
                       };


Now suppose these are the requirements from all the blocks
at any point of time:
- block1: 100000 850000
- block2: 100000 925000
- block3: 80000  850000
- block4: 133000 925000

Now, all of them can control freq separately and we don't need to
worry for that. But regulator is shared between them. We can check
what's the highest voltage requested at this point of time and can
switch to that.

i.e. 925000 in this case. And that's not the highest possible one.
And you will reach to similar conclusion with your current code as
well I believe.

> I think it is DFS instead of DVFS. Is it right?

No. I am still talking about DVFS, V being the highest requested one.

> What is the correct picture? do you need more detailed explanation
> of Exynos memory bus structure?

The correct picture is what i showed in the above dts example.
