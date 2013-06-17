Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752680Ab3FQWV7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 18:21:59 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:40670 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751305Ab3FQWV5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 18:21:57 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Matthew Garrett <matthew.garrett@nebula.com>, linux-kernel@vger.kernel.org
Cc: linux-acpi@vger.kernel.org, seth.forshee@canonical.com,
        joeyli.kernel@gmail.com, daniel.vetter@ffwll.ch, lenb@kernel.org,
        Bob Moore <robert.moore@intel.com>
Subject: Re: [PATCH 2/3] ACPICA: Add interface for getting latest OS version requested via _OSI
Date: Tue, 18 Jun 2013 00:31:14 +0200
Message-ID: <2212597.t9jOQU2YXi@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1370818899-8595-3-git-send-email-matthew.garrett@nebula.com>
References: <1370818899-8595-1-git-send-email-matthew.garrett@nebula.com> <1370818899-8595-3-git-send-email-matthew.garrett@nebula.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matthew,

On Sunday, June 09, 2013 07:01:38 PM Matthew Garrett wrote:
> Drivers may need to make policy decisions based on the OS that the firmware
> believes it's interacting with. ACPI firmware will make a series of _OSI
> calls, starting from the oldest OS version they support and ending with the
> most recent. Add a function to return the last successful call so that
> drivers know what the firmware's expecting.
> 
> Based on a patch by Seth Forshee <seth.forshee@canonical.com>

Bob (CCed) would prefer us to access acpi_gbl_osi_data directly instead of
adding the wrapper to ACPICA.  He also thinks that the symbol definitions
should go into include/acpi/actypes.h rather than into acpixf.h.

Then, the only ACPICA change would be to move the symbols and we can
add a Linux-specific patch on top of that adding the acpi_gbl_osi_data
wrapper.

How does that sound?

Rafael


> Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>
> Cc: Seth Forshee <seth.forshee@canonical.com>
> ---
>  drivers/acpi/acpica/aclocal.h | 13 -------------
>  drivers/acpi/acpica/utxface.c | 19 +++++++++++++++++++
>  include/acpi/acpixf.h         | 22 ++++++++++++++++++++++
>  3 files changed, 41 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/acpi/acpica/aclocal.h b/drivers/acpi/acpica/aclocal.h
> index d5bfbd3..8a2f532 100644
> --- a/drivers/acpi/acpica/aclocal.h
> +++ b/drivers/acpi/acpica/aclocal.h
> @@ -948,19 +948,6 @@ struct acpi_bit_register_info {
>  
>  /* Structs and definitions for _OSI support and I/O port validation */
>  
> -#define ACPI_OSI_WIN_2000               0x01
> -#define ACPI_OSI_WIN_XP                 0x02
> -#define ACPI_OSI_WIN_XP_SP1             0x03
> -#define ACPI_OSI_WINSRV_2003            0x04
> -#define ACPI_OSI_WIN_XP_SP2             0x05
> -#define ACPI_OSI_WINSRV_2003_SP1        0x06
> -#define ACPI_OSI_WIN_VISTA              0x07
> -#define ACPI_OSI_WINSRV_2008            0x08
> -#define ACPI_OSI_WIN_VISTA_SP1          0x09
> -#define ACPI_OSI_WIN_VISTA_SP2          0x0A
> -#define ACPI_OSI_WIN_7                  0x0B
> -#define ACPI_OSI_WIN_8                  0x0C
> -
>  #define ACPI_ALWAYS_ILLEGAL             0x00
>  
>  struct acpi_interface_info {
> diff --git a/drivers/acpi/acpica/utxface.c b/drivers/acpi/acpica/utxface.c
> index 6505774..c1638c3 100644
> --- a/drivers/acpi/acpica/utxface.c
> +++ b/drivers/acpi/acpica/utxface.c
> @@ -389,6 +389,25 @@ ACPI_EXPORT_SYMBOL(acpi_install_interface_handler)
>  
>  /*****************************************************************************
>   *
> + * FUNCTION:    acpi_osi_version
> + *
> + * PARAMETERS:  None
> + *
> + * RETURN:      Last OS version requested via _OSI
> + *
> + * DESCRIPTION: Returns the argument to the most recent _OSI query performed
> + *		by the firmware
> + *
> + ****************************************************************************/
> +u8 acpi_osi_version(void)
> +{
> +	return acpi_gbl_osi_data;
> +}
> +
> +ACPI_EXPORT_SYMBOL(acpi_osi_version)
> +
> +/*****************************************************************************
> + *
>   * FUNCTION:    acpi_check_address_range
>   *
>   * PARAMETERS:  space_id            - Address space ID
> diff --git a/include/acpi/acpixf.h b/include/acpi/acpixf.h
> index 454881e..41d3ac1 100644
> --- a/include/acpi/acpixf.h
> +++ b/include/acpi/acpixf.h
> @@ -82,6 +82,22 @@ extern u8 acpi_gbl_truncate_io_addresses;
>  extern u8 acpi_gbl_disable_auto_repair;
>  
>  /*
> + * Values returned by acpi_osi_version()
> + */
> +#define ACPI_OSI_WIN_2000               0x01
> +#define ACPI_OSI_WIN_XP                 0x02
> +#define ACPI_OSI_WIN_XP_SP1             0x03
> +#define ACPI_OSI_WINSRV_2003            0x04
> +#define ACPI_OSI_WIN_XP_SP2             0x05
> +#define ACPI_OSI_WINSRV_2003_SP1        0x06
> +#define ACPI_OSI_WIN_VISTA              0x07
> +#define ACPI_OSI_WINSRV_2008            0x08
> +#define ACPI_OSI_WIN_VISTA_SP1          0x09
> +#define ACPI_OSI_WIN_VISTA_SP2          0x0A
> +#define ACPI_OSI_WIN_7                  0x0B
> +#define ACPI_OSI_WIN_8                  0x0C
> +
> +/*
>   * Hardware-reduced prototypes. All interfaces that use these macros will
>   * be configured out of the ACPICA build if the ACPI_REDUCED_HARDWARE flag
>   * is set to TRUE.
> @@ -307,6 +323,12 @@ acpi_status acpi_install_notify_handler(acpi_handle device, u32 handler_type,
>  					acpi_notify_handler handler,
>  					void *context);
>  
> +#ifdef CONFIG_ACPI
> +u8 acpi_osi_version(void);
> +#else
> +static inline u8 acpi_osi_version(void) { return 0; }
> +#endif
> +
>  acpi_status
>  acpi_remove_notify_handler(acpi_handle device,
>  			   u32 handler_type, acpi_notify_handler handler);
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
