Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752391Ab3CKFiP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 01:38:15 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:49548 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751516Ab3CKFiN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 01:38:13 -0400
Message-ID: <513D6E2D.4040805@ti.com>
Date: Mon, 11 Mar 2013 11:09:57 +0530
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Lokesh Vutla <lokeshvutla@ti.com>
CC: <linux-kernel@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Nishanth Menon <nm@ti.com>
Subject: Re: [PATCH 5/8] memory: emif: use restart if power_off not present
 when out of spec
References: <1362978365-5593-1-git-send-email-lokeshvutla@ti.com> <1362978365-5593-6-git-send-email-lokeshvutla@ti.com>
In-Reply-To: <1362978365-5593-6-git-send-email-lokeshvutla@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 11 March 2013 10:36 AM, Lokesh Vutla wrote:
> From: Nishanth Menon <nm@ti.com>
> 
> Some machine or kernel variants might have missed implementation
> of power off handlers. We DONOT want to let the system be in
> "out of spec" state in this condition. So, WARN and attempt
> a machine restart in the hopes of clearing the out-of-spec
> temperature condition.
> 
> NOTE: This is not the safest option, but safer than leaving the
> system in unstable conditions.
> 
> Signed-off-by: Nishanth Menon <nm@ti.com>
> Signed-off-by: Lokesh Vutla <lokeshvutla@ti.com>
> ---
>  drivers/memory/emif.c |    9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/memory/emif.c b/drivers/memory/emif.c
> index 927fb55..02a94fc 100644
> --- a/drivers/memory/emif.c
> +++ b/drivers/memory/emif.c
> @@ -25,6 +25,7 @@
>  #include <linux/module.h>
>  #include <linux/list.h>
>  #include <linux/spinlock.h>
> +#include <linux/pm.h>
>  #include <memory/jedec_ddr.h>
>  #include "emif.h"
>  #include "of_memory.h"
> @@ -1011,7 +1012,13 @@ static irqreturn_t emif_threaded_isr(int irq, void *dev_id)
>  
>  	if (emif->temperature_level == SDRAM_TEMP_VERY_HIGH_SHUTDOWN) {
>  		dev_emerg(emif->dev, "SDRAM temperature exceeds operating limit.. Needs shut down!!!\n");
> -		kernel_power_off();
Extra line here would be good here.
> +		/* If we have Power OFF ability, use it, else try restarting */
> +		if (pm_power_off) {
> +			kernel_power_off();
> +		} else {
> +			WARN(1, "FIXME: NO pm_power_off!!! trying restart\n");
> +			kernel_restart("SDRAM Over-temp Emergency restart");
> +		}
>  		return IRQ_HANDLED;
>  	}
>  
Otherwise,
Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>

