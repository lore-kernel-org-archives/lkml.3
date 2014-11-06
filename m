Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751667AbaKFSXl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 13:23:41 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:54142 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751618AbaKFSXi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 13:23:38 -0500
Date: Thu, 6 Nov 2014 18:23:29 +0000
From: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
To: Anatol Pomozov <anatol.pomozov@gmail.com>
Cc: "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] clocksource: arch_timer: Mark ARMv8 system timer as
 'always-on'
Message-ID: <20141106182329.GA445@red-moon>
References: <1415296639-40203-1-git-send-email-anatol.pomozov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415296639-40203-1-git-send-email-anatol.pomozov@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2014 at 05:57:19PM +0000, Anatol Pomozov wrote:
> Quoting ARMv8 Reference Manual section D6.1:
> "The system counter must be implemented in an always-on power domain."

Do not mix up the system counter with arch timers. System counter is
always-on, but the arch timer(s) logic (that implements eg timers
comparators against the system counter value) might not be (timer logic
is in the processor), so it can be lost on processor(s) power down.

NAK.

Lorenzo

> There is no need to keep 'always-on' configurable on ARMv8. We ignore
> this dts property value and unconditionally set it to true.


> 
> The issue was discovered while working on ARMv8 board with only one timer
> (arm arch timer). If 'always-on' is false then it disables high-resolution
> timer functionality.
> 
> Signed-off-by: Anatol Pomozov <anatol.pomozov@gmail.com>
> ---
>  .../devicetree/bindings/arm/arch_timer.txt          |  8 ++++++--
>  drivers/clocksource/arm_arch_timer.c                | 21 +++++++++++++++++----
>  2 files changed, 23 insertions(+), 6 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/arm/arch_timer.txt b/Documentation/devicetree/bindings/arm/arch_timer.txt
> index 37b2caf..cb2d572 100644
> --- a/Documentation/devicetree/bindings/arm/arch_timer.txt
> +++ b/Documentation/devicetree/bindings/arm/arch_timer.txt
> @@ -19,8 +19,12 @@ to deliver its interrupts via SPIs.
>  
>  - clock-frequency : The frequency of the main counter, in Hz. Optional.
>  
> -- always-on : a boolean property. If present, the timer is powered through an
> -  always-on power domain, therefore it never loses context.
> +- always-on : an "armv7-timer" specific boolean property.
> +  If present, the timer is powered through an always-on power domain, therefore
> +  it never loses context.
> +  ARMv8 system timer is in always-on power domain (per Architecture Reference
> +  section D6.1) thus this proprty is ignored for "arm,armv8-timer" compatible
> +  timer.
>  
>  Example:
>  
> diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
> index 2133f9d..610052d 100644
> --- a/drivers/clocksource/arm_arch_timer.c
> +++ b/drivers/clocksource/arm_arch_timer.c
> @@ -719,13 +719,26 @@ static void __init arch_timer_init(struct device_node *np)
>  		}
>  	}
>  
> -	arch_timer_c3stop = !of_property_read_bool(np, "always-on");
> -
>  	arch_timer_register();
>  	arch_timer_common_init();
>  }
> -CLOCKSOURCE_OF_DECLARE(armv7_arch_timer, "arm,armv7-timer", arch_timer_init);
> -CLOCKSOURCE_OF_DECLARE(armv8_arch_timer, "arm,armv8-timer", arch_timer_init);
> +
> +static void __init v7_arch_timer_init(struct device_node *np)
> +{
> +	arch_timer_c3stop = !of_property_read_bool(np, "always-on");
> +	arch_timer_init(np);
> +}
> +
> +static void __init v8_arch_timer_init(struct device_node *np)
> +{
> +	/* Per ARMv8 Architecture Reference Manual section D6.1
> +	 * the system timer is in always-on power domain.
> +	 */
> +	arch_timer_c3stop = false;
> +	arch_timer_init(np);
> +}
> +CLOCKSOURCE_OF_DECLARE(armv7_arch_timer, "arm,armv7-timer", v7_arch_timer_init);
> +CLOCKSOURCE_OF_DECLARE(armv8_arch_timer, "arm,armv8-timer", v8_arch_timer_init);
>  
>  static void __init arch_timer_mem_init(struct device_node *np)
>  {
> -- 
> 2.1.0.rc2.206.gedb03e5
> 
> 
