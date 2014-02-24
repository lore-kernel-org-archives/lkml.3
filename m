Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752970AbaBXQay (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 11:30:54 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:48986 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753468AbaBXQaw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 11:30:52 -0500
Date: Mon, 24 Feb 2014 16:30:35 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Emilio Lopez <emilio@elopez.com.ar>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>, devicetree@vger.kernel.org,
        Mike Turquette <mturquette@linaro.org>, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com, dmaengine@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/5] clk: sun6i: Protect CPU clock
Message-ID: <20140224163034.GN21483@n2100.arm.linux.org.uk>
References: <1393258967-4843-1-git-send-email-maxime.ripard@free-electrons.com> <1393258967-4843-2-git-send-email-maxime.ripard@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393258967-4843-2-git-send-email-maxime.ripard@free-electrons.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 24, 2014 at 05:22:43PM +0100, Maxime Ripard wrote:
> Right now, AHB is an indirect child clock of the CPU clock. If that happens to
> change, since the CPU clock has no other consumers declared in Linux, it would
> be shut down, which is not really a good idea.
> 
> Prevent this by forcing it enabled.
> 
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> ---
>  drivers/clk/sunxi/clk-sunxi.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/drivers/clk/sunxi/clk-sunxi.c b/drivers/clk/sunxi/clk-sunxi.c
> index 23baad9..cedaf4b 100644
> --- a/drivers/clk/sunxi/clk-sunxi.c
> +++ b/drivers/clk/sunxi/clk-sunxi.c
> @@ -1301,6 +1301,14 @@ static void __init sunxi_clock_protect(void)
>  		clk_prepare_enable(clk);
>  		clk_put(clk);
>  	}
> +
> +	/* CPU clocks - sun6i */
> +	clk = clk_get(NULL, "cpu");
> +	if (!IS_ERR(clk)) {
> +		clk_prepare_enable(clk);
> +		clk_put(clk);
> +	}

This is broken.  I'm not sure what's difficult to grasp about the concept
of "while a clock is in use, you should keep a reference to that clock".

That implies that if you get a clock, and then enable it, you don't
put the clock until you've disabled it.

The only reason the core doesn't check for this kind of thing is that
a clock may be shared, so it's entirely possible for a correctly written
driver to have a clock which is still enabled at put time - but enabled
by an entirely different driver.

However, that's no excuse for this kind of sloppiness.

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
