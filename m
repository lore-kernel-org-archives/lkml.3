Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932831AbaKRXb3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 18:31:29 -0500
Received: from mail-ie0-f182.google.com ([209.85.223.182]:33709 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754692AbaKRXb1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 18:31:27 -0500
MIME-Version: 1.0
In-Reply-To: <2163272.NHMRkNIupX@vostro.rjw.lan>
References: <20141015225657.GA818@dtor-ws>
	<20141016160555.GA3255@dtor-ws>
	<CAE_wzQ8FTtnMGTxyaFu8=QqyuD0=W_ZyWXCf9_BK1sWKZHh95g@mail.gmail.com>
	<2163272.NHMRkNIupX@vostro.rjw.lan>
Date: Tue, 18 Nov 2014 15:31:26 -0800
Message-ID: <CAE_wzQ-wAWZX5AKsdJ9LNFYkN9rz+WbMgBb4S+-edb76NUoDgA@mail.gmail.com>
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

On Tue, Nov 18, 2014 at 3:43 PM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> On Tuesday, November 18, 2014 10:00:53 AM Dmitry Torokhov wrote:
>> Hi Rafael,
>>
>> On Thu, Oct 16, 2014 at 9:05 AM, Dmitry Torokhov <dtor@chromium.org> wrote:
>> > Hi Rafael,
>> >
>> > On Thu, Oct 16, 2014 at 10:10:20AM +0200, Rafael J. Wysocki wrote:
>> >> Hi,
>> >>
>> >> On Thu, Oct 16, 2014 at 12:56 AM, Dmitry Torokhov <dtor@chromium.org> wrote:
>> >> > Newer kernels put i2c devices with ACPI companion in ACPI power domain and
>> >> > then ACPI will try to configure them for wakeup (if requested).
>> >> > Unfortunately on some Chromebooks firmware separates wakeup GPIO into a
>> >> > completely separate device (which is handled by the kernel as a sleep
>> >> > button), leaving the touchpads themselves not wakeup capable (as far as
>> >> > ACPI is concerned). This causes ACPI late suspend code to fail to configure
>> >> > them as wakeup sources and aborts entire suspend.
>> >> >
>> >> > To work around this issues let's not abort entire suspend process if
>> >> > driver asked to be a wakeup source but ACPI can not satisfy that
>> >> > request.
>> >> >
>> >> > Note that originally I tried to simply change the driver to not mark
>> >> > device as wakeup source, unfortunately then we do not know that we
>> >> > should not be powering down the device completely, otherwise we can't
>> >> > wake up.
>> >> >
>> >> > Verified by making sure that "echo mem > /sys/power/state" works on
>> >> > Squawks.
>> >> >
>> >> > Reviewed-by: Benson Leung <bleung@chromium.org>
>> >> > Signed-off-by: Dmitry Torokhov <dtor@chromium.org>
>> >> > ---
>> >> >  drivers/acpi/device_pm.c | 16 ++++++++++++----
>> >> >  1 file changed, 12 insertions(+), 4 deletions(-)
>> >> >
>> >> > diff --git a/drivers/acpi/device_pm.c b/drivers/acpi/device_pm.c
>> >> > index 67075f8..440bc3d 100644
>> >> > --- a/drivers/acpi/device_pm.c
>> >> > +++ b/drivers/acpi/device_pm.c
>> >> > @@ -871,6 +871,7 @@ int acpi_dev_suspend_late(struct device *dev)
>> >> >         struct acpi_device *adev = ACPI_COMPANION(dev);
>> >> >         u32 target_state;
>> >> >         bool wakeup;
>> >> > +       bool can_wakeup;
>> >> >         int error;
>> >> >
>> >> >         if (!adev)
>> >> > @@ -878,12 +879,19 @@ int acpi_dev_suspend_late(struct device *dev)
>> >> >
>> >> >         target_state = acpi_target_system_state();
>> >> >         wakeup = device_may_wakeup(dev);
>> >> > -       error = acpi_device_wakeup(adev, target_state, wakeup);
>> >> > -       if (wakeup && error)
>> >> > -               return error;
>> >> > +       can_wakeup = acpi_device_can_wakeup(adev);
>> >> > +
>> >> > +       if (can_wakeup) {
>> >> > +               error = acpi_device_wakeup(adev, target_state, wakeup);
>> >> > +               if (wakeup && error)
>> >> > +                       return error;
>> >> > +       } else if (wakeup) {
>> >>
>> >> I think we just need to return an error code in that case, because otherwise
>> >
>> > We used to return error and that error aborted the suspend altogether,
>> > which prompted creating this patch.
>> >
>> >> this is potentially dangerous (worst case, it may be impossible to wake up
>> >> the machine at all after that).
>> >
>> > Yes, there is such potential, but that kind of error (no working wakeup
>> > sources) will be discovered before a box is shipped. Right now we have
>> > boxes in the wild that suspend fine with 3.10 and refuse to suspend with
>> > 3.14 because between 3.10 and 3.14 we started placing i2c devices with
>> > ACPI companions into ACPI power domain and ACPI power domain is now
>> > trying to configure them as wakeup sources and fails.
>>
>> A gentle ping on the patch - without it (or something else) we basically
>> have a regression on shipped hardware: Chromebooks that were
>> suspending fine with 3.10 refuse to suspend with 3.14.
>
> It fell of my radar, sorry about that.
>
> So the error here is that device_may_wakeup(dev) returns true, because the
> device is technically wakeup-capable, but the wakeup is not via ACPI?
>
> I'd say this is rather not in accordance with the spec,

Well, specs, they are mostly like... guidelines ;)

> but that means we
> need to simply ignore 'wakeup' if acpi_device_can_wakeup(adev) returns false.
>
> So what about the appended patch?

Would work as well with the difference that your version is silent so next time
firmware engineers come up with similar stuff it will stay unnoticed.

I am happy with either version.

Thanks.

-- 
Dmitry
