Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752100Ab3LBNxq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 08:53:46 -0500
Received: from mga09.intel.com ([134.134.136.24]:29245 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751510Ab3LBNxm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 08:53:42 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,811,1378882800"; 
   d="scan'208";a="437101585"
Date: Mon, 2 Dec 2013 15:53:33 +0200
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Sergei Ianovich <ynvich@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>,
        Eric Miao <eric.y.miao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Arnd Bergmann <arnd@arndb.de>,
        "open list:SERIAL DRIVERS" <linux-serial@vger.kernel.org>
Subject: Re: [PATCH 05/11] serial: support for 16550 serial ports on LP-8x4x
Message-ID: <20131202135333.GJ3942@xps8300>
References: <1385879185-22455-1-git-send-email-ynvich@gmail.com>
 <1385879185-22455-6-git-send-email-ynvich@gmail.com>
 <20131202084845.GD3942@xps8300>
 <1385984782.12531.26.camel@host5.omatika.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1385984782.12531.26.camel@host5.omatika.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Dec 02, 2013 at 03:46:22PM +0400, Sergei Ianovich wrote:
> On Mon, 2013-12-02 at 10:48 +0200, Heikki Krogerus wrote:
> > On Sun, Dec 01, 2013 at 10:26:18AM +0400, Sergei Ianovich wrote:
> > > +static int request_and_remap(int i)
> > > +{
> > > +	if (!request_mem_region(extra_mem[i], 1, "serial"))
> > > +		return -EBUSY;
> > > +
> > > +	lp8x4x_data[i].private_data = ioremap(extra_mem[i], 1);
> > > +	if (lp8x4x_data[i].private_data)
> > > +		return 0;
> > > +
> > > +	release_mem_region(extra_mem[i], 1);
> > > +	return -ENODEV;
> 
> > Instead of registering a platform device for serial8250 here, you need
> > to simply register a platform driver for something like lp8x4x_serial.
> > The platform code will to registers the platform devices for it. You
> > will use serial8250_register_8250_port() in your probe to register a
> > new port. Use 8250_em.c and 8250_dw.c under drivers/tty/serial/8250/
> > as an example.
> > 
> > You don't need to introduce plat_serial8250_port so you won't need
> > the QUIRK_PORT stuff. You deliver the iomem and the irq as normal
> > resources that the driver uses when you create the platform device.
> > That of course also means the driver does not need to care about the
> > instances. The platform code will generate a platform device for as
> > many ports you have and set to resources accordingly.
> 
> 8250_core.c doesn't use platform infrastructure to request and map IO
> memory. There will be a conflict (and an error in
> serial8250_request_std_resource()), if main IO memory is requested by
> the platform device, won't it?

You don't need to request the mem region in your probe driver.

You can still map it. You have the flag UPF_IOREMAP that you can use
to tell 8250_code.c to map the region. If you don't set the flag,
8250_core.c will in practice expect that port->membase is already set
by the probe driver.

Check 8250_dw.c. It does the mapping on it's own and simply doesn't
set the flag.

Br,

-- 
heikki
