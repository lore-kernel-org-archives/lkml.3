Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758668AbaD3KC7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 06:02:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35933 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758219AbaD3KC6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 06:02:58 -0400
Message-ID: <5360CA3A.2040706@redhat.com>
Date: Wed, 30 Apr 2014 12:02:34 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>, Jet Chen <jet.chen@intel.com>,
        "Romer, Benjamin M" <Benjamin.Romer@unisys.com>
CC: Fengguang Wu <fengguang.wu@intel.com>, Borislav Petkov <bp@alien8.de>,
        LKML <linux-kernel@vger.kernel.org>,
        qemu-devel <qemu-devel@nongnu.org>
Subject: Re: [visorchipset] invalid opcode: 0000 [#1] PREEMPT SMP
References: <20140407111725.GC25152@localhost> <C97001BC43954D438ACB059713BA5CDF92040F0F00@USEA-EXCH7.na.uis.unisys.com> <53444220.50009@intel.com> <C97001BC43954D438ACB059713BA5CDF92040F0F06@USEA-EXCH7.na.uis.unisys.com> <53458A3A.1050608@intel.com> <20140409230114.GB8370@localhost> <5345D360.5000506@linux.intel.com> <C97001BC43954D438ACB059713BA5CDF92040F0F0A@USEA-EXCH7.na.uis.unisys.com> <53475344.5090009@linux.intel.com> <C97001BC43954D438ACB059713BA5CDF92040F0F10@USEA-EXCH7.na.uis.unisys.com> <53481976.3020209@zytor.com> <534827F5.1020004@intel.com> <5348291B.7090501@zytor.com>
In-Reply-To: <5348291B.7090501@zytor.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 11/04/2014 19:40, H. Peter Anvin ha scritto:
> On 04/11/2014 10:35 AM, Jet Chen wrote:
>>
>> As Peter said, QEMU probably should *not* set the hypervisor bit. But based on my testing, I think KVM works properly in this case.
>>
>
> Either way, unless there is a CPUID interface exposed in CPUID levels
> 0x40000000+, then relying on the hypervisor bit to do VMCALL is wrong in
> the extreme.

Sorry for the delay guys, I was on vacation.

Lack of a CPUID interface at 0x40000000 is indeed *the* good reason why 
QEMU should not set the hypervisor bit.  Of course that there is no 
guarantee that QEMU will never expose a 0x40000000 interface, and at 
that point the hypervisor bit may reappear in QEMU's JIT mode.

As to sending #UD to the guest at CPL>0, that is a choice of the 
hypervisor.  Hyper-V (and KVM in Hyper-V emulation mode) does that, and 
does the same in real mode too.  KVM instead sets EAX to -KVM_EPERM, and 
accepts hypercalls in real mode (where CPL=0).  Terminating the guest is 
surely the wrong thing to do at CPL>0.

Thanks,

Paolo
