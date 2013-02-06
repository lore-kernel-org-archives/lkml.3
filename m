Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757356Ab3BFSMv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 13:12:51 -0500
Received: from e06smtp17.uk.ibm.com ([195.75.94.113]:53149 "EHLO
	e06smtp17.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754059Ab3BFSMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 13:12:49 -0500
Date: Wed, 6 Feb 2013 19:12:42 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Arnd Bergmann <arnd@arndb.de>, axboe@kernel.dk, cbou@mail.ru,
        davem@davemloft.net, dtor@mail.ru, dwmw2@infradead.org,
        grant.likely@secretlab.ca, gregkh@linuxfoundation.org, jkosina@suse.cz,
        jslaby@suse.cz, khali@linux-fr.org, mchehab@redhat.com, perex@perex.cz,
        sameo@linux.intel.com, w.sang@pengutronix.de,
        linux-kernel@vger.kernel.org, sebott@linux.vnet.ibm.com,
        gerald.schaefer@de.ibm.com, schwidefsky@de.ibm.com
Subject: Re: [PATCH 12/15] sound: add missing HAS_IOPORT and GENERIC_HARDIRQS
 dependencies
Message-ID: <20130206181242.GA3281@osiris>
References: <1360167843-3587-1-git-send-email-heiko.carstens@de.ibm.com>
 <1360167843-3587-13-git-send-email-heiko.carstens@de.ibm.com>
 <s5hpq0d74qd.wl%tiwai@suse.de>
 <3907394.lhaMMhFrPm@wuerfel>
 <s5hmwvh73rp.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <s5hmwvh73rp.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 13020618-0542-0000-0000-000004562375
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 06, 2013 at 06:26:02PM +0100, Takashi Iwai wrote:
> At Thu, 07 Feb 2013 02:13:19 +0100,
> Arnd Bergmann wrote:
> > On Wednesday 06 February 2013 18:05:14 Takashi Iwai wrote:
> > > At Wed,  6 Feb 2013 17:24:00 +0100,
> > > Heiko Carstens wrote:
> > > #if defined(CONFIG_HAS_IOPORT) && defined(CONFIG_GENERIC_IOMAP)
> > > extern void __iomem *ioport_map(unsigned long port, unsigned int nr);
> > > extern void ioport_unmap(void __iomem *p);
> > > #else
> > > static inline void __iomem *ioport_map(unsigned long port, unsigned int nr)
> > > {
> > > 	return (void __iomem *) port;
> > > }
> > > 
> > > static inline void ioport_unmap(void __iomem *p)
> > > {
> > > }
> > > #endif /* CONFIG_HAS_IOPORT */
> > 
> > No, it is intentional that the CONFIG_HAS_IOPORT symbol refers to
> > the fact that you can use the ioport_map function, in order to
> > disallow building drivers that depend on this function when it
> > is unavailable. I actually want to change this, but in the opposite
> > way of what you are proposing:
> > 
> > I think CONFIG_HAS_IOPORT should refer to the fact that the
> > inb/outb family of functions are usuable and be unset when
> > they are not provided, and I would introduce a new
> > CONFIG_HAS_IOPORT_MAP symbol for those (few) platforms that
> > have a working inb/outb but no ioport_map.
> 
> Yet another Kconfig, but sounds reasonable :)

Right... I just wanted to make s390 compile with the Kconfig methods we use
since nearly a decade and not change the world ;)

> > > > sound/soc/codecs/wm8903.c: In function ‘wm8903_set_pdata_irq_trigger’:
> > > > sound/soc/codecs/wm8903.c:1954:9: error: implicit declaration of function ‘irq_get_irq_data’
> > > 
> > > Ditto, how about defining
> > > 
> > > #ifndef CONFIG_GENERIC_HARDIRQS
> > > #define irq_get_irq_data(x)  NULL
> > > #endif
> > > 
> > > somewhere appropriately?
> > > 
> > 
> > Why not just make CONFIG_GENERIC_HARDIRQS mandatory for all
> > platforms. It is use almost everywhere now.
> 
> I wonder it, too...

I haven't looked into it, but I doubt if that is possible without large
effort, if at all. s390 doesn't have any irq chips, nor something like
edge or level triggered irqs.
Instead we have floating interrupts. Does that fit into the concept of
GENERIC_HARDIRQS at all?
If so, we can give it a try, sure. But that won't happen any time soon.

Or are you simply proposing we should have both, our own irq handling plus
GENERIC_HARDIRQS with dummy functions?

