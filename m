Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756105AbaJaWu0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 18:50:26 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:59417 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751639AbaJaWuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 18:50:25 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Pavel Machek <pavel@ucw.cz>, Russell King <linux@arm.linux.org.uk>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kevin Hilman <khilman@kernel.org>
Subject: Re: [PATCH v8 1/5] PM / Runtime: Add getter for querying the IRQ safe option
Date: Sat, 01 Nov 2014 00:11:05 +0100
Message-ID: <32933431.rIxraemF7M@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1413795888-18559-2-git-send-email-k.kozlowski@samsung.com>
References: <1413795888-18559-1-git-send-email-k.kozlowski@samsung.com> <1413795888-18559-2-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[CC list trimmed + added Kevin Hilman]

On Monday, October 20, 2014 11:04:44 AM Krzysztof Kozlowski wrote:
> Add a simple getter pm_runtime_is_irq_safe() for querying whether runtime
> PM IRQ safe was set or not.
> 
> Various bus drivers implementing runtime PM may use choose to suspend
> differently based on IRQ safeness status of child driver (e.g. do not
> unprepare the clock if IRQ safe is not set).
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>

So why do we need to add the wrapper?

And it goes kind of against the intention which was to set irq_safe when
we knew that the callbacks were safe to be executed from interrupt context
and not when we wished that to be the case.

> ---
>  Documentation/power/runtime_pm.txt | 4 ++++
>  include/linux/pm_runtime.h         | 6 ++++++
>  2 files changed, 10 insertions(+)
> 
> diff --git a/Documentation/power/runtime_pm.txt b/Documentation/power/runtime_pm.txt
> index f32ce5419573..397b81593142 100644
> --- a/Documentation/power/runtime_pm.txt
> +++ b/Documentation/power/runtime_pm.txt
> @@ -468,6 +468,10 @@ drivers/base/power/runtime.c and include/linux/pm_runtime.h:
>      - set the power.irq_safe flag for the device, causing the runtime-PM
>        callbacks to be invoked with interrupts off
>  
> +  bool pm_runtime_is_irq_safe(struct device *dev);
> +    - return true if power.irq_safe flag was set for the device, causing
> +      the runtime-PM callbacks to be invoked with interrupts off
> +
>    void pm_runtime_mark_last_busy(struct device *dev);
>      - set the power.last_busy field to the current time
>  
> diff --git a/include/linux/pm_runtime.h b/include/linux/pm_runtime.h
> index 367f49b9a1c9..44d74f0f182e 100644
> --- a/include/linux/pm_runtime.h
> +++ b/include/linux/pm_runtime.h
> @@ -128,6 +128,11 @@ static inline void pm_runtime_mark_last_busy(struct device *dev)
>  	ACCESS_ONCE(dev->power.last_busy) = jiffies;
>  }
>  
> +static inline bool pm_runtime_is_irq_safe(struct device *dev)
> +{
> +	return dev->power.irq_safe;
> +}
> +
>  #else /* !CONFIG_PM_RUNTIME */
>  
>  static inline int __pm_runtime_idle(struct device *dev, int rpmflags)
> @@ -167,6 +172,7 @@ static inline bool pm_runtime_enabled(struct device *dev) { return false; }
>  
>  static inline void pm_runtime_no_callbacks(struct device *dev) {}
>  static inline void pm_runtime_irq_safe(struct device *dev) {}
> +static inline bool pm_runtime_is_irq_safe(struct device *dev) { return false; }
>  
>  static inline bool pm_runtime_callbacks_present(struct device *dev) { return false; }
>  static inline void pm_runtime_mark_last_busy(struct device *dev) {}
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
