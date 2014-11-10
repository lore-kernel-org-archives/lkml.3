Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752637AbaKJUhL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 15:37:11 -0500
Received: from mout.kundenserver.de ([212.227.126.187]:64017 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752288AbaKJUhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 15:37:07 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Grygorii Strashko <grygorii.strashko@ti.com>
Cc: ssantosh@kernel.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        khilman@linaro.org, linux-pm@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, grant.likely@secretlab.ca,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH v4 1/2] ARM: keystone: pm: switch to use generic pm domains
Date: Mon, 10 Nov 2014 21:36:55 +0100
Message-ID: <1600093.60yAP0Qpua@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <5460F806.3040305@ti.com>
References: <1415631557-22897-1-git-send-email-grygorii.strashko@ti.com> <5331397.OQCQmJO78C@wuerfel> <5460F806.3040305@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:SeostACv2dbqBuvlKcFPm4BGirWwF0VwzoAHOaQGCi2
 AzVLmuQwcbuE2hx/e2QlVB6AP/kMww2JgU1N+k3Mrn7p5NqSYN
 Giny4G8gb8VLeRNan3MijJYlQx+/vfdp6TAVFLeCaEz6GKjBrb
 Gh1mM/kDcth7gMm17grBzM80capDHcAjTpbti1PewUY84qhqsi
 0AlyepOIyY09plJlnWtIIqgdhxXSCxN9SMR+R/NlE1XhnhtCLm
 +djy/dwv7jIC1YqEokDIT19XmgUzBnARhdX4mYOT/fC5giAY9Y
 /ntl6CQZG70vJsltdem+5XfXDpI+fGa+h/wFmnRkeY84x09LJg
 8RQJ/nvfsZrUOEd0xKc0=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 10 November 2014 19:38:14 Grygorii Strashko wrote:
> Hi Arnd,
> 
> On 11/10/2014 05:06 PM, Arnd Bergmann wrote:
> > On Monday 10 November 2014 16:59:16 Grygorii Strashko wrote:
> >> --- /dev/null
> >> +++ b/Documentation/devicetree/bindings/power/ti,keystone-powerdomain.txt
> >> @@ -0,0 +1,31 @@
> >> +* TI Keystone 2 Generic PM Controller
> >> +
> >> +The TI Keystone 2 Generic PM Controller is responsible for Clock gating
> >> +for each controlled IP module.
> >> +
> >> +Required properties:
> >> +- compatible: Should be "ti,keystone-powerdomain"
> >> +- #power-domain-cells: Should be 0, see below:
> >> +
> >> +The PM Controller node is a PM domain as documented in
> >> +Documentation/devicetree/bindings/power/power_domain.txt.
> >> +
> >> +Example:
> >> +
> >> +       pm_controller: pm-controller {
> >> +               compatible = "ti,keystone-powerdomain";
> >> +               #power-domain-cells = <0>;
> >> +       };
> >> +
> >> +       netcp: netcp@2090000 {
> >> +               reg = <0x2620110 0x8>;
> >> +               reg-names = "efuse";
> >> +               ...
> >> +               #address-cells = <1>;
> >> +               #size-cells = <1>;
> >> +               ranges;
> >> +               power-domains = <&pm_controller>;
> >> +
> >> +               clocks = <&clkpa>, <&clkcpgmac>, <&chipclk12>;
> >> +               dma-coherent;
> >> +       }
> > 
> > I don't get it. What keystone specific about a "ti,keystone-powerdomain"
> > device? It seems that the device has no registers whatsoever and the
> > driver doesn't really do anything that relates to the platform.
> 
> That's true. but it was the only one acceptable way  to enable
> Generic clock manipulation PM callbacks for the DT-boot case.
> After several unsuccessful attempts the idea to use GPD
> was introduced by Kevin there:
>   https://lkml.org/lkml/2014/9/8/643
> 
> So, The Keystone 2 Generic PM Controller is just a proxy PM layer here between
> device and Generic clock manipulation PM callbacks.
> It fills per-device clock list when device is attached to GPD and
> ensures that all clocks from that list enabled/disabled when device is
> started/stopped.

The idea of such a generic power domain implementation sounds useful, but
it has absolutely no business in platform specific code.

I suggest you either remove the power domain proxy from your drivers
and use the clocks directly, or come up with an implementation that can
be used across other platforms and CPU architectures.

	Arnd
