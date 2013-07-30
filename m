Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757003Ab3G3DLM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 23:11:12 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:63664 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753015Ab3G3DLK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 23:11:10 -0400
Message-ID: <51F72EF3.8080706@gmail.com>
Date: Tue, 30 Jul 2013 11:11:47 +0800
From: Aaron Lu <aaron.lwe@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Felipe Contreras <felipe.contreras@gmail.com>
CC: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <lenb@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [REGRESSION/PATCH] acpi: blacklist win8 OSI for ASUS Zenbok Prime
 UX31A
References: <1375125658-1223-1-git-send-email-felipe.contreras@gmail.com>
In-Reply-To: <1375125658-1223-1-git-send-email-felipe.contreras@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/30/2013 03:20 AM, Felipe Contreras wrote:
> Since v3.7 the acpi backlight driver doesn't work at all on this machine
> because presumably the ACPI code contains stub code when Windows 8 OSI is
> reported.
> 
> The commit ea45ea7 (in v3.11-rc2) tried to fix this problem by using the intel
> backlight driver, however, on this machine it turns the backlight completely
> off when it reaches level 0%, after which the user might have a lot trouble
> trying to bring it back.

What do you mean by a lot of trouble? If you press hotkey to increase
backlight brightness level, does it work? If so, the screen should not
be black any more, it's not that user has to blindly enter some command
to get out of the black screen.

And I'm not sure if this is a bug of intel_backlight(setting a low level
makes the screen almost off), I see different models with different
vendors having this behavior. If this is deemed a bug, then I'm afraid
intel_backlight interface is useless for a lot of systems...perhaps we
can only say, intel_backlight's interpretation of low levels are
different with ACPI video's, and that's probably why its type is named
as raw :-)

-Aaron

> 
> This patch fixes both regressions by blacklisting the win8 OSI, so we are back
> to v3.6 behavior, and it should remain that way until the intel backlight
> driver is fixed.
> 
> Since v3.7, users have been forced to fix the initial regression by modifying
> the boot arguments [1].
> 
> [1] https://wiki.archlinux.org/index.php/ASUS_Zenbook_Prime_UX31A
> 
> Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
> ---
>  drivers/acpi/blacklist.c | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 
> diff --git a/drivers/acpi/blacklist.c b/drivers/acpi/blacklist.c
> index cb96296..a404127 100644
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
> @@ -267,6 +273,14 @@ static struct dmi_system_id acpi_osi_dmi_table[] __initdata = {
>  		     DMI_MATCH(DMI_PRODUCT_NAME, "Satellite P305D"),
>  		},
>  	},
> +	{
> +	.callback = dmi_disable_osi_win8,
> +	.ident = "ASUS Zenbook Prime UX31A",
> +	.matches = {
> +		     DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
> +		     DMI_MATCH(DMI_PRODUCT_NAME, "UX31A"),
> +		},
> +	},
>  
>  	/*
>  	 * BIOS invocation of _OSI(Linux) is almost always a BIOS bug.
> 

