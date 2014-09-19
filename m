Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932394AbaISSax (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 14:30:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37005 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932069AbaISSav (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 14:30:51 -0400
Date: Fri, 19 Sep 2014 19:39:51 +0100
From: Alexander Gordeev <agordeev@redhat.com>
To: Dan Williams <dan.j.williams@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        IDE/ATA development list <linux-ide@vger.kernel.org>,
        "Jiang, Dave" <dave.jiang@intel.com>
Subject: Re: [PATCH v3 6/5] AHCI: Do not read HOST_IRQ_STAT register in
 multi-MSI mode
Message-ID: <20140919183950.GJ8793@agordeev.usersys.redhat.com>
References: <cover.1411031922.git.agordeev@redhat.com>
 <20140919082552.GH8793@agordeev.usersys.redhat.com>
 <CAA9_cmcpKRczsosw7odOC-a4-xRM6E5QrkQoxPrBBFybzcKZbg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAA9_cmcpKRczsosw7odOC-a4-xRM6E5QrkQoxPrBBFybzcKZbg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 19, 2014 at 09:34:34AM -0700, Dan Williams wrote:
> On Fri, Sep 19, 2014 at 1:25 AM, Alexander Gordeev <agordeev@redhat.com> wrote:
> > As described in AHCI v1.0 specification chapter 10.6.2.2
> > "Multiple MSI Based Messages" generation of interrupts
> > is not controlled through the HOST_IRQ_STAT register.
> >
> > Considering MMIO access is expensive remove unnecessary
> > reading and writing of HOST_IRQ_STAT register.
> >
> > Further, serializing access to the host data is no longer
> > needed and the interrupt service routine can avoid competing
> > on the host lock.
> >
> > Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
> > Suggested-by: "Jiang, Dave" <dave.jiang@intel.com>
> > Cc: linux-ide@vger.kernel.org
> > ---
> >  drivers/ata/ahci.h    |  1 +
> >  drivers/ata/libahci.c | 54 ++++++++-------------------------------------------
> >  2 files changed, 9 insertions(+), 46 deletions(-)
> >
> > diff --git a/drivers/ata/ahci.h b/drivers/ata/ahci.h
> > index c12f590..b8e117a 100644
> > --- a/drivers/ata/ahci.h
> > +++ b/drivers/ata/ahci.h
> > @@ -305,6 +305,7 @@ struct ahci_port_priv {
> >         unsigned int            ncq_saw_dmas:1;
> >         unsigned int            ncq_saw_sdb:1;
> >         u32                     intr_status;    /* interrupts to handle */
> > +       spinlock_t              intr_lock;      /* protects intr_status */
> 
> Why introduce a new lock?  Can't we switch to per-ata port locking
> rather than ata_host locking?

We could. But this case hardware context interrupt handler would compete
with threads/softriqs, which is exactly what I tried to avoid. With the
separate lock we *only* update ahci_port_priv::intr_status with interrupts
disabled.

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
