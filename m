Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753039AbaKQTOW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 14:14:22 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:34350 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751653AbaKQTOU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 14:14:20 -0500
From: Kevin Hilman <khilman@kernel.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Grygorii Strashko <grygorii.strashko@ti.com>, ssantosh@kernel.org,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-pm@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, grant.likely@secretlab.ca,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH v4 1/2] ARM: keystone: pm: switch to use generic pm domains
References: <1415631557-22897-1-git-send-email-grygorii.strashko@ti.com>
	<5331397.OQCQmJO78C@wuerfel> <5460F806.3040305@ti.com>
	<1600093.60yAP0Qpua@wuerfel>
Date: Mon, 17 Nov 2014 11:14:16 -0800
In-Reply-To: <1600093.60yAP0Qpua@wuerfel> (Arnd Bergmann's message of "Mon, 10
	Nov 2014 21:36:55 +0100")
Message-ID: <7h389h3aif.fsf@deeprootsystems.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann <arnd@arndb.de> writes:

> On Monday 10 November 2014 19:38:14 Grygorii Strashko wrote:
>> Hi Arnd,
>> 
>> On 11/10/2014 05:06 PM, Arnd Bergmann wrote:
>> > On Monday 10 November 2014 16:59:16 Grygorii Strashko wrote:
>> >> --- /dev/null
>> >> +++ b/Documentation/devicetree/bindings/power/ti,keystone-powerdomain.txt
>> >> @@ -0,0 +1,31 @@
>> >> +* TI Keystone 2 Generic PM Controller
>> >> +
>> >> +The TI Keystone 2 Generic PM Controller is responsible for Clock gating
>> >> +for each controlled IP module.
>> >> +
>> >> +Required properties:
>> >> +- compatible: Should be "ti,keystone-powerdomain"
>> >> +- #power-domain-cells: Should be 0, see below:
>> >> +
>> >> +The PM Controller node is a PM domain as documented in
>> >> +Documentation/devicetree/bindings/power/power_domain.txt.
>> >> +
>> >> +Example:
>> >> +
>> >> +       pm_controller: pm-controller {
>> >> +               compatible = "ti,keystone-powerdomain";
>> >> +               #power-domain-cells = <0>;
>> >> +       };
>> >> +
>> >> +       netcp: netcp@2090000 {
>> >> +               reg = <0x2620110 0x8>;
>> >> +               reg-names = "efuse";
>> >> +               ...
>> >> +               #address-cells = <1>;
>> >> +               #size-cells = <1>;
>> >> +               ranges;
>> >> +               power-domains = <&pm_controller>;
>> >> +
>> >> +               clocks = <&clkpa>, <&clkcpgmac>, <&chipclk12>;
>> >> +               dma-coherent;
>> >> +       }
>> > 
>> > I don't get it. What keystone specific about a "ti,keystone-powerdomain"
>> > device? It seems that the device has no registers whatsoever and the
>> > driver doesn't really do anything that relates to the platform.
>> 
>> That's true. but it was the only one acceptable way  to enable
>> Generic clock manipulation PM callbacks for the DT-boot case.
>> After several unsuccessful attempts the idea to use GPD
>> was introduced by Kevin there:
>>   https://lkml.org/lkml/2014/9/8/643
>> 
>> So, The Keystone 2 Generic PM Controller is just a proxy PM layer here between
>> device and Generic clock manipulation PM callbacks.
>> It fills per-device clock list when device is attached to GPD and
>> ensures that all clocks from that list enabled/disabled when device is
>> started/stopped.
>
> The idea of such a generic power domain implementation sounds useful, but
> it has absolutely no business in platform specific code.

Yes it does.  This isn't a generic power domain implementation, but
rather just the platform-specific glue that hooks up the clocks to the
right devices and power-domains so that the generic power-domain and
generic pm_clocks code does the right thing.

> I suggest you either remove the power domain proxy from your drivers
> and use the clocks directly, 

No.  That's a step in the wrong direction.  This change isn't affecting
drivers directly.  It's the runtime PM and generic power domain layers
that handle this, and runtime PM adapted drivers don't need any changes.
 
> or come up with an implementation that can be used across other
> platforms and CPU architectures.

We already have those in the generic power domain and the pm_clock
layers.  This series is just hooking those up for Keystone.

Kevin
