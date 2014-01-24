Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752850AbaAXOyw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 09:54:52 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:41301 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752212AbaAXOyt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 09:54:49 -0500
MIME-Version: 1.0
In-Reply-To: <38648196.Uh7omNjHIu@vostro.rjw.lan>
References: <1390448559-33896-1-git-send-email-wangyijing@huawei.com>
 <CAErSpo7YBGnPF9gz4rwwEdk8uF2h2aNAZWhSAd-X=tAOWOhRow@mail.gmail.com> <38648196.Uh7omNjHIu@vostro.rjw.lan>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 24 Jan 2014 07:54:29 -0700
Message-ID: <CAErSpo5VGy9nCnrOAZtU9OjMsXxz5q_x2rVn596mqg1TWTT64g@mail.gmail.com>
Subject: Re: [PATCH v5] ACPI: Fix acpi_evaluate_object() return value check
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Yijing Wang <wangyijing@huawei.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        David Airlie <airlied@linux.ie>, intel-gfx@lists.freedesktop.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Dave Airlie <airlied@redhat.com>, Hanjun Guo <guohanjun@huawei.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 23, 2014 at 5:33 PM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> On Thursday, January 23, 2014 11:21:01 AM Bjorn Helgaas wrote:
>> On Wed, Jan 22, 2014 at 8:42 PM, Yijing Wang <wangyijing@huawei.com> wrote:
>> > Since acpi_evaluate_object() returns acpi_status and not plain int,
>> > ACPI_FAILURE() should be used for checking its return value. Also
>> > add some detailed debug info when acpi_evaluate_object() failed.
>> >
>> > Reviewed-by: Jani Nikula <jani.nikula@intel.com>
>> > Acked-by: Bjorn Helgaas <bhelgaas@google.com>
>> > Signed-off-by: Yijing Wang <wangyijing@huawei.com>
>> > ---
>> > v4->v5: Add some detailed debug info for acpi_evaluate_object()
>> >         failure suggested by Bjorn.
>> > v3->v4: Fix spell error, add Jani Nikula reviewed-by.
>> > v2->v3: Fix compile error pointed out by Hanjun.
>> > v1->v2: Add CC to related subsystem MAINTAINERS
>> > ---
>> >  drivers/gpu/drm/i915/intel_acpi.c              |   33 ++++++++++++++++-------
>> >  drivers/gpu/drm/nouveau/core/subdev/mxm/base.c |   13 ++++++---
>> >  drivers/gpu/drm/nouveau/nouveau_acpi.c         |   25 +++++++++++-------
>> >  drivers/pci/pci-label.c                        |   10 +++++--
>> >  4 files changed, 54 insertions(+), 27 deletions(-)
>> >
>> > diff --git a/drivers/gpu/drm/i915/intel_acpi.c b/drivers/gpu/drm/i915/intel_acpi.c
>> > index dfff090..e7b526b 100644
>> > --- a/drivers/gpu/drm/i915/intel_acpi.c
>> > +++ b/drivers/gpu/drm/i915/intel_acpi.c
>> > @@ -31,11 +31,13 @@ static const u8 intel_dsm_guid[] = {
>> >  static int intel_dsm(acpi_handle handle, int func)
>> >  {
>> >         struct acpi_buffer output = { ACPI_ALLOCATE_BUFFER, NULL };
>> > +       struct acpi_buffer string = { ACPI_ALLOCATE_BUFFER, NULL };
>> >         struct acpi_object_list input;
>> >         union acpi_object params[4];
>> >         union acpi_object *obj;
>> >         u32 result;
>> > -       int ret = 0;
>> > +       acpi_status status;
>> > +       int ret;
>> >
>> >         input.count = 4;
>> >         input.pointer = params;
>> > @@ -50,10 +52,14 @@ static int intel_dsm(acpi_handle handle, int func)
>> >         params[3].package.count = 0;
>> >         params[3].package.elements = NULL;
>> >
>> > -       ret = acpi_evaluate_object(handle, "_DSM", &input, &output);
>> > -       if (ret) {
>> > -               DRM_DEBUG_DRIVER("failed to evaluate _DSM: %d\n", ret);
>> > -               return ret;
>> > +       status = acpi_evaluate_object(handle, "_DSM", &input, &output);
>> > +       if (ACPI_FAILURE(status)) {
>> > +               acpi_get_name(handle, ACPI_FULL_PATHNAME, &string);
>> > +               DRM_DEBUG_DRIVER(
>> > +                       "failed to evaluate _DSM for %s, exit status %u\n",
>> > +                       (char *)string.pointer, (unsigned int)status);
>> > +               kfree(string.pointer);
>> > +               return -EINVAL;
>>
>> I said "too bad there isn't an *easy* way" to include more
>> information.  IMHO this is too ugly and error-prone to use
>> consistently.  And if you are going to add more information, why did
>> you only do it for some of the calls and not others?
>>
>> I considered adding a %p extension to print the pathname; I don't know
>> if that's worthwhile or not.  I think it would be ideal if we had a
>> struct device and could use dev_info(), and then a way to connect the
>> struct device with an ACPI path, like maybe a dmesg note when we
>> create the struct device corresponding to an ACPI Device node.
>
> Well, we can generally print something like that from pci_acpi_setup().
>
> What about the below?  Wouldn't it generate too much output on some systems?

Yeah, that probably would generate an awful lot of output.  I was just
hoping to avoid treating ACPI pathnames as first-class objects.  What
do you think about a %p extension?  I played with that once, but I
seem to have lost the patch.

> ---
>  drivers/pci/pci-acpi.c |    2 ++
>  1 file changed, 2 insertions(+)
>
> Index: linux-pm/drivers/pci/pci-acpi.c
> ===================================================================
> --- linux-pm.orig/drivers/pci/pci-acpi.c
> +++ linux-pm/drivers/pci/pci-acpi.c
> @@ -330,6 +330,8 @@ static void pci_acpi_setup(struct device
>         if (!adev)
>                 return;
>
> +       acpi_handle_info(adev->handle, "bound to %s\n", dev_name(dev));
> +
>         pci_acpi_add_pm_notifier(adev, pci_dev);
>         if (!adev->wakeup.flags.valid)
>                 return;
>
