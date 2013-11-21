Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755167Ab3KURib (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 12:38:31 -0500
Received: from mail-vb0-f48.google.com ([209.85.212.48]:47716 "EHLO
	mail-vb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755115Ab3KURi2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 12:38:28 -0500
MIME-Version: 1.0
In-Reply-To: <CAMuHMdXfsB_Ewz9sUPZaAjFaQGTGeqMiD8mJ0tCoH1uFLYGoxw@mail.gmail.com>
References: <5283A000.8090007@gmail.com>
	<1384859554-27268-1-git-send-email-geert@linux-m68k.org>
	<20131121122148.1B43DC40A2C@trevor.secretlab.ca>
	<CAMuHMdXfsB_Ewz9sUPZaAjFaQGTGeqMiD8mJ0tCoH1uFLYGoxw@mail.gmail.com>
Date: Thu, 21 Nov 2013 11:38:26 -0600
Message-ID: <CAL_JsqJVteJuaD0PRMHSR9cVcMJTSNj4wXtYiftG=-pYSR9vsQ@mail.gmail.com>
Subject: Re: [PATCH 1/9] dt: Handle passed/built-in DT selection in early_init_dt_scan()
From: Rob Herring <robherring2@gmail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 21, 2013 at 7:42 AM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> On Thu, Nov 21, 2013 at 1:21 PM, Grant Likely <grant.likely@secretlab.ca> wrote:
>>>  bool __init early_init_dt_scan(void *params)
>>>  {
>>> -     if (!params)
>>> -             return false;
>>> -
>>>       /* Setup flat device-tree pointer */
>>>       initial_boot_params = params;
>>>
>>> -     /* check device tree validity */
>>> -     if (be32_to_cpu(initial_boot_params->magic) != OF_DT_HEADER) {
>>> -             initial_boot_params = NULL;
>>> -             return false;
>>> +     /* check passed device tree validity */
>>> +     if (initial_boot_params &&
>>> +         be32_to_cpu(initial_boot_params->magic) == OF_DT_HEADER) {
>>> +             pr_info("FDT at %p\n", initial_boot_params);
>>> +             goto found;
>>> +     }
>>> +
>>> +     /* check built-in device tree validity */
>>> +     initial_boot_params = &__dtb_start;
>>> +     if (__dtb_end != (void *)&__dtb_start &&
>>> +         be32_to_cpu(initial_boot_params->magic) == OF_DT_HEADER) {
>>> +             pr_info("Compiled-in FDT at %p\n", initial_boot_params);
>>> +             goto found;
>>
>> __dtb_start is in an init section which is discarded after initcalls.
>> For this to work, the dtb needs to be copied into a region of allocated
>
> My changes don't change the current behavior much: currently
> early_init_dt_scan() is already called with &__dtb_start in several places.
> If this is broken, it's already broken.

Agreed. The early scan is already done in the init section.

>> memory. The dtb section can also potentially contain multiple .dtb
>> blobs. In the use case that you care about you are probably only
>
> Multiple dtb blobs are currently handled in platform-specific code, which
> passes the right dtb to early_init_dt_scan().
>

Agreed. Arches can still do however complicated dtb search they want.
This handles the common, default case.

>> thinking about one, but it is entirely possible for device drivers to
>> have a dtb linked in which may break this if it gets linked in a
>> different order. The specific example I'm thinking about is I want to
>> have the DT selftest code load an overlay to get testcase data from a
>> dtb blob.
>>
>> The other concern I have here is that I don't really want this to be the
>> default on a lot of platforms. ARM and PowerPC for instance should only
>> get the default dtb from the boot wrapper. It needs to be configurable
>> in some way.
>
> On ARM and PowerPC, the section is empty, hence &__dbt_start ==
> &__dtb_end.

The build rules for built-in dtbs are architecture specific already,
so I don't see a need to make this code configurable at this point.

I really don't like saying one arch can have built-in dtb and another
one can't. Either we allow it or we don't. If this is a bad feature,
then why did we let multiple arches implement it.

Rob
