Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933128AbaKSAOw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 19:14:52 -0500
Received: from mail-ie0-f175.google.com ([209.85.223.175]:62967 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932108AbaKSAOv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 19:14:51 -0500
MIME-Version: 1.0
In-Reply-To: <1863054.8ksDvip1yp@vostro.rjw.lan>
References: <20141015225657.GA818@dtor-ws>
	<CAE_wzQ-wAWZX5AKsdJ9LNFYkN9rz+WbMgBb4S+-edb76NUoDgA@mail.gmail.com>
	<1672520.bjZSvglt27@vostro.rjw.lan>
	<1863054.8ksDvip1yp@vostro.rjw.lan>
Date: Tue, 18 Nov 2014 16:14:49 -0800
Message-ID: <CAE_wzQ_keT0zm0iV=S3gM9r94bM73E5kFpbWX85AckRVcC6KSQ@mail.gmail.com>
Subject: Re: [PATCH] ACPI: do not fail suspend if unable to configure wakeup
From: Dmitry Torokhov <dtor@chromium.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Dmitry Torokhov <dtor@chromium.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Benson Leung <bleung@chromium.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 18, 2014 at 4:20 PM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> It goes again below with a changelog, but since technically it is a regression
> fix, I'd like to push it for "stable" too.  I suppose that the commit that
> things stopped working after is a76e9bd89ae7 (i2c: attach/detach I2C client
> device to the ACPI power domain).  Is that correct?

Yes.

>
> Rafael
>
>
> --
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Subject: ACPI / PM: Ignore wakeup setting if the ACPI companion can't wake up
>
> As reported by Dmitry, on some Chromebooks there are devices with
> corresponding ACPI objects and with unusual system wakeup
> configuration.  Namely, they technically are wakeup-capable, but the
> wakeup is handled via a platform-specific out-of-band mechanism
> rather than by standard ACPI means.

I think they are using standard ACPI wakeup methods, but in a very perverted
way: there is "shadow" ACPI sleep button corresponding to the GPIO assigned
to the trackpad or touchscreen; it is just not tied to touchpad/touchscreen
device in DSDT.

We won't have such set up again, but we do have existing boxes that are
like that.

>  As a result, the
> device_may_wakeup(dev) called from acpi_dev_suspend_late() returns
> 'true' for them, but the wakeup.flags.valid flag is unset for the
> corresponding ACPI device objects, so acpi_dev_suspend_late()
> reproducibly returns an error for them causing the entire system
> suspend to be aborted.  Consequently, system suspend doesn't work
> on those machines at all.
>
> Address the problem by ignoring the device_may_wakeup(dev) return
> value in acpi_dev_suspend_late() if the ACPI companion of the device
> in question has wakeup.flags.valid unset (in which case it is clear
> that the wakeup cannot happen via ACPI).
>
> Reported-by: Dmitry Torokhov <dtor@chromium.org>
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> ---
>  drivers/acpi/device_pm.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> Index: linux-pm/drivers/acpi/device_pm.c
> ===================================================================
> --- linux-pm.orig/drivers/acpi/device_pm.c
> +++ linux-pm/drivers/acpi/device_pm.c
> @@ -878,7 +878,7 @@ int acpi_dev_suspend_late(struct device
>                 return 0;
>
>         target_state = acpi_target_system_state();
> -       wakeup = device_may_wakeup(dev);
> +       wakeup = device_may_wakeup(dev) && acpi_device_can_wakeup(adev);
>         error = acpi_device_wakeup(adev, target_state, wakeup);
>         if (wakeup && error)
>                 return error;
>
