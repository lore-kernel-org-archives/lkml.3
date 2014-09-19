Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757772AbaISUR1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 16:17:27 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:38181 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756771AbaISUR0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 16:17:26 -0400
Date: Fri, 19 Sep 2014 13:17:22 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: Florian Fainelli <f.fainelli@gmail.com>
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 1/2] bus: brcmstb_gisb: register the fault code hook
Message-ID: <20140919201722.GL1193@ld-irv-0074>
References: <1411156230-24024-1-git-send-email-f.fainelli@gmail.com>
 <1411156230-24024-2-git-send-email-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411156230-24024-2-git-send-email-f.fainelli@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 19, 2014 at 12:50:29PM -0700, Florian Fainelli wrote:
> Commit 44127b771d9c31 ("bus: add Broadcom GISB bus arbiter timeout/error
> handler") added everything that is required to register an ARM fault
> handler for imprecise external aborts, except that there is nothing
> calling this currently.
> 
> We do not need to export that specific function and have to update
> arch/arm/mach-bcm/brcmstb.c to call it, simply, register the fault
> handler with an arch_initcall.

Am I missing something, or does that mean that this error handler will
be registered for *all* kernels which include this driver? e.g., anyone
using multi_v7_defconfig?

So it seems we need to gate this behind some kind of machine check;
either called from mach-bcm/*, or better, from something that is probed
via device tree. Is it a problem to register this in the probe()
function, like drivers/pci/host/pci-imx6.c?

> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
> Changes in v2:
> - removed the accidental hunk that added saved_timeout since it does
>   not belong in this patch
> 
>  drivers/bus/brcmstb_gisb.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/bus/brcmstb_gisb.c b/drivers/bus/brcmstb_gisb.c
> index f2cd6a2d40b4..5b608955957a 100644
> --- a/drivers/bus/brcmstb_gisb.c
> +++ b/drivers/bus/brcmstb_gisb.c
> @@ -160,11 +160,13 @@ static int brcmstb_bus_error_handler(unsigned long addr, unsigned int fsr,
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

Brian
