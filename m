Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754424Ab3I0ToE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 15:44:04 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:51643 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753421Ab3I0ToA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 15:44:00 -0400
Date: Fri, 27 Sep 2013 15:41:44 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Joerg Roedel <joro@8bytes.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Subject: Re: [PATCH] iommu: Remove stack trace from broken irq remapping
 warning
Message-ID: <20130927194144.GA2375@hmsreliant.think-freely.org>
References: <1380300815-1864-1-git-send-email-nhorman@tuxdriver.com>
 <CALCETrVB-rUds-u1sdXeUwgJtnTV0pFpaeZiDMKv96-uZ8uqSg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrVB-rUds-u1sdXeUwgJtnTV0pFpaeZiDMKv96-uZ8uqSg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Score: -2.9 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 27, 2013 at 12:24:10PM -0700, Andy Lutomirski wrote:
> On Fri, Sep 27, 2013 at 9:53 AM, Neil Horman <nhorman@tuxdriver.com> wrote:
> > The warning for the irq remapping broken check in intel_irq_remapping.c is
> > pretty pointless.  We need the warning, but we know where its comming from, the
> > stack trace will always be the same, and it needlessly triggers things like
> > Abrt.  This changes the warning to just print a text warning about BIOS being
> > broken, without the stack trace, then sets the appropriate taint bit.  Since we
> > automatically disable irq remapping, theres no need to contiue making Abrt jump
> > at this problem
> >
> > Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
> > CC: Joerg Roedel <joro@8bytes.org>
> > CC: Bjorn Helgaas <bhelgaas@google.com>
> > CC: Andy Lutomirski <luto@amacapital.net>
> > CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> > CC: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
> > ---
> >  drivers/iommu/intel_irq_remapping.c | 13 +++++++------
> >  1 file changed, 7 insertions(+), 6 deletions(-)
> >
> > diff --git a/drivers/iommu/intel_irq_remapping.c b/drivers/iommu/intel_irq_remapping.c
> > index f71673d..b97d70b 100644
> > --- a/drivers/iommu/intel_irq_remapping.c
> > +++ b/drivers/iommu/intel_irq_remapping.c
> > @@ -525,12 +525,13 @@ static int __init intel_irq_remapping_supported(void)
> >         if (disable_irq_remap)
> >                 return 0;
> >         if (irq_remap_broken) {
> > -               WARN_TAINT(1, TAINT_FIRMWARE_WORKAROUND,
> > -                          "This system BIOS has enabled interrupt remapping\n"
> > -                          "on a chipset that contains an erratum making that\n"
> > -                          "feature unstable.  To maintain system stability\n"
> > -                          "interrupt remapping is being disabled.  Please\n"
> > -                          "contact your BIOS vendor for an update\n");
> > +               printk(KERN_WARNING
> > +                       "This system BIOS has enabled interrupt remapping\n"
> > +                       "on a chipset that contains an erratum making that\n"
> > +                       "feature unstable.  To maintain system stability\n"
> > +                       "interrupt remapping is being disabled.  Please\n"
> > +                       "contact your BIOS vendor for an update\n");
> > +               add_taint(TAINT_FIRMWARE_WORKAROUND, LOCKDEP_STILL_OK);
> 
> Is the taint bit actually useful?  It seems like functionality will be
> missing if this workaround happens, but everything should be stable.
> 
I think its useful yes.  The system will be stable, an in fact should run
exactly as it did before, but since the errata indicates this should be fixed in
BIOS, its a reminder to the admin that you should investigate an update, or take
action in manually disabling iommu on the command line

Its also in keeping with the way this was structured previously.
Neil

> --Andy
> 
