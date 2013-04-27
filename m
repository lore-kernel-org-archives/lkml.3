Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756048Ab3D0AJP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 20:09:15 -0400
Received: from casper.infradead.org ([85.118.1.10]:53045 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751782Ab3D0AJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 20:09:14 -0400
Message-ID: <517B16FF.6070008@infradead.org>
Date: Fri, 26 Apr 2013 17:08:31 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Olof Johansson <olof@lixom.net>
CC: Mike Turquette <mturquette@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] clk: add option to keep boot clocks on
References: <1367019591-31685-1-git-send-email-olof@lixom.net>
In-Reply-To: <1367019591-31685-1-git-send-email-olof@lixom.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/26/13 16:39, Olof Johansson wrote:
> This is primarily useful when there's a driver that doesn't claim clocks
> properly, but the bootloader does. It's not expected to be used in normal
> cases, but for bringup and debug it's very useful to have the option to
> not gate unclaimed clocks that are still on.
> 
> Signed-off-by: Olof Johansson <olof@lixom.net>

add to Documentation/kernel-parameters.txt or somewhere else?

> ---
> 
> Mike, this is a pretty trivial patch that I would love to see in 3.10
> even though it's getting late. I'm definitely not picky about the naming
> of the boot option, so feel free to change it.
> 
> 
> -Olof
> 
>  drivers/clk/clk.c | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 
> diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
> index 20ce67f..b22551e 100644
> --- a/drivers/clk/clk.c
> +++ b/drivers/clk/clk.c
> @@ -499,10 +499,24 @@ out:
>  	return;
>  }
>  
> +
> +static bool keep_boot_clocks;
> +static int __init clk_keep_boot_clocks(char *__unused)
> +{
> +	keep_boot_clocks = true;
> +	return 1;
> +}
> +__setup("clk_keep_boot_clocks", clk_keep_boot_clocks);
> +
>  static int clk_disable_unused(void)
>  {
>  	struct clk *clk;
>  
> +	if (keep_boot_clocks) {
> +		pr_warn("clk: Not disabling unused clocks\n");
> +		return 0;
> +	}
> +
>  	clk_prepare_lock();
>  
>  	hlist_for_each_entry(clk, &clk_root_list, child_node)
> 


-- 
~Randy
