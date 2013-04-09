Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936521Ab3DIWA1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 18:00:27 -0400
Received: from mail-vb0-f42.google.com ([209.85.212.42]:33561 "EHLO
	mail-vb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936570Ab3DIWAX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 18:00:23 -0400
MIME-Version: 1.0
In-Reply-To: <1365077935-6859-2-git-send-email-matt@console-pimps.org>
References: <1365077935-6859-1-git-send-email-matt@console-pimps.org> <1365077935-6859-2-git-send-email-matt@console-pimps.org>
From: Mike Waychison <mikew@google.com>
Date: Tue, 9 Apr 2013 15:00:02 -0700
Message-ID: <CAGTjWtCFSxJMKf=Xp+5MKLSb3qH4YpWVYYmUb6fkjwctMc1bDQ@mail.gmail.com>
Subject: Re: [PATCH 1/6] efi: move utf16 string functions to efi.h
To: Matt Fleming <matt@console-pimps.org>
Cc: "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Matt Fleming <matt.fleming@intel.com>, Tom Gundersen <teg@jklm.no>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fwiw, I was tempted to rename these to ucs2_*() last time I was here.

Reviewed-by: Mike Waychison <mikew@google.com>

On Thu, Apr 4, 2013 at 5:18 AM, Matt Fleming <matt@console-pimps.org> wrote:
> From: Matt Fleming <matt.fleming@intel.com>
>
> There are currently two implementations of the utf16 string functions.
> Somewhat confusingly, they've got different names.
>
> Centralise the functions in efi.h.
>
> Cc: Tom Gundersen <teg@jklm.no>
> Cc: Mike Waychison <mikew@google.com>
> Signed-off-by: Matt Fleming <matt.fleming@intel.com>
> ---
>  drivers/firmware/efivars.c     |   17 -----------------
>  drivers/firmware/google/gsmi.c |   19 ++++---------------
>  include/linux/efi.h            |   17 +++++++++++++++++
>  3 files changed, 21 insertions(+), 32 deletions(-)
>
> diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
> index 7acafb8..34c8783 100644
> --- a/drivers/firmware/efivars.c
> +++ b/drivers/firmware/efivars.c
> @@ -172,23 +172,6 @@ static void efivar_update_sysfs_entries(struct work_struct *);
>  static DECLARE_WORK(efivar_work, efivar_update_sysfs_entries);
>  static bool efivar_wq_enabled = true;
>
> -/* Return the number of unicode characters in data */
> -static unsigned long
> -utf16_strnlen(efi_char16_t *s, size_t maxlength)
> -{
> -       unsigned long length = 0;
> -
> -       while (*s++ != 0 && length < maxlength)
> -               length++;
> -       return length;
> -}
> -
> -static inline unsigned long
> -utf16_strlen(efi_char16_t *s)
> -{
> -       return utf16_strnlen(s, ~0UL);
> -}
> -
>  /*
>   * Return the number of bytes is the length of this string
>   * Note: this is NOT the same as the number of unicode characters
> diff --git a/drivers/firmware/google/gsmi.c b/drivers/firmware/google/gsmi.c
> index 91ddf0f..c409a75 100644
> --- a/drivers/firmware/google/gsmi.c
> +++ b/drivers/firmware/google/gsmi.c
> @@ -288,17 +288,6 @@ static int gsmi_exec(u8 func, u8 sub)
>         return rc;
>  }
>
> -/* Return the number of unicode characters in data */
> -static size_t
> -utf16_strlen(efi_char16_t *data, unsigned long maxlength)
> -{
> -       unsigned long length = 0;
> -
> -       while (*data++ != 0 && length < maxlength)
> -               length++;
> -       return length;
> -}
> -
>  static efi_status_t gsmi_get_variable(efi_char16_t *name,
>                                       efi_guid_t *vendor, u32 *attr,
>                                       unsigned long *data_size,
> @@ -311,7 +300,7 @@ static efi_status_t gsmi_get_variable(efi_char16_t *name,
>         };
>         efi_status_t ret = EFI_SUCCESS;
>         unsigned long flags;
> -       size_t name_len = utf16_strlen(name, GSMI_BUF_SIZE / 2);
> +       size_t name_len = utf16_strnlen(name, GSMI_BUF_SIZE / 2);
>         int rc;
>
>         if (name_len >= GSMI_BUF_SIZE / 2)
> @@ -380,7 +369,7 @@ static efi_status_t gsmi_get_next_variable(unsigned long *name_size,
>                 return EFI_BAD_BUFFER_SIZE;
>
>         /* Let's make sure the thing is at least null-terminated */
> -       if (utf16_strlen(name, GSMI_BUF_SIZE / 2) == GSMI_BUF_SIZE / 2)
> +       if (utf16_strnlen(name, GSMI_BUF_SIZE / 2) == GSMI_BUF_SIZE / 2)
>                 return EFI_INVALID_PARAMETER;
>
>         spin_lock_irqsave(&gsmi_dev.lock, flags);
> @@ -408,7 +397,7 @@ static efi_status_t gsmi_get_next_variable(unsigned long *name_size,
>
>                 /* Copy the name back */
>                 memcpy(name, gsmi_dev.name_buf->start, GSMI_BUF_SIZE);
> -               *name_size = utf16_strlen(name, GSMI_BUF_SIZE / 2) * 2;
> +               *name_size = utf16_strnlen(name, GSMI_BUF_SIZE / 2) * 2;
>
>                 /* copy guid to return buffer */
>                 memcpy(vendor, &param.guid, sizeof(param.guid));
> @@ -434,7 +423,7 @@ static efi_status_t gsmi_set_variable(efi_char16_t *name,
>                               EFI_VARIABLE_BOOTSERVICE_ACCESS |
>                               EFI_VARIABLE_RUNTIME_ACCESS,
>         };
> -       size_t name_len = utf16_strlen(name, GSMI_BUF_SIZE / 2);
> +       size_t name_len = utf16_strnlen(name, GSMI_BUF_SIZE / 2);
>         efi_status_t ret = EFI_SUCCESS;
>         int rc;
>         unsigned long flags;
> diff --git a/include/linux/efi.h b/include/linux/efi.h
> index 9bf2f1f..d1d782a 100644
> --- a/include/linux/efi.h
> +++ b/include/linux/efi.h
> @@ -719,6 +719,23 @@ static inline void memrange_efi_to_native(u64 *addr, u64 *npages)
>         *addr &= PAGE_MASK;
>  }
>
> +/* Return the number of unicode characters in data */
> +static inline unsigned long
> +utf16_strnlen(efi_char16_t *s, size_t maxlength)
> +{
> +       unsigned long length = 0;
> +
> +       while (*s++ != 0 && length < maxlength)
> +               length++;
> +       return length;
> +}
> +
> +static inline unsigned long
> +utf16_strlen(efi_char16_t *s)
> +{
> +       return utf16_strnlen(s, ~0UL);
> +}
> +
>  #if defined(CONFIG_EFI_VARS) || defined(CONFIG_EFI_VARS_MODULE)
>  /*
>   * EFI Variable support.
> --
> 1.7.10.4
>
