Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752622AbaKZNxk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 08:53:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37807 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750951AbaKZNxi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 08:53:38 -0500
Date: Wed, 26 Nov 2014 14:53:22 +0100
From: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        wanpeng.li@linux.intel.com, namit@cs.technion.ac.il,
        hpa@linux.intel.com, Fenghua Yu <fenghua.yu@intel.com>
Subject: Re: [CFT PATCH v2 2/2] KVM: x86: support XSAVES usage in the host
Message-ID: <20141126135322.GA4887@potion.brq.redhat.com>
References: <1416847414-22253-1-git-send-email-pbonzini@redhat.com>
 <1416847414-22253-3-git-send-email-pbonzini@redhat.com>
 <20141126120753.GA31982@potion.redhat.com>
 <5475D20A.90505@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5475D20A.90505@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-11-26 14:13+0100, Paolo Bonzini:
> On 26/11/2014 13:07, Radim Krčmář wrote:
> > 2014-11-24 17:43+0100, Paolo Bonzini:
> >> Userspace is expecting non-compacted format for KVM_GET_XSAVE, but
> >> struct xsave_struct might be using the compacted format.  Convert
> >> in order to preserve userspace ABI.
> >>
> >> Likewise, userspace is passing non-compacted format for KVM_SET_XSAVE
> >> but the kernel will pass it to XRSTORS, and we need to convert back.
> > 
> > Future instructions might force us to calling xsave/xrstor directly, so
> > we could do that even now and save the explicit conversion ...
> > 
> > What I mean is:  we could be using the native xsave.*/xrstor.* while in
> > kernel and use xsave/xrstor for communication with userspace.
> > Hardware would take care of everything in the conversion.
> > 
> > get_xsave = native_xrstor(guest_xsave);  xsave(aligned_userspace_buffer)
> > set_xsave = xrstor(aligned_userspace_buffer);  native_xsave(guest_xsave)
> > 
> > Could that work?
> 
> It could, though it is more like
> 
>    get_fpu()
>    native_xrstor(guest_xsave)
>    xsave(buffer)
>    put_fpu()
> 
> and vice versa.  Also, the userspace buffer is mos likely not aligned,
> so you need some kind of bounce buffer.  It can be done if the CPUID
> turns out to be a bottleneck, apart from that it'd most likely be slower.

Yeah, it was mostly making this code more future-proof ... it is easier
to convince xsave.h to export its structures if CPUID is the problem.
(I still see some hope for Linux, so performance isn't my primary goal.)

I'm quite interested in CPUID now though, so I'll try to benchmark it,
someday.
