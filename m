Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752668Ab3FFS6N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 14:58:13 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:47314 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751264Ab3FFS6M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 14:58:12 -0400
Date: Thu, 6 Jun 2013 14:58:00 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Jan Beulich <JBeulich@suse.com>
Cc: xen-devel <xen-devel@lists.xen.org>, linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] [PATCH 2/9] xen/smp: Introduce a common structure to
 contain the IRQ name and interrupt line.
Message-ID: <20130606185800.GB21538@konrad-lan.dumpdata.com>
References: <1370447678-22367-1-git-send-email-konrad.wilk@oracle.com>
 <1370447678-22367-3-git-send-email-konrad.wilk@oracle.com>
 <51B0537702000078000DBC74@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51B0537702000078000DBC74@nat28.tlf.novell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 06, 2013 at 08:16:39AM +0100, Jan Beulich wrote:
> >>> On 05.06.13 at 17:54, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> > This patch adds a new structure to contain the common two things
> > that each of the per-cpu interrupts need:
> >  - an interrupt number,
> >  - and the name of the interrupt (to be added in 'xen/smp: Don't leak
> >    interrupt name when offlining').
> > 
> > This allows us to carry the tuple of the per-cpu interrupt data structure
> > and expand it as we need in the future.
> > 
> > Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> > ---
> >  arch/x86/xen/smp.c | 44 ++++++++++++++++++++++++--------------------
> >  1 file changed, 24 insertions(+), 20 deletions(-)
> > 
> > diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
> > index 19fc9f3..f5b29ec 100644
> > --- a/arch/x86/xen/smp.c
> > +++ b/arch/x86/xen/smp.c
> > @@ -39,11 +39,15 @@
> >  
> >  cpumask_var_t xen_cpu_initialized_map;
> >  
> > -static DEFINE_PER_CPU(int, xen_resched_irq);
> > -static DEFINE_PER_CPU(int, xen_callfunc_irq);
> > -static DEFINE_PER_CPU(int, xen_callfuncsingle_irq);
> > -static DEFINE_PER_CPU(int, xen_irq_work);
> > -static DEFINE_PER_CPU(int, xen_debug_irq) = -1;
> > +struct xen_common_irq {
> > +	int irq;
> > +	char *name;
> > +};
> > +static DEFINE_PER_CPU(struct xen_common_irq, xen_resched_irq);
> > +static DEFINE_PER_CPU(struct xen_common_irq, xen_callfunc_irq);
> > +static DEFINE_PER_CPU(struct xen_common_irq, xen_callfuncsingle_irq);
> > +static DEFINE_PER_CPU(struct xen_common_irq, xen_irq_work);
> > +static DEFINE_PER_CPU(struct xen_common_irq, xen_debug_irq) = { .irq = -1 };
> 
> I have to admit that I'm quite puzzled by this still being massaged
> the way it is, rather than getting converted to proper per-CPU
> IRQs (i.e. with one global IRQ and only per-CPU event channels).
> Not only conserves this on resources (irrespective of IRQs not
> being a scarce resources anymore with SPARSE_IRQS), it also
> makes /proc/interrupts output a lot more manageable on domains
> with many vCPU-s.
> 
> I did this years ago for our kernels, but due to time constraints
> can't offer to do the same for the upstream kernel until we get
> ready to switch to using it in favor of the forward port.

I believe it was just the matter of other higher priority items preempting
it. Let me put it on the "v3.11 and the future list" so that I won't forget.

Thanks!
