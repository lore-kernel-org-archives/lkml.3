Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758815Ab3CYRco (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 13:32:44 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:58649 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758229Ab3CYRcm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 13:32:42 -0400
Message-ID: <51508A36.2010605@wwwdotorg.org>
Date: Mon, 25 Mar 2013 11:32:38 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] clk: tegra: Don't enable PLLs during early boot
References: <1363953308-28828-1-git-send-email-pdeschrijver@nvidia.com> <514C7D3B.40602@wwwdotorg.org> <20130325101542.GB18519@tbergstrom-lnx.Nvidia.com>
In-Reply-To: <20130325101542.GB18519@tbergstrom-lnx.Nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/25/2013 04:15 AM, Peter De Schrijver wrote:
> On Fri, Mar 22, 2013 at 04:48:11PM +0100, Stephen Warren wrote:
>> On 03/22/2013 05:54 AM, Peter De Schrijver wrote:
>>> The PLL code relies on udelay() which is not available when CCF is
>>> initialized. Hence we can't enable any PLL during this phase.
...
>>> Can you confirm this is ok for the audio drivers?
>>>
>>> We used to be lucky that this has worked up to now, but I will introduce some
>>> changes to the pll lock check code which cause this to fail due to the
>>> slight differences in timing.
>>
>> No, this won't work for the audio drivers; they assume the clock is
>> enabled when they start.
...
>> Perhaps this is due to initializing the Tegra clock driver in the
>> machine descriptor's init_irq function, rather than in the init_machine
>> function? Can this be moved?
> 
> Maybe. But we need the clockframework before the timers are initialized...
> So I have to check the dependencies.

In kernel 3.8, the initialization of the Tegra clock driver and the
processing of the "clock initialization table" were separate. The clock
driver used to be initialized in .init_early(), whereas the clock init
table was processed in .init_machine().

In 3.9, those two things have been conflated into .init_irq().

Is the solution here to separate those two initialization steps again;
leave the base clock driver init in .init_irq() since that's where it
needs to be for unrelated reasons, but move the processing of the clock
init table back into .init_machine() so that there are no restrictions
re: which clocks can actually be initialized?

That would probably require exposing some custom API from the Tegra clk
driver for the Tegra DT board file to call to process the clock init
table, but that should be pretty easy to do, and shouldn't cause any
scalability issues.

Perhaps that extra API can even be standardized later, along with some
way of representing the initial clock tree parenting/... setup in the
DT, and thus making it useful for any SoC.
