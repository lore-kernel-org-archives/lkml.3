Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754556AbbAZNcs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 08:32:48 -0500
Received: from mail-ig0-f173.google.com ([209.85.213.173]:34286 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753315AbbAZNcp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 08:32:45 -0500
MIME-Version: 1.0
In-Reply-To: <1422278918-31477-2-git-send-email-ivan.khoronzhuk@linaro.org>
References: <1422278918-31477-1-git-send-email-ivan.khoronzhuk@linaro.org>
	<1422278918-31477-2-git-send-email-ivan.khoronzhuk@linaro.org>
Date: Mon, 26 Jan 2015 13:32:44 +0000
Message-ID: <CAKv+Gu_0rboaHFn6buoHUtupR4_Wgoi5WqZ_jK9Uw9ooAquLLQ@mail.gmail.com>
Subject: Re: [Patch v2 1/2] firmware: dmi_scan: add symbol to get SMBIOS entry area
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        "x86@kernel.org" <x86@kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dmidecode-devel@nongnu.org, Grant Likely <grant.likely@linaro.org>,
        Leif Lindholm <leif.lindholm@linaro.org>,
        Matt Fleming <matt.fleming@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26 January 2015 at 13:28, Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org> wrote:
> There are situations when code needs to access SMBIOS entry table
> area. For example, to pass it via sysfs to userspace when it's not
> allowed to get SMBIOS info via /dev/mem.
>
> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>

Reviewed-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

> ---
>  drivers/firmware/dmi_scan.c | 26 ++++++++++++++++++++++++++
>  include/linux/dmi.h         |  3 +++
>  2 files changed, 29 insertions(+)
>
> diff --git a/drivers/firmware/dmi_scan.c b/drivers/firmware/dmi_scan.c
> index 420c8d8..d94c6b7 100644
> --- a/drivers/firmware/dmi_scan.c
> +++ b/drivers/firmware/dmi_scan.c
> @@ -113,6 +113,8 @@ static void dmi_table(u8 *buf, int len, int num,
>         }
>  }
>
> +static unsigned char smbios_header[32];
> +static int smbios_header_size;
>  static phys_addr_t dmi_base;
>  static u16 dmi_len;
>  static u16 dmi_num;
> @@ -474,6 +476,8 @@ static int __init dmi_present(const u8 *buf)
>         if (memcmp(buf, "_SM_", 4) == 0 &&
>             buf[5] < 32 && dmi_checksum(buf, buf[5])) {
>                 smbios_ver = get_unaligned_be16(buf + 6);
> +               smbios_header_size = buf[5];
> +               memcpy(smbios_header, buf, smbios_header_size);
>
>                 /* Some BIOS report weird SMBIOS version, fix that up */
>                 switch (smbios_ver) {
> @@ -505,6 +509,8 @@ static int __init dmi_present(const u8 *buf)
>                                 pr_info("SMBIOS %d.%d present.\n",
>                                        dmi_ver >> 8, dmi_ver & 0xFF);
>                         } else {
> +                               smbios_header_size = 15;
> +                               memcpy(smbios_header, buf, smbios_header_size);
>                                 dmi_ver = (buf[14] & 0xF0) << 4 |
>                                            (buf[14] & 0x0F);
>                                 pr_info("Legacy DMI %d.%d present.\n",
> @@ -531,6 +537,8 @@ static int __init dmi_smbios3_present(const u8 *buf)
>                 dmi_ver &= 0xFFFFFF;
>                 dmi_len = get_unaligned_le32(buf + 12);
>                 dmi_base = get_unaligned_le64(buf + 16);
> +               smbios_header_size = buf[6];
> +               memcpy(smbios_header, buf, smbios_header_size);
>
>                 /*
>                  * The 64-bit SMBIOS 3.0 entry point no longer has a field
> @@ -944,3 +952,21 @@ void dmi_memdev_name(u16 handle, const char **bank, const char **device)
>         }
>  }
>  EXPORT_SYMBOL_GPL(dmi_memdev_name);
> +
> +/**
> + * dmi_get_smbios_entry_area - copy SMBIOS entry point area to array.
> + * @size - pointer to assign actual size of SMBIOS entry point area.
> + *
> + * returns NULL if table is not available, otherwise returns pointer on
> + * SMBIOS entry point area array.
> + */
> +const u8 *dmi_get_smbios_entry_area(int *size)
> +{
> +       if (!smbios_header_size || !dmi_available)
> +               return NULL;
> +
> +       *size = smbios_header_size;
> +
> +       return smbios_header;
> +}
> +EXPORT_SYMBOL_GPL(dmi_get_smbios_entry_area);
> diff --git a/include/linux/dmi.h b/include/linux/dmi.h
> index f820f0a..8e1a28d 100644
> --- a/include/linux/dmi.h
> +++ b/include/linux/dmi.h
> @@ -109,6 +109,7 @@ extern int dmi_walk(void (*decode)(const struct dmi_header *, void *),
>         void *private_data);
>  extern bool dmi_match(enum dmi_field f, const char *str);
>  extern void dmi_memdev_name(u16 handle, const char **bank, const char **device);
> +const u8 *dmi_get_smbios_entry_area(int *size);
>
>  #else
>
> @@ -140,6 +141,8 @@ static inline void dmi_memdev_name(u16 handle, const char **bank,
>                 const char **device) { }
>  static inline const struct dmi_system_id *
>         dmi_first_match(const struct dmi_system_id *list) { return NULL; }
> +static inline const u8 *dmi_get_smbios_entry_area(int *size)
> +       { return NULL; }
>
>  #endif
>
> --
> 1.9.1
>
