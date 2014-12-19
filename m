Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751940AbaLSCUu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 21:20:50 -0500
Received: from mga03.intel.com ([134.134.136.65]:1477 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751547AbaLSCUs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 21:20:48 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,604,1413270000"; 
   d="scan'208";a="656824953"
From: "Wu, Feng" <feng.wu@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Wu, Feng" <feng.wu@intel.com>
Subject: RE: [v3 16/26] KVM: Make struct kvm_irq_routing_table accessible
Thread-Topic: [v3 16/26] KVM: Make struct kvm_irq_routing_table accessible
Thread-Index: AQHQGhYm7sLo56pczEOP78elCT7pbZyWL+DA
Date: Fri, 19 Dec 2014 02:19:09 +0000
Message-ID: <E959C4978C3B6342920538CF579893F00230A97C@SHSMSX104.ccr.corp.intel.com>
References: <1418397300-10870-1-git-send-email-feng.wu@intel.com>
 <1418397300-10870-17-git-send-email-feng.wu@intel.com>
 <5491ACA9.5020507@redhat.com>
In-Reply-To: <5491ACA9.5020507@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org
> [mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of Paolo Bonzini
> Sent: Thursday, December 18, 2014 12:18 AM
> To: linux-kernel@vger.kernel.org
> Cc: iommu@lists.linux-foundation.org; kvm@vger.kernel.org;
> linux-kernel@vger.kernel.org; kvm@vger.kernel.org
> Subject: Re: [v3 16/26] KVM: Make struct kvm_irq_routing_table accessible
> 
> 
> 
> On 12/12/2014 16:14, Feng Wu wrote:
> > Move struct kvm_irq_routing_table from irqchip.c to kvm_host.h,
> > so we can use it outside of irqchip.c.
> >
> > Signed-off-by: Feng Wu <feng.wu@intel.com>
> > ---
> >  include/linux/kvm_host.h | 19 +++++++++++++++++++
> >  virt/kvm/irqchip.c       | 11 -----------
> >  2 files changed, 19 insertions(+), 11 deletions(-)
> >
> > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > index 0b9659d..cfa85ac 100644
> > --- a/include/linux/kvm_host.h
> > +++ b/include/linux/kvm_host.h
> > @@ -335,6 +335,25 @@ struct kvm_kernel_irq_routing_entry {
> >  	struct hlist_node link;
> >  };
> >
> > +#ifdef CONFIG_HAVE_KVM_IRQ_ROUTING
> > +
> > +struct kvm_irq_routing_table {
> > +	int chip[KVM_NR_IRQCHIPS][KVM_IRQCHIP_NUM_PINS];
> > +	struct kvm_kernel_irq_routing_entry *rt_entries;
> > +	u32 nr_rt_entries;
> > +	/*
> > +	 * Array indexed by gsi. Each entry contains list of irq chips
> > +	 * the gsi is connected to.
> > +	 */
> > +	struct hlist_head map[0];
> > +};
> > +
> > +#else
> > +
> > +struct kvm_irq_routing_table {};
> 
> If possible, just make this "struct kvm_irq_routing_table;" and pull
> this line to include/linux/kvm_types.h.
> 
> Paolo

Do you mean move the definition of struct kvm_irq_routing_table
to include/linux/kvm_types.h and add a declaration here?

Thanks,
Feng

> 
> > +
> > +#endif
> > +
> >  #ifndef KVM_PRIVATE_MEM_SLOTS
> >  #define KVM_PRIVATE_MEM_SLOTS 0
> >  #endif
> > diff --git a/virt/kvm/irqchip.c b/virt/kvm/irqchip.c
> > index 7f256f3..cdf29a6 100644
> > --- a/virt/kvm/irqchip.c
> > +++ b/virt/kvm/irqchip.c
> > @@ -31,17 +31,6 @@
> >  #include <trace/events/kvm.h>
> >  #include "irq.h"
> >
> > -struct kvm_irq_routing_table {
> > -	int chip[KVM_NR_IRQCHIPS][KVM_IRQCHIP_NUM_PINS];
> > -	struct kvm_kernel_irq_routing_entry *rt_entries;
> > -	u32 nr_rt_entries;
> > -	/*
> > -	 * Array indexed by gsi. Each entry contains list of irq chips
> > -	 * the gsi is connected to.
> > -	 */
> > -	struct hlist_head map[0];
> > -};
> > -
> >  int kvm_irq_map_gsi(struct kvm *kvm,
> >  		    struct kvm_kernel_irq_routing_entry *entries, int gsi)
> >  {
> >
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
