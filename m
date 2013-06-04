Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751540Ab3FDWYx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 18:24:53 -0400
Received: from mail-qa0-f52.google.com ([209.85.216.52]:59971 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868Ab3FDWYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 18:24:52 -0400
MIME-Version: 1.0
In-Reply-To: <201306041951.00447.arnd@arndb.de>
References: <1370038972-2318779-1-git-send-email-arnd@arndb.de>
	<201306012257.02327.arnd@arndb.de>
	<CAL_JsqKMOy4CM=FXbsy7mQ1f0DLyK6n_cuZ92uhsSM2Mq-3B1g@mail.gmail.com>
	<201306041951.00447.arnd@arndb.de>
Date: Tue, 4 Jun 2013 17:24:51 -0500
Message-ID: <CAL_JsqLRJ1cEWBfAdHEyngJHQKauJ6XzWH2JwXh1qDusMkzUGA@mail.gmail.com>
Subject: Re: [PATCH 15/15] OF: remove #ifdef from linux/of_platform.h
From: Rob Herring <robherring2@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>, patches@lists.linaro.org,
        Rob Herring <rob.herring@calxeda.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 4, 2013 at 12:51 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Tuesday 04 June 2013, Rob Herring wrote:
>> On Sat, Jun 1, 2013 at 3:57 PM, Arnd Bergmann <arnd@arndb.de> wrote:
>> > On Saturday 01 June 2013, Rob Herring wrote:
>> >> No, we still need empty functions. Here is what of_device.h looks like:
>> >>
>> >> http://tinyurl.com/l2azz5m
>> >>
>> >> BTW, it has your ack.
>> >>
>> >
>> > Could you add a patch on top that only puts the function declarations
>> > inside of #ifdef that don't have an inline wrapper?
>>
>> I'm confused. You mean that DO have an inline? Like this:
>>
>> void foo(void);
>>
>> #ifdef CONFIG_OF
>> void bar(void);
>> #else
>> static inline void bar(void) {}
>> #endif
>
> Yes, sorry. That's what I meant.
>
>> > It's really annoying to have to change the header file every time one
>> > needs to call a function from a driver in the DT-only case.
>>
>> The functions without inlines are ones that drivers should not call
>> and should only be called from OF enabled code. That's why we have not
>> done a complete pass of adding inlines for everything.
>
> The problem is that it's a bad default. The convention in kernel code
> is not to hide declarations in #ifdef, for multiple reasons:
>
> * It avoids unnecessary code rebuilds when the symbol changes between
>   two 'make' runs.
>
> * It lets drivers and platform code call the function from dead code
>   without causing a build error, thus improving compile coverage.
>
> * It's much nicer to read when can write your code like
>
> void __init exynos_init_io(struct map_desc *mach_desc, int size)
> {
>         if (IS_ENABLED_(CONFIG_OF) && initial_boot_params)
>                 of_scan_flat_dt(exynos_fdt_map_chipid, NULL);
>         else
>                 iotable_init(exynos_iodesc, ARRAY_SIZE(exynos_iodesc));
>         ...
> }
>
> instead of
>
> void __init exynos_init_io(struct map_desc *mach_desc, int size)
> {
> #ifdef CONFIG_OF
>         if (initial_boot_params)
>                 of_scan_flat_dt(exynos_fdt_map_chipid, NULL);
>         else
> #endif
>                 iotable_init(exynos_iodesc, ARRAY_SIZE(exynos_iodesc));
>         ...
> }
>
> The first one looks like actual C code, the second is really ugly,
> and an inline wrapper wouldn't even do the right thing here.

Right. I get all that. You still have to go add inlines if you want to make:

if (IS_ENABLED(CONFIG_OF))
    of_foo();

just be:

of_foo();

There are situations for both and only inlines cover both cases. I
don't see a reason we would want to allow the first case and not allow
the second case. I am tired of taking patches adding the inlines 1 by
1, so perhaps we need to refactor the OF headers to better separate
core infrastructure includes vs. driver only includes if that is
really a concern.

Rob
