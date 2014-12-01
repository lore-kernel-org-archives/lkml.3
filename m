Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932695AbaLAWvu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 17:51:50 -0500
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:42846 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932559AbaLAWvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 17:51:49 -0500
Date: Mon, 1 Dec 2014 22:50:57 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Doug Anderson <dianders@chromium.org>
Cc: Heiko Stuebner <heiko@sntech.de>, Chris Zhong <zyw@rock-chips.com>,
        Kevin Hilman <khilman@linaro.org>, Sonny Rao <sonnyrao@chromium.org>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, russ.dill@gmail.com,
        olof@lixom.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: rockchip: Convert resume code to C
Message-ID: <20141201225057.GA11285@n2100.arm.linux.org.uk>
References: <1417461694-5129-1-git-send-email-dianders@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417461694-5129-1-git-send-email-dianders@chromium.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 01, 2014 at 11:21:34AM -0800, Doug Anderson wrote:
> We convert the existing assembly resume code into C as proof that this
> works and to prepare for linking in SDRAM reinit code.

...

> base my patch atop them.  Why?
                            ^^^^

That's a very good question...

> +static void __noreturn rk3288_resume_c(void)
> +{
> +	if (rk3288_resume_params.l2ctlr_f)
> +		asm("mcr p15, 1, %0, c9, c0, 2" : :
> +			"r" (rk3288_resume_params.l2ctlr));

Assembly...

> +static void __naked __noreturn rk3288_resume(void)
> +{
> +	/* Make sure we're on CPU0, no IRQs and get a stack setup */
> +	asm volatile (
> +			"msr	cpsr_cxf, %0\n"
> +
> +			/* Only cpu0 continues to run, the others halt here */
> +			"mrc	p15, 0, r1, c0, c0, 5\n"
> +			"and	r1, r1, #0xf\n"
> +			"cmp	r1, #0\n"
> +			"beq	cpu0run\n"
> +		"secondary_loop:\n"
> +			"wfe\n"
> +			"b	secondary_loop\n"
> +
> +		"cpu0run:\n"
> +			"mov	sp, %1\n"
> +		:
> +		: "i" (INIT_CPSR), "r" (&__stack_start)
> +		: "cc", "r1", "sp");

Big load of assembly.

What I see here is a load of complexity which achieves very little.
The result doesn't get rid of much assembly, but it does make stuff
more complicated.  And the diffstat speaks volumes about this:

 10 files changed, 275 insertions(+), 94 deletions(-)                           

There's a lot of words in the description, but it's missing the most
important bit: why do we want to take this approach - what benefits
does it bring?

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
