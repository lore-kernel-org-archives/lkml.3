Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752044AbaEUJSS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 05:18:18 -0400
Received: from mail-ig0-f175.google.com ([209.85.213.175]:65062 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011AbaEUJR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 05:17:57 -0400
Date: Wed, 21 May 2014 10:17:51 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Jay Aurabind <mail@aurabindo.in>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kbuild test robot <fengguang.wu@intel.com>
Subject: Re: [PATCH V2] mfd: abx500-core: Fix compiler warning larger stack
 frame
Message-ID: <20140521091751.GC6679@lee--X1>
References: <536E1543.3090107@aurabindo.in>
 <20140520152054.GB24991@lee--X1>
 <537C447D.7070406@aurabindo.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <537C447D.7070406@aurabindo.in>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Change from V1 -> V2: Fix a potential null pointer dereference as reported by kbuild test robot <fengguang.wu@intel.com>.
> 
> Inorder to report the kzalloc failure, I have just used a pr_debug statement. If it looks ugly, should I change the function's return value to int and give out an -ENOMEM ?

Yes, please do that - and obviously add the checks to the calling code.

> From 6615c7a995a6bb4dcf4c1e9ac59bca823ec821a5 Mon Sep 17 00:00:00 2001
> From: Aurabindo J <mail@aurabindo.in>
> Date: Wed, 21 May 2014 11:18:10 +0530
> Subject: [PATCH] mfd: abx500-core: Fix compiler warning larger stack frame
> 
> On systems with CONFIG_FRAME_WARN=1024, compiler warns the allocation of
> an object of struct device on stack. Make the allocation dynamically to
> fix the warning.
> 
> Signed-off-by: Aurabindo J <mail@aurabindo.in>
> ---
>  drivers/mfd/abx500-core.c | 19 ++++++++++++-------
>  1 file changed, 12 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/mfd/abx500-core.c b/drivers/mfd/abx500-core.c
> index f3a15aa..5e5098d 100644
> --- a/drivers/mfd/abx500-core.c
> +++ b/drivers/mfd/abx500-core.c
> @@ -154,16 +154,21 @@ EXPORT_SYMBOL(abx500_startup_irq_enabled);
>  void abx500_dump_all_banks(void)
>  {
>  	struct abx500_ops *ops;
> -	struct device dummy_child = {NULL};
> +	struct device *dummy_child;
>  	struct abx500_device_entry *dev_entry;
>  
> -	list_for_each_entry(dev_entry, &abx500_list, list) {
> -		dummy_child.parent = dev_entry->dev;
> -		ops = &dev_entry->ops;
> +	dummy_child = kzalloc(sizeof(struct device), GFP_KERNEL);
> +	if (dummy_child != NULL) {
> +		list_for_each_entry(dev_entry, &abx500_list, list) {
> +			dummy_child->parent = dev_entry->dev;
> +			ops = &dev_entry->ops;
>  
> -		if ((ops != NULL) && (ops->dump_all_banks != NULL))
> -			ops->dump_all_banks(&dummy_child);
> -	}
> +			if ((ops != NULL) && (ops->dump_all_banks != NULL))
> +				ops->dump_all_banks(dummy_child);
> +		}
> +		kfree(dummy_child);
> +	} else
> +		pr_debug("kzalloc failure in abx500_dump_all_banks\n");
>  }
>  EXPORT_SYMBOL(abx500_dump_all_banks);
>  



-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
