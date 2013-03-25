Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755717Ab3CYGvW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 02:51:22 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:38689 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755299Ab3CYGvV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 02:51:21 -0400
Message-ID: <514FF3C9.1000000@ti.com>
Date: Mon, 25 Mar 2013 12:20:49 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Mike Turquette <mturquette@linaro.org>
CC: <davinci-linux-open-source@linux.davincidsp.com>, <linux@arm.linux.org.uk>,
        <sshtylyov@mvista.com>, <arnd@arndb.de>,
        Kevin Hilman <khilman@deeprootsystems.com>, <linus.walleij@linaro.org>,
        <linux-kernel@vger.kernel.org>, <rob.herring@calxeda.com>,
        <linux-keystone@list.ti.com>, <viresh.linux@gmail.com>,
        <akpm@linux-foundation.org>, <shawn.guo@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 02/11] clk: davinci - add PSC clock driver
References: <1351181518-11882-1-git-send-email-m-karicheri2@ti.com> <1351181518-11882-3-git-send-email-m-karicheri2@ti.com> <50950908.1060302@ti.com> <5097D6FC.7040202@ti.com> <20121110022254.18014.31873@nucleus> <50B4D6B1.3000903@ti.com> <20121127172900.21126.89528@nucleus> <50B6101C.30502@ti.com> <514C3E7C.3000705@ti.com> <20130322203715.834.30085@quantum>
In-Reply-To: <20130322203715.834.30085@quantum>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

On 3/23/2013 2:07 AM, Mike Turquette wrote:
> Quoting Sekhar Nori (2013-03-22 04:20:28)
>> Mike,
>>
>> On 11/28/2012 6:52 PM, Sekhar Nori wrote:
>>> On 11/27/2012 10:59 PM, Mike Turquette wrote:
>>
>>>> Also have you looked into regmap?  Since you are defining your own clock
>>>> type that might be something nice for you.
>>>
>>> No, haven't looked at regmap yet. Will look at that.
>>
>> I could get to this only now. regmap needs a valid struct device. We
>> aren't modelling psc clocks as device so regmap cannot be used here.
>>
> 
> According to Murali's reply back in November it was still not known if
> the PTCMD register was going to be concurrently accessed by sources
> outside the clock framework.  If this is so then neither the existing

I can confirm that PTCMD is a PSC specific register and it is not
accessed outside of clock framework.

> framework-level lock (e.g. enable_lock) nor the shared clock driver lock
> (e.g. spinlock in struct clk_psc) are adequate.  You may need a device
> driver which represents the PSC and use accessor functions to write to
> those register which provide coordination.

Well the only reason to access *any* PSC register outside of clock
framework would be to handle the corner case where DSP needs to be reset
using its PSC.

In this case, there needs to be an access to MDCTL register specific to
that module (ie the DSP). Right now this functionality is implemented
using the function davinci_psc_reset().

When moving to common clock framework, I think this can be moved to
drivers/clk/davinci/clk-psc.c (it will be similar to the way
tegra_periph_reset() is handled in drivers/clk/tegra/clk-periph-gate.c).

And in this case I do agree we need a spinlock local to clk-psc.c (like
the periph_ref_lock spinlock used in tegra implementation). That said,
the current series only enables DM644x and does not really implement the
reset stuff needed for DA850. So we can either add the spinlock now, or
defer it to later when DA850 get supported (so there is a clear history
trace of why it was added).

Thanks,
Sekhar
