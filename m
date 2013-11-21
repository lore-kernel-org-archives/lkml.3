Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755026Ab3KUNmb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 08:42:31 -0500
Received: from mail-pb0-f42.google.com ([209.85.160.42]:46028 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754986Ab3KUNm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 08:42:28 -0500
MIME-Version: 1.0
In-Reply-To: <20131121122148.1B43DC40A2C@trevor.secretlab.ca>
References: <5283A000.8090007@gmail.com>
	<1384859554-27268-1-git-send-email-geert@linux-m68k.org>
	<20131121122148.1B43DC40A2C@trevor.secretlab.ca>
Date: Thu, 21 Nov 2013 14:42:27 +0100
X-Google-Sender-Auth: t3SseaeVqMbf0JImldqYUUQDvak
Message-ID: <CAMuHMdXfsB_Ewz9sUPZaAjFaQGTGeqMiD8mJ0tCoH1uFLYGoxw@mail.gmail.com>
Subject: Re: [PATCH 1/9] dt: Handle passed/built-in DT selection in early_init_dt_scan()
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Rob Herring <rob.herring@calxeda.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 21, 2013 at 1:21 PM, Grant Likely <grant.likely@secretlab.ca> wrote:
>>  bool __init early_init_dt_scan(void *params)
>>  {
>> -     if (!params)
>> -             return false;
>> -
>>       /* Setup flat device-tree pointer */
>>       initial_boot_params = params;
>>
>> -     /* check device tree validity */
>> -     if (be32_to_cpu(initial_boot_params->magic) != OF_DT_HEADER) {
>> -             initial_boot_params = NULL;
>> -             return false;
>> +     /* check passed device tree validity */
>> +     if (initial_boot_params &&
>> +         be32_to_cpu(initial_boot_params->magic) == OF_DT_HEADER) {
>> +             pr_info("FDT at %p\n", initial_boot_params);
>> +             goto found;
>> +     }
>> +
>> +     /* check built-in device tree validity */
>> +     initial_boot_params = &__dtb_start;
>> +     if (__dtb_end != (void *)&__dtb_start &&
>> +         be32_to_cpu(initial_boot_params->magic) == OF_DT_HEADER) {
>> +             pr_info("Compiled-in FDT at %p\n", initial_boot_params);
>> +             goto found;
>
> __dtb_start is in an init section which is discarded after initcalls.
> For this to work, the dtb needs to be copied into a region of allocated

My changes don't change the current behavior much: currently
early_init_dt_scan() is already called with &__dtb_start in several places.
If this is broken, it's already broken.

> memory. The dtb section can also potentially contain multiple .dtb
> blobs. In the use case that you care about you are probably only

Multiple dtb blobs are currently handled in platform-specific code, which
passes the right dtb to early_init_dt_scan().

> thinking about one, but it is entirely possible for device drivers to
> have a dtb linked in which may break this if it gets linked in a
> different order. The specific example I'm thinking about is I want to
> have the DT selftest code load an overlay to get testcase data from a
> dtb blob.
>
> The other concern I have here is that I don't really want this to be the
> default on a lot of platforms. ARM and PowerPC for instance should only
> get the default dtb from the boot wrapper. It needs to be configurable
> in some way.

On ARM and PowerPC, the section is empty, hence &__dbt_start ==
&__dtb_end.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
