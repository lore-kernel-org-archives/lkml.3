Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752720AbaKZNOC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 08:14:02 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47926 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750871AbaKZNOA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 08:14:00 -0500
Message-ID: <5475D20A.90505@redhat.com>
Date: Wed, 26 Nov 2014 14:13:46 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        wanpeng.li@linux.intel.com, namit@cs.technion.ac.il,
        hpa@linux.intel.com, Fenghua Yu <fenghua.yu@intel.com>
Subject: Re: [CFT PATCH v2 2/2] KVM: x86: support XSAVES usage in the host
References: <1416847414-22253-1-git-send-email-pbonzini@redhat.com> <1416847414-22253-3-git-send-email-pbonzini@redhat.com> <20141126120753.GA31982@potion.redhat.com>
In-Reply-To: <20141126120753.GA31982@potion.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 26/11/2014 13:07, Radim Krčmář wrote:
> 2014-11-24 17:43+0100, Paolo Bonzini:
>> Userspace is expecting non-compacted format for KVM_GET_XSAVE, but
>> struct xsave_struct might be using the compacted format.  Convert
>> in order to preserve userspace ABI.
>>
>> Likewise, userspace is passing non-compacted format for KVM_SET_XSAVE
>> but the kernel will pass it to XRSTORS, and we need to convert back.
> 
> Future instructions might force us to calling xsave/xrstor directly, so
> we could do that even now and save the explicit conversion ...
> 
> What I mean is:  we could be using the native xsave.*/xrstor.* while in
> kernel and use xsave/xrstor for communication with userspace.
> Hardware would take care of everything in the conversion.
> 
> get_xsave = native_xrstor(guest_xsave);  xsave(aligned_userspace_buffer)
> set_xsave = xrstor(aligned_userspace_buffer);  native_xsave(guest_xsave)
> 
> Could that work?

It could, though it is more like

   get_fpu()
   native_xrstor(guest_xsave)
   xsave(buffer)
   put_fpu()

and vice versa.  Also, the userspace buffer is mos likely not aligned,
so you need some kind of bounce buffer.  It can be done if the CPUID
turns out to be a bottleneck, apart from that it'd most likely be slower.

Paolo
