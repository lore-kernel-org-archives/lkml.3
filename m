Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758173Ab3CUNKk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 09:10:40 -0400
Received: from mail-ob0-f175.google.com ([209.85.214.175]:43300 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756333Ab3CUNKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 09:10:37 -0400
MIME-Version: 1.0
In-Reply-To: <201303201146.07987.arnd@arndb.de>
References: <1363266691-15757-1-git-send-email-fabio.porcedda@gmail.com>
 <201303201020.14654.arnd@arndb.de> <CAHkwnC-8FH0nyJ+eT=+7doP+fSdZjNYUW4zzs_r6e9wt3Yt4Fg@mail.gmail.com>
 <201303201146.07987.arnd@arndb.de>
From: Fabio Porcedda <fabio.porcedda@gmail.com>
Date: Thu, 21 Mar 2013 14:10:17 +0100
Message-ID: <CAHkwnC-u=34CnHR5dH3qu6YeYyNcsmPfVORZFwtS4RYSjrVJ2g@mail.gmail.com>
Subject: Re: [PATCH 10/10] drivers: misc: use module_platform_driver_probe()
To: Arnd Bergmann <arnd@arndb.de>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 20, 2013 at 12:46 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Wednesday 20 March 2013, Fabio Porcedda wrote:
>>
>> On Wed, Mar 20, 2013 at 11:20 AM, Arnd Bergmann <arnd@arndb.de> wrote:
>> > On Wednesday 20 March 2013, Fabio Porcedda wrote:
>> >> I think we can check inside the  deferred_probe_work_func()
>> >> if the dev->probe function pointer is equal to platform_drv_probe_fail().
>> >
>> > I think it's too late by then, because that would only warn if we try to probe
>> > it again, but when platform_driver_probe() does not succeed immediately, it
>>
>> Maybe you mean "does succeed immediately" ?
>
> I mean in this code (simplified for the sake of discussion)
>
> int __init_or_module platform_driver_probe(struct platform_driver *drv,
>                 int (*probe)(struct platform_device *))
> {
>         int retval, code;
>
>         drv->probe = probe;
>         retval = code = platform_driver_register(drv);
>
>         drv->probe = NULL;
>         if (code == 0 && list_empty(&drv->driver.p->klist_devices.k_list))
>                 retval = -ENODEV;
>         drv->driver.probe = platform_drv_probe_fail;
>
>         if (code != retval)
>                 platform_driver_unregister(drv);
>         return retval;
> }
>
> we assume that all devices are bound to drivers during the call to
> platform_driver_register, and if the device list is empty afterwards,
> we unregister the driver and will never get to the deferred probing
> stage.

Thanks for the explanation, I understand now that is not that simple.

I was hoping it was easier.

Regards
--
Fabio Porcedda
