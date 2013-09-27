Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752398Ab3I0Gcg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 02:32:36 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:57717 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202Ab3I0Gce (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 02:32:34 -0400
Date: Fri, 27 Sep 2013 08:32:26 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
cc: linux-kernel@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
        linux-sh@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Simon Horman <horms@verge.net.au>
Subject: Re: [PATCH v2 5/5] ARM: shmobile: lager: (DEVEL) add CPUFreq support
In-Reply-To: <1472582.vouUexCmlh@avalon>
Message-ID: <Pine.LNX.4.64.1309270818450.23205@axis700.grange>
References: <1380216060-14506-1-git-send-email-g.liakhovetski@gmx.de>
 <1380216060-14506-6-git-send-email-g.liakhovetski@gmx.de> <1472582.vouUexCmlh@avalon>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:Y++F8H54o2IqQn0uacCriX+VRn8nWtcJN2SHMWmexqD
 0SU/zS9UyQnF7NAtbbBM9p2QYpmHfWb/NaTNWcfDMj5Br5Xsbo
 xHpW2RdWsBNsCyfu2CiiH3qywFb/NbXxscepNRSHBhEzHAKTqF
 n0aJ5NVLNzc9sOunJ9d0m49y3SL+9MkTXR2iSBNIz4i4TJBRNy
 vtuK/arZdlB89vi18NgUabAeI4sbEQMSi0DzDIhrDjFXLNEE27
 3UCDb+muQbBmlclbP3t35nGjuvBCL/z79ovZ4xQ340zLUNNZm/
 L8BlfTRdop2yULfrFoC4xb8XxFFPD0OuNjAwB8w9BAR76qIbmu
 Yeab4gWshaEYixwrJmKD4EQs3Zy4wvBSEt+Y94b5CaduLWk9xN
 CHmQdBkiSwBvQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Laurent

On Fri, 27 Sep 2013, Laurent Pinchart wrote:

> Hi Guennadi,
> 
> Thank you for the patch.
> 
> On Thursday 26 September 2013 19:21:00 Guennadi Liakhovetski wrote:
> > The Lager board uses a DA9210 voltage regulator to supply DVFS power to the
> > CA15 cores on the r8a7790 SoC. This patch adds CPUFreq support for that
> > board using the cpufreq-cpu0 driver.
> > 
> > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
> > ---
> > 
> > v2: added 'status = "okay";' to the i2c bus
> > 
> >  arch/arm/boot/dts/r8a7790-lager-reference.dts  |   33 +++++++++++++++++++++
> >  arch/arm/mach-shmobile/board-lager-reference.c |    4 ++-
> >  2 files changed, 36 insertions(+), 1 deletions(-)
> > 
> > diff --git a/arch/arm/boot/dts/r8a7790-lager-reference.dts
> > b/arch/arm/boot/dts/r8a7790-lager-reference.dts index c462ef1..1ce0a97
> > 100644
> > --- a/arch/arm/boot/dts/r8a7790-lager-reference.dts
> > +++ b/arch/arm/boot/dts/r8a7790-lager-reference.dts
> > @@ -43,3 +43,36 @@
> >  		};
> >  	};
> >  };
> > +
> > +&i2c3 {
> > +	status = "okay";
> > +	pinctrl-names = "default";
> > +	pinctrl-0 = <&i2c3_pins>;
> > +
> > +	vdd_dvfs: da9210@68 {
> > +		compatible = "diasemi,da9210";
> > +		reg = <0x68>;
> > +
> > +		regulator-min-microvolt = <900000>;
> > +		regulator-max-microvolt = <1000000>;
> > +		regulator-boot-on;
> > +		regulator-always-on;
> > +	};
> > +};
> > +
> > +&cpu0 {
> > +	cpu0-supply = <&vdd_dvfs>;
> > +	operating-points = <
> > +		/* kHz  uV - OPs unknown yet */
> > +		1300000 1000000
> > +		1000000  900000
> > +	>;
> > +	voltage-tolerance = <1>; /* 1% */
> > +};
> > +
> > +&pfc {
> > +	i2c3_pins: i2c3 {
> > +		renesas,groups = "i2c3";
> > +		renesas,function = "i2c3";
> > +	};
> > +};
> > diff --git a/arch/arm/mach-shmobile/board-lager-reference.c
> > b/arch/arm/mach-shmobile/board-lager-reference.c index 1a1a4a8..2bc8bae
> > 100644
> > --- a/arch/arm/mach-shmobile/board-lager-reference.c
> > +++ b/arch/arm/mach-shmobile/board-lager-reference.c
> > @@ -20,6 +20,7 @@
> > 
> >  #include <linux/init.h>
> >  #include <linux/of_platform.h>
> > +#include <linux/platform_device.h>
> >  #include <mach/r8a7790.h>
> >  #include <asm/mach/arch.h>
> > 
> > @@ -29,7 +30,8 @@ static void __init lager_add_standard_devices(void)
> >  	r8a7790_clock_init();
> > 
> >  	r8a7790_add_dt_devices();
> > -        of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
> > +	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
> > +	platform_device_register_simple("cpufreq-cpu0", -1, NULL, 0);
> 
> Out of curiosity, could you explain how this cpufreq-cpu0 platform device gets 
> associated with the cpu0 DT node ?

I can try, yes.

> The cpufreq-cpu0 driver requires a DT node 
> (its probe function returns -ENOENT if pdev->dev.of_node is NULL), and I don't 
> see how the of_node gets set as the platform device is registered through 
> board code. I might of course be missing something obvious :-)

I think you can just follow this threads:

http://thread.gmane.org/gmane.linux.kernel.cpufreq/11427/focus=1547510
http://thread.gmane.org/gmane.linux.kernel.cpufreq/12408

and there's also a comment in another my patch from yesterday from the 
same thread:

http://marc.info/?l=linux-sh&m=138021613314913&w=2

So, in short, you seem to be looking at a buggy driver state, yes. A fix 
is on its way.

Thanks
Guennadi

> >  }
> > 
> >  static const char *lager_boards_compat_dt[] __initdata = {
> -- 
> Regards,
> 
> Laurent Pinchart

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
