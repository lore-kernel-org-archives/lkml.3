Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758539Ab3BFV6I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 16:58:08 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:49892 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755489Ab3BFV6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 16:58:05 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [PATCH 12/15] sound: add missing HAS_IOPORT and GENERIC_HARDIRQS dependencies
Date: Wed, 6 Feb 2013 21:56:55 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-4-generic; KDE/4.3.2; x86_64; ; )
Cc: Takashi Iwai <tiwai@suse.de>, axboe@kernel.dk, cbou@mail.ru,
        davem@davemloft.net, dtor@mail.ru, dwmw2@infradead.org,
        grant.likely@secretlab.ca, gregkh@linuxfoundation.org, jkosina@suse.cz,
        jslaby@suse.cz, khali@linux-fr.org, mchehab@redhat.com, perex@perex.cz,
        sameo@linux.intel.com, w.sang@pengutronix.de,
        linux-kernel@vger.kernel.org, sebott@linux.vnet.ibm.com,
        gerald.schaefer@de.ibm.com, schwidefsky@de.ibm.com
References: <1360167843-3587-1-git-send-email-heiko.carstens@de.ibm.com> <s5hmwvh73rp.wl%tiwai@suse.de> <20130206181242.GA3281@osiris>
In-Reply-To: <20130206181242.GA3281@osiris>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201302062156.55910.arnd@arndb.de>
X-Provags-ID: V02:K0:XaWIevJgCK3iIuntC06M6ac3dxpI+JGSt20FtD0GAjL
 QJgNlbjx1W6W2IIzgHzOijXyYbOYcxGbLOZRvPb7hiRagTg92z
 VsJ0npJkXwdfhHSbqd+StfhKf4OD9H7TLVEUBdYYSY+7lMVoTJ
 uciF41IVGWvezspzW/As0RNIo1GnIDCHY4qaDqntB/kzrAcUXA
 yP/ZswbROwIu5Y8dOIw+KqbxW9ZK+yjOphN+YhtGpwOjBGXsUQ
 MxAnTJadwXriGp7uF3YGN3n4ueD75VH/stKkRzZ3qeHIdarwfL
 P8HwStHnnwibrxDpCm1rF10f0VdmDuqR2BNpfvfNEAjSthvHSW
 y5n3d1Eega91IpoKDjtw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 06 February 2013, Heiko Carstens wrote:
> On Wed, Feb 06, 2013 at 06:26:02PM +0100, Takashi Iwai wrote:
> > At Thu, 07 Feb 2013 02:13:19 +0100,
> > Arnd Bergmann wrote:
> > > No, it is intentional that the CONFIG_HAS_IOPORT symbol refers to
> > > the fact that you can use the ioport_map function, in order to
> > > disallow building drivers that depend on this function when it
> > > is unavailable. I actually want to change this, but in the opposite
> > > way of what you are proposing:
> > > 
> > > I think CONFIG_HAS_IOPORT should refer to the fact that the
> > > inb/outb family of functions are usuable and be unset when
> > > they are not provided, and I would introduce a new
> > > CONFIG_HAS_IOPORT_MAP symbol for those (few) platforms that
> > > have a working inb/outb but no ioport_map.
> > 
> > Yet another Kconfig, but sounds reasonable :)
> 
> Right... I just wanted to make s390 compile with the Kconfig methods we use
> since nearly a decade and not change the world ;)

Your patch looks fine here, I was just mentioning that this is going to
change. After my patch, things will be different for s390 as well, because
it presumably won't provide the inb/outb accessors any more then
and not set the (new) CONFIG_HAS_IOPORT.

> > > 
> > > Why not just make CONFIG_GENERIC_HARDIRQS mandatory for all
> > > platforms. It is use almost everywhere now.
> > 
> > I wonder it, too...
> 
> I haven't looked into it, but I doubt if that is possible without large
> effort, if at all. s390 doesn't have any irq chips, nor something like
> edge or level triggered irqs.
> Instead we have floating interrupts. Does that fit into the concept of
> GENERIC_HARDIRQS at all?
> If so, we can give it a try, sure. But that won't happen any time soon.
> 
> Or are you simply proposing we should have both, our own irq handling plus
> GENERIC_HARDIRQS with dummy functions?

I think you should use GENERIC_HARDIRQ just for PCI, and rename the s390
interrupt handling to something that does not conflict. I understand
that the concepts are quite different, but with PCI support, you actually
do get all the weird interrupt hardware.
More importantly, some features provided by GENERIC_HARDIRQ are replacing
the traditional interfaces now, e.g. devm_request_irq() is actually
recommended over request_irq() for normal drivers these days, as it
simplifies the error handling.

	Arnd
