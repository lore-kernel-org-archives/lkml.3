Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752778AbaD0TJA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 15:09:00 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:62307 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375AbaD0TI6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 15:08:58 -0400
Message-ID: <535D55C6.9090609@gmail.com>
Date: Sun, 27 Apr 2014 21:08:54 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Russell King <rmk+kernel@arm.linux.org.uk>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>
Subject: Re: [PATCH] clkdev: only fall through to clk_get_sys() if DT indicates
 no entry
References: <E1We4rQ-0001mv-Ps@rmk-PC.arm.linux.org.uk>
In-Reply-To: <E1We4rQ-0001mv-Ps@rmk-PC.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/26/2014 05:49 PM, Russell King wrote:
> There are two failures which DT can return when looking up a phandle:
> -ENOENT - when DT finds that the desired property/index is not present
> -EINVAL - when DT finds that the desired property/index is present, but
>   there is a problem parsing it.
>
> We should only fall through to clk_get_sys() (the table driven clock
> lookup) when DT indicates that there was no entry in the OF tables
> for the clock.  Doing otherwise causes the clk API to always indicate
> that there is no entry for this clock, which is not correct behaviour.
>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
> ---
> Grant, Rob,
>
> Please let me know ASAP if this gives you any cause for concern.  This
> looks to me like a long standing bug which really needs fixing.  Part
> of the motivation here is similar to Jean-Francois' patch to clkdev
> which allows a DT specified clock which isn't get present to have
> clk_get() and friends return -EPROBE_DEFER - again, something that I
> think really should happen.  Jean-Francois hasn't been able to get
> much traction for his patch, so let's start with fixing this bug first.

How about upstream commit a34cd4666f3da84228a82f70c94b8d9b692034ea,
I thought it already solves the issue you're trying to address in
this patch ?

>   drivers/clk/clkdev.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/clk/clkdev.c b/drivers/clk/clkdev.c
> index 48f67218247c..4e65d0e10b05 100644
> --- a/drivers/clk/clkdev.c
> +++ b/drivers/clk/clkdev.c
> @@ -165,7 +165,7 @@ struct clk *clk_get(struct device *dev, const char *con_id)
>
>   	if (dev) {
>   		clk = of_clk_get_by_name(dev->of_node, con_id);
> -		if (!IS_ERR(clk))
> +		if (!IS_ERR(clk) || PTR_ERR(clk) != -ENOENT)
>   			return clk;
>   	}

--
Regards,
Sylwester
