Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756442Ab3D1Nmi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Apr 2013 09:42:38 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:19700 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756279Ab3D1Nmf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Apr 2013 09:42:35 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Sun, 28 Apr 2013 06:42:34 -0700
From: Bibek Basu <bbasu@nvidia.com>
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Date: Sun, 28 Apr 2013 19:12:28 +0530
Subject: RE: [PATCH 2/2] ARM: DT: tegra: pinctrl suspend resume hook
Thread-Topic: [PATCH 2/2] ARM: DT: tegra: pinctrl suspend resume hook
Thread-Index: Ac5CtyS+NAtuyek5RzOmyXj/GS74vQBW7XcA
Message-ID: <77F7DB30C698A44DA22FB222C89DE941A6692E62BD@BGMAIL01.nvidia.com>
References: <1366740542-26127-1-git-send-email-bbasu@nvidia.com>
 <1366740542-26127-2-git-send-email-bbasu@nvidia.com>
 <20130426194908.GA3302@avionic-0098.mockup.avionic-design.de>
In-Reply-To: <20130426194908.GA3302@avionic-0098.mockup.avionic-design.de>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Thierry Reding [mailto:thierry.reding@avionic-design.de]
> Sent: Saturday, April 27, 2013 1:19 AM
> To: Bibek Basu
> Cc: Rafael J. Wysocki; linus.walleij@linaro.org; swarren@wwwdotorg.org;
> linux-tegra@vger.kernel.org; linux-kernel@vger.kernel.org; linux-
> pm@vger.kernel.org
> Subject: Re: [PATCH 2/2] ARM: DT: tegra: pinctrl suspend resume hook
> 
> * PGP Signed by an unknown key
> 
> On Tue, Apr 23, 2013 at 11:39:02PM +0530, Bibek Basu wrote:
> > Make pinmux as the first node of tegra DT so as to achieve pinctrl as
> > last device to suspend and first device to resume.
> 
> I don't think this is a good idea. For one it encodes Linux specific
> implementation details within the device tree. Furthermore I seem to
> remember that the device tree makes no guarantees that the order of nodes
> in the blob is the same as the order in the DTS.
> 
> That said I don't have a good alternative. Perhaps one solution would be to
> use suspend_late() and resume_early() for the pinmux driver since they will
> be called after and before the suspend() and resume() callbacks of all other
> devices, respectively. Other than that I wasn't able to find anything about
> forcing a particular order during suspend and resume.
> 
> Cc'ing Rafael and the linux-pm mailing list, maybe somebody among them
> knows a proper solution.
> 
Stephen actually suggested me earlier to add dummy pinmux state on all dependent devices node. And that will make sure that dependency of driver prevails.
I tried that but I was not getting the desired result.
Can anyone tell me correct syntax for adding dummy state?

Regards
Bibek

> Thierry
> 
> >
> > Signed-off-by: Bibek Basu <bbasu@nvidia.com>
> > ---
> >  arch/arm/boot/dts/tegra114.dtsi | 12 ++++++------
> > arch/arm/boot/dts/tegra20.dtsi  | 16 ++++++++--------
> > arch/arm/boot/dts/tegra30.dtsi  | 13 +++++++------
> >  3 files changed, 21 insertions(+), 20 deletions(-)
> >
> > diff --git a/arch/arm/boot/dts/tegra114.dtsi
> > b/arch/arm/boot/dts/tegra114.dtsi index a58a761..36596ae 100644
> > --- a/arch/arm/boot/dts/tegra114.dtsi
> > +++ b/arch/arm/boot/dts/tegra114.dtsi
> > @@ -11,6 +11,12 @@
> >  		serial3 = &uartd;
> >  	};
> >
> > +	pinmux: pinmux {
> > +		compatible = "nvidia,tegra114-pinmux";
> > +		reg = <0x70000868 0x148		/* Pad control
> registers */
> > +		       0x70003000 0x40c>;	/* Mux registers */
> > +	};
> > +
> >  	host1x {
> >  		compatible = "nvidia,tegra114-host1x", "simple-bus";
> >  		reg = <0x50000000 0x00028000>;
> > @@ -165,12 +171,6 @@
> >  		interrupt-controller;
> >  	};
> >
> > -	pinmux: pinmux {
> > -		compatible = "nvidia,tegra114-pinmux";
> > -		reg = <0x70000868 0x148		/* Pad control
> registers */
> > -		       0x70003000 0x40c>;	/* Mux registers */
> > -	};
> > -
> >  	/*
> >  	 * There are two serial driver i.e. 8250 based simple serial
> >  	 * driver and APB DMA based serial driver for higher baudrate diff
> > --git a/arch/arm/boot/dts/tegra20.dtsi
> > b/arch/arm/boot/dts/tegra20.dtsi index a5a9615..6d8a663 100644
> > --- a/arch/arm/boot/dts/tegra20.dtsi
> > +++ b/arch/arm/boot/dts/tegra20.dtsi
> > @@ -12,6 +12,14 @@
> >  		serial4 = &uarte;
> >  	};
> >
> > +	pinmux: pinmux {
> > +		compatible = "nvidia,tegra20-pinmux";
> > +		reg = <0x70000014 0x10   /* Tri-state registers */
> > +		       0x70000080 0x20   /* Mux registers */
> > +		       0x700000a0 0x14   /* Pull-up/down registers */
> > +		       0x70000868 0xa8>; /* Pad control registers */
> > +	};
> > +
> >  	host1x {
> >  		compatible = "nvidia,tegra20-host1x", "simple-bus";
> >  		reg = <0x50000000 0x00024000>;
> > @@ -196,14 +204,6 @@
> >  		interrupt-controller;
> >  	};
> >
> > -	pinmux: pinmux {
> > -		compatible = "nvidia,tegra20-pinmux";
> > -		reg = <0x70000014 0x10   /* Tri-state registers */
> > -		       0x70000080 0x20   /* Mux registers */
> > -		       0x700000a0 0x14   /* Pull-up/down registers */
> > -		       0x70000868 0xa8>; /* Pad control registers */
> > -	};
> > -
> >  	das {
> >  		compatible = "nvidia,tegra20-das";
> >  		reg = <0x70000c00 0x80>;
> > diff --git a/arch/arm/boot/dts/tegra30.dtsi
> > b/arch/arm/boot/dts/tegra30.dtsi index 9f33086..b4b79f0 100644
> > --- a/arch/arm/boot/dts/tegra30.dtsi
> > +++ b/arch/arm/boot/dts/tegra30.dtsi
> > @@ -12,6 +12,13 @@
> >  		serial4 = &uarte;
> >  	};
> >
> > +	pinmux: pinmux {
> > +		compatible = "nvidia,tegra30-pinmux";
> > +		reg = <0x70000868 0xd4    /* Pad control registers */
> > +		       0x70003000 0x3e4>; /* Mux registers */
> > +	};
> > +
> > +
> >  	host1x {
> >  		compatible = "nvidia,tegra30-host1x", "simple-bus";
> >  		reg = <0x50000000 0x00024000>;
> > @@ -216,12 +223,6 @@
> >  		interrupt-controller;
> >  	};
> >
> > -	pinmux: pinmux {
> > -		compatible = "nvidia,tegra30-pinmux";
> > -		reg = <0x70000868 0xd4    /* Pad control registers */
> > -		       0x70003000 0x3e4>; /* Mux registers */
> > -	};
> > -
> >  	/*
> >  	 * There are two serial driver i.e. 8250 based simple serial
> >  	 * driver and APB DMA based serial driver for higher baudrate
> > --
> > 1.8.1.5
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-tegra"
> > in the body of a message to majordomo@vger.kernel.org More
> majordomo
> > info at  http://vger.kernel.org/majordomo-info.html
> >
> >
> 
> * Unknown Key
> * 0x7F3EB3A1
