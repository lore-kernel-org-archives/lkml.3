Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751808Ab3HTU6A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 16:58:00 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:55041 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751257Ab3HTU56 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 16:57:58 -0400
Message-ID: <5213D853.7070102@wwwdotorg.org>
Date: Tue, 20 Aug 2013 14:57:55 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC 02/17] ARM: call clk_of_init from time_init
References: <1376964271-22715-1-git-send-email-sebastian.hesselbarth@gmail.com> <1376964271-22715-3-git-send-email-sebastian.hesselbarth@gmail.com> <52138F56.6030008@wwwdotorg.org> <201308202244.56782.arnd@arndb.de>
In-Reply-To: <201308202244.56782.arnd@arndb.de>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/20/2013 02:44 PM, Arnd Bergmann wrote:
> On Tuesday 20 August 2013, Stephen Warren wrote:
>> On 08/19/2013 08:04 PM, Sebastian Hesselbarth wrote:
>>> Most DT ARM machs require common clock providers initialized before timers.
>>> Currently, arch/arm machs use .init_time to call clk_of_init right before
>>> clocksource_of_init. This prevents to remove that hook and use the default
>>> hook instead. clk_of_init now checks for multiple calls to it, so add
>>> the call to ARM arch time_init by default.
>>
>> Some SoCs call this function in .init_irq() rather than .init_time().
>> Perhaps we adjust this patch to do that instead. That way, we can
>> presumably get rid of patch 1/17 since we can eliminate any duplicate
>> calls, and adjust patch 14/17 (Tegra board file) to remove its custom
>> call to of_clock_init(NULL)?
> 
> I think we should do thinks as late as possible in general. We probably
> need clocks running on most platforms before we can set up timers, so
> it makes sense to do the clocks first, but very few platforms require
> clocks to be running before the interrupt controller is set up.
> 
> A nicer solution would be to change the tegra code to not require this
> to be called this early, if at all possible.

Hmm. This probably isn't too hard. I /think/ the only reason the clocks
are initialized early is:

* The PMC HW block is involved in the path of some interrupts (i.e. it
inverts, or not, the IRQ input pin dedicated to the PMIC).

* So, that part of the PMC must be initialized early so that the IRQ
polarity is correct.

* The PMC initialization is currently monolithic, and the PMC has some
clock inputs, so the init routine ends up calling of_clk_get_by_name(),
and hence clocks must be set up early too.

Perhaps if we just separate tegra_pmc_init() into two functions which
initialize different parts of the PMC, we can get rid of the
tegra_dt_init_irq() -> tegra_pmc_init() -> of_clk_get_by_name() call
path, and hence move Tegra's call to of_clk_init() to the typical place.

I'll try it.
