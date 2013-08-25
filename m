Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756638Ab3HYTh5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Aug 2013 15:37:57 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:33540 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756099Ab3HYTh4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Aug 2013 15:37:56 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        Len Brown <lenb@kernel.org>
Subject: Re: [PATCH] acpi: blacklist win8 OSI for buggy laptops
Date: Sun, 25 Aug 2013 21:48:34 +0200
Message-ID: <1703730.yuNIYf6TyH@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.11.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <1377452253-15882-1-git-send-email-felipe.contreras@gmail.com>
References: <1377452253-15882-1-git-send-email-felipe.contreras@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, August 25, 2013 12:37:33 PM Felipe Contreras wrote:
> Since v3.7 the acpi backlight driver doesn't work correctly in several
> machines because ACPI code has different code for Windows 8, and the
> rest.
> 
> The commit ea45ea7 (in v3.11-rc2) tried to fix this problem by using the
> intel backlight driver, however it introduced several other issues in
> different machines.
> 
> This patch fixes both regressions by blacklisting the win8 OSI, so we
> are back to v3.6 behavior, and it should remain that way until the intel
> backlight driver is fixed.
> 
> Since v3.7, users have been forced to fix the initial regression by
> modifying the boot arguments (acpi_osi="!Windows 2012").
> 
> Once the Intel backlight driver works correctly for all machines, this
> blacklist can be removed and that driver can be used instead.
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=60682
> 
> Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>

Queued up for 3.12, but I've already applied your previous patch for the Asus
Zenbook, so I needed to rebase this one.  Please check the bleeding-edge branch
of the linux-pm.git tree for the result.

Also next time you fix problems reported by other people please add Reported-by
tags to the patch to give a credit to the reporters.

Thanks,
Rafael


> ---
>  drivers/acpi/blacklist.c | 35 +++++++++++++++++++++++++++++++++++
>  1 file changed, 35 insertions(+)
> 
> diff --git a/drivers/acpi/blacklist.c b/drivers/acpi/blacklist.c
> index cb96296..42cccbe 100644
> --- a/drivers/acpi/blacklist.c
> +++ b/drivers/acpi/blacklist.c
> @@ -192,6 +192,12 @@ static int __init dmi_disable_osi_win7(const struct dmi_system_id *d)
>  	acpi_osi_setup("!Windows 2009");
>  	return 0;
>  }
> +static int __init dmi_disable_osi_win8(const struct dmi_system_id *d)
> +{
> +	printk(KERN_NOTICE PREFIX "DMI detected: %s\n", d->ident);
> +	acpi_osi_setup("!Windows 2012");
> +	return 0;
> +}
>  
>  static struct dmi_system_id acpi_osi_dmi_table[] __initdata = {
>  	{
> @@ -269,6 +275,35 @@ static struct dmi_system_id acpi_osi_dmi_table[] __initdata = {
>  	},
>  
>  	/*
> +	 * The following machines have broken backlight support when reporting
> +	 * the Windows 2012 OSI, so disable it until their support is fixed.
> +	 */
> +	{
> +	.callback = dmi_disable_osi_win8,
> +	.ident = "ASUS Zenbook Prime UX31A",
> +	.matches = {
> +		     DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
> +		     DMI_MATCH(DMI_PRODUCT_NAME, "UX31A"),
> +		},
> +	},
> +	{
> +	.callback = dmi_disable_osi_win8,
> +	.ident = "Dell Inspiron 15R SE",
> +	.matches = {
> +		     DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
> +		     DMI_MATCH(DMI_PRODUCT_NAME, "Inspiron 7520"),
> +		},
> +	},
> +	{
> +	.callback = dmi_disable_osi_win8,
> +	.ident = "Lenovo ThinkPad Edge E530",
> +	.matches = {
> +		     DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
> +		     DMI_MATCH(DMI_PRODUCT_VERSION, "3259A2G"),
> +		},
> +	},
> +
> +	/*
>  	 * BIOS invocation of _OSI(Linux) is almost always a BIOS bug.
>  	 * Linux ignores it, except for the machines enumerated below.
>  	 */
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
