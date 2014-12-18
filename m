Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751998AbaLRDQy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 22:16:54 -0500
Received: from mga01.intel.com ([192.55.52.88]:55723 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751307AbaLRDQx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 22:16:53 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="430471306"
From: "Wu, Feng" <feng.wu@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>, Gleb Natapov <gleb@kernel.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        "jiang.liu-VuQAYsv1563Yd54FQh9/CA@public.gmane.org" 
	<jiang.liu-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
CC: "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>, Eric Auger <eric.auger@linaro.org>,
        "Wu, Feng" <feng.wu@intel.com>
Subject: RE: [v3 23/26] KVM: Update Posted-Interrupts Descriptor when vCPU
 is preempted
Thread-Topic: [v3 23/26] KVM: Update Posted-Interrupts Descriptor when vCPU
 is preempted
Thread-Index: AQHQGhyMxQwKwmn5PUWiIKBWFJvdpJyUnX5A
Date: Thu, 18 Dec 2014 03:15:37 +0000
Message-ID: <E959C4978C3B6342920538CF579893F002307C66@SHSMSX104.ccr.corp.intel.com>
References: <1418397300-10870-1-git-send-email-feng.wu@intel.com>
 <1418397300-10870-24-git-send-email-feng.wu@intel.com>
 <5491B924.3090200@redhat.com>
In-Reply-To: <5491B924.3090200@redhat.com>
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
> Sent: Thursday, December 18, 2014 1:11 AM
> To: Wu, Feng; Thomas Gleixner; Ingo Molnar; H. Peter Anvin; x86@kernel.org;
> Gleb Natapov; Paolo Bonzini; dwmw2@infradead.org; joro@8bytes.org; Alex
> Williamson; jiang.liu-VuQAYsv1563Yd54FQh9/CA@public.gmane.org
> Cc: iommu@lists.linux-foundation.org; linux-kernel@vger.kernel.org; KVM list;
> Eric Auger
> Subject: Re: [v3 23/26] KVM: Update Posted-Interrupts Descriptor when vCPU
> is preempted
> 
> 
> 
> On 12/12/2014 16:14, Feng Wu wrote:
> > +	if (irq_remapping_cap(IRQ_POSTING_CAP)) {
> > +		struct pi_desc *pi_desc = vcpu_to_pi_desc(vcpu);
> > +		struct pi_desc old, new;
> > +		unsigned int dest;
> > +
> > +		memset(&old, 0, sizeof(old));
> > +		memset(&new, 0, sizeof(new));
> 
> This is quite expensive.  Just use an u64 for old_control and
> new_control, instead of a full struct.
> 
> >
> > +			pi_clear_sn(&new);
> 
> This can be simply new.sn = 0.  It does not need atomic operations.

Thanks for your comments, Paolo!

If we use u64 new_control, we cannot use new.sn any more.
Maybe we can change the struct pi_desc {} like this:

typedef struct pid_control{
        u64     on      : 1,
        sn      : 1,
        rsvd_1  : 13,
        ndm     : 1,
        nv      : 8,
        rsvd_2  : 8,
        ndst    : 32;
}pid_control_t;

struct pi_desc {
        u32 pir[8];     /* Posted interrupt requested */
		pid_control_t control;
        u32 rsvd[6];
} __aligned(64);


Then we can define pid_control_t new_control, old_control. And use new_control.sn = 0.

What is your opinon?

Thanks,
Feng

> 
> Same in patch 24 (if needed at all there---see the reply there).
> 
> >
> > +	if (irq_remapping_cap(IRQ_POSTING_CAP)) {
> > +		struct pi_desc *pi_desc = vcpu_to_pi_desc(vcpu);
> > +		struct pi_desc old, new;
> > +
> > +		memset(&old, 0, sizeof(old));
> > +		memset(&new, 0, sizeof(new));
> > +
> 
> Here you do not need old/new at all because...
> 
> > +		if (vcpu->preempted) {
> > +			do {
> > +				old.control = new.control = pi_desc->control;
> > +				pi_set_sn(&new);
> > +			} while (cmpxchg(&pi_desc->control, old.control,
> > +					new.control) != old.control);
> 
> this can do pi_set_sn directly on pi_desc, without the cmpxchg.
> 
> Paolo
