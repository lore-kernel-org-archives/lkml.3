Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933106Ab3DGJ0Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 05:26:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60521 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932997Ab3DGJ0N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 05:26:13 -0400
Date: Sun, 7 Apr 2013 10:41:13 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Christoffer Dall <cdall@cs.columbia.edu>
Cc: Alexander Graf <agraf@suse.de>, Gleb Natapov <gleb@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Takuya Yoshikawa <yoshikawa_takuya_b1@lab.ntt.co.jp>,
        Alex Williamson <alex.williamson@redhat.com>,
        Will Deacon <will.deacon@arm.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH RFC] kvm: add PV MMIO EVENTFD
Message-ID: <20130407074113.GB10317@redhat.com>
References: <20130404123806.GG17919@redhat.com>
 <EF153515-9835-4FB9-B6BC-73D0BDC86492@suse.de>
 <20130404124501.GH17919@redhat.com>
 <1B68D701-103D-4B1A-8F5E-3916753699CB@suse.de>
 <20130404125649.GI17919@redhat.com>
 <8E65D34D-2DA7-4C2E-9C3E-BE3A7DBC3279@suse.de>
 <20130404133318.GI6467@redhat.com>
 <14B443D5-5785-487D-9EA3-0AD20141BC06@suse.de>
 <20130404153629.GN6467@redhat.com>
 <CAEDV+gKpCj1Sgn4TYw5ViYK-x4_c=-9nOpBwGfTBXRkJaN=gNg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEDV+gKpCj1Sgn4TYw5ViYK-x4_c=-9nOpBwGfTBXRkJaN=gNg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 04, 2013 at 04:32:01PM -0700, Christoffer Dall wrote:
> [...]
> 
> >> >> to give us some idea how much performance we would gain from each approach? Thoughput should be completely unaffected anyway, since virtio just coalesces kicks internally.
> >> >
> >> > Latency is dominated by the scheduling latency.
> >> > This means virtio-net is not the best benchmark.
> >>
> >> So what is a good benchmark?
> >
> > E.g. ping pong stress will do but need to look at CPU utilization,
> > that's what is affected, not latency.
> >
> >> Is there any difference in speed at all? I strongly doubt it. One of virtio's main points is to reduce the number of kicks.
> >
> > For this stage of the project I think microbenchmarks are more appropriate.
> > Doubling the price of exit is likely to be measureable. 30 cycles likely
> > not ...
> >
> I don't quite understand this point here. If we don't have anything
> real-world where we can measure a decent difference, then why are we
> doing this? I would agree with Alex that the three test scenarios
> proposed by him should be tried out before adding this complexity,
> measured in CPU utilization or latency as you wish.

Sure, plan to do real world benchmarks for PV MMIO versus PIO as well.
I don't see why I should bother implementing hypercalls given that the
kvm maintainer says they won't be merged.

> FWIW, ARM always uses MMIO and provides hardware decoding of all sane
> (not user register-writeback) instruction, but the hypercall vs. mmio
> looks like this:
> 
> hvc:  4,917
> mmio_kernel: 6,248

So 20% difference?  That's not far from what happens on my intel laptop:
vmcall 1519
outl_to_kernel 1745
10% difference here.

> 
> But I doubt that an hvc wrapper around mmio decoding would take care
> of all this difference, because the mmio operation needs to do other
> work not realated to emulating the instruction in software, which
> you'd have to do for an hvc anyway (populate kvm_mmio structure etc.)
> 
> -Christoffer

Instead of speculating, someone with relevant hardware
could just try this, but kvm unittest doesn't seem to have arm support
at the moment. Anyone working on this?

-- 
MST
