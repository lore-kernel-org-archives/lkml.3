Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753427AbaKXKvP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 05:51:15 -0500
Received: from mout.kundenserver.de ([212.227.17.13]:56646 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753178AbaKXKvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 05:51:13 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Grygorii Strashko <grygorii.strashko@ti.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Kevin Hilman <khilman@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <robh+dt@kernel.org>, ssantosh@kernel.org
Subject: Re: [PATCH v4 1/2] ARM: keystone: pm: switch to use generic pm domains
Date: Mon, 24 Nov 2014 11:50:28 +0100
Message-ID: <2997659.fTX2lvxXfH@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <546F8B39.1080106@ti.com>
References: <1415631557-22897-1-git-send-email-grygorii.strashko@ti.com> <CAMuHMdU6G35SP-P7bt6RJQk59CrGcKE2XM4N3o8Dv3qxZU7gxA@mail.gmail.com> <546F8B39.1080106@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:oJ+4f62Oi852R4m4rGaTiU1hIGzNJTXWB56KXGwyltc
 kvwUGlafMwi6xG3R4mUFXWAc/BcVCBwIjw0hYYepAAVM+rlemY
 5eWQkAUPiEtTmzCmNJBOneKfrGWaWSx5hQM5gyovuEYo67bovv
 gwn50ehiUHdR8oxxNiWAis+jXGyQrohs7TYarC8D9o2HoKYNq6
 S6Xj6Q08/VUWDvbLZPKP1fWuaVVLCLACnWN08n0yHz0HqF/CIg
 aXxXazoxrXMvOrr7lPvf96FO9ld7v73a/wnmpceqybP/wax/Ds
 cdB/mW23cIbpV1K4ivi4HTAvxznp+sNdH5EAi4SPVHv2k/gdU9
 6xvuMpWRnHbrOzUSc7TY=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 21 November 2014 20:58:01 Grygorii Strashko wrote:
> Hi Kevin,
> On 11/21/2014 10:06 AM, Geert Uytterhoeven wrote:
> > On Fri, Nov 21, 2014 at 2:30 AM, Kevin Hilman <khilman@kernel.org> wrote:
> >> Geert Uytterhoeven <geert@linux-m68k.org> writes:
> >>
> >> So now I'm confused about why the PM domain has to do anything special
> >> if the presence/absence of the clocks is already handled by the DT.
> > 
> > Just adding a clock property to a device node in DT doesn't enable the clock
> > automatically, nor make it runtime-managed automatically.
> > Compare this to e.g. pinctrl, where adding pinctrl properties to DT does enable
> > them automatically, without the driver for the device having to care about it.
> >
> > Drivers interfacing external hardware typically do care about clocks, as they
> > have to program clock generators for the external hardware interface (e.g.
> > driving spi or i2c buses at specific frequencies).

But is this a property of the driver or of the device? If this is true
independent of the driver implementation, I don't see a problem with 
the approach of linking to a power-domain that automatically manages
all clocks for the devices that need this, and requires the driver to
manage them itself when there are any clocks that can't be handled
with the generic clk-power-domain implementation.
 
> 
> In non-DT case, we have possibility to divide clocks on "fck" and "opt"
> (The way it can be done is not convenient, but it is - .con_id).
> 
> For DT-case - no way now. Also, PM domains are not physically present on
> Keystone 2 and GPD was selected as glue layer to integrate DT, pm_clk and
> PM runtime all together (one big-fat-global PM domain :).
> 
> So, I was able to find only following way to define "fck" clocks in DT:
> 	clocks = <&papllclk>, <&clkcpgmac>, <&chipclk12>;
> 	clock-names = "clk_pa", "clk_cpgmac", "cpsw_cpts_rft_clk";
> 	fck-clocks = <&papllclk>, <&clkcpgmac>;
> As you can see - this will lead to data duplication in DT (
> 
> Any propositions are welcome?
> 
> Unfortunately, It seems that if we would not able to find DT solution
> then there will be following ways to move forward:
> - "remove the power domain proxy from your drivers and use the clocks directly" 
> ((c) Arnd Bergmann).
> [As possibility - It can be allowed to use clk_pm APIs by drivers]
> - continue using platform specific implementations.

Could the driver maybe identify the clocks that it wants to manage itself
to the pm-domain code? If it's safe for a device to have the clock turned
on at the default rate before loading the driver, any device that is connected
to the simple clk-pm-domain code could have all its clocks start out as
owned by the pm-domain, but then claim the clocks it needs to reprogram for
itself and take them out of the pmdomain.

	Arnd
