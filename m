Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752709Ab3FZOlu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 10:41:50 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:47635 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355Ab3FZOlq convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:6:2>);
	Wed, 26 Jun 2013 10:41:46 -0400
Message-Id: <51CB19C602000078000E0D75@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.2 
Date: Wed, 26 Jun 2013 15:41:42 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Ben Guthro" <benjamin.guthro@citrix.com>
Cc: "Bob Moore" <robert.moore@intel.com>, <xen-devel@lists.xen.org>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>,
        "Rafaell J . Wysocki" <rjw@sisk.pl>, <linux-acpi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 1/3] acpi: Call acpi_os_prepare_sleep hook in
 reduced hardware sleep path
References: <1372255575-29567-1-git-send-email-benjamin.guthro@citrix.com>
 <1372255575-29567-2-git-send-email-benjamin.guthro@citrix.com>
In-Reply-To: <1372255575-29567-2-git-send-email-benjamin.guthro@citrix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 26.06.13 at 16:06, Ben Guthro <benjamin.guthro@citrix.com> wrote:
> In version 3.4 acpi_os_prepare_sleep() got introduced in parallel with
> reduced hardware sleep support, and the two changes didn't get
> synchronized: The new code doesn't call the hook function (if so
> requested). Fix this, requiring a parameter to be added to the
> hook function to distinguish "extended" from "legacy" sleep.
> 
> Signed-off-by: Ben Guthro <benjamin.guthro@citrix.com>
> Signed-off-by: Jan Beulich <jbeulich@suse.com>

I think these are intended to reflect the flow of things, so
should be reversed (also in the other patches).

> --- a/drivers/acpi/acpica/hwesleep.c
> +++ b/drivers/acpi/acpica/hwesleep.c
> @@ -43,6 +43,7 @@
>   */
>  
>  #include <acpi/acpi.h>
> +#include <linux/acpi.h>

This also got complaints, so I'd be very surprised if they took it now.

>  #include "accommon.h"
>  
>  #define _COMPONENT          ACPI_HARDWARE
> @@ -128,6 +129,13 @@ acpi_status acpi_hw_extended_sleep(u8 sleep_state)
>  
>  	ACPI_FLUSH_CPU_CACHE();
>  
> +	status = acpi_os_prepare_sleep(sleep_state, acpi_gbl_sleep_type_a,
> +				       acpi_gbl_sleep_type_b, true);

Without using "bool", using "true" and "false" is wrong (should
be TRUE and FALSE afaict).

> --- a/drivers/acpi/acpica/hwsleep.c
> +++ b/drivers/acpi/acpica/hwsleep.c
> @@ -153,7 +153,7 @@ acpi_status acpi_hw_legacy_sleep(u8 sleep_state)
>  	ACPI_FLUSH_CPU_CACHE();
>  
>  	status = acpi_os_prepare_sleep(sleep_state, pm1a_control,
> -				       pm1b_control);
> +				       pm1b_control, false);

Same here.

>  	if (ACPI_SKIP(status))
>  		return_ACPI_STATUS(AE_OK);
>  	if (ACPI_FAILURE(status))

And the split point ought to be here - everything below doesn't
modify ACPI CA code. Which in particular means that ...

> --- a/include/linux/acpi.h
> +++ b/include/linux/acpi.h
> @@ -477,11 +477,11 @@ static inline bool acpi_driver_match_device(struct device *dev,
>  #endif	/* !CONFIG_ACPI */
>  
>  #ifdef CONFIG_ACPI
> -void acpi_os_set_prepare_sleep(int (*func)(u8 sleep_state,
> -			       u32 pm1a_ctrl,  u32 pm1b_ctrl));
> +void acpi_os_set_prepare_sleep(int (*func)(u8 sleep_state, u32 val_a,
> +					   u32 val_b, u8 extended));
>  
> -acpi_status acpi_os_prepare_sleep(u8 sleep_state,
> -				  u32 pm1a_control, u32 pm1b_control);
> +acpi_status acpi_os_prepare_sleep(u8 sleep_state, u32 val_a, u32 val_b,
> +				  u8 extended);

... this needs to be moved elsewhere (under include/acpi/), but the
two incarnations of acpi_os_set_prepare_sleep() should presumably
remain here.

Jan

>  #ifdef CONFIG_X86
>  void arch_reserve_mem_area(acpi_physical_address addr, size_t size);
>  #else
> @@ -491,7 +491,7 @@ static inline void arch_reserve_mem_area(acpi_physical_address addr,
>  }
>  #endif /* CONFIG_X86 */
>  #else
> -#define acpi_os_set_prepare_sleep(func, pm1a_ctrl, pm1b_ctrl) do { } while (0)
> +#define acpi_os_set_prepare_sleep(func, val_a, val_b, ext) do { } while (0)
>  #endif
>  
>  #if defined(CONFIG_ACPI) && defined(CONFIG_PM_RUNTIME)


