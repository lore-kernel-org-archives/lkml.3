Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754700AbaLWJHt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 04:07:49 -0500
Received: from mga01.intel.com ([192.55.52.88]:63771 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753998AbaLWJHp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 04:07:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,630,1413270000"; 
   d="scan'208";a="641826558"
From: "Wu, Feng" <feng.wu@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
        "Zhang, Yang Z" <yang.z.zhang@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>, Gleb Natapov <gleb@kernel.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jiang Liu <jiang.liu@linux.intel.com>
CC: "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>, Eric Auger <eric.auger@linaro.org>,
        "Wu, Feng" <feng.wu@intel.com>
Subject: RE: [v3 06/26] iommu, x86: No need to migrating irq for VT-d
 Posted-Interrupts
Thread-Topic: [v3 06/26] iommu, x86: No need to migrating irq for VT-d
 Posted-Interrupts
Thread-Index: AQHQHo0zCIPBFdpFuEmLUQfVNyledpyc4SAw
Date: Tue, 23 Dec 2014 09:07:39 +0000
Message-ID: <E959C4978C3B6342920538CF579893F002314236@SHSMSX104.ccr.corp.intel.com>
References: <1418397300-10870-1-git-send-email-feng.wu@intel.com>
	<1418397300-10870-7-git-send-email-feng.wu@intel.com>
	<A9667DDFB95DB7438FA9D7D576C3D87E0AC0486D@SHSMSX104.ccr.corp.intel.com>
	<E959C4978C3B6342920538CF579893F00230A649@SHSMSX104.ccr.corp.intel.com>
	<A9667DDFB95DB7438FA9D7D576C3D87E0AC04E77@SHSMSX104.ccr.corp.intel.com>
	<54941326.4080405@redhat.com>
 <A9667DDFB95DB7438FA9D7D576C3D87E0AC06282@SHSMSX104.ccr.corp.intel.com>
 <54992C2C.5030305@redhat.com>
In-Reply-To: <54992C2C.5030305@redhat.com>
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
> From: Paolo Bonzini [mailto:paolo.bonzini@gmail.com] On Behalf Of Paolo
> Bonzini
> Sent: Tuesday, December 23, 2014 4:48 PM
> To: Zhang, Yang Z; Paolo Bonzini; Wu, Feng; Thomas Gleixner; Ingo Molnar; H.
> Peter Anvin; x86@kernel.org; Gleb Natapov; dwmw2@infradead.org;
> joro@8bytes.org; Alex Williamson; Jiang Liu
> Cc: iommu@lists.linux-foundation.org; linux-kernel@vger.kernel.org; KVM list;
> Eric Auger
> Subject: Re: [v3 06/26] iommu, x86: No need to migrating irq for VT-d
> Posted-Interrupts
> 
> 
> 
> On 23/12/2014 01:37, Zhang, Yang Z wrote:
> > I don't quite understand it. If user set an interrupt's affinity to a
> > CPU, but he still see the interrupt delivers to other CPUs in host.
> > Do you think it is a right behavior?
> 
> No, the interrupt is not delivered at all in the host.  Normally you'd have:
> 
> - interrupt delivered to CPU from host affinity
> 
> - VFIO interrupt handler writes to irqfd
> 
> - interrupt delivered to vCPU from guest affinity
> 
> Here, you just skip the first two steps.  The interrupt is delivered to
> the thread that is running the vCPU directly, so the host affinity is
> bypassed entirely.
> 
> ... unless you are considering the case where the vCPU is blocked and
> the host is processing the posted interrupt wakeup vector.  In that case
> yes, it would be better to set NDST to a CPU matching the host affinity.

In my understanding, wakeup vector should have no relationship with the
host affinity of the irq. Wakeup notification event should be delivered to
the pCPU which the vCPU was blocked on. And in kernel's point of view,
the irq is not associated with the wakeup vector, right?

Thanks,
Feng

>  But it would be handled in patch 24.  We also have the same problem
> with lowest-priority interrupts; likely the host has configured the
> interrupt affinity for any CPU.  So we can do it later when we add
> vector hashing support.  In the meanwhile, Feng, please add a FIXME
> comment.
> 
> Does this make sense?
> 
> Paolo
