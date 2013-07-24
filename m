Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752691Ab3GXOp7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 10:45:59 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:42649 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751323Ab3GXOp6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 10:45:58 -0400
Date: Wed, 24 Jul 2013 10:45:32 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Youquan Song <youquan.song@intel.com>, Gleb Natapov <gleb@redhat.com>,
        Sheng Yang <sheng@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Youquan Song <youquan.song@linux.intel.com>
Subject: Re: [PATCH] x86, apic: Enable x2APIC physical when cpu < 256 native
Message-ID: <20130724144532.GJ2518@phenom.dumpdata.com>
References: <1373592159-459-1-git-send-email-youquan.song@intel.com>
 <CAE9FiQVDZGbTEd7jpmOQY9+_Gb=DRrd=CCmvQPqXWoyww2NjdQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE9FiQVDZGbTEd7jpmOQY9+_Gb=DRrd=CCmvQPqXWoyww2NjdQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 23, 2013 at 09:24:45PM -0700, Yinghai Lu wrote:
> On Thu, Jul 11, 2013 at 6:22 PM, Youquan Song <youquan.song@intel.com> wrote:
> > x2APIC extends APICID from 8 bits to 32 bits, but the device interrupt routed
> > from IOAPIC or delivered in MSI mode will keep 8 bits destination APICID.
> > In order to support x2APIC, the VT-d interrupt remapping is introduced to
> > translate the destination APICID to 32 bits in x2APIC mode and keep the device
> > compatible in this way.
> >
> > x2APIC support both logical and physical mode in destination mode.
> > In logical destination mode, the 32 bits Logical APICID has 2 sub-fields:
> >  16 bits cluster ID and 16 bits logical ID within the cluster and it is
> > required VT-d interrupt remapping in x2APIC cluster mode.
> > In physical destination mode, the 8 bits physical id is compatible with 32
> > bits physical id when CPU number < 256.
> > When interrupt remapping initialization fail on platform with CPU number < 256,
> > current kernel only enables x2APIC physical mode in virutalization environment,
                                                        ^^^^^^^^^^^^^^-virtualization
> > while we also can enable x2APIC physcial mode in native kernel this situation,
                                    ^^^^^^^ physical
> > and the device interrupt will use 8 bits destination APICID in physical mode
> > and be compatible with x2APIC physical when < 256 CPUs.
> >
> > So we can benefit from x2APIC vs xAPIC MMIO:
> >  - x2APIC MSR read/write is faster than xAPIC mmio
> >  - x2APIC only ICR write to deliver interrupt without polling ICR deliver
> >    status bit and xAPIC need poll to read ICR deliver status bit.
> >  - x2APIC 64 bits ICR access instead of xAPIC two 32 bits access.
> >
> > Signed-off-by: Youquan Song <youquan.song@intel.com>
> > ---
> >  arch/x86/kernel/apic/apic.c |    7 ++-----
> >  1 files changed, 2 insertions(+), 5 deletions(-)
> >
> > diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
> > index 904611b..51a065a 100644
> > --- a/arch/x86/kernel/apic/apic.c
> > +++ b/arch/x86/kernel/apic/apic.c
> > @@ -1603,11 +1603,8 @@ void __init enable_IR_x2apic(void)
> >                 goto skip_x2apic;
> >
> >         if (ret < 0) {
> > -               /* IR is required if there is APIC ID > 255 even when running
> > -                * under KVM
> > -                */
> > -               if (max_physical_apicid > 255 ||
> > -                   !hypervisor_x2apic_available()) {
> > +               /* IR is required if there is APIC ID > 255 */
> > +               if (max_physical_apicid > 255) {
> >                         if (x2apic_preenabled)
> >                                 disable_x2apic();
> >                         goto skip_x2apic;
> 
> Those are kvm and xen related.
> 
> Add more Cc.
> 
> Yinghai
