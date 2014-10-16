Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751576AbaJPIK1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 04:10:27 -0400
Received: from mail-oi0-f51.google.com ([209.85.218.51]:54029 "EHLO
	mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751084AbaJPIKV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 04:10:21 -0400
MIME-Version: 1.0
In-Reply-To: <20141015225657.GA818@dtor-ws>
References: <20141015225657.GA818@dtor-ws>
Date: Thu, 16 Oct 2014 10:10:20 +0200
X-Google-Sender-Auth: hqHxqK1PoUr2bjSvN8xi_38dZ1s
Message-ID: <CAJZ5v0jAe9npr-4U+CGCQWfZ8bQ988z+_pRjUiMN871kP-39FQ@mail.gmail.com>
Subject: Re: [PATCH] ACPI: do not fail suspend if unable to configure wakeup
From: "Rafael J. Wysocki" <rafael@kernel.org>
To: Dmitry Torokhov <dtor@chromium.org>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Benson Leung <bleung@chromium.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Oct 16, 2014 at 12:56 AM, Dmitry Torokhov <dtor@chromium.org> wrote:
> Newer kernels put i2c devices with ACPI companion in ACPI power domain and
> then ACPI will try to configure them for wakeup (if requested).
> Unfortunately on some Chromebooks firmware separates wakeup GPIO into a
> completely separate device (which is handled by the kernel as a sleep
> button), leaving the touchpads themselves not wakeup capable (as far as
> ACPI is concerned). This causes ACPI late suspend code to fail to configure
> them as wakeup sources and aborts entire suspend.
>
> To work around this issues let's not abort entire suspend process if
> driver asked to be a wakeup source but ACPI can not satisfy that
> request.
>
> Note that originally I tried to simply change the driver to not mark
> device as wakeup source, unfortunately then we do not know that we
> should not be powering down the device completely, otherwise we can't
> wake up.
>
> Verified by making sure that "echo mem > /sys/power/state" works on
> Squawks.
>
> Reviewed-by: Benson Leung <bleung@chromium.org>
> Signed-off-by: Dmitry Torokhov <dtor@chromium.org>
> ---
>  drivers/acpi/device_pm.c | 16 ++++++++++++----
>  1 file changed, 12 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/acpi/device_pm.c b/drivers/acpi/device_pm.c
> index 67075f8..440bc3d 100644
> --- a/drivers/acpi/device_pm.c
> +++ b/drivers/acpi/device_pm.c
> @@ -871,6 +871,7 @@ int acpi_dev_suspend_late(struct device *dev)
>         struct acpi_device *adev = ACPI_COMPANION(dev);
>         u32 target_state;
>         bool wakeup;
> +       bool can_wakeup;
>         int error;
>
>         if (!adev)
> @@ -878,12 +879,19 @@ int acpi_dev_suspend_late(struct device *dev)
>
>         target_state = acpi_target_system_state();
>         wakeup = device_may_wakeup(dev);
> -       error = acpi_device_wakeup(adev, target_state, wakeup);
> -       if (wakeup && error)
> -               return error;
> +       can_wakeup = acpi_device_can_wakeup(adev);
> +
> +       if (can_wakeup) {
> +               error = acpi_device_wakeup(adev, target_state, wakeup);
> +               if (wakeup && error)
> +                       return error;
> +       } else if (wakeup) {

I think we just need to return an error code in that case, because otherwise
this is potentially dangerous (worst case, it may be impossible to wake up
the machine at all after that).

> +               dev_warn(dev,
> +                        "device is not wakeup-capable, not enabling wakeup\n");
> +       }
>
>         error = acpi_dev_pm_low_power(dev, adev, target_state);
> -       if (error)
> +       if (error && can_wakeup)
>                 acpi_device_wakeup(adev, ACPI_STATE_UNKNOWN, false);
>
>         return error;
> --

Rafael
