Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753968AbbAIWgu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 17:36:50 -0500
Received: from mail-we0-f181.google.com ([74.125.82.181]:45437 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751554AbbAIWgs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 17:36:48 -0500
MIME-Version: 1.0
In-Reply-To: <20150109220552.GA86398@gandalf.middle.earth.net>
References: <1420813745-130341-1-git-send-email-george_davis@mentor.com>
 <CAL_JsqJaT-Y7DHQS5ZZ0TP6r0iPDbUZwU-Kec5MSE7DOPgZxCg@mail.gmail.com>
 <20150109183310.GA38065@gandalf.middle.earth.net> <20150109220552.GA86398@gandalf.middle.earth.net>
From: Rob Herring <robherring2@gmail.com>
Date: Fri, 9 Jan 2015 16:29:43 -0600
Message-ID: <CAL_JsqLKMw4bvov+t7SkEsY5Gu_rrJ5yDKhB6BckuTFfD4-MSA@mail.gmail.com>
Subject: Re: [PATCH] drivers: of: Export of_reserved_mem_device_{init,release}
To: "George G. Davis" <ggdavisiv@gmail.com>
Cc: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        "George G. Davis" <george_davis@mentor.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 9, 2015 at 4:05 PM, George G. Davis <ggdavisiv@gmail.com> wrote:
> On Fri, Jan 09, 2015 at 01:33:10PM -0500, George G. Davis wrote:
>> On Fri, Jan 09, 2015 at 11:53:01AM -0600, Rob Herring wrote:
>> > On Fri, Jan 9, 2015 at 8:29 AM, George G. Davis <ggdavisiv@gmail.com> wrote:
>> > > Export of_reserved_mem_device_{init,release} so that modules
>> > > can initialize and release their assigned per-device cma_area.
>> >
>> > I believe the original intent was for the core bus code to call these
>> > functions. While the commit adding them says "automated assignment"
>> > that part did not go in.
>>
>> I suspected that there may have been a bit of missing magic.  The only
>> use of these functions that I was able to find was in an earlier out of
>> tree patch series where these functions were called from the s5p-mfc
>> driver:
>>
>> http://lists.linaro.org/pipermail/linaro-mm-sig/2014-August/004140.html
>>
>> I agree that "automated assignment" via core bus code would be a better
>> solution but I don't know where to add the calls.
>
> How about something like the following for automated assignment?:

It seems Grant wasn't happy about the core code doing this[1]. So I
guess your original patch was okay except you should use
EXPORT_SYMBOL_GPL. I can fix that up if you agree.

Rob


[1] https://lkml.org/lkml/2014/3/2/30

>
> diff --git a/drivers/base/platform.c b/drivers/base/platform.c
> index 9421fed..231b427 100644
> --- a/drivers/base/platform.c
> +++ b/drivers/base/platform.c
> @@ -14,6 +14,7 @@
>  #include <linux/platform_device.h>
>  #include <linux/of_device.h>
>  #include <linux/of_irq.h>
> +#include <linux/of_reserved_mem.h>
>  #include <linux/module.h>
>  #include <linux/init.h>
>  #include <linux/dma-mapping.h>
> @@ -509,9 +510,12 @@ static int platform_drv_probe(struct device *_dev)
>
>         ret = dev_pm_domain_attach(_dev, true);
>         if (ret != -EPROBE_DEFER) {
> +               of_reserved_mem_device_init(_dev);
>                 ret = drv->probe(dev);
> -               if (ret)
> +               if (ret) {
> +                       of_reserved_mem_device_release(_dev);
>                         dev_pm_domain_detach(_dev, true);
> +               }
>         }
>
>         if (drv->prevent_deferred_probe && ret == -EPROBE_DEFER) {
> @@ -534,6 +538,7 @@ static int platform_drv_remove(struct device *_dev)
>         int ret;
>
>         ret = drv->remove(dev);
> +       of_reserved_mem_device_release(_dev);
>         dev_pm_domain_detach(_dev, true);
>
>         return ret;
>
>
> --
> Regards,
> George
>>
>> > As it stands, there are no in tree users of
>> > these functions.
>> >
>> > Marek, comments?
>>
>> Thanks!
>>
>> --
>> Regards,
>> George
>>
>> >
>> > Rob
>> >
>> > >
>> > > Signed-off-by: George G. Davis <george_davis@mentor.com>
>> > > ---
>> > >  drivers/of/of_reserved_mem.c | 2 ++
>> > >  1 file changed, 2 insertions(+)
>> > >
>> > > diff --git a/drivers/of/of_reserved_mem.c b/drivers/of/of_reserved_mem.c
>> > > index dc566b3..5eeb5b2 100644
>> > > --- a/drivers/of/of_reserved_mem.c
>> > > +++ b/drivers/of/of_reserved_mem.c
>> > > @@ -265,6 +265,7 @@ int of_reserved_mem_device_init(struct device *dev)
>> > >
>> > >         return ret;
>> > >  }
>> > > +EXPORT_SYMBOL(of_reserved_mem_device_init);
>> > >
>> > >  /**
>> > >   * of_reserved_mem_device_release() - release reserved memory device structures
>> > > @@ -289,3 +290,4 @@ void of_reserved_mem_device_release(struct device *dev)
>> > >
>> > >         rmem->ops->device_release(rmem, dev);
>> > >  }
>> > > +EXPORT_SYMBOL(of_reserved_mem_device_release);
>> > > --
>> > > 1.9.3
>> > >
