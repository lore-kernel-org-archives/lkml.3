Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752351AbaAQOph (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 09:45:37 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:33879 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751094AbaAQOpf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 09:45:35 -0500
Date: Fri, 17 Jan 2014 14:44:57 +0000
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
Subject: Re: [PATCH] of: add function to count number of u32 elements in a
 property
Message-ID: <20140117144456.GG19578@e106331-lin.cambridge.arm.com>
References: <27256277.YJ687suYy5@phil>
 <1669323.jqjZBfkRx4@phil>
 <20140116124527.GD19578@e106331-lin.cambridge.arm.com>
 <3781679.27UF2dWtKL@phil>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3781679.27UF2dWtKL@phil>
Thread-Topic: [PATCH] of: add function to count number of u32 elements in a
 property
Accept-Language: en-GB, en-US
Content-Language: en-US
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 16, 2014 at 06:04:42PM +0000, Heiko Stübner wrote:
> The need to know the number of array elements in a property is
> a common pattern. To prevent duplication of open-coded implementations
> add a helper function that also centralises strict sanity checking
> and DTB format details.
> 
> Suggested-by: Mark Rutland <mark.rutland@arm.com>
> Signed-off-by: Heiko Stuebner <heiko@sntech.de>
> ---
> Hi Mark,
> did you mean it like this? I've tested it with the sram-reserve change and
> it made the part of the determining the number elements a lot nicer :-)

Yes! This looks pretty nice! :)

> 
>  drivers/of/base.c  |   32 ++++++++++++++++++++++++++++++++
>  include/linux/of.h |    8 ++++++++
>  2 files changed, 40 insertions(+)
> 
> diff --git a/drivers/of/base.c b/drivers/of/base.c
> index f807d0e..0f40ea5 100644
> --- a/drivers/of/base.c
> +++ b/drivers/of/base.c
> @@ -920,6 +920,38 @@ int of_property_read_u32_index(const struct device_node *np,
>  EXPORT_SYMBOL_GPL(of_property_read_u32_index);
>  
>  /**
> + * of_property_count_u32_elems - Count the number of u32 values in a property
> + *
> + * @np:		device node from which the property value is to be read.
> + * @propname:	name of the property to be searched.
> + *
> + * Search for a property in a device node and count the number of u32 elements
> + * in it. Returns number of elements on sucess, -EINVAL if the property does
> + * not exist or its length does not match a multiple of u32 and -ENODATA if the
> + * property does not have a value.
> + */
> +int of_property_count_u32_elems(const struct device_node *np,
> +				const char *propname)
> +{
> +	int elem_size = sizeof(u32);
> +	int len;
> +	struct property *prop = of_find_property(np, propname, &len);
> +
> +	if (!prop)
> +		return -EINVAL;
> +	if (!prop->value)
> +		return -ENODATA;
> +
> +	if (prop->length % elem_size != 0) {
> +		pr_err("size of %s is not a multiple of u32\n", propname);
> +		return -EINVAL;
> +	}
> +
> +	return len / elem_size;
> +}
> +EXPORT_SYMBOL_GPL(of_property_count_u32_elems);

As Rob said in his reply, it would be nice to split this into a static
helper that took elem size as a parameter, so we can have the full suite
of of_property_count_{u8,u16,u32,u64}_elems.

Also, I think you can get rid of len and always use prop->length, as
other helpers seem to do.

Cheers for putting this together!

Mark.
