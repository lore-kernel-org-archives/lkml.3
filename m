Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753346AbaKKLIH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 06:08:07 -0500
Received: from mail-wg0-f42.google.com ([74.125.82.42]:54727 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753152AbaKKLID (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 06:08:03 -0500
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: Creating a new platform_bus inside a spi_driver
To: Arnd Bergmann <arnd@arndb.de>,
        DATACOM - =?iso-8859-1?b?yXJpY28=?= Nunes 
	<erico.nunes@datacom.ind.br>
Cc: robh+dt@kernel.org, devicetree@vger.kernel.org, sameo@linux.intel.com,
        lee.jones@linaro.org, linux-kernel@vger.kernel.org
In-Reply-To: <2501338.EAyTJJ482M@wuerfel>
References: <545BD3EC.6050503@datacom.ind.br>
	<707686811.tbHdnxXMgE@wuerfel> <545CF546.8090703@datacom.ind.br>
	<2501338.EAyTJJ482M@wuerfel>
Date: Tue, 11 Nov 2014 11:07:57 +0000
Message-Id: <20141111110757.3DFFAC40D48@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 07 Nov 2014 18:04:35 +0100
, Arnd Bergmann <arnd@arndb.de>
 wrote:
> On Friday 07 November 2014 14:37:26 DATACOM - Érico Nunes wrote:
> > Hello Arnd and all,
> > 
> > On 11/07/2014 08:04 AM, Arnd Bergmann wrote:
> > > On Thursday 06 November 2014 18:02:52 DATACOM - Érico Nunes wrote:
> > >> The idea is that "fpga-spi" is a spi_driver which instantiates all of the
> > >> "fpga-deviceN" as platform_devices, through the use of
> > >> of_platform_populate(dev->of_node, NULL, NULL, dev).
> > >>
> > >> The visible problem we're facing with this approach is that, as the internal
> > >> platform_devices have a "reg" property, of_platform_populate() eventually
> > >> triggers an address translation which is apparently trying to translate the
> > >> addresses of the internal platform_bus to addresses of the processor memory
> > >> map.
> > >> This translation is however not part of our intention, as we intend to have an
> > >> internal bus with its own memory map.
> > >> This fails when __of_translate_address() reaches the spi-master boundary
> > >> because (as it seems to make sense) it isn't possible to translate them past
> > >> that.
> > >> A KERN_ERR rated message like
> > >> "prom_parse: Bad cell count for /soc@f0000000/spi@2000/fpga@1"
> > >> is thrown by __of_translate_address() and later it is not possible to obtain
> > >> the "reg" address with platform_get_resource().
> > >>
> > >> On this scenario, we have a few questions and, depending on the outcome of
> > >> these, possibly a patch.
> > >>
> > >> 1. Is it possible to have an internal platform_bus with a different memory map
> > >> as we intended? Or are platform_busses and platform_devices supposed to always
> > >> be mapped on the processor memory map?
> > > It's inconsistent. We have some code that assumes that platform devices
> > > are always memory mapped, and some other code that breaks this assumption.
> > 
> > By this I take that the platform subsystem could be made generic so it can be
> > used in both ways (mapped to processor memory map or mapped to a private memory
> > map). There seems to be no strict requirement enforcing it to be processor
> > memory map.
> > 
> > Is this correct?
> 
> It could be, but I'm sure if that is a good idea or not. It might complicate
> things elsewhere, so it would at least need careful testing and consensus
> among a broader group of developers.

I don't think it is a good idea. I would prefer to make the behaviour of
of_platform_populate() generic so it could work for multiple bus
types rather than reusing/abusing platform_device in this way.

If the devices on the FPGA were memory mapped, it would be a different
situation, but being behind an SPI bus where the access to those devices
must always be mediated by the SPI controller, it would be better to
have a separate bus type and a separate pool of drivers for those
devices.

g.
