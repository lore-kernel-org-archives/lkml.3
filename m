Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757359Ab3BFRTu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 12:19:50 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:61480 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752024Ab3BFRTt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 12:19:49 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Takashi Iwai <tiwai@suse.de>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>, axboe@kernel.dk, cbou@mail.ru,
        davem@davemloft.net, dtor@mail.ru, dwmw2@infradead.org,
        grant.likely@secretlab.ca, gregkh@linuxfoundation.org, jkosina@suse.cz,
        jslaby@suse.cz, khali@linux-fr.org, mchehab@redhat.com, perex@perex.cz,
        sameo@linux.intel.com, w.sang@pengutronix.de,
        linux-kernel@vger.kernel.org, sebott@linux.vnet.ibm.com,
        gerald.schaefer@de.ibm.com, schwidefsky@de.ibm.com
Subject: Re: [PATCH 12/15] sound: add missing HAS_IOPORT and GENERIC_HARDIRQS dependencies
Date: Thu, 07 Feb 2013 02:13:19 +0100
Message-ID: <3907394.lhaMMhFrPm@wuerfel>
User-Agent: KMail/4.10 rc3 (Linux/3.8.0-3-generic; KDE/4.9.98; x86_64; ; )
In-Reply-To: <s5hpq0d74qd.wl%tiwai@suse.de>
References: <1360167843-3587-1-git-send-email-heiko.carstens@de.ibm.com> <1360167843-3587-13-git-send-email-heiko.carstens@de.ibm.com> <s5hpq0d74qd.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
X-Provags-ID: V02:K0:01rDzXZNZ2rs1SKWBH7w/BUn/SbDPrhWtR/3RAIQW9E
 eePERcbuHRR4KVvJdw2nHAObRv3kLbVbgwX3Ljzb2ZqZolVgmc
 HWmXpquDb6fhV5uKYISdYQ9xXIkxASQidC7iMTAt0aj5TtFDN0
 xZt5QlN9fn/KpvJDoToLaAFR+t/dqNabYhXno1sSlMsrJmAnyr
 eW+gDYsNqdc35uC5ekfget7vXPpa+GjjyLQkgX0RXRZI1ch5qR
 wPG4hOu+y0BPUIKTMLQYcLj/ov69kZsiPnrQWiZJa5wNLYOnOK
 plNjxk3AGZxGpKMLwyxG5zGRU3wQbkCCNofb4liQDo/meMKGAX
 fJIR7s9mDNfCHSgSkM3A=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 06 February 2013 18:05:14 Takashi Iwai wrote:
> At Wed,  6 Feb 2013 17:24:00 +0100,
> Heiko Carstens wrote:
> > 
> > Fix these two compile errors on s390 which does not have HAS_IOPORT
> > nor GENERIC_HARDIRQS:
> > 
> > sound/pci/lx6464es/lx6464es.c: In function ‘snd_lx6464es_free’:
> > sound/pci/lx6464es/lx6464es.c:565:2: error: implicit declaration of function ‘ioport_unmap’
> 
> Shouldn't this be fixed rather in asm-generic/io.h?
> Something like,
> 
> #if defined(CONFIG_HAS_IOPORT) && defined(CONFIG_GENERIC_IOMAP)
> extern void __iomem *ioport_map(unsigned long port, unsigned int nr);
> extern void ioport_unmap(void __iomem *p);
> #else
> static inline void __iomem *ioport_map(unsigned long port, unsigned int nr)
> {
> 	return (void __iomem *) port;
> }
> 
> static inline void ioport_unmap(void __iomem *p)
> {
> }
> #endif /* CONFIG_HAS_IOPORT */

No, it is intentional that the CONFIG_HAS_IOPORT symbol refers to
the fact that you can use the ioport_map function, in order to
disallow building drivers that depend on this function when it
is unavailable. I actually want to change this, but in the opposite
way of what you are proposing:

I think CONFIG_HAS_IOPORT should refer to the fact that the
inb/outb family of functions are usuable and be unset when
they are not provided, and I would introduce a new
CONFIG_HAS_IOPORT_MAP symbol for those (few) platforms that
have a working inb/outb but no ioport_map.

> > sound/soc/codecs/wm8903.c: In function ‘wm8903_set_pdata_irq_trigger’:
> > sound/soc/codecs/wm8903.c:1954:9: error: implicit declaration of function ‘irq_get_irq_data’
> 
> Ditto, how about defining
> 
> #ifndef CONFIG_GENERIC_HARDIRQS
> #define irq_get_irq_data(x)  NULL
> #endif
> 
> somewhere appropriately?
> 

Why not just make CONFIG_GENERIC_HARDIRQS mandatory for all
platforms. It is use almost everywhere now.

	Arnd
