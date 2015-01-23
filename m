Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755460AbbAWOSR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 09:18:17 -0500
Received: from mail-la0-f51.google.com ([209.85.215.51]:63401 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752912AbbAWOSO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 09:18:14 -0500
MIME-Version: 1.0
In-Reply-To: <2160255.41m7rrCYxI@wuerfel>
References: <1421919253-4784-1-git-send-email-geert+renesas@glider.be>
	<7hvbjy30an.fsf@deeprootsystems.com>
	<CAMuHMdUMcyXdgv+xdd8Zo67rYnfh6JaSWfr1H3c6NrQs=JsNLg@mail.gmail.com>
	<2160255.41m7rrCYxI@wuerfel>
Date: Fri, 23 Jan 2015 15:18:11 +0100
X-Google-Sender-Auth: UrvO2v1-z6dBLlW0kT0CDB2ZjW8
Message-ID: <CAMuHMdVC_BoKgSXytYtc9CnGdTPezc8BcJ_ZrDP=3ZN1Kf6bJA@mail.gmail.com>
Subject: Re: [PATCH v3/resend 3/4] drivers: bus: Add Simple Power-Managed Bus
 DT Bindings
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Kevin Hilman <khilman@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Olof Johansson <olof@lixom.net>,
        Simon Horman <horms+renesas@verge.net.au>,
        Magnus Damm <magnus.damm@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

On Fri, Jan 23, 2015 at 2:46 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Friday 23 January 2015 09:56:51 Geert Uytterhoeven wrote:
>> >> diff --git a/Documentation/devicetree/bindings/bus/simple-pm-bus.txt b/Documentation/devicetree/bindings/bus/simple-pm-bus.txt
>> >> new file mode 100644
>> >> index 0000000000000000..d03abf7fd8e3997a
>> >> --- /dev/null
>> >> +++ b/Documentation/devicetree/bindings/bus/simple-pm-bus.txt
>> >> @@ -0,0 +1,52 @@
>> >> +Simple Power-Managed Bus
>> >> +========================
>> >> +
>> >> +A Simple Power-Managed Bus is a transparent bus that doesn't need a real
>> >> +driver, as it's typically initialized by the boot loader.
>> >> +
>> >> +However, its bus controller is part of a PM domain, or under the control of a
>> >> +functional clock.  Hence, the bus controller's PM domain and/or clock must be
>> >> +enabled for child devices connected to the bus (either on-SoC or externally)
>> >> +to function.
>> >> +
>> >> +
>> >> +Generic compatible values and properties
>> >> +----------------------------------------
>> >> +
>> >> +Required properties:
>> >> +  - compatible: Must be at least one of the vendor-specific compatible values
>> >> +             from a vendor-specific section below, and "simple-bus" as a
>> >> +             fallback.
>> >
>> > What happened to the idea of using something like "simple-pm-bus"?
>>
>> I think that's a decision to make by the (successor of the) ePAPR committee.
>> At least it would be nice to get some feedback from the DT review team
>> about this.
>>
>> If we go that road, the vendor-specific compatible value should still be
>> documented, else checkpatch will complain when encountering it in a DTS.
>> Then, should it become
>>
>>     compatible = "renesas,bsc-sh73a0", "renesas,bsc", "simple-pm-bus",
>> "simple-bus";
>>
>> or should "simple-bus" just be added to of_default_bus_match_table[], so we

Sorry, FTR, I meant "simple-pm-bus" here.

>> can drop "simple-bus" from the list in the DTS:
>>
>>     compatible = "renesas,bsc-sh73a0", "renesas,bsc", "simple-pm-bus";
>
> I was thinking of the reverse: drop "simple-bus" bus from the list here,
> but not add "simple-pm-bus" to of_default_bus_match_table. This will
> cause child devices to no longer be probed automatically, and you will
> have to call of_platform_populate() from simple_pm_bus_probe(), after
> pm_runtime_enable(). This seems like a cleaner model to me, for two
> reasons:
>
> - In the binding, claiming compatibility with "simple-bus" feels
>   wrong to me, because you have a bus that is not as simple as others
>
> - The ordering between pm_runtime_enable() and the probing of the
>   child devices is guaranteed, which I think it is not with your
>   current code.

The ordering is indeed a good argument. Will update.

Hence:
  - The DTS will claim a compatibility with
    "renesas,bsc-sh73a0", "renesas,bsc", "simple-pm-bus".
  - The driver will match against "simple-pm-bus".

Note that if we ever have a real driver for "renesas,bsc", we'll have to
be careful about binding ordering. "simple-bus" is handled by core code,
 and doesn't prevent a more specific driver to take precedence.
"simple-pm-bus" is handled by a driver, so if it binds first, a more specific
driver cannot take over.

> Does this make sense, or am I missing an important reason why there
> has to be a "simple-bus" compatible string here?

Yes, it makes sense. I had the "simple-bus" compatible entry there because of
the "most generic first", "least generic last" rule. If you don't use the
extra features (i.e. don't touch the clocks or PM domains in the SoC), it is
compatible with "simple-bus". That's more or less how it was in
r8a73a4-ape6evm-reference.dts before the advent of CCF and PM domains.

Thanks!

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
