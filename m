Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751846AbaLSBat (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 20:30:49 -0500
Received: from mga11.intel.com ([192.55.52.93]:46144 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751224AbaLSBar convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 20:30:47 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="430988704"
From: "Wu, Feng" <feng.wu@intel.com>
To: "Zhang, Yang Z" <yang.z.zhang@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>, "gleb@kernel.org" <gleb@kernel.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jiang.liu@linux.intel.com" <jiang.liu@linux.intel.com>,
        "Sankaran, Rajesh" <rajesh.sankaran@intel.com>
CC: "eric.auger@linaro.org" <eric.auger@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Wu, Feng" <feng.wu@intel.com>
Subject: RE: [v3 13/26] KVM: Define a new interface kvm_find_dest_vcpu() for
 VT-d PI
Thread-Topic: [v3 13/26] KVM: Define a new interface kvm_find_dest_vcpu()
 for VT-d PI
Thread-Index: AQHQFiCrJgBr1evklkuo8VNfnV0dX5yVdJYA//+gqoCAAQuSEIAABb3A
Date: Fri, 19 Dec 2014 01:30:41 +0000
Message-ID: <E959C4978C3B6342920538CF579893F00230A5EA@SHSMSX104.ccr.corp.intel.com>
References: <1418397300-10870-1-git-send-email-feng.wu@intel.com>
 <1418397300-10870-14-git-send-email-feng.wu@intel.com>
 <A9667DDFB95DB7438FA9D7D576C3D87E0AC048A2@SHSMSX104.ccr.corp.intel.com>
 <549307A5.3060305@redhat.com>
 <A9667DDFB95DB7438FA9D7D576C3D87E0AC04E0A@SHSMSX104.ccr.corp.intel.com>
In-Reply-To: <A9667DDFB95DB7438FA9D7D576C3D87E0AC04E0A@SHSMSX104.ccr.corp.intel.com>
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
> From: Zhang, Yang Z
> Sent: Friday, December 19, 2014 9:14 AM
> To: Paolo Bonzini; Wu, Feng; tglx@linutronix.de; mingo@redhat.com;
> hpa@zytor.com; x86@kernel.org; gleb@kernel.org; dwmw2@infradead.org;
> joro@8bytes.org; alex.williamson@redhat.com; jiang.liu@linux.intel.com
> Cc: eric.auger@linaro.org; linux-kernel@vger.kernel.org;
> iommu@lists.linux-foundation.org; kvm@vger.kernel.org
> Subject: RE: [v3 13/26] KVM: Define a new interface kvm_find_dest_vcpu() for
> VT-d PI
> 
> Paolo Bonzini wrote on 2014-12-19:
> >
> >
> > On 18/12/2014 15:49, Zhang, Yang Z wrote:
> >>>> Here, we introduce a similar way with 'apic_arb_prio' to handle
> >>>> guest lowest priority interrtups when VT-d PI is used. Here is the
> >>>> ideas: - Each vCPU has a counter 'round_robin_counter'. - When
> >>>> guests sets an interrupts to lowest priority, we choose the vCPU
> >>>> with smallest 'round_robin_counter' as the destination, then
> >>>> increase it.
> >>
> >> How this can work well? All subsequent interrupts are delivered to
> >> one vCPU? It shouldn't be the best solution, need more consideration.
> >
> > Well, it's a hardware limitation.  The alternative (which is easy to
> 
> Agree, it is limited by hardware. But lowest priority distributes the interrupt
> more efficient than fixed mode. And current implementation more likes to
> switch the lowest priority mode to fixed mode. In case of interrupt intensive
> environment, this may be a bottleneck and VM may not benefit greatly from
> VT-d PI. But agree again, it is really a hardware limitation.
> 
> > implement) is to only do PI for single-CPU interrupts.  This should
> > work well for multiqueue NICs (and of course for UP guests :)), so
> > perhaps it's a good idea to only support that as a first attempt.
> 
> The more easy way is to deliver the interrupt to the first matched VCPU we find.
> The round_robin_counter really helps nothing here since the interrupt is
> delivered by hardware directly.
> 
> >
> > Paolo
> >
> >> Also, I think you should take the apic_arb_prio into consider since
> >> the priority is for the whole vCPU not for one interrupt.
> 
> 
> Best regards,
> Yang

In fact, the current solution was discussed with Rajesh in the cc List, here is Rajesh's original words:

"When you see a guest requesting a lowest priority interrupts (by programming the virtual IOAPIC, or by programming the virtual MSI/MSI-X registers), have KVM associate it to a vCPU.  Or, put another way, use the 'apic_arb_prio' method you describe below, but instead of using it at time of interrupt (which you no longer have control with posted interrupt direct delivery), do it at time of initializing the interrupt resource.  This way, if the guest asks for 4 lowest priority interrupts, and say you a guest with two vCPUs, the first interrupt request will be serviced by KVM by assigning it through posting to vCPU0, the next one goes to vCPU1, the next one would go back to vCPU0, and so forth..  You could also choose to do this based on vector hashing instead of round-robin."

Thanks,
Feng

> 

