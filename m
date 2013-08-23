Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756553Ab3HWXUa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 19:20:30 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:50302 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756519Ab3HWXUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 19:20:22 -0400
Date: Sat, 24 Aug 2013 00:13:15 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: linux-arm-kernel@lists.infradead.org, mturquette@linaro.org,
        jiada_wang@mentor.com, broonie@kernel.org, vapier@gentoo.org,
        ralf@linux-mips.org, kyungmin.park@samsung.com,
        myungjoo.ham@samsung.com, shawn.guo@linaro.org,
        sebastian.hesselbarth@gmail.com, LW@KARO-electronics.de,
        t.figa@samsung.com, g.liakhovetski@gmx.de,
        laurent.pinchart@ideasonboard.com, linux-kernel@vger.kernel.org,
        uclinux-dist-devel@blackfin.uclinux.org, linux-mips@linux-mips.org,
        linux-sh@vger.kernel.org
Subject: Re: [PATCH v3 3/5] clk: Add common __clk_get(), __clk_put()
	implementations
Message-ID: <20130823231314.GR6617@n2100.arm.linux.org.uk>
References: <1377270227-1030-1-git-send-email-s.nawrocki@samsung.com> <1377270227-1030-4-git-send-email-s.nawrocki@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377270227-1030-4-git-send-email-s.nawrocki@samsung.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 23, 2013 at 05:03:45PM +0200, Sylwester Nawrocki wrote:
> This patch adds common __clk_get(), __clk_put() clkdev helpers which
> replace their platform specific counterparts when the common clock
> API is enabled.
> 
> The owner module pointer field is added to struct clk so a reference
> to the clock supplier module can be taken by the clock consumers.
> 
> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>

I'm mostly happy with this now.

> +int __clk_get(struct clk *clk)
> +{
> +	if (clk && !try_module_get(clk->owner))
> +		return 0;
> +
> +	return 1;
> +}
> +EXPORT_SYMBOL(__clk_get);
> +
> +void __clk_put(struct clk *clk)
> +{
> +	if (WARN_ON_ONCE(IS_ERR(clk)))
> +		return;
> +
> +	if (clk)
> +		module_put(clk->owner);
> +}
> +EXPORT_SYMBOL(__clk_put);

Why are these exported?  clkdev can only be built into the kernel, as can
the common clk framework - they can't be modular.  So why would a module
wish to access these directly?
