Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932134AbaISTqI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 15:46:08 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:59157 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932080AbaISTqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 15:46:06 -0400
Message-ID: <541C87E9.1080600@gmail.com>
Date: Fri, 19 Sep 2014 12:45:45 -0700
From: Florian Fainelli <f.fainelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: arnd@arndb.de, computersforpeace@gmail.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/2] bus: brcmstb_gisb: register the fault code hook
References: <1411155880-23447-1-git-send-email-f.fainelli@gmail.com> <1411155880-23447-2-git-send-email-f.fainelli@gmail.com>
In-Reply-To: <1411155880-23447-2-git-send-email-f.fainelli@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/19/2014 12:44 PM, Florian Fainelli wrote:
> Commit 44127b771d9c31 ("bus: add Broadcom GISB bus arbiter timeout/error
> handler") added everything that is required to register an ARM fault
> handler for imprecise external aborts, except that there is nothing
> calling this currently.
> 
> We do not need to export that specific function and have to update
> arch/arm/mach-bcm/brcmstb.c to call it, simply, register the fault
> handler with an arch_initcall.
> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
>  drivers/bus/brcmstb_gisb.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/bus/brcmstb_gisb.c b/drivers/bus/brcmstb_gisb.c
> index f2cd6a2d40b4..daae4f77f34a 100644
> --- a/drivers/bus/brcmstb_gisb.c
> +++ b/drivers/bus/brcmstb_gisb.c
> @@ -48,6 +48,7 @@ struct brcmstb_gisb_arb_device {
>  	struct list_head next;
>  	u32 valid_mask;
>  	const char *master_names[sizeof(u32) * BITS_PER_BYTE];
> +	u32 saved_timeout;

Meh, this change is unrelated, I will resubmit a v2 shortly, sorry for
the noise.

>  };
>  
>  static LIST_HEAD(brcmstb_gisb_arb_device_list);
> @@ -160,11 +161,13 @@ static int brcmstb_bus_error_handler(unsigned long addr, unsigned int fsr,
>  	return ret;
>  }
>  
> -void __init brcmstb_hook_fault_code(void)
> +static int __init brcmstb_hook_fault_code(void)
>  {
>  	hook_fault_code(22, brcmstb_bus_error_handler, SIGBUS, 0,
>  			"imprecise external abort");
> +	return 0;
>  }
> +arch_initcall(brcmstb_hook_fault_code)
>  
>  static irqreturn_t brcmstb_gisb_timeout_handler(int irq, void *dev_id)
>  {
> 

