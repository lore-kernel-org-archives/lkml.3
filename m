Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754902AbbAZNev (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 08:34:51 -0500
Received: from mail-ie0-f176.google.com ([209.85.223.176]:36392 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754135AbbAZNes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 08:34:48 -0500
MIME-Version: 1.0
In-Reply-To: <1422278918-31477-3-git-send-email-ivan.khoronzhuk@linaro.org>
References: <1422278918-31477-1-git-send-email-ivan.khoronzhuk@linaro.org>
	<1422278918-31477-3-git-send-email-ivan.khoronzhuk@linaro.org>
Date: Mon, 26 Jan 2015 13:34:47 +0000
Message-ID: <CAKv+Gu8_ND+6Ep+WT8qBZ=ASLHQOxP_eMD9LhtogMb1ifMWsVw@mail.gmail.com>
Subject: Re: [Patch v2 2/2] firmware: dmi-sysfs: add SMBIOS entry point area attribute
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
> area, but cannot use /dev/mem for this. As the table format is
> consistent only for a version, and can be changed, use binary
> attribute to give access to raw SMBIOS entry table area.
>
> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>

Reviewed-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

> ---
>  drivers/firmware/dmi-sysfs.c | 42 ++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 42 insertions(+)
>
> diff --git a/drivers/firmware/dmi-sysfs.c b/drivers/firmware/dmi-sysfs.c
> index e0f1cb3..61b6a38 100644
> --- a/drivers/firmware/dmi-sysfs.c
> +++ b/drivers/firmware/dmi-sysfs.c
> @@ -29,6 +29,8 @@
>  #define MAX_ENTRY_TYPE 255 /* Most of these aren't used, but we consider
>                               the top entry type is only 8 bits */
>
> +static const u8 *smbios_raw_header;
> +
>  struct dmi_sysfs_entry {
>         struct dmi_header dh;
>         struct kobject kobj;
> @@ -646,9 +648,37 @@ static void cleanup_entry_list(void)
>         }
>  }
>
> +static ssize_t smbios_entry_area_raw_read(struct file *filp,
> +                                         struct kobject *kobj,
> +                                         struct bin_attribute *bin_attr,
> +                                         char *buf, loff_t pos, size_t count)
> +{
> +       ssize_t size;
> +
> +       size = bin_attr->size;
> +
> +       if (size > pos)
> +               size -= pos;
> +       else
> +               return 0;
> +
> +       if (count < size)
> +               size = count;
> +
> +       memcpy(buf, &smbios_raw_header[pos], size);
> +
> +       return size;
> +}
> +
> +static struct bin_attribute smbios_raw_area_attr = {
> +       .read = smbios_entry_area_raw_read,
> +       .attr = {.name = "smbios_raw_header", .mode = 0400},
> +};
> +
>  static int __init dmi_sysfs_init(void)
>  {
>         int error = -ENOMEM;
> +       int size;
>         int val;
>
>         /* Set up our directory */
> @@ -669,6 +699,18 @@ static int __init dmi_sysfs_init(void)
>                 goto err;
>         }
>
> +       smbios_raw_header = dmi_get_smbios_entry_area(&size);
> +       if (!smbios_raw_header) {
> +               pr_debug("dmi-sysfs: SMBIOS raw data is not available.\n");
> +               error = -ENODATA;
> +               goto err;
> +       }
> +
> +       /* Create the raw binary file to access the entry area */
> +       smbios_raw_area_attr.size = size;
> +       if (sysfs_create_bin_file(dmi_kobj, &smbios_raw_area_attr))
> +               goto err;
> +
>         pr_debug("dmi-sysfs: loaded.\n");
>
>         return 0;
> --
> 1.9.1
>
