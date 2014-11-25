Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751896AbaKYGoO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 01:44:14 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:43102 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751303AbaKYGoL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 01:44:11 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <2997659.fTX2lvxXfH@wuerfel>
Cc: "Grygorii Strashko" <grygorii.strashko@ti.com>,
        "Geert Uytterhoeven" <geert@linux-m68k.org>,
        "Kevin Hilman" <khilman@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "Ulf Hansson" <ulf.hansson@linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "Dmitry Torokhov" <dmitry.torokhov@gmail.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Grant Likely" <grant.likely@secretlab.ca>,
        "Rob Herring" <robh+dt@kernel.org>, ssantosh@kernel.org
References: <1415631557-22897-1-git-send-email-grygorii.strashko@ti.com>
 <CAMuHMdU6G35SP-P7bt6RJQk59CrGcKE2XM4N3o8Dv3qxZU7gxA@mail.gmail.com>
 <546F8B39.1080106@ti.com> <2997659.fTX2lvxXfH@wuerfel>
Message-ID: <20141125064406.12298.57929@quantum>
User-Agent: alot/0.3.5
Subject: Re: [PATCH v4 1/2] ARM: keystone: pm: switch to use generic pm domains
Date: Mon, 24 Nov 2014 22:44:06 -0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Arnd Bergmann (2014-11-24 02:50:28)
> On Friday 21 November 2014 20:58:01 Grygorii Strashko wrote:
> > Hi Kevin,
> > On 11/21/2014 10:06 AM, Geert Uytterhoeven wrote:
> > > On Fri, Nov 21, 2014 at 2:30 AM, Kevin Hilman <khilman@kernel.org> wrote:
> > >> Geert Uytterhoeven <geert@linux-m68k.org> writes:
> > >>
> > >> So now I'm confused about why the PM domain has to do anything special
> > >> if the presence/absence of the clocks is already handled by the DT.
> > > 
> > > Just adding a clock property to a device node in DT doesn't enable the clock
> > > automatically, nor make it runtime-managed automatically.
> > > Compare this to e.g. pinctrl, where adding pinctrl properties to DT does enable
> > > them automatically, without the driver for the device having to care about it.
> > >
> > > Drivers interfacing external hardware typically do care about clocks, as they
> > > have to program clock generators for the external hardware interface (e.g.
> > > driving spi or i2c buses at specific frequencies).
> 
> But is this a property of the driver or of the device? If this is true
> independent of the driver implementation, I don't see a problem with 
> the approach of linking to a power-domain that automatically manages
> all clocks for the devices that need this, and requires the driver to
> manage them itself when there are any clocks that can't be handled
> with the generic clk-power-domain implementation.
>  
> > 
> > In non-DT case, we have possibility to divide clocks on "fck" and "opt"
> > (The way it can be done is not convenient, but it is - .con_id).
> > 
> > For DT-case - no way now. Also, PM domains are not physically present on
> > Keystone 2 and GPD was selected as glue layer to integrate DT, pm_clk and
> > PM runtime all together (one big-fat-global PM domain :).
> > 
> > So, I was able to find only following way to define "fck" clocks in DT:
> >       clocks = <&papllclk>, <&clkcpgmac>, <&chipclk12>;
> >       clock-names = "clk_pa", "clk_cpgmac", "cpsw_cpts_rft_clk";
> >       fck-clocks = <&papllclk>, <&clkcpgmac>;
> > As you can see - this will lead to data duplication in DT (
> > 
> > Any propositions are welcome?
> > 
> > Unfortunately, It seems that if we would not able to find DT solution
> > then there will be following ways to move forward:
> > - "remove the power domain proxy from your drivers and use the clocks directly" 
> > ((c) Arnd Bergmann).
> > [As possibility - It can be allowed to use clk_pm APIs by drivers]
> > - continue using platform specific implementations.
> 
> Could the driver maybe identify the clocks that it wants to manage itself
> to the pm-domain code? If it's safe for a device to have the clock turned
> on at the default rate before loading the driver, any device that is connected
> to the simple clk-pm-domain code could have all its clocks start out as
> owned by the pm-domain, but then claim the clocks it needs to reprogram for
> itself and take them out of the pmdomain.

I was thinking along similar lines. The functional versus optional stuff
is really a property of the consuming device, not the clock signal
itself.

Instead of adding a new property to the clock binding (e.g. fck-clocks
or optional-clocks), could we simply wrap those lists of clocks in
another node? E.g:

mandatory-clocks {
       clocks = <&papllclk>, <&clkcpgmac>;
       clock-names = "clk_pa", "clk_cpgmac";
}

clocks = <&papllclk>, <&clkcpgmac>, <&chipclk12>;
       clocks = <&clkcpgmac>;
       clock-names = "cpsw_cpts_rft_clk";
}

I'm showing my DT ignorance on this one. I haven't really thought
through how these sub-nodes would work with of_clk_* handlers in
drivers/clk/clkdev.c.

Regards,
Mike

> 
>         Arnd
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
