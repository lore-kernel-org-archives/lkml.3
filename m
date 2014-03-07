Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753902AbaCGQDd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 11:03:33 -0500
Received: from moutng.kundenserver.de ([212.227.17.13]:56470 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752701AbaCGQDb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 11:03:31 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: Re: [PATCH 4/7] of: configure the platform device dma_mask and dma_pfn_offset
Date: Fri, 7 Mar 2014 17:02:41 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Rob Herring <robherring2@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Russell King <linux@arm.linux.org.uk>, Olof Johansson <olof@lixom.net>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Linus Walleij <linus.walleij@linaro.org>
References: <1394097598-17622-1-git-send-email-santosh.shilimkar@ti.com> <CAL_Jsq+Y8w0sLLdh5vcWMnW3ohEafAFRWubtCK66P1axsf1wRA@mail.gmail.com> <53194817.70802@ti.com>
In-Reply-To: <53194817.70802@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201403071702.41716.arnd@arndb.de>
X-Provags-ID: V02:K0:VQfbKY73uSfRzC2qMKoGv28ftj2nSbCW45tko0rxA0Z
 /iiIXV0bglP+BJEFD+9TgVrNOzkTOFy11obnmqA2twAfmqcAhx
 VtofyH7Ig9XQbD7Kz9eewyVe6k1g0t2OvpWqJsFr/zXNy6xrF4
 qFbJCoO91tUxsFObRwGvKXYsaeUwrfrmxrQoKYXpWy7wGtgmqW
 aBWh3FD9buxraJKSfoJRaXBbUFiN2XFn9uKtoS/9o0wemG4GM8
 gs3rXNAgiTYXzl4LQ5MJmW15lunbocUEGVLN3hurgPG4TFkUQR
 oM7E6p0g9qxDvJHnKlxNvsm6xS2/6KDb+F0iyKWs6dP+9QdRXj
 wZQKYr7HkbDl+8/r/0cc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 07 March 2014, Santosh Shilimkar wrote:
> >> +
> >> +       ret = dma_set_mask(dev, dma_mask);
> >> +       if (ret < 0) {
> >> +               dev_err(dev, "failed to set DMA mask %pad\n", &dma_mask);
> >> +               dev->dma_mask = NULL;
> >> +               return;
> >> +       }
> >> +
> >> +       dev_dbg(dev, "dma_pfn_offset(%#08lx) dma_mask(%pad)\n",
> >> +               dev->dma_pfn_offset, dev->dma_mask);
> >> +
> >> +       ret = dma_set_coherent_mask(dev, dma_mask);
> > 
> > I think these 2 calls belong in the drivers, not here.
> > 
> I also had same initial thought but Arnd mentioned that its a
> shared responsibility between ARCH and drivers. Driver which
> could be common between arches not always have the correct
> mask information and it can change based on which arch it
> is running.
> 
> With some discussion back and forth, we thought updating
> the dma_mask while the device getting created, would be
> better place since we can find the arch capability at
> this centralise code and update it.
> 
> Ofcourse its bit debatable as the question you asked is
> bit obvious as well. I let Arnd give his view here.

If we set the mask *here*, we probably don't want to call 'dma_set_mask', but
write to the mask directly, or we could call dma_coerce_mask_and_coherent(),
which is really for overriding the mask pointer and value at once in cases
where you absolutely know what it should be.

We do need to decide what interface we want to use in platform device drivers,
and I'm hoping that Russell has some idea which one he prefers:

a) Follow what we do for PCI devices: assume that we can do DMA_MASK(32)
on any device, and have drivers call dma_set_mask(DMA_MASK(64)) on devices
that would like to do more than that, or call e.g. dma_set_mask(DMA_MASK(28))
for devices that can do less than 32 bit, as given in the argument. This
approach would be most consistent with the way PCI works, but it doesn't
really work well for the case where the mask is less than 32-bit and the
device driver doesn't know that.

b) Never have to call dma_set_mask() for platform devices and assume that the
platform code sets it up correctly. This would probably be the simpler
solution, and I can't think of any downsides at the moment.

In either case we probably want to call something like dt_dma_configure()
from dma_set_mask() again to make sure that we stay within the limits
imposed by the bus structure.

	Arnd

