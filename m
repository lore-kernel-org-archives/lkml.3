Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755335AbaDTKb2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2014 06:31:28 -0400
Received: from mga02.intel.com ([134.134.136.20]:29002 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754905AbaDTKbW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2014 06:31:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,891,1389772800"; 
   d="scan'208";a="524228318"
Message-ID: <5353A1F6.60602@linux.intel.com>
Date: Sun, 20 Apr 2014 18:31:18 +0800
From: "Jin, Yao" <yao.jin@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Adam Williamson <awilliam@redhat.com>
CC: Linus Walleij <linus.walleij@linaro.org>, alan@linux.intel.com,
        mathias.nyman@intel.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: Re: [PATCH] pinctrl-baytrail: fix for irq descriptor conflict on
 ASUS T100TA
References: <1397649959-29762-1-git-send-email-yao.jin@linux.intel.com> <CAN+gG=E7jbpQxxVuhmY5E2msgdMhLLjMd=Kxn9JO57eCN+5nCQ@mail.gmail.com>
In-Reply-To: <CAN+gG=E7jbpQxxVuhmY5E2msgdMhLLjMd=Kxn9JO57eCN+5nCQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 2014/4/19 4:44, Benjamin Tissoires wrote:
> On Wed, Apr 16, 2014 at 8:05 AM, Jin Yao <yao.jin@linux.intel.com> wrote:
>> A crash is triggered on the ASUS T100TA Baytrail-T because of a irq
>> descriptor conflict. There are two gpio triggered acpi events in this
>> device, GPIO 6 and 18. These gpios are translated to irqs by calling
>> gpio_to_irq which in turn will call irq_create_mapping(vg->domain, offset).
>> irq_create_mapping will take care of allocating the irq descriptor, taking
>> the first available number starting from the given value (6 in our case).
>> The 0-15 are already reserved by legacy ISA code, so it gets the first
>> free irq descriptor which is number 16. The i915 driver also uses irq 16,
>> it loads later than gpio and crashes in probe.
>>
>> The bug is reported here:
>> https://bugzilla.kernel.org/show_bug.cgi?id=68291
> 
> Adam, the reporter of this bug told me that his touchscreen was broken
> in its tablet.
This bug is triggered when system boots, or rather, it's triggered in
i915 probe, because i915 still uses irq 16 but it's allocated for gpio
yet. It's not a touchscreen case.

> I strongly suspect this patch to be the root cause of this, because
> the touchscreen uses i2c_hid. i2c_hid relies on an IRQ declared in the
> DSDT when it is acpi enumerated, and since the inclusion of this
> patch, no irq are triggered from a driver point of view.
> 
> Adam should still confirm that the revert of the patch makes the
> touchscreen back alive, but if I understood correctly the bug report,
> without the patch, his tablet oopses at boot.
Do you mean this patch cause the touchscreen doesn't work? I suspect
that because the touch screen works on my T100 with this patch.

> 
> Still, it would be good if you could check that shifting the irqs in
> the pinctrl is or is not a problem with the irqs used for i2c devices
> (and others) declared in the dsdt.
I checked DSDT of ASUS T100, looks no irq conflict after irq shifting.

> 
> Cheers,
> Benjamin
> 
>>
>> The rootcause we know now is a low level irq issue. It needs a long term
>> solution to fix the issue in irq system.
>>
>> This patch changes the Baytrail GPIO driver to avoid the irq descriptor
>> conflict. It still uses the irq domain to allocate irq descriptor but start
>> from a predefined irq base number (256) to avoid the conflict.
>>
>> Signed-off-by: Jin Yao <yao.jin@linux.intel.com>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
