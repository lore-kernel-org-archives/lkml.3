Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753279AbaKXKOw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 05:14:52 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:60135 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765AbaKXKOu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 05:14:50 -0500
Message-ID: <5473034F.7030408@redhat.com>
Date: Mon, 24 Nov 2014 11:07:11 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Wanpeng Li <wanpeng.li@linux.intel.com>
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Fenghua Yu <fenghua.yu@intel.com>, stable@vger.kernel.org,
        Nadav Amit <namit@cs.technion.ac.il>,
        Andy Lutomirski <luto@amacapital.net>
Subject: Re: [CFT PATCH 2/2] KVM: x86: support XSAVES usage in the host
References: <1416594678-13011-1-git-send-email-pbonzini@redhat.com> <1416594678-13011-3-git-send-email-pbonzini@redhat.com> <20141124021009.GB27849@kernel>
In-Reply-To: <20141124021009.GB27849@kernel>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 24/11/2014 03:10, Wanpeng Li wrote:
> Hi Paolo,
> On Fri, Nov 21, 2014 at 07:31:18PM +0100, Paolo Bonzini wrote:
> [...]
>> +		u64 feature = valid & -valid;
>> +		int index = fls64(feature) - 1;
>> +		void *src = get_xsave_addr(xsave, feature);
>> +
>> +	        if (src) {
>> +			u32 size, offset, ecx, edx;
>> +			cpuid_count(XSTATE_CPUID, index,
>> +				    &size, &offset, &ecx, &edx);
>> +	                memcpy(dest + offset, src, size);
> 
> The offset you get is still for compact format

No, it's not, or all old software using XSAVE/XRSTOR would be broken.

The code in arch/x86/kernel/xsave.c agrees with me; compacted offsets
(xsave_comp_offsets) are computed by summing sizes, while non-compacted
offsets (xsave_offsets) come for CPUID.

> , so you almost convert compat 
> format to compat format instead of convert compact format to standard format. 
> In addition, I think convert standard format to compact format should be 
> implemented in put path.

If I do that, userspace is broken because it expects standard format.
Hence, passing XSAVE data to userspace in compact format can be done,
but has to be guarded by an explicitly enabled capability (using
KVM_ENABLE_CAP).

I do not think that's useful, since no supervisor-specific states are
defined yet, and anyway they can be passed using KVM_GET/SET_MSR because
this is not a fast path.

Paolo
