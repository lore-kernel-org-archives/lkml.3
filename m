Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751866AbaAGNbb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 08:31:31 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:27313 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751106AbaAGNbU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 08:31:20 -0500
X-IronPort-AV: E=Sophos;i="4.95,618,1384300800"; 
   d="scan'208";a="88268192"
Date: Tue, 7 Jan 2014 13:30:10 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Yinghai Lu <yinghai@kernel.org>
CC: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Xen Devel <xen-devel@lists.xensource.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH v5 16/33] xen, irq: Call irq_alloc_reserved_desc_at()
 at first
In-Reply-To: <CAE9FiQVba9K_3LDkHTP4YZJ-FzwE_mF3h6iiXEFb1shUUmhGpg@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1401071327510.8667@kaball.uk.xensource.com>
References: <1388707565-16535-1-git-send-email-yinghai@kernel.org> <1388707565-16535-17-git-send-email-yinghai@kernel.org> <alpine.DEB.2.02.1401031749340.8667@kaball.uk.xensource.com> <CAE9FiQVba9K_3LDkHTP4YZJ-FzwE_mF3h6iiXEFb1shUUmhGpg@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Jan 2014, Yinghai Lu wrote:
> On Fri, Jan 3, 2014 at 9:50 AM, Stefano Stabellini
> <stefano.stabellini@eu.citrix.com> wrote:
> 
> >>  drivers/xen/events.c | 8 ++++++--
> >>  1 file changed, 6 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/drivers/xen/events.c b/drivers/xen/events.c
> >> index 4035e83..020cd77 100644
> >> --- a/drivers/xen/events.c
> >> +++ b/drivers/xen/events.c
> >> @@ -508,8 +508,12 @@ static int __must_check xen_allocate_irq_gsi(unsigned gsi)
> >>       /* Legacy IRQ descriptors are already allocated by the arch. */
> >>       if (gsi < NR_IRQS_LEGACY)
> >>               irq = gsi;
> >> -     else
> >> -             irq = irq_alloc_desc_at(gsi, -1);
> >> +     else {
> >> +             /* for x86, irq already get reserved for gsi */
> >> +             irq = irq_alloc_reserved_desc_at(gsi, -1);
> >> +             if (irq < 0)
> >> +                     irq = irq_alloc_desc_at(gsi, -1);
> >> +     }
> >
> > This is common code. On ARM I get:
> >
> > drivers/xen/events.c: In function 'xen_allocate_irq_gsi':
> > drivers/xen/events.c:513:3: error: implicit declaration of function 'irq_alloc_reserved_desc_at' [-Werror=implicit-function-declaration]
> >    irq = irq_alloc_reserved_desc_at(gsi, -1);
> >    ^
> > cc1: some warnings being treated as errors
> 
> It's strange.
> 
> that is defined with irq_alloc_desc_at in parallel in
> include/linux/irq.h and kernel/irq/irqdesc.c.
> 
> Did you try the whole tree, or just this patch?

Just this patch.
The whole tree (yinghai/for-x86-irq-3.14) builds just fine.
Thanks!

- Stefano
