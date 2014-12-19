Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751881AbaLSCKC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 21:10:02 -0500
Received: from mga03.intel.com ([134.134.136.65]:48009 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751602AbaLSCKA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 21:10:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,691,1406617200"; 
   d="scan'208";a="501291319"
From: "Wu, Feng" <feng.wu@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Wu, Feng" <feng.wu@intel.com>
Subject: RE: [v3 23/26] KVM: Update Posted-Interrupts Descriptor when vCPU
 is preempted
Thread-Topic: [v3 23/26] KVM: Update Posted-Interrupts Descriptor when vCPU
 is preempted
Thread-Index: AQHQGp2TX4ce4Iy7jE+LovTGMQc/WJyWLBVQ
Date: Fri, 19 Dec 2014 02:09:54 +0000
Message-ID: <E959C4978C3B6342920538CF579893F00230A86A@SHSMSX104.ccr.corp.intel.com>
References: <1418397300-10870-1-git-send-email-feng.wu@intel.com>
	<1418397300-10870-24-git-send-email-feng.wu@intel.com>
	<5491B924.3090200@redhat.com>
 <E959C4978C3B6342920538CF579893F002307C66@SHSMSX104.ccr.corp.intel.com>
 <5492911D.3000900@redhat.com>
In-Reply-To: <5492911D.3000900@redhat.com>
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
> Sent: Thursday, December 18, 2014 4:32 PM
> To: linux-kernel@vger.kernel.org
> Cc: iommu@lists.linux-foundation.org; kvm@vger.kernel.org;
> linux-kernel@vger.kernel.org; kvm@vger.kernel.org
> Subject: Re: [v3 23/26] KVM: Update Posted-Interrupts Descriptor when vCPU
> is preempted
> 
> 
> 
> On 18/12/2014 04:15, Wu, Feng wrote:
> > Thanks for your comments, Paolo!
> >
> > If we use u64 new_control, we cannot use new.sn any more.
> > Maybe we can change the struct pi_desc {} like this:
> >
> > typedef struct pid_control{
> >         u64     on      : 1,
> >         sn      : 1,
> >         rsvd_1  : 13,
> >         ndm     : 1,
> >         nv      : 8,
> >         rsvd_2  : 8,
> >         ndst    : 32;
> > }pid_control_t;
> >
> > struct pi_desc {
> >         u32 pir[8];     /* Posted interrupt requested */
> > 		pid_control_t control;
> 
> Probably something like this to keep the union:
> 
> typedef union pid_control {
> 	u64 full;
> 	struct {
> 		u64 on : 1,
> 		...
> 	} fields;
> };
> 
> >         u32 rsvd[6];
> > } __aligned(64);
> >
> >
> > Then we can define pid_control_t new_control, old_control. And use
> new_control.sn = 0.
> >
> > What is your opinon?
> 
> Sure.  Alternatively, keep using struct pi_desc new; just
> do not zero it, nor access any field outide the control word.
> 
> Paolo

Yes, this is also a good idea. Thanks!

Thanks,
Feng

> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
