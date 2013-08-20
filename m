Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751495Ab3HTUdD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 16:33:03 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:42121 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908Ab3HTUdB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 16:33:01 -0400
Date: Tue, 20 Aug 2013 21:30:34 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: linux-arm-kernel@lists.infradead.org, mturquette@linaro.org,
        jiada_wang@mentor.com, robherring2@gmail.com, grant.likely@linaro.org,
        broonie@kernel.org, vapier@gentoo.org, ralf@linux-mips.org,
        kyungmin.park@samsung.com, shawn.guo@linaro.org,
        sebastian.hesselbarth@gmail.com, LW@KARO-electronics.de,
        t.figa@samsung.com, g.liakhovetski@gmx.de,
        laurent.pinchart@ideasonboard.com, linux-kernel@vger.kernel.org,
        uclinux-dist-devel@blackfin.uclinux.org, linux-mips@linux-mips.org,
        linux-sh@vger.kernel.org
Subject: Re: [PATCH v2 1/4] clk: add common __clk_get(), __clk_put()
	implementations
Message-ID: <20130820203034.GC17845@n2100.arm.linux.org.uk>
References: <1377020063-30213-1-git-send-email-s.nawrocki@samsung.com> <1377020063-30213-2-git-send-email-s.nawrocki@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377020063-30213-2-git-send-email-s.nawrocki@samsung.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 20, 2013 at 07:34:20PM +0200, Sylwester Nawrocki wrote:
> +int __clk_get(struct clk *clk)
> +{
> +	if (WARN_ON((!clk)))
> +		return 0;

This changes the behaviour of clk_get()

> +
> +	if (!try_module_get(clk->owner))
> +		return 0;

If you want this to be safe against NULL pointers, just do this:

	if (clk && !try_module_get(clk->owner))
		return 0;

> +
> +	return 1;
> +}
> +EXPORT_SYMBOL(__clk_get);
> +
> +void __clk_put(struct clk *clk)
> +{
> +	if (!clk || IS_ERR(clk))
> +		return;
> +
> +	module_put(clk->owner);

Calling clk_put() with an error-pointer should be a Bad Thing and something
that shouldn't be encouraged, so trapping it is probably unwise.  So, just
do here:

	if (clk)
		module_put(clk->owner);

If we do have some callers of this with ERR pointers, then we could add:

	if (WARN_ON_ONCE(IS_ERR(clk)))
		return;

and remove it after a full kernel cycle or so.
