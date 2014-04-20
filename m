Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755369AbaDTM5F (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2014 08:57:05 -0400
Received: from mail-lb0-f177.google.com ([209.85.217.177]:46102 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755196AbaDTM44 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2014 08:56:56 -0400
MIME-Version: 1.0
In-Reply-To: <5353A1F6.60602@linux.intel.com>
References: <1397649959-29762-1-git-send-email-yao.jin@linux.intel.com>
	<CAN+gG=E7jbpQxxVuhmY5E2msgdMhLLjMd=Kxn9JO57eCN+5nCQ@mail.gmail.com>
	<5353A1F6.60602@linux.intel.com>
Date: Sun, 20 Apr 2014 08:56:55 -0400
Message-ID: <CAN+gG=E9UZBfKzou8-JbLyuUVhd2nY+GW9GegSH6=Y_SxJWc8g@mail.gmail.com>
Subject: Re: [PATCH] pinctrl-baytrail: fix for irq descriptor conflict on ASUS T100TA
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: "Jin, Yao" <yao.jin@linux.intel.com>
Cc: Adam Williamson <awilliam@redhat.com>,
        Linus Walleij <linus.walleij@linaro.org>, alan@linux.intel.com,
        mathias.nyman@intel.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 20, 2014 at 6:31 AM, Jin, Yao <yao.jin@linux.intel.com> wrote:
>
>
> On 2014/4/19 4:44, Benjamin Tissoires wrote:
>> On Wed, Apr 16, 2014 at 8:05 AM, Jin Yao <yao.jin@linux.intel.com> wrote:
>>> A crash is triggered on the ASUS T100TA Baytrail-T because of a irq
>>> descriptor conflict. There are two gpio triggered acpi events in this
>>> device, GPIO 6 and 18. These gpios are translated to irqs by calling
>>> gpio_to_irq which in turn will call irq_create_mapping(vg->domain, offset).
>>> irq_create_mapping will take care of allocating the irq descriptor, taking
>>> the first available number starting from the given value (6 in our case).
>>> The 0-15 are already reserved by legacy ISA code, so it gets the first
>>> free irq descriptor which is number 16. The i915 driver also uses irq 16,
>>> it loads later than gpio and crashes in probe.
>>>
>>> The bug is reported here:
>>> https://bugzilla.kernel.org/show_bug.cgi?id=68291
>>
>> Adam, the reporter of this bug told me that his touchscreen was broken
>> in its tablet.
> This bug is triggered when system boots, or rather, it's triggered in
> i915 probe, because i915 still uses irq 16 but it's allocated for gpio
> yet. It's not a touchscreen case.
>
>> I strongly suspect this patch to be the root cause of this, because
>> the touchscreen uses i2c_hid. i2c_hid relies on an IRQ declared in the
>> DSDT when it is acpi enumerated, and since the inclusion of this
>> patch, no irq are triggered from a driver point of view.
>>
>> Adam should still confirm that the revert of the patch makes the
>> touchscreen back alive, but if I understood correctly the bug report,
>> without the patch, his tablet oopses at boot.
> Do you mean this patch cause the touchscreen doesn't work? I suspect
> that because the touch screen works on my T100 with this patch.

I think this patch breaks his touchscreen, yes.
Adam has a Dell Venue Pro 8 with a touchscreen connected through
i2c-hid, which IRQ is declared in plain in the DSDT (I'll check that
with Adam what is this exact irq in his DSDT).

>
>>
>> Still, it would be good if you could check that shifting the irqs in
>> the pinctrl is or is not a problem with the irqs used for i2c devices
>> (and others) declared in the dsdt.
> I checked DSDT of ASUS T100, looks no irq conflict after irq shifting.

I meant: "Can you check if shifting the irqs in the pinctrl is a
problem if irqs are generally declared in the DSDT?"
I understand that you do not see a conflict with your Asus, otherwise
you wouldn't have proposed the patch. But is the patch _really_ safe
when the OEM uses irqs in the DSDT?

Another way of seeing this is: shouldn't we also patch an other part
of the acpi which retrieve the irqs when dealing with the enumaration
of the devices?

Cheers,
Benjamin
