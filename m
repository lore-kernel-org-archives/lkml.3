Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751332AbaDAOwU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 10:52:20 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:13242 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095AbaDAOwS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 10:52:18 -0400
X-AuditID: cbfec7f4-b7f796d000005a13-c8-533ad29e0967
Message-id: <533AD297.2020302@samsung.com>
Date: Tue, 01 Apr 2014 16:52:07 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.3.0
MIME-version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, gregkh@linuxfoundation.org,
        mturquette@linaro.org, linux@arm.linux.org.uk, robh+dt@kernel.org,
        grant.likely@linaro.org, mark.rutland@arm.com, galak@codeaurora.org,
        kyungmin.park@samsung.com, sw0312.kim@samsung.com,
        m.szyprowski@samsung.com, t.figa@samsung.com, s.hauer@pengutronix.de
Subject: Re: [PATCH RFC v4 2/2] clk: Add handling of clk parent and rate
 assigned from DT
References: <1396284116-19178-1-git-send-email-s.nawrocki@samsung.com>
 <1396284116-19178-3-git-send-email-s.nawrocki@samsung.com>
 <1965445.mLnp8rmPxd@avalon>
In-reply-to: <1965445.mLnp8rmPxd@avalon>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmphkeLIzCtJLcpLzFFi42I5/e/4Fd15l6yCDRafMbaYf+Qcq0X/m4Ws
	Fgf+7GC0aF68ns3ibNMbdovOiUvYLTY9vsZqcXnXHDaL25d5LdYeuctusfT6RSaLpxMuslm0
	7j3CbvF3+yYWixmTX7JZrJ/xmsVBwGPNvDWMHi3NPWwel/t6mTxmd8xk9di0qpPN4861PWwe
	++euYffYvKTeo/+vgUffllWMHp83yQVwR3HZpKTmZJalFunbJXBlbPylXPBGpuLcOZsGxjli
	XYycHBICJhKbfvUxQdhiEhfurWfrYuTiEBJYyijxasYERgjnE6PE3f42FpAqXgEtiXeTNjOD
	2CwCqhJLNr4Ds9kEDCV6j/YxgtiiAhEScyduZoOoF5T4MfkeWK+IgIVE76LpYDXMAp3MEu/X
	m4DYwgLREmcaNoLNERJYyCjx5KcNiM0poCHROn8/G0S9jsT+1mlQtrzE5jVvmScwCsxCsmIW
	krJZSMoWMDKvYhRNLU0uKE5KzzXUK07MLS7NS9dLzs/dxAiJuS87GBcfszrEKMDBqMTDa1Fu
	GSzEmlhWXJl7iFGCg1lJhNd6hVWwEG9KYmVValF+fFFpTmrxIUYmDk6pBsbyAvGj2uvffGOM
	Vf20OVI7Z0fnoisvJlXy+vg9YytbIrzY+M9HXzMmo+OlkzZVSWxcY+5bb2qj7qplzumetf5B
	akP0Mvc/B3ujhGQ1Vk58orfk+VEeOb4Ptc/PH6h5679EabLWtau5VtrZ27LfJtRlLXw1+83t
	51q+kf2/pG136hkaOO4Pf6HEUpyRaKjFXFScCAADa8NklwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Laurent,

On 01/04/14 15:15, Laurent Pinchart wrote:
[...]
>> +/**
>> + * of_clk_device_init() - parse and set clk configuration assigned to a
>> device
>> + * @node: device node to apply the configuration for
>> + *
>> + * This function parses 'clock-parents' and 'clock-rates' properties and
>> sets
>> + * any specified clock parents and rates.
>> + */
>> +int of_clk_device_init(struct device_node *node)
>> +{
>> +	struct property	*prop;
>> +	const __be32 *cur;
>> +	int rc, index, num_parents;
>> +	struct clk *clk, *pclk;
>> +	u32 rate;
>> +
>> +	num_parents = of_count_phandle_with_args(node, "clock-parents",
>> +						 "#clock-cells");
>> +	if (num_parents == -EINVAL)
>> +		pr_err("clk: Invalid value of clock-parents property at %s\n",
>> +		       node->full_name);
> 
> This is an implementation detail, but wouldn't it simplify the code if you 
> merged the two loops by iterating of the 	clocks property instead of over the 
> clock-parents and clock-rates properties separately ?

The issue here is that all clock parents should be set before we start setting
clock rates. Otherwise the clock frequencies could be incorrect if clk_set_rate()
is followed by clk_set_parent().

>> +	for (index = 0; index < num_parents; index++) {
>> +		pclk = of_clk_get_by_property(node, "clock-parents", index);
>> +		if (IS_ERR(pclk)) {
>> +			/* skip empty (null) phandles */
>> +			if (PTR_ERR(pclk) == -ENOENT)
>> +				continue;
>> +
>> +			pr_warn("clk: couldn't get parent clock %d for %s\n",
>> +				index, node->full_name);
>> +			return PTR_ERR(pclk);
>> +		}
>> +
>> +		clk = of_clk_get(node, index);
>> +		if (IS_ERR(clk)) {
>> +			pr_warn("clk: couldn't get clock %d for %s\n",
>> +				index, node->full_name);
>> +			return PTR_ERR(clk);
>> +		}
>> +
>> +		rc = clk_set_parent(clk, pclk);
>> +		if (rc < 0)
>> +			pr_err("clk: failed to reparent %s to %s: %d\n",
>> +			       __clk_get_name(clk), __clk_get_name(pclk), rc);
>> +		else
>> +			pr_debug("clk: set %s as parent of %s\n",
>> +				 __clk_get_name(pclk), __clk_get_name(clk));
>> +	}
>> +
>> +	index = 0;
>> +	of_property_for_each_u32(node, "clock-rates", prop, cur, rate) {
>> +		if (rate) {
>> +			clk = of_clk_get(node, index);
>> +			if (IS_ERR(clk)) {
>> +				pr_warn("clk: couldn't get clock %d for %s\n",
>> +					index, node->full_name);
>> +				return PTR_ERR(clk);
>> +			}
>> +
>> +			rc = clk_set_rate(clk, rate);
>> +			if (rc < 0)
>> +				pr_err("clk: couldn't set %s clock rate: %d\n",
>> +				       __clk_get_name(clk), rc);
>> +			else
>> +				pr_debug("clk: set rate of clock %s to %lu\n",
>> +					 __clk_get_name(clk), clk_get_rate(clk));
>> +		}
>> +		index++;
>> +	}
>> +
>> +	return 0;
>> +}
>> diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
>> index dff0373..ea6d8bd 100644
>> --- a/drivers/clk/clk.c
>> +++ b/drivers/clk/clk.c
> 
> [snip]
> 
>> @@ -2620,7 +2621,15 @@ void __init of_clk_init(const struct of_device_id
>> *matches) list_for_each_entry_safe(clk_provider, next,
>>  					&clk_provider_list, node) {
>>  			if (force || parent_ready(clk_provider->np)) {
>> +
>>  				clk_provider->clk_init_cb(clk_provider->np);
>> +
>> +				/* Set any assigned clock parents and rates */
>> +				np = of_get_child_by_name(clk_provider->np,
>> +							  "assigned-clocks");
>> +				if (np)
>> +					of_clk_device_init(np);
> 
> Aren't you missing an of_node_put() here ?

Indeed, it's missing. Will fix that in next version, thanks for pointing out.

>>  				list_del(&clk_provider->node);
>>  				kfree(clk_provider);
>>  				is_init_done = true;

--
Regards,
Sylwester
