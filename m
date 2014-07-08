Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755118AbaGHNIn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 09:08:43 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:53549 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754876AbaGHNIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 09:08:41 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Lan Tianyu <tianyu.lan@intel.com>
Cc: lenb@kernel.org, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 2/2] ACPI/Wakup: Enable button wakeup GPEs if these GPEs have associated GPE methods.
Date: Tue, 08 Jul 2014 15:26:45 +0200
Message-ID: <3011365.oYtXFx0LHa@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.15.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1404802679-24019-2-git-send-email-tianyu.lan@intel.com>
References: <1404802679-24019-1-git-send-email-tianyu.lan@intel.com> <1404802679-24019-2-git-send-email-tianyu.lan@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, July 08, 2014 02:57:58 PM Lan Tianyu wrote:
> The button wakeup GPEs are enabled unconditionally in the current world by
> commit 2a5d24(ACPI / Wakeup: Enable button GPEs unconditionally during
> initialization). Because button's GPE methods needs to be run to clear
> GPE status on some machines when there is GPE interrupt. If not, it will
> cause machines resume immediately after being suspended since GPE status
> isn't cleared correctly.
> 
> But if there is no GPE method for button wakeup GPE, these GPEs should not
> be enabled since nothing needs to be done when they are triggered and this
> also causes LID GPE storm on Lenovo Ideapad y560p.
> 
> This patch is to check Button GPE method and enable it if there is associated
> GPE method.

Part of the problem is that we call acpi_setup_gpe_for_wake() for buttons too
and it sets ACPI_GPE_DISPATCH_NOTIFY unconditionally.  While we could address
this the way you're proposing, it seems a bit less than straightforward so to
speak.

Let me think more about how to address that.

> Reference: https://bugzilla.kernel.org/show_bug.cgi?id=61051
> Reported-by: James Tocknell<aragilar@gmail.com>
> Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
> ---
>  drivers/acpi/wakeup.c | 11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/acpi/wakeup.c b/drivers/acpi/wakeup.c
> index 1638401..5b20ae4 100644
> --- a/drivers/acpi/wakeup.c
> +++ b/drivers/acpi/wakeup.c
> @@ -86,9 +86,14 @@ int __init acpi_wakeup_device_init(void)
>  						       struct acpi_device,
>  						       wakeup_list);
>  		if (device_can_wakeup(&dev->dev)) {
> -			/* Button GPEs are supposed to be always enabled. */
> -			acpi_enable_gpe(dev->wakeup.gpe_device,
> -					dev->wakeup.gpe_number);
> +			/*
> +			 * Button GPEs are supposed to be always enabled if
> +			 * they have associated GPE methods.
> +			 */
> +			if (ACPI_SUCCESS(acpi_check_gpe_method(
> +			    dev->wakeup.gpe_device, dev->wakeup.gpe_number)))
> +				acpi_enable_gpe(dev->wakeup.gpe_device,
> +						dev->wakeup.gpe_number);
>  			device_set_wakeup_enable(&dev->dev, true);
>  		}
>  	}
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
