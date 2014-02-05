Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752232AbaBEKva (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 05:51:30 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:58428 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751549AbaBEKv2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 05:51:28 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Toshi Kani <toshi.kani@hp.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ACPI hotplug: Fix panic on eject to ejected device
Date: Wed, 05 Feb 2014 12:05:58 +0100
Message-ID: <3540455.FvCglr7S6V@vostro.rjw.lan>
User-Agent: KMail/4.11.4 (Linux/3.13.0+; KDE/4.11.4; x86_64; ; )
In-Reply-To: <1391561308-18893-1-git-send-email-toshi.kani@hp.com>
References: <1391561308-18893-1-git-send-email-toshi.kani@hp.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, February 04, 2014 05:48:28 PM Toshi Kani wrote:
> When an eject request is sent to an ejected ACPI device, the following
> panic occurs:
> 
>  ACPI: \_SB_.SCK3.CPU3: ACPI_NOTIFY_EJECT_REQUEST event
>  BUG: unable to handle kernel NULL pointer dereference at 0000000000000070
>  IP: [<ffffffff813a7cfe>] acpi_device_hotplug+0x10b/0x33b
> 	:
>  Call Trace:
>  [<ffffffff813a24da>] acpi_hotplug_work_fn+0x1c/0x27
>  [<ffffffff8109cbe5>] process_one_work+0x175/0x430
>  [<ffffffff8109d7db>] worker_thread+0x11b/0x3a0
> 
> This is becase device->handler is NULL in acpi_device_hotplug().
> This case was used to fail in acpi_hotplug_notify_cb() as the target
> had no acpi_deivce.  However, acpi_device now exists after ejection.
> 
> Added a check to verify if acpi_device->handler is valid for an
> eject request in acpi_hotplug_notify_cb().  Note that handler passed
> from an argument is still valid while acpi_device->handler is NULL.
> 
> Signed-off-by: Toshi Kani <toshi.kani@hp.com>
> ---
>  drivers/acpi/scan.c |    5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
> index 7384158..5cf6adf 100644
> --- a/drivers/acpi/scan.c
> +++ b/drivers/acpi/scan.c
> @@ -484,7 +484,6 @@ static void acpi_device_hotplug(void *data, u32 src)
>  static void acpi_hotplug_notify_cb(acpi_handle handle, u32 type, void *data)
>  {
>  	u32 ost_code = ACPI_OST_SC_NON_SPECIFIC_FAILURE;
> -	struct acpi_scan_handler *handler = data;
>  	struct acpi_device *adev;
>  	acpi_status status;
>  
> @@ -500,7 +499,9 @@ static void acpi_hotplug_notify_cb(acpi_handle handle, u32 type, void *data)
>  		break;
>  	case ACPI_NOTIFY_EJECT_REQUEST:
>  		acpi_handle_debug(handle, "ACPI_NOTIFY_EJECT_REQUEST event\n");
> -		if (!handler->hotplug.enabled) {
> +		if (!adev->handler)
> +			goto err_out;
> +		if (!adev->handler->hotplug.enabled) {
>  			acpi_handle_err(handle, "Eject disabled\n");
>  			ost_code = ACPI_OST_SC_EJECT_NOT_SUPPORTED;
>  			goto err_out;

OK, I'll queue this up for the next pull request, but it actually isn't safe,
because adev is not really guaranteed to exist here (it might have been deleted
already when this function is running).

The series of 24 patches I've sent recently addresses this problem, but they
are 3.15 material, so we need a stop-gap for 3.14.

Thanks!

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
