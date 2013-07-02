Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932280Ab3GBGT2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 02:19:28 -0400
Received: from mga11.intel.com ([192.55.52.93]:50587 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932116Ab3GBGT0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 02:19:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,978,1363158000"; 
   d="scan'208";a="363963786"
From: "Zheng, Lv" <lv.zheng@intel.com>
To: Ben Guthro <benjamin.guthro@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jan Beulich <jbeulich@suse.com>, "Rafaell J . Wysocki" <rjw@sisk.pl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>
CC: "Moore, Robert" <robert.moore@intel.com>
Subject: RE: [PATCH v3 1/3] acpi: Call acpi_os_prepare_sleep hook in reduced
 hardware sleep path
Thread-Topic: [PATCH v3 1/3] acpi: Call acpi_os_prepare_sleep hook in
 reduced hardware sleep path
Thread-Index: AQHOcnac189PXIyTT0GA11YOlMneHJlQ7d+w
Date: Tue, 2 Jul 2013 06:19:22 +0000
Message-ID: <1AE640813FDE7649BE1B193DEA596E880241B363@SHSMSX101.ccr.corp.intel.com>
References: <1372255575-29567-1-git-send-email-benjamin.guthro@citrix.com>
 <1372255575-29567-2-git-send-email-benjamin.guthro@citrix.com>
In-Reply-To: <1372255575-29567-2-git-send-email-benjamin.guthro@citrix.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for your efforts!

I wonder if it is possible to remove the argument - "u8 extended" and convert "pm1a_control, pm1b_control" into some u8 values that are equivalent to "acpi_gbl_sleep_type_a, acpi_gbl_sleep_type_b" in the legacy sleep path.
It can also simplify Xen codes.

As in ACPI specification, the bit definitions between the legacy sleep registers and the extended sleep registers are equivalent.

The legacy sleep register definition:
Table 4-16 PM1 Status Registers Fixed Hardware Feature Status Bits - WAK_STS(bit 15)
Table 4-18 PM1 Control Registers Fixed Hardware Feature Control Bits - SLP_TYPx (bit 10-12), SLP_EN (bit 13)

The extended sleep register definition:
Table 4-24 Sleep Control Register - SLP_TYPx (3 bits from offset 2), SLP_EN (1 bit from offset 5), here 10-8 = 2, and 13-8 = 5, this definition is equivalent to Table 4-18.
Table 4-25 Sleep Status Register - WAK_STS (1 bit 7), 15-8 = 7, this definition is equivalent to Table 4-16.

Thanks and best regards
-Lv

> -----Original Message-----
> From: linux-acpi-owner@vger.kernel.org
> [mailto:linux-acpi-owner@vger.kernel.org] On Behalf Of Ben Guthro
> Sent: Wednesday, June 26, 2013 10:06 PM
> To: Konrad Rzeszutek Wilk; Jan Beulich; Rafaell J . Wysocki;
> linux-kernel@vger.kernel.org; linux-acpi@vger.kernel.org;
> xen-devel@lists.xen.org
> Cc: Ben Guthro; Moore, Robert
> Subject: [PATCH v3 1/3] acpi: Call acpi_os_prepare_sleep hook in reduced
> hardware sleep path
> 
> In version 3.4 acpi_os_prepare_sleep() got introduced in parallel with
> reduced hardware sleep support, and the two changes didn't get
> synchronized: The new code doesn't call the hook function (if so
> requested). Fix this, requiring a parameter to be added to the
> hook function to distinguish "extended" from "legacy" sleep.
> 
> Signed-off-by: Ben Guthro <benjamin.guthro@citrix.com>
> Signed-off-by: Jan Beulich <jbeulich@suse.com>
> Cc: Bob Moore <robert.moore@intel.com>
> Cc: Rafaell J. Wysocki <rjw@sisk.pl>
> Cc: linux-acpi@vger.kernel.org
> ---
>  drivers/acpi/acpica/hwesleep.c |    8 ++++++++
>  drivers/acpi/acpica/hwsleep.c  |    2 +-
>  drivers/acpi/osl.c             |   16 ++++++++--------
>  include/linux/acpi.h           |   10 +++++-----
>  4 files changed, 22 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/acpi/acpica/hwesleep.c b/drivers/acpi/acpica/hwesleep.c
> index 5e5f762..6834dd7 100644
> --- a/drivers/acpi/acpica/hwesleep.c
> +++ b/drivers/acpi/acpica/hwesleep.c
> @@ -43,6 +43,7 @@
>   */
> 
>  #include <acpi/acpi.h>
> +#include <linux/acpi.h>
>  #include "accommon.h"
> 
>  #define _COMPONENT          ACPI_HARDWARE
> @@ -128,6 +129,13 @@ acpi_status acpi_hw_extended_sleep(u8
> sleep_state)
> 
>  	ACPI_FLUSH_CPU_CACHE();
> 
> +	status = acpi_os_prepare_sleep(sleep_state, acpi_gbl_sleep_type_a,
> +				       acpi_gbl_sleep_type_b, true);
> +	if (ACPI_SKIP(status))
> +		return_ACPI_STATUS(AE_OK);
> +	if (ACPI_FAILURE(status))
> +		return_ACPI_STATUS(status);
> +
>  	/*
>  	 * Set the SLP_TYP and SLP_EN bits.
>  	 *
> diff --git a/drivers/acpi/acpica/hwsleep.c b/drivers/acpi/acpica/hwsleep.c
> index e3828cc..a93c299 100644
> --- a/drivers/acpi/acpica/hwsleep.c
> +++ b/drivers/acpi/acpica/hwsleep.c
> @@ -153,7 +153,7 @@ acpi_status acpi_hw_legacy_sleep(u8 sleep_state)
>  	ACPI_FLUSH_CPU_CACHE();
> 
>  	status = acpi_os_prepare_sleep(sleep_state, pm1a_control,
> -				       pm1b_control);
> +				       pm1b_control, false);
>  	if (ACPI_SKIP(status))
>  		return_ACPI_STATUS(AE_OK);
>  	if (ACPI_FAILURE(status))
> diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
> index e721863..3fc2801 100644
> --- a/drivers/acpi/osl.c
> +++ b/drivers/acpi/osl.c
> @@ -77,8 +77,8 @@ EXPORT_SYMBOL(acpi_in_debugger);
>  extern char line_buf[80];
>  #endif				/*ENABLE_DEBUGGER */
> 
> -static int (*__acpi_os_prepare_sleep)(u8 sleep_state, u32 pm1a_ctrl,
> -				      u32 pm1b_ctrl);
> +static int (*__acpi_os_prepare_sleep)(u8 sleep_state, u32 val_a, u32 val_b,
> +				      u8 extended);
> 
>  static acpi_osd_handler acpi_irq_handler;
>  static void *acpi_irq_context;
> @@ -1757,13 +1757,13 @@ acpi_status acpi_os_terminate(void)
>  	return AE_OK;
>  }
> 
> -acpi_status acpi_os_prepare_sleep(u8 sleep_state, u32 pm1a_control,
> -				  u32 pm1b_control)
> +acpi_status acpi_os_prepare_sleep(u8 sleep_state, u32 val_a, u32 val_b,
> +				  u8 extended)
>  {
>  	int rc = 0;
>  	if (__acpi_os_prepare_sleep)
> -		rc = __acpi_os_prepare_sleep(sleep_state,
> -					     pm1a_control, pm1b_control);
> +		rc = __acpi_os_prepare_sleep(sleep_state, val_a, val_b,
> +					     extended);
>  	if (rc < 0)
>  		return AE_ERROR;
>  	else if (rc > 0)
> @@ -1772,8 +1772,8 @@ acpi_status acpi_os_prepare_sleep(u8 sleep_state,
> u32 pm1a_control,
>  	return AE_OK;
>  }
> 
> -void acpi_os_set_prepare_sleep(int (*func)(u8 sleep_state,
> -			       u32 pm1a_ctrl, u32 pm1b_ctrl))
> +void acpi_os_set_prepare_sleep(int (*func)(u8 sleep_state, u32 val_a,
> +					   u32 val_b, u8 extended))
>  {
>  	__acpi_os_prepare_sleep = func;
>  }
> diff --git a/include/linux/acpi.h b/include/linux/acpi.h
> index 17b5b59..de99022 100644
> --- a/include/linux/acpi.h
> +++ b/include/linux/acpi.h
> @@ -477,11 +477,11 @@ static inline bool acpi_driver_match_device(struct
> device *dev,
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
>  #ifdef CONFIG_X86
>  void arch_reserve_mem_area(acpi_physical_address addr, size_t size);
>  #else
> @@ -491,7 +491,7 @@ static inline void
> arch_reserve_mem_area(acpi_physical_address addr,
>  }
>  #endif /* CONFIG_X86 */
>  #else
> -#define acpi_os_set_prepare_sleep(func, pm1a_ctrl, pm1b_ctrl) do { } while
> (0)
> +#define acpi_os_set_prepare_sleep(func, val_a, val_b, ext) do { } while (0)
>  #endif
> 
>  #if defined(CONFIG_ACPI) && defined(CONFIG_PM_RUNTIME)
> --
> 1.7.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
