Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757428AbaAIJ0h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 04:26:37 -0500
Received: from mail-ob0-f181.google.com ([209.85.214.181]:56414 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755097AbaAIJ03 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 04:26:29 -0500
MIME-Version: 1.0
In-Reply-To: <CAOesGMgfFVoVJpOMXWtzVWj_F4pD-L9Osyv4u6=c8RUWOoLHFw@mail.gmail.com>
References: <d9239e0a5df99392647ff8343673342f89d09476.1389059568.git.viresh.kumar@linaro.org>
	<CAOesGMgfFVoVJpOMXWtzVWj_F4pD-L9Osyv4u6=c8RUWOoLHFw@mail.gmail.com>
Date: Thu, 9 Jan 2014 14:56:28 +0530
Message-ID: <CAKohpo=EsaBPdF3wYsa2rEdjcpPagbhPcxWw1_PA=yVLDnjRiA@mail.gmail.com>
Subject: Re: [PATCH V3 Resend] cpufreq: create cpufreq_generic_get() routine
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Olof Johansson <olof@lixom.net>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Fengguang Wu <fengguang.wu@intel.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cc'ng Russell/LAKML/Fengguang..

On 9 January 2014 14:08, Olof Johansson <olof@lixom.net> wrote:
> This patch breaks a bunch of ARM boards. In particular, the following
> defconfigs no longer build:

That's really bad, Rafael will scold me again :)

>           assabet_defconfig
>           badge4_defconfig
>           cerfcube_defconfig
>           collie_defconfig
>           h3600_defconfig
>           hackkit_defconfig
>           jornada720_defconfig
>           lart_defconfig
>           neponset_defconfig
>           pleb_defconfig
>           shannon_defconfig
>           simpad_defconfig
>
> Error is:
>
> drivers/built-in.o: In function `cpufreq_generic_get':
> drivers/cpufreq/cpufreq.c:189: undefined reference to `clk_get_rate'
>
> Seems like this needs to be guarded by HAVE_CLK?

Naah.. After some investigation I found this:

- We already have dummy implementations of clk routines in case
CONFIG_HAVE_CLK is not defined (I added them long back).

- There is one thing common among all above defconfigs, all
belong to SA1100 family :)

- And the problem is: SA1100 wanted to define its own clk routines
and selects CLKDEV_LOOKUP (which enables HAVE_CLK), but it
doesn't implement all clk routines. Which is *wrong*.

So, actually this patch brought an _existing_ bug in limelight. And
this should be fixed by adding dummy or meaningful implementation
of missing clk routines.

@Russell: If above looks correct then can you please communicate
what should we do here? I don't really know what exactly these
routines should have, simply a copy of dummy routines from clk.h
or some meaningful stuff. So, maybe you can write a patch, otherwise
let me know what to write and I will give it a try.

@Rafael: Please *don't* revert this patch, its not my fault this time :)

@Fengguang: Would it make sense to add build tests for all ARM
defconfigs in your build system? I thought its already there :)
That way I can always be sure that my stuff (would be helpful for
others as well though) isn't breaking build (Atleast) for any platform.

Thanks.

--
viresh
