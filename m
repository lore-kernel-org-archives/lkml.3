Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752232AbaKDXtT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 18:49:19 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:58140 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229AbaKDXtR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 18:49:17 -0500
MIME-Version: 1.0
In-Reply-To: <20141029175142.GC26471@leverpostej>
References: <1414541562-10076-1-git-send-email-abrestic@chromium.org>
	<1414541562-10076-5-git-send-email-abrestic@chromium.org>
	<20141029175142.GC26471@leverpostej>
Date: Tue, 4 Nov 2014 15:49:16 -0800
X-Google-Sender-Auth: 3ZIhdXobjDyVckOe5k3bldYwIYA
Message-ID: <CAL1qeaG0EpxdbV+QxAsdYgAWc19yWf8eLW0mfVxevQaJDxER6w@mail.gmail.com>
Subject: Re: [PATCH V3 4/4] clocksource: mips-gic: Add device-tree support
From: Andrew Bresticker <abrestic@chromium.org>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Ralf Baechle <ralf@linux-mips.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        John Crispin <blogic@openwrt.org>, David Daney <ddaney.cavm@gmail.com>,
        Qais Yousef <qais.yousef@imgtec.com>,
        "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

>> +static void __init gic_clocksource_of_init(struct device_node *node)
>> +{
>> +     if (of_property_read_u32(node, "clock-frequency", &gic_frequency)) {
>> +             pr_err("GIC frequency not specified.\n");
>> +             return;
>> +     }
>> +     gic_timer_irq = irq_of_parse_and_map(node, 0);
>> +     if (!gic_timer_irq) {
>> +             pr_err("GIC timer IRQ not specified.\n");
>> +             return;
>> +     }
>> +
>> +     __gic_clocksource_init();
>> +}
>> +CLOCKSOURCE_OF_DECLARE(mips_gic_timer, "mti,interaptiv-gic-timer",
>> +                    gic_clocksource_of_init);
>
> Your binding document expected the timer node under the GIC node, and it
> looks like this relies on GIC internals. Hwoever, this allows for people
> to put the timer node anywhere (and it turns out people are _really_ bad
> at putting things together as the binding author expected).
>
> It might be better if the GIC driver detected the sub node and probed
> the clocksource driver (or registered a platform device that the
> clocksource driver gets registered from). that could prevent some
> horrible issues with probe ordering and/or bad dts.

Probing the clocksource during probe of the irqchip doesn't work
because time-keeping isn't set up at the time.  Registering a platform
device for the timer pushes back GIC timer registration to later in
the boot process (assuming it now becomes a module_platform_driver)
and makes it rather non-parallel to how it's done in the non-DT case
(this could be changed, though IMO it's a lot of churn just to thwart
bad DT authors).

Probe ordering shouldn't be an issue because irqchips are probed
before clocksources.  Perhaps checking for the presence of GIC
(there's the global gic_present) and node->parent (to enforce the
parent-child relationship) would be sufficient?

Thanks,
Andrew
