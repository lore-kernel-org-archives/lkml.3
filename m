Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752764Ab3LHHFm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Dec 2013 02:05:42 -0500
Received: from mail-la0-f53.google.com ([209.85.215.53]:47639 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942Ab3LHHFk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Dec 2013 02:05:40 -0500
Message-ID: <1386486335.7152.83.camel@host5.omatika.ru>
Subject: Re: [PATCH v2 02/11] arm: pxa27x: support ICP DAS LP-8x4x
From: Sergei Ianovich <ynvich@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Eric Miao <eric.y.miao@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>
Date: Sun, 08 Dec 2013 11:05:35 +0400
In-Reply-To: <201312080321.12001.arnd@arndb.de>
References: <1385879185-22455-3-git-send-email-ynvich@gmail.com>
	 <1386348542-9584-1-git-send-email-ynvich@gmail.com>
	 <201312080321.12001.arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-12-08 at 03:21 +0100, Arnd Bergmann wrote:
> On Friday 06 December 2013, Sergei Ianovich wrote:
> You have some rather unusual options in here. I'd suggest you go through
> the reduced defconfig file and remove all options that look like they
> are unnecessary for your system.
> 
> It's probably based on some distro config that enables lots of modules
> you don't actually want.

I tried to future-proof the config, by enabling all partition tables and
USB disks and modems that could be plugged into the device.

I'll remove those. However, I would like to retain config options
related to low latency and small kernel size. Keeping them will
hopefully allow being notified about changes affecting the system.

Will this fly?

> > +#define LP8X4X_FPGA_PHYS     0x17000000
> > +#define LP8X4X_FPGA_VIRT     ((void *) 0xf1000000)
> > +#define LP8X4X_P2V(x)                IOMEM((x) - LP8X4X_FPGA_PHYS + LP8X4X_FPGA_VIRT)
> > +#define LP8X4X_V2P(x)                ((x) - LP8X4X_FPGA_VIRT + LP8X4X_FPGA_PHYS)
> 
> I think you misunderstood my comment, the point was that you should
> move the IOMEM() to the LP8X4X_FPGA_VIRT definition, like
> 
> #define LP8X4X_FPGA_VIRT        ((void __iomem *) 0xf1000000)
> #define LP8X4X_P2V(x)           (x) - LP8X4X_FPGA_PHYS + LP8X4X_FPGA_VIRT)
> 
> which would result in the correct type because of pointer arithmetics.
> 
> > +/* board level registers in the FPGA */
> > +
> > +#define LP8X4X_EOI           LP8X4X_P2V(0x17009006)
> > +#define LP8X4X_INSINT                LP8X4X_P2V(0x17009008)
> > +#define LP8X4X_ENSYSINT              LP8X4X_P2V(0x1700900A)
> > +#define LP8X4X_PRIMINT               LP8X4X_P2V(0x1700900C)
> > +#define LP8X4X_SECOINT               LP8X4X_P2V(0x1700900E)
> > +#define LP8X4X_ENRISEINT     LP8X4X_P2V(0x17009010)
> > +#define LP8X4X_CLRRISEINT    LP8X4X_P2V(0x17009012)
> > +#define LP8X4X_ENHILVINT     LP8X4X_P2V(0x17009014)
> > +#define LP8X4X_CLRHILVINT    LP8X4X_P2V(0x17009016)
> > +#define LP8X4X_ENFALLINT     LP8X4X_P2V(0x17009018)
> > +#define LP8X4X_CLRFALLINT    LP8X4X_P2V(0x1700901a)
> 
> Thinking about this again, it's actually better if you just get rid of
> LP8X4X_P2V() entirely and redefine these to
> 
> #define LP8X4X_EOI              0x0006
> #define LP8X4X_INSINT           0x0008
> ...
> 
> and change the users to do e.g.
> 
>         readl(LP8X4X_FPGA_VIRT + LP8X4X_INSINT);

I am trying to boot the system with device tree. If I manage, I'll move
this code into drivers/irqchip/ as a platform device. Otherwise, I'll
make this change.

> This is closer to the normal way of adding the offset to an __iomem
> pointer returned from ioremap.
> 
> > +     platform_device_register_resndata(NULL, "pxa2xx-flash", 0,
> > +                     &lp8x4x_flash_resources[0], 1,
> > +                     &lp8x4x_flash_data[0], sizeof(lp8x4x_flash_data[0]));
> > +     platform_device_register_resndata(NULL, "pxa2xx-flash", 1,
> > +                     &lp8x4x_flash_resources[1], 1,
> > +                     &lp8x4x_flash_data[1], sizeof(lp8x4x_flash_data[1]));
> > +     platform_device_register_simple("dm9000", 0,
> > +                     &lp8x4x_dm9000_resources[0], 3);
> > +     platform_device_register_simple("dm9000", 1,
> > +                     &lp8x4x_dm9000_resources[3], 3);
> 
> This looks much better than the first version, a slight improvement IMHO would
> be to split the resource arrays into one symbol per device to turn this into
> 
> platform_device_register_resndata(NULL, "pxa2xx-flash", 0,
>                         &lp8x4x_flash_resources0, 1,
>                         &lp8x4x_flash_data0, sizeof(lp8x4x_flash_data0));
> platform_device_register_resndata(NULL, "pxa2xx-flash", 1,
>                         &lp8x4x_flash_resources1, 1,
>                         &lp8x4x_flash_data1, sizeof(lp8x4x_flash_data1));
> 
> It's not important though if you have a strong preference for the way you
> did this, it just seems unusual.

I'll make this change, if device tree doesn't boot.

Thanks for reviewing.


