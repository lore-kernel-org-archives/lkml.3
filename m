Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753864Ab3CKQnQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 12:43:16 -0400
Received: from mga09.intel.com ([134.134.136.24]:45187 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751868Ab3CKQnP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 12:43:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,824,1355126400"; 
   d="scan'208";a="276521500"
Message-ID: <1363020239.3348.56.camel@sauron.fi.intel.com>
Subject: Re: Dead mappings and drivers in MTD
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Olof Johansson <olof@lixom.net>
Cc: linux-mtd@lists.infradead.org, linux-arm-kernel@lists.infradead.org,
        LKML <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org,
        linux-m68k@vger.kernel.org, linux-pcmcia@lists.infradead.org
Date: Mon, 11 Mar 2013 18:43:59 +0200
In-Reply-To: <CAOesGMhy6YceRr3T4ZALhYeSQfEuASO+ajJy1Htwws=OMtvrTg@mail.gmail.com>
References: <1363016099.3348.47.camel@sauron.fi.intel.com>
	 <CAOesGMhy6YceRr3T4ZALhYeSQfEuASO+ajJy1Htwws=OMtvrTg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3 (3.6.3-2.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-03-11 at 09:20 -0700, Olof Johansson wrote:
> On Mon, Mar 11, 2013 at 8:34 AM, Artem Bityutskiy <dedekind1@gmail.com> wrote:
> > Hi MTD folks,
> >
> > we have huge amount of drivers, espacially mapping drives in
> > 'drivers/mtd', and for sure may of them are for ancient devices which
> > are long dead and not supported by modern kernels anyway. I would like
> > to do a small clean-up. It is difficult to judge which ones are dead for
> > me, so I am asking the community to help. Thanks!
> >
> > There are few easy cases - some drivers depend on Kconfig symbols which
> > are not defined anywhere - I guess these are clear candidates for
> > removal. For example this one:
> >
> > config MTD_DBOX2
> >         tristate "CFI Flash device mapped on D-Box2"
> >         depends on DBOX2 && MTD_CFI_INTELSTD && MTD_CFI_INTELEXT && MTD_CFI_AMDSTD
> >         help
> >           This enables access routines for the flash chips on the Nokia/Sagem
> >           D-Box 2 board. If you have one of these boards and would like to use
> >
> > Grepping for "DBOX2" gives nothing.
> 
> In 2.6.14, it dropped two dependencies that used to be there for PPC32
> and 8xx. There still was no DBOX2 symbol to fulfill that dependency
> back then.
> 
> Take it out, if someone finds a user later on it can always be
> reverted. Seems very very unlikely in this case.

I agree, thanks. I've quickly went through all the MTD map drivers and
found many candidates for removal. I did not prepare a patch-set yet,
but the below commit messages from my tree should give enough info about
what I am thinking to remove.

Author: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Date:   Mon Mar 11 18:24:37 2013 +0200

    mtd: remove the mbx860 map driver
    
    This driver depends on CONFIG_MBX which is not defined anywhere, which means
    this driver is dead.
    
    Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

 drivers/mtd/maps/Kconfig   |    9 --
 drivers/mtd/maps/Makefile  |    1 -
 drivers/mtd/maps/ixp2000.c |  253 --------------------------------------------
 3 files changed, 263 deletions(-)

commit 3e8b189c4fad6196333fb2069ab1f183b652a81d
Author: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Date:   Mon Mar 11 18:10:06 2013 +0200

    mtd: remove the dilnetpc map driver support
    
    This driver is marked as broken for very long time. Most probably this board is
    just something ancient no one cares about anyway.
    
    Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

 drivers/mtd/maps/Kconfig    |   16 --
 drivers/mtd/maps/Makefile   |    1 -
 drivers/mtd/maps/dilnetpc.c |  496 -------------------------------------------
 3 files changed, 513 deletions(-)

commit e9313043d5bb4b2429b60092ebd9974598b5b62d
Author: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Date:   Mon Mar 11 18:07:35 2013 +0200

    mtd: remove the tqm8xxl map driver
    
    This driver depends on the CONFIG_TQM8xxL symbol, which is not defined
    anywhere, which means that this driver is dead.
    
    Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

 drivers/mtd/maps/Kconfig   |   10 --
 drivers/mtd/maps/Makefile  |    1 -
 drivers/mtd/maps/tqm8xxl.c |  249 --------------------------------------------
 3 files changed, 260 deletions(-)

commit 1b17ddb0219d9ab6b96a2bc22331d89ac4ca4539
Author: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Date:   Mon Mar 11 18:05:13 2013 +0200

    pcmcia: remove RPX board stuff
    
    The RPX board is not supported by the kernel because CONFIG_RPXCLASSIC and
    CONFIG_RPXLITE symbols and not defined anywhere. Clean-up the m8xx_pcmcia
    driver a little bit.
    
    Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

 drivers/pcmcia/m8xx_pcmcia.c |   81 ------------------------------------------
 1 file changed, 81 deletions(-)

commit 518fa5d9718cbe00ed3de3798761cc051dcef04b
Author: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Date:   Mon Mar 11 18:03:11 2013 +0200

    m68k: remove rpxlite stuff
    
    The CONFIG_RPXLITE is not defined anywhere, which means that this board is not
    supported anyway, and we can clean-up commproc.h a little.
    
    Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

 arch/m68k/include/asm/commproc.h |   17 -----------------
 1 file changed, 17 deletions(-)

commit de70cc56d0c067275c3cac5659196d9ef4043888
Author: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Date:   Mon Mar 11 18:01:02 2013 +0200

    mtd: maps: kill the rpxlite map driver
    
    This driver depends on the CONFIG_RPXCLASSIC and CONFIG_RPXLITE symbols, which
    are not defined anywhere, and this means that this driver is dead.
    
    Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

 drivers/mtd/maps/Kconfig   |   10 -------
 drivers/mtd/maps/Makefile  |    1 -
 drivers/mtd/maps/rpxlite.c |   64 --------------------------------------------
 3 files changed, 75 deletions(-)

commit 1ebbc11e1e2a143308689af47bb766824c035285
Author: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Date:   Mon Mar 11 17:56:31 2013 +0200

    pcmcia: remove Motorolla MBX860 support
    
    The CONFIG_MBX symbol is not defined anywhere in the kernel tree, which means
    this platform is not supported by the Linux kernel and we can remove the
    corresponding code from the 'm8xx_pcmcia' driver.
    
    Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

 drivers/pcmcia/m8xx_pcmcia.c |   59 ------------------------------------------
 1 file changed, 59 deletions(-)

commit 61f417243e1157d436ac04b1307f40b2996a4923
Author: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Date:   Mon Mar 11 17:54:11 2013 +0200

    mtd: remove the mbx860 map driver
    
    This driver depends on CONFIG_MBX which is not defined anywhere, which means
    this driver is dead.
    
    Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

 drivers/mtd/maps/Kconfig  |    8 ----
 drivers/mtd/maps/Makefile |    1 -
 drivers/mtd/maps/mbx860.c |   98 ---------------------------------------------
 3 files changed, 107 deletions(-)

commit 55c159005c92a7ce8234c6d0072d8d2f6e45a57d
Author: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Date:   Mon Mar 11 17:42:54 2013 +0200

    mtd: remove the dmv182 map driver
    
    This driver depends on the CONFIG_DMV182 symbol which is not defined anywhere,
    and this means that this driver is dead.
    
    Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

 drivers/mtd/maps/Kconfig  |    9 ---
 drivers/mtd/maps/Makefile |    1 -
 drivers/mtd/maps/dmv182.c |  146 ---------------------------------------------
 3 files changed, 156 deletions(-)

commit 750b26e3b17a148a7a7d64026088d1e29f9cd118
Author: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Date:   Mon Mar 11 17:38:43 2013 +0200

    mtd: remove the dbox2-flash map driver
    
    This driver depends on the CONFIG_DBOX2 symbol which does not exist in
    the kernel, which means the driver is dead.
    
    Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

 drivers/mtd/maps/Kconfig       |    8 ---
 drivers/mtd/maps/Makefile      |    1 -
 drivers/mtd/maps/dbox2-flash.c |  123 ----------------------------------------
 3 files changed, 132 deletions(-)


-- 
Best Regards,
Artem Bityutskiy

