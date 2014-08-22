Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932828AbaHVSAY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 14:00:24 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:25064 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932410AbaHVSAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 14:00:20 -0400
Date: Thu, 21 Aug 2014 23:32:28 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Mukesh Rathor <mukesh.rathor@oracle.com>
Cc: boris.ostrovsky@oracle.com, david.vrabel@citrix.com,
        xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] [V0 PATCH 1/2] AMD-PVH: set EFER.NX and EFER.SCE for
 the boot vcpu
Message-ID: <20140822033228.GA4296@laptop.dumpdata.com>
References: <1408587400-18663-1-git-send-email-mukesh.rathor@oracle.com>
 <1408587400-18663-2-git-send-email-mukesh.rathor@oracle.com>
 <20140822013904.GA20329@laptop.dumpdata.com>
 <20140821194656.4eea5654@mantra.us.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140821194656.4eea5654@mantra.us.oracle.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 21, 2014 at 07:46:56PM -0700, Mukesh Rathor wrote:
> On Thu, 21 Aug 2014 21:39:04 -0400
> Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> 
> > On Wed, Aug 20, 2014 at 07:16:39PM -0700, Mukesh Rathor wrote:
> > > On AMD, NX feature must be enabled in the efer for NX to be honored
> > > in the pte entries, otherwise protection fault. We also set SC for
> > > system calls to be enabled.
> > 
> > How come we don't need to do that for Intel (that is set the NX bit)?
> > Could you include the explanation here please?
> 
> Intel doesn't have EFER.NX bit. The SC bit is being set in xen, but it
> doesn't need to be, and I'm going to submit a patch to undo it.

I understand that it does not have an EFER.NX bit. What I was trying
to figure out is _where_ do we set the NX bit for Intel CPUs? Is
it done in the hypervisor? In the Linux code?

Thank you.
> 
> > 
> > > 
> > > Signed-off-by: Mukesh Rathor <mukesh.rathor@oracle.com>
> > > ---
> > >  arch/x86/xen/enlighten.c | 12 ++++++++++++
> > >  1 file changed, 12 insertions(+)
> > > 
> > > diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
> > > index c0cb11f..4af512d 100644
> > > --- a/arch/x86/xen/enlighten.c
> > > +++ b/arch/x86/xen/enlighten.c
> > > @@ -1499,6 +1499,17 @@ void __ref xen_pvh_secondary_vcpu_init(int
> > > cpu) xen_pvh_set_cr_flags(cpu);
> > >  }
> > >  
> > > +/* This is done in secondary_startup_64 for hvm guests. */
> > > +static void __init xen_configure_efer(void)
> > > +{
> > > +	u64 efer;
> > > +
> > > +	rdmsrl(MSR_EFER, efer);
> > > +	efer |= EFER_SCE;
> > > +	efer |= (cpuid_edx(0x80000001) & (1 << 20)) ? EFER_NX : 0;
> > 
> > Ahem? #defines for these magic values please?
> 
> Linux uses these directly all over the code as they are set in stone
> pretty much, and I didn't find any #defines. See cpu/common.c for one of
> the places. Also see secondary_startup_64, and others...
> 
> > Or could you use 'boot_cpu_has'?
> 
> Nop, it's not initialized at this point.
> 
> thanks,
> Mukesh
