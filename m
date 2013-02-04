Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755865Ab3BDTkA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 14:40:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42588 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755056Ab3BDTj7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 14:39:59 -0500
Message-ID: <1360006795.11144.529.camel@bling.home>
Subject: Re: [PATCH] intel_irq_remapping: Clean up x2apic optout security
 warning mess
From: Alex Williamson <alex.williamson@redhat.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Gleb Natapov <gleb@redhat.com>, Don Zickus <dzickus@redhat.com>,
        x86@kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Prarit Bhargava <prarit@redhat.com>
Date: Mon, 04 Feb 2013 12:39:55 -0700
In-Reply-To: <CALCETrVv0NXQACT=nrRZfN+9JbRmGKZWZvP7wWDveBtJt7E8zQ@mail.gmail.com>
References: <510C3AF0.6050109@amacapital.net>
	 <2011b943a886fd7c46079eb10bc24fc130587503.1359759303.git.luto@amacapital.net>
	 <1360004651.11144.511.camel@bling.home>
	 <CALCETrVv0NXQACT=nrRZfN+9JbRmGKZWZvP7wWDveBtJt7E8zQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-02-04 at 11:19 -0800, Andy Lutomirski wrote:
> On Mon, Feb 4, 2013 at 11:04 AM, Alex Williamson
> <alex.williamson@redhat.com> wrote:
> > On Fri, 2013-02-01 at 14:57 -0800, Andy Lutomirski wrote:
> >> Current kernels print this on my Dell server:
> >>
> >>    ------------[ cut here ]------------
> >>    WARNING: at drivers/iommu/intel_irq_remapping.c:542
> >>    intel_enable_irq_remapping+0x7b/0x27e()
> >>    Hardware name: PowerEdge R620
> >>    Your BIOS is broken and requested that x2apic be disabled
> >>    This will leave your machine vulnerable to irq-injection attacks
> >>    Use 'intremap=no_x2apic_optout' to override BIOS request
> >>    [...]
> >>    Enabled IRQ remapping in xapic mode
> >>    x2apic not enabled, IRQ remapping is in xapic mode
> >>
> >> This is inconsistent with itself -- interrupt remapping is *on*.
> >>
> >> Fix the mess by making the warnings say what they mean and my making
> >> sure that compatibility format interrupts (the dangerous ones) are
> >> disabled if x2apic is present regardless of BIOS settings.
> >>
> >> With this patch applied, the output is:
> >>
> >>   Your BIOS is broken and requested that x2apic be disabled.
> >>   This will slightly decrease performance.
> >>   Use 'intremap=no_x2apic_optout' to override BIOS request.
> >>   Enabled IRQ remapping in xapic mode
> >>   x2apic not enabled, IRQ remapping is in xapic mode
> >>
> >> This should make us as or more secure than we are now and replace
> >> a rather scary warning with a much less scary warning on silly
> >> but functional systems.
> >>
> >> Signed-off-by: Andy Lutomirski <luto@amacapital.net>
> >> ---
> >>  drivers/iommu/intel_irq_remapping.c | 36 ++++++++++++++++++++++++++++--------
> >>  1 file changed, 28 insertions(+), 8 deletions(-)
> >>
> >> diff --git a/drivers/iommu/intel_irq_remapping.c b/drivers/iommu/intel_irq_remapping.c
> >> index af8904d..eca8832 100644
> >> --- a/drivers/iommu/intel_irq_remapping.c
> >> +++ b/drivers/iommu/intel_irq_remapping.c
> >> @@ -425,11 +425,22 @@ static void iommu_set_irq_remapping(struct intel_iommu *iommu, int mode)
> >>
> >>       /* Enable interrupt-remapping */
> >>       iommu->gcmd |= DMA_GCMD_IRE;
> >> +     iommu->gcmd &= ~DMA_GCMD_CFI;  /* Block compatibility-format MSIs */
> >>       writel(iommu->gcmd, iommu->reg + DMAR_GCMD_REG);
> >>
> >>       IOMMU_WAIT_OP(iommu, DMAR_GSTS_REG,
> >>                     readl, (sts & DMA_GSTS_IRES), sts);
> >>
> >> +     /*
> >> +      * With CFI clear in the Global Command register, we should be
> >> +      * protected from dangerous (i.e. compatibility) interrupts
> >> +      * regardless of x2apic status.  Check just to be sure.
> >> +      */
> >> +     if (sts & DMA_GSTS_CFIS)
> >> +             WARN(1, KERN_WARNING
> >> +                     "Compatibility-format IRQs enabled despite intr remapping;\n"
> >> +                     "you are vulnerable to IRQ injection.\n");
> >> +
> >>       raw_spin_unlock_irqrestore(&iommu->register_lock, flags);
> >>  }
> >>
> >> @@ -526,20 +537,24 @@ static int __init intel_irq_remapping_supported(void)
> >>  static int __init intel_enable_irq_remapping(void)
> >>  {
> >>       struct dmar_drhd_unit *drhd;
> >> +     bool x2apic_present;
> >>       int setup = 0;
> >>       int eim = 0;
> >>
> >> +     x2apic_present = x2apic_supported();
> >> +
> >>       if (parse_ioapics_under_ir() != 1) {
> >>               printk(KERN_INFO "Not enable interrupt remapping\n");
> >> -             return -1;
> >> +             goto error;
> >>       }
> >>
> >> -     if (x2apic_supported()) {
> >> +     if (x2apic_present) {
> >>               eim = !dmar_x2apic_optout();
> >> -             WARN(!eim, KERN_WARNING
> >> -                        "Your BIOS is broken and requested that x2apic be disabled\n"
> >> -                        "This will leave your machine vulnerable to irq-injection attacks\n"
> >> -                        "Use 'intremap=no_x2apic_optout' to override BIOS request\n");
> >> +             if (!eim)
> >> +                     printk(KERN_WARNING
> >> +                             "Your BIOS is broken and requested that x2apic be disabled.\n"
> >> +                             "This will slightly decrease performance.\n"
> >> +                             "Use 'intremap=no_x2apic_optout' to override BIOS request.\n");
> >>       }
> >>
> >>       for_each_drhd_unit(drhd) {
> >> @@ -578,7 +593,7 @@ static int __init intel_enable_irq_remapping(void)
> >>               if (eim && !ecap_eim_support(iommu->ecap)) {
> >>                       printk(KERN_INFO "DRHD %Lx: EIM not supported by DRHD, "
> >>                              " ecap %Lx\n", drhd->reg_base_addr, iommu->ecap);
> >> -                     return -1;
> >> +                     goto error;
> >>               }
> >>       }
> >>
> >> @@ -594,7 +609,7 @@ static int __init intel_enable_irq_remapping(void)
> >>                       printk(KERN_ERR "DRHD %Lx: failed to enable queued, "
> >>                              " invalidation, ecap %Lx, ret %d\n",
> >>                              drhd->reg_base_addr, iommu->ecap, ret);
> >> -                     return -1;
> >> +                     goto error;
> >>               }
> >>       }
> >>
> >> @@ -625,6 +640,11 @@ error:
> >>       /*
> >>        * handle error condition gracefully here!
> >>        */
> >> +
> >> +     if (x2apic_present)
> >> +             WARN(1, KERN_WARNING
> >> +                     "Failed to enable irq remapping.  You are vulnerable to irq-injection attacks.\n");
> >
> > How so?  Without interrupt remapping, neither KVM assignment or vfio
> > work unless the user explicitly opts-in to insecure interrupts via
> > module options.  Are there other attack vectors?  Also, I really like
> > the code above that forces CFI clear, but I don't think that warning is
> > correct yet.  According to the paper the vulnerability is enabled if
> > both x2apic is not enabled and CFI is enabled.  When x2apic is enabled,
> > does it matter if CFI is enabled?  My understand is no.  Should a
> > warning only occur if the interrupt remapper is enabled and x2apic is
> > not enabled and we're not able to clear CFI?  Thanks,
> 
> That's x2apic *present*, not enabled.  The idea is that, on a system
> that has x2apic (which AFAIK is the same set of systems that support
> interrupt remapping)

I don't know that those are entirely overlapping sets.

> , then you expect interrupt remapping to work,
> whether in x2apic mode or xapic mode.  This warning should never
> trigger on any hardware I know of (which, admittedly, doesn't mean
> much).

Sure, you expect it to work, otherwise the interrupt remapping
supported() callback should have failed.  If we get here, regardless of
x2apic, we might want to print something about failing to enable it.

> I have no objection to rewording the warning, if you have any better
> ideas.  I guess the vfio code (and hence the kvm code?) is more
> careful than I realized.

As above, I think we're only vulnerable if we enable irq remapping,
disable x2apic, and can't disable CFI.  Even then, I'm not sure what
good it is to print scary warnings about vulnerabilities when the
majority of the user base isn't actually doing anything that makes them
vulnerable.

Should we even put the user in a state where they can be vulnerable?
Rather than print a warning we could disable interrupt remapping if
either x2apic isn't enabled or CFI cannot be disabled.  This could be
noted with a pr_info/pr_debug warning and enabled with an iommu= option.
Then, like doing device assignment w/o interrupt remapping, the user has
to opt-in for interrupt remapping that is vulnerable to MSI injection.
Thanks,

Alex

