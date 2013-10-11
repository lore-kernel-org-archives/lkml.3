Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758337Ab3JKPk6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 11:40:58 -0400
Received: from mail.skyhub.de ([78.46.96.112]:48265 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753206Ab3JKPkz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 11:40:55 -0400
Date: Fri, 11 Oct 2013 17:40:48 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Chen, Gong" <gong.chen@linux.intel.com>
Cc: tony.luck@intel.com, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH 4/8] DMI: Parse memory device (type 17) in SMBIOS
Message-ID: <20131011154048.GH5925@pd.tnic>
References: <1381473166-29303-1-git-send-email-gong.chen@linux.intel.com>
 <1381473166-29303-5-git-send-email-gong.chen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1381473166-29303-5-git-send-email-gong.chen@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 11, 2013 at 02:32:42AM -0400, Chen, Gong wrote:
> This patch adds a new interface to decode memory device (type 17)
> to help error reporting on DIMMs.
> 
> Original-author: Tony Luck <tony.luck@intel.com>
> Signed-off-by: Chen, Gong <gong.chen@linux.intel.com>

Reviewed-by: Borislav Petkov <bp@suse.de>

Just a question below:

> ---
>  arch/ia64/kernel/setup.c    |  1 +
>  arch/x86/kernel/setup.c     |  1 +
>  drivers/firmware/dmi_scan.c | 60 +++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/dmi.h         |  5 ++++
>  4 files changed, 67 insertions(+)
> 

[ ... ]

> diff --git a/drivers/firmware/dmi_scan.c b/drivers/firmware/dmi_scan.c
> index fa0affb..ca3619d 100644
> --- a/drivers/firmware/dmi_scan.c
> +++ b/drivers/firmware/dmi_scan.c
> @@ -25,6 +25,13 @@ static int dmi_initialized;
>  /* DMI system identification string used during boot */
>  static char dmi_ids_string[128] __initdata;
>  
> +static struct dmi_memdev_info {
> +	const char *device;
> +	const char *bank;
> +	u16 handle;
> +} *dmi_memdev;
> +static int dmi_memdev_nr;
> +
>  static const char * __init dmi_string_nosave(const struct dmi_header *dm, u8 s)
>  {
>  	const u8 *bp = ((u8 *) dm) + dm->length;
> @@ -322,6 +329,42 @@ static void __init dmi_save_extended_devices(const struct dmi_header *dm)
>  	dmi_save_one_device(*d & 0x7f, dmi_string_nosave(dm, *(d - 1)));
>  }
>  
> +static void __init count_mem_devices(const struct dmi_header *dm, void *v)
> +{
> +	if (dm->type != DMI_ENTRY_MEM_DEVICE)
> +		return;
> +	dmi_memdev_nr++;
> +}
> +
> +static void __init save_mem_devices(const struct dmi_header *dm, void *v)
> +{
> +	const char *d = (const char *)dm;
> +	static int nr;
> +
> +	if (dm->type != DMI_ENTRY_MEM_DEVICE)
> +		return;
> +	if (nr >= dmi_memdev_nr) {
> +		pr_warn_once("Too many DIMM entries in SMBIOS table\n");
> +		return;

Is this and count_mem_devices() some sort of precaution against insane
DMI tables?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
