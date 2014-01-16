Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752748AbaAPMqU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 07:46:20 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:36272 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752722AbaAPMqT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 07:46:19 -0500
Date: Thu, 16 Jan 2014 12:45:27 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Heiko =?utf-8?Q?St=C3=BCbner?= <heiko@sntech.de>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "arm@kernel.org" <arm@kernel.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Rob Herring <robherring2@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>
Subject: Re: [PATCH v6 2/6] misc: sram: implement mmio-sram-reserved option
Message-ID: <20140116124527.GD19578@e106331-lin.cambridge.arm.com>
References: <27256277.YJ687suYy5@phil>
 <1669323.jqjZBfkRx4@phil>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1669323.jqjZBfkRx4@phil>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 15, 2014 at 09:41:28PM +0000, Heiko Stübner wrote:
> This implements support for the mmio-sram-reserved option to keep the
> genpool from using these areas.
> 
> Suggested-by: Rob Herring <robherring2@gmail.com>
> Signed-off-by: Heiko Stuebner <heiko@sntech.de>
> Tested-by: Ulrich Prinz <ulrich.prinz@googlemail.com>
> ---
>  drivers/misc/sram.c |  118 +++++++++++++++++++++++++++++++++++++++++++++++----
>  1 file changed, 110 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/misc/sram.c b/drivers/misc/sram.c
> index afe66571..7fb60f3 100644
> --- a/drivers/misc/sram.c
> +++ b/drivers/misc/sram.c
> @@ -36,13 +36,23 @@ struct sram_dev {
>  	struct clk *clk;
>  };
>  
> +struct sram_reserve {
> +	unsigned long start;
> +	unsigned long size;
> +};
> +
>  static int sram_probe(struct platform_device *pdev)
>  {
>  	void __iomem *virt_base;
>  	struct sram_dev *sram;
>  	struct resource *res;
> -	unsigned long size;
> -	int ret;
> +	unsigned long size, cur_start, cur_size;
> +	const __be32 *reserved_list = NULL;
> +	int reserved_size = 0;
> +	struct sram_reserve *rblocks;
> +	unsigned int nblocks;
> +	int ret = 0;
> +	int i;
>  
>  	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>  	virt_base = devm_ioremap_resource(&pdev->dev, res);
> @@ -65,19 +75,111 @@ static int sram_probe(struct platform_device *pdev)
>  	if (!sram->pool)
>  		return -ENOMEM;
>  
> -	ret = gen_pool_add_virt(sram->pool, (unsigned long)virt_base,
> -				res->start, size, -1);
> -	if (ret < 0) {
> -		if (sram->clk)
> -			clk_disable_unprepare(sram->clk);
> -		return ret;
> +	if (pdev->dev.of_node) {
> +		reserved_list = of_get_property(pdev->dev.of_node,
> +						"mmio-sram-reserved",
> +						&reserved_size);
> +		if (reserved_list) {
> +			reserved_size /= sizeof(*reserved_list);

As a general observation, It looks like a lot of people need to know how
many array elements a property might hold (for datastructure
allocation), and are open-coding element counting.

I think it would be nice if we had a helper function to count how many
elements a property can hold (of_property_count_u32_elems?) that would
centralise strict sanity checking (e.g. prop->len % elem_size == 0) and
DTB format details (so you don't have to care about endianness, and it
becomes possible to add DTB metadata later and get runtime type
checking).

That can all come later and shouldn't block this patch.

> +			if (!reserved_size || reserved_size % 2) {
> +				dev_warn(&pdev->dev, "wrong number of arguments in mmio-sram-reserved\n");
> +				reserved_list = NULL;
> +				reserved_size = 0;
> +			}
> +		}
> +	}
> +
> +	/*
> +	 * We need an additional block to mark the end of the memory region
> +	 * after the reserved blocks from the dt are processed.
> +	 */
> +	nblocks = reserved_size / 2 + 1;
> +	rblocks = kmalloc((nblocks) * sizeof(*rblocks), GFP_KERNEL);
> +	if (!rblocks) {
> +		ret = -ENOMEM;
> +		goto err_alloc;
> +	}
> +
> +	cur_start = 0;
> +	for (i = 0; i < nblocks - 1; i++) {
> +		rblocks[i].start = be32_to_cpu(*reserved_list++);
> +		rblocks[i].size = be32_to_cpu(*reserved_list++);

It feels a little odd to have to have to care about the format of the
dtb and do endianness conversion here. It would be nice to limit the
scope of DTB format details to the of_ helper functions.

Could you use of_property_read_u32_index here instead please?

Otherwise this looks fine to me.

Cheers,
Mark.
