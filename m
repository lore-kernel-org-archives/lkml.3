Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751570AbaKGKEp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 05:04:45 -0500
Received: from mout.kundenserver.de ([212.227.17.13]:60387 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957AbaKGKEn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 05:04:43 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: DATACOM - =?ISO-8859-1?Q?=C9rico?= Nunes 
	<erico.nunes@datacom.ind.br>
Cc: grant.likely@linaro.org, robh+dt@kernel.org, devicetree@vger.kernel.org,
        sameo@linux.intel.com, lee.jones@linaro.org,
        linux-kernel@vger.kernel.org
Subject: Re: Creating a new platform_bus inside a spi_driver
Date: Fri, 07 Nov 2014 11:04:36 +0100
Message-ID: <707686811.tbHdnxXMgE@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <545BD3EC.6050503@datacom.ind.br>
References: <545BD3EC.6050503@datacom.ind.br>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
X-Provags-ID: V02:K0:LKVvWJCBl2O6bFrFHpqlwv8Kx7ywxzP9jY8nptbjrCu
 kTrXgvxCABk2ejkyI/N3yD9eC1O9ZFPkjxyUA9jmAD/j+OxjRC
 D65qTMSBHrgXXTPsgncNOxTXc4xCj5jpRKcaZUzFkJO74BUbNk
 d0v4OLWQUHoHjQocU5cKMySQD5tFjV+8q8M39bpzp+Gd+Q5UrV
 f906zRNgF6EiNaLpBBDxj+C5hsaZPzqoSQpU/4I1REpPgB+xRW
 b7ZZ0+Sqr/yQ4UJ43vC4V4z5fxkFUePPsIcNKgyWCFxlrMK/Zr
 kTDvxdlMp58uiUsLvtkPP0HrwsRYyImtyFMRmCqQ5pUBpmRAjK
 bUXIiDY/KRBR/c651E8g=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 06 November 2014 18:02:52 DATACOM - Érico Nunes wrote:
> 
> The idea is that "fpga-spi" is a spi_driver which instantiates all of the
> "fpga-deviceN" as platform_devices, through the use of
> of_platform_populate(dev->of_node, NULL, NULL, dev).
> 
> The visible problem we're facing with this approach is that, as the internal
> platform_devices have a "reg" property, of_platform_populate() eventually
> triggers an address translation which is apparently trying to translate the
> addresses of the internal platform_bus to addresses of the processor memory
> map.
> This translation is however not part of our intention, as we intend to have an
> internal bus with its own memory map.
> This fails when __of_translate_address() reaches the spi-master boundary
> because (as it seems to make sense) it isn't possible to translate them past
> that.
> A KERN_ERR rated message like
> "prom_parse: Bad cell count for /soc@f0000000/spi@2000/fpga@1"
> is thrown by __of_translate_address() and later it is not possible to obtain
> the "reg" address with platform_get_resource().
> 
> On this scenario, we have a few questions and, depending on the outcome of
> these, possibly a patch.
> 
> 1. Is it possible to have an internal platform_bus with a different memory map
> as we intended? Or are platform_busses and platform_devices supposed to always
> be mapped on the processor memory map?

It's inconsistent. We have some code that assumes that platform devices
are always memory mapped, and some other code that breaks this assumption.

> 2. If platform_bus and platform_device were actually designed to always be
> mappable to the processor memory map, what would be a different approach to
> this problem?  One alternative considered was to define a new "fpga_bus" and
> "fpga_device" but that seemed as an overkill approach to the problem.

I think the existing mfd framework should do what you need, when you call
mfd_add_devices() and pass a table of cells with the compatible strings
for your devices, it should create the platform devices you want. If not,
that can probably be fixed in the mfd core code.

	Arnd
