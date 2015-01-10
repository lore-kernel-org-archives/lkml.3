Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755571AbbAJVx2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 16:53:28 -0500
Received: from mout.kundenserver.de ([212.227.126.131]:65407 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753124AbbAJVx1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 16:53:27 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Rob Herring <robh@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-pci <linux-pci@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 07/16] ARM: integrator: convert PCI to use generic config accesses
Date: Sat, 10 Jan 2015 22:53:06 +0100
Message-ID: <4938579.0KIk3QtTCP@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CACRpkdbwKN9LenqrWeu4WykhdZOGAdxpC_BYr2cYpc2_cn5GfA@mail.gmail.com>
References: <1420857290-8373-1-git-send-email-robh@kernel.org> <1420857290-8373-8-git-send-email-robh@kernel.org> <CACRpkdbwKN9LenqrWeu4WykhdZOGAdxpC_BYr2cYpc2_cn5GfA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:umOs98ugBoNC35Rp7umzJvLeFzVH2nOJmINuGOQPHgM+fkc9yk2
 m1KDE44Zi0IhdP0lO2UnNeQBKK548c30aMDHw4DYijxfs5oY1QMHKmrZeSe73VtDo4HkCNp
 wQZ43du8prq0UL/ujz73mzxIeo5pm02Ps1SkLg9HcDmMfBRXxl1JWaQtBTsuUjBHgW/2xfG
 xIRvmh/iMNvY8BGoVL0HA==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 10 January 2015 22:40:22 Linus Walleij wrote:
> >  static int v3_read_config(struct pci_bus *bus, unsigned int devfn, int where,
> >                           int size, u32 *val)
> >  {
> > -       addr = v3_open_config_window(bus, devfn, where);
> > +       int ret = pci_generic_config_read(bus, devfn, where, size, val);
> >         v3_close_config_window();
> > +       return ret;
> >  }
> >
> >  static int v3_write_config(struct pci_bus *bus, unsigned int devfn, int where,
> >                            int size, u32 val)
> >  {
> > +       int ret = pci_generic_config_write(bus, devfn, where, size, val);
> >         v3_close_config_window();
> > -       raw_spin_unlock_irqrestore(&v3_lock, flags);
> > +       return ret;
> >  }
> >
> >  static struct pci_ops pci_v3_ops = {
> > +       .map_bus = v3_open_config_window,
> >         .read   = v3_read_config,
> >         .write  = v3_write_config,
> 
> So .map_bus is called before every .read/.write operation I take it.
> 
> Wouldn't it be proper to call the v3_close_config_window() from a
> matching .unmap_bus() callback for symmetry?

It would be nicer for integrator but useless for anything else, so
I'd vote for leaving it the way Rob posted.

	Arnd
