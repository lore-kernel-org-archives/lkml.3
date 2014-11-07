Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752314AbaKGREr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 12:04:47 -0500
Received: from mout.kundenserver.de ([212.227.17.13]:56132 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752089AbaKGREp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 12:04:45 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: DATACOM - =?ISO-8859-1?Q?=C9rico?= Nunes 
	<erico.nunes@datacom.ind.br>
Cc: grant.likely@linaro.org, robh+dt@kernel.org, devicetree@vger.kernel.org,
        sameo@linux.intel.com, lee.jones@linaro.org,
        linux-kernel@vger.kernel.org
Subject: Re: Creating a new platform_bus inside a spi_driver
Date: Fri, 07 Nov 2014 18:04:35 +0100
Message-ID: <2501338.EAyTJJ482M@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <545CF546.8090703@datacom.ind.br>
References: <545BD3EC.6050503@datacom.ind.br> <707686811.tbHdnxXMgE@wuerfel> <545CF546.8090703@datacom.ind.br>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
X-Provags-ID: V02:K0:Byth/M9N+8tD3hnYGxnVgSfPchmkyLB+NM8h6AaMV/W
 9GY2f2YAiy60x60bp7k6Pec6a90VPTnsaJEtIPaUQZn8zvd3Ol
 st7VCY6xYRvfvu2i7tkvTcbYHkiW2N/aMrlAZOWswesjO2WzMP
 rI4VXjtGOJnzFu+Hzti0NRITdw3q8UCzUSWAnBJ4r0p3/tcRlq
 VOgZ/ERvlZJu1untBUbAvvt5hr5G3aeA+V7qMGb1GnSwsUKNwB
 uFOw6IIOrE19sRv7FB2cnYK2smeR9eLjKDR6VOko/Kzh/3lxEp
 UtDrXJ0QXkxj6ezNG2L+cvWc4m8PaIx8WSWgcYDy9RoxeByKV8
 +dGaUtGMPmvHhQ5vFBuc=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 07 November 2014 14:37:26 DATACOM - Érico Nunes wrote:
> Hello Arnd and all,
> 
> On 11/07/2014 08:04 AM, Arnd Bergmann wrote:
> > On Thursday 06 November 2014 18:02:52 DATACOM - Érico Nunes wrote:
> >> The idea is that "fpga-spi" is a spi_driver which instantiates all of the
> >> "fpga-deviceN" as platform_devices, through the use of
> >> of_platform_populate(dev->of_node, NULL, NULL, dev).
> >>
> >> The visible problem we're facing with this approach is that, as the internal
> >> platform_devices have a "reg" property, of_platform_populate() eventually
> >> triggers an address translation which is apparently trying to translate the
> >> addresses of the internal platform_bus to addresses of the processor memory
> >> map.
> >> This translation is however not part of our intention, as we intend to have an
> >> internal bus with its own memory map.
> >> This fails when __of_translate_address() reaches the spi-master boundary
> >> because (as it seems to make sense) it isn't possible to translate them past
> >> that.
> >> A KERN_ERR rated message like
> >> "prom_parse: Bad cell count for /soc@f0000000/spi@2000/fpga@1"
> >> is thrown by __of_translate_address() and later it is not possible to obtain
> >> the "reg" address with platform_get_resource().
> >>
> >> On this scenario, we have a few questions and, depending on the outcome of
> >> these, possibly a patch.
> >>
> >> 1. Is it possible to have an internal platform_bus with a different memory map
> >> as we intended? Or are platform_busses and platform_devices supposed to always
> >> be mapped on the processor memory map?
> > It's inconsistent. We have some code that assumes that platform devices
> > are always memory mapped, and some other code that breaks this assumption.
> 
> By this I take that the platform subsystem could be made generic so it can be
> used in both ways (mapped to processor memory map or mapped to a private memory
> map). There seems to be no strict requirement enforcing it to be processor
> memory map.
> 
> Is this correct?

It could be, but I'm sure if that is a good idea or not. It might complicate
things elsewhere, so it would at least need careful testing and consensus
among a broader group of developers.

> >> 2. If platform_bus and platform_device were actually designed to always be
> >> mappable to the processor memory map, what would be a different approach to
> >> this problem?  One alternative considered was to define a new "fpga_bus" and
> >> "fpga_device" but that seemed as an overkill approach to the problem.
> > I think the existing mfd framework should do what you need, when you call
> > mfd_add_devices() and pass a table of cells with the compatible strings
> > for your devices, it should create the platform devices you want. If not,
> > that can probably be fixed in the mfd core code.
> >
> >
> 
> Thanks for the tip, we were not aware of the purpose of this mfd framework and
> we will take a look at this framework now.
> However I'm thinking now that eventually it would fall in the same case of
> trying to translate the address of any "reg" dts property to the processor
> memory map, and fail with the same error for the SPI case.
> 
> Considering this and taking the answer to the first question, do you think a
> patch fixing the "error" report by the translation function would be
> acceptable?
> We can prepare/test that under our platform and submit it.

Please try to use the mfd approach first. There are a lot of mfd drivers
on the SPI bus, so I'd assume this works fine.

	Arnd
