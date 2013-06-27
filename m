Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753664Ab3F0PLl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 11:11:41 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:36806 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752647Ab3F0PLi convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:6:2>);
	Thu, 27 Jun 2013 11:11:38 -0400
Message-Id: <51CC724702000078000E149B@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.2 
Date: Thu, 27 Jun 2013 16:11:35 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Ben Guthro" <benjamin.guthro@citrix.com>
Cc: "Bob Moore" <robert.moore@intel.com>, <xen-devel@lists.xen.org>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>,
        "Rafaell J . Wysocki" <rjw@sisk.pl>, <linux-acpi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 3/5] acpi: Adjust linux acpi OS functions to new
 extended parameter
References: <1372345323-9266-1-git-send-email-benjamin.guthro@citrix.com>
 <1372345323-9266-4-git-send-email-benjamin.guthro@citrix.com>
In-Reply-To: <1372345323-9266-4-git-send-email-benjamin.guthro@citrix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 27.06.13 at 17:02, Ben Guthro <benjamin.guthro@citrix.com> wrote:
> Change the function definitions of acpi_os_prepare_sleep() and
> acpi_os_set_prepare_sleep() to pass along the new extended sleep
> parameter.
> 
> Signed-off-by: Jan Beulich <jbeulich@suse.com>
> Signed-off-by: Ben Guthro <benjamin.guthro@citrix.com>
> Cc: Bob Moore <robert.moore@intel.com>
> Cc: Rafaell J. Wysocki <rjw@sisk.pl>
> Cc: linux-acpi@vger.kernel.org 
> ---
>  drivers/acpi/osl.c   |   16 ++++++++--------
>  include/linux/acpi.h |    6 +++---
>  2 files changed, 11 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
> index e721863..0251c9b 100644
> --- a/drivers/acpi/osl.c
> +++ b/drivers/acpi/osl.c
> @@ -77,8 +77,8 @@ EXPORT_SYMBOL(acpi_in_debugger);
>  extern char line_buf[80];
>  #endif				/*ENABLE_DEBUGGER */
>  
> -static int (*__acpi_os_prepare_sleep)(u8 sleep_state, u32 pm1a_ctrl,
> -				      u32 pm1b_ctrl);
> +static int (*__acpi_os_prepare_sleep)(u8 sleep_state, u32 val_a, u32 val_b,
> +				      bool extended);

So from here till patch 5 the build will be half broken because of
the type mismatches? I think at least the types of the consumers
need to be changed in this patch; leaving the meat of the Xen
change to patch 4 is perhaps fine.

Jan

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
> @@ -1772,8 +1772,8 @@ acpi_status acpi_os_prepare_sleep(u8 sleep_state, u32 
> pm1a_control,
>  	return AE_OK;
>  }
>  
> -void acpi_os_set_prepare_sleep(int (*func)(u8 sleep_state,
> -			       u32 pm1a_ctrl, u32 pm1b_ctrl))
> +void acpi_os_set_prepare_sleep(int (*func)(u8 sleep_state, u32 val_a,
> +			       u32 val_b, bool extended))
>  {
>  	__acpi_os_prepare_sleep = func;
>  }
> diff --git a/include/linux/acpi.h b/include/linux/acpi.h
> index 709a2f2..26f9996 100644
> --- a/include/linux/acpi.h
> +++ b/include/linux/acpi.h
> @@ -477,8 +477,8 @@ static inline bool acpi_driver_match_device(struct device 
> *dev,
>  #endif	/* !CONFIG_ACPI */
>  
>  #ifdef CONFIG_ACPI
> -void acpi_os_set_prepare_sleep(int (*func)(u8 sleep_state,
> -			       u32 pm1a_ctrl,  u32 pm1b_ctrl));
> +void acpi_os_set_prepare_sleep(int (*func)(u8 sleep_state, u32 val_a,
> +			       u32 val_b, bool extended));
>  #ifdef CONFIG_X86
>  void arch_reserve_mem_area(acpi_physical_address addr, size_t size);
>  #else
> @@ -488,7 +488,7 @@ static inline void 
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



