Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758045Ab3GRI44 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 04:56:56 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:54736 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757670Ab3GRIzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 04:55:38 -0400
Message-ID: <51E7AD38.6010108@ti.com>
Date: Thu, 18 Jul 2013 11:54:16 +0300
From: Grygorii Strashko <grygorii.strashko@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>
CC: Kevin Hilman <khilman@linaro.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>,
        Benoit Cousson <benoit.cousson@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>
Subject: Re: [PATCH 3/3] ARM: dts: omap4-sdp: add dynamic pin states for uart3/4
References: <1374061312-25469-1-git-send-email-grygorii.strashko@ti.com> <1374061312-25469-4-git-send-email-grygorii.strashko@ti.com> <20130717153248.GI7656@atomide.com> <51E6C939.40208@ti.com> <20130718080953.GR7656@atomide.com>
In-Reply-To: <20130718080953.GR7656@atomide.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/18/2013 11:09 AM, Tony Lindgren wrote:
> * Grygorii Strashko <grygorii.strashko@ti.com> [130717 09:48]:
>> Hi,
>>
>> On 07/17/2013 06:32 PM, Tony Lindgren wrote:
>>> * Grygorii Strashko <grygorii.strashko@ti.com> [130717 04:49]:
>>>> Add dynamic "active"/"idle" pin states for uart3/4 which will be applied
>>>> when uart3/4 state is switched from active to idle and back by Runtime
>>>> PM or during system suspend.
>>>
>>> This is good for testing code, but should not be merged because
>>> omap4 has the iopad wake-ups available for uarts. So those can
>>> be always enabled.
>>
>> In this case, 2 IRQ will be received per each UART RX event - one from
>> PRCM and from UART - and that's not good from PM perspective (It will
>> affect on CPUIdle and CPUFreq at least).
>
> Oh I see, that's because I accidentally left the debug code enabled
> to make it easier to test the wake-up events without having to
> have working off-idle. The wake flags can be kept on always for
> sure.
>
> The patch below should sort out the issue of getting wake-up interrupts
> during runtime as long as you don't have DEBUG defined.
>
> Regards,
>
> Tony
>
> --- a/drivers/pinctrl/pinctrl-single-omap.c
> +++ b/drivers/pinctrl/pinctrl-single-omap.c
> @@ -140,9 +140,17 @@ static irqreturn_t pcs_omap_handle_irq(int irq, void *data)
>   		if ((val & OMAP_WAKEUP_EVENT_MASK) == OMAP_WAKEUP_EVENT_MASK)
>   			generic_handle_irq(wakeirq);
>   	}
> -
> +#ifdef DEBUG

Don't think it's debug code - IO chain need to be rearmed after each
PRCM IO IRQ - otherwise IO wakeup events may be lost (at least on
OMAP4, OMAP5 requires more complex handling(( ).


> +	/*
> +	 * This enables wake-up interrupts during runtime also
> +	 * causing duplicate interrupts. But it also makes debugging
> +	 * the wake-up events easy as deeper idle states often are
> +	 * not working for new devices while the drivers are being
> +	 * developed.
> +	 */
>   	if (pcso->reconfigure_io_chain)
>   		pcso->reconfigure_io_chain();
> +#endif
>
>   	return IRQ_HANDLED;
>   }
>

I didn't pick up your padconf patches yet -seems i need to be in sync :)

Below the diff I used to verify IO wake up (It follows old IO daisy
chain hanlding models in hwmod before DT):


--- a/arch/arm/mach-omap2/omap_device.c
+++ b/arch/arm/mach-omap2/omap_device.c
@@ -574,7 +574,7 @@ odbs_exit:

         return ERR_PTR(ret);
  }
-
+#include "prm44xx.h"
  #ifdef CONFIG_PM_RUNTIME
  static int _od_runtime_suspend(struct device *dev)
  {
@@ -586,6 +586,7 @@ static int _od_runtime_suspend(struct device *dev)
         if (!ret) {
                 omap_device_idle(pdev);
                 pinctrl_pm_select_idle_state(dev);
+               omap44xx_prm_reconfigure_io_chain();
         }

         return ret;
@@ -596,6 +597,7 @@ static int _od_runtime_resume(struct device *dev)
         struct platform_device *pdev = to_platform_device(dev);

         pinctrl_pm_select_active_state(dev);
+       omap44xx_prm_reconfigure_io_chain();

         omap_device_enable(pdev);

diff --git a/arch/arm/mach-omap2/prm_common.c 
b/arch/arm/mach-omap2/prm_common.c
index 228b850..5db073a 100644
--- a/arch/arm/mach-omap2/prm_common.c
+++ b/arch/arm/mach-omap2/prm_common.c
@@ -79,7 +79,7 @@ static void omap_prcm_events_filter_priority(unsigned 
long *events,
                 events[i] ^= priority_events[i];
         }
  }
-
+#include "prm44xx.h"
  /*
   * PRCM Interrupt Handler
   *
@@ -144,6 +144,7 @@ static void omap_prcm_irq_handler(unsigned int irq, 
struct irq_desc *desc)
         chip->irq_unmask(&desc->irq_data);

         prcm_irq_setup->ocp_barrier(); /* avoid spurious IRQs */
+       omap44xx_prm_reconfigure_io_chain();
  }


