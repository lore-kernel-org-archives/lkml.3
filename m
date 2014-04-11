Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759649AbaDKQel (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 12:34:41 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44752 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754354AbaDKQeh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 12:34:37 -0400
Message-ID: <53481976.3020209@zytor.com>
Date: Fri, 11 Apr 2014 09:33:58 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: "Romer, Benjamin M" <Benjamin.Romer@unisys.com>
CC: Fengguang Wu <fengguang.wu@intel.com>, Jet Chen <jet.chen@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>, Borislav Petkov <bp@alien8.de>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [visorchipset] invalid opcode: 0000 [#1] PREEMPT SMP
References: <20140407111725.GC25152@localhost> <C97001BC43954D438ACB059713BA5CDF92040F0F00@USEA-EXCH7.na.uis.unisys.com> <53444220.50009@intel.com> <C97001BC43954D438ACB059713BA5CDF92040F0F06@USEA-EXCH7.na.uis.unisys.com> <53458A3A.1050608@intel.com> <20140409230114.GB8370@localhost> <5345D360.5000506@linux.intel.com> <C97001BC43954D438ACB059713BA5CDF92040F0F0A@USEA-EXCH7.na.uis.unisys.com> <53475344.5090009@linux.intel.com> <C97001BC43954D438ACB059713BA5CDF92040F0F10@USEA-EXCH7.na.uis.unisys.com>
In-Reply-To: <C97001BC43954D438ACB059713BA5CDF92040F0F10@USEA-EXCH7.na.uis.unisys.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11/2014 06:51 AM, Romer, Benjamin M wrote:
>
>> I'm still confused where KVM comes into the picture.  Are you actually
>> using KVM (and thus talking about nested virtualization) or are you
>> using Qemu in JIT mode and running another hypervisor underneath?
> 
> The test that Fengguang used to find the problem was running the linux
> kernel directly using KVM. When the kernel was run with "-cpu Haswell,
> +smep,+smap" set, the vmcall failed with invalid op, but when the kernel
> is run with "-cpu qemu64", the vmcall causes a vmexit, as it should.

As far as I know, Fengguang's test doesn't use KVM at all, it runs Qemu
as a JIT.  Completely different thing.  In that case Qemu probably
should *not* set the hypervisor bit.  However, the only thing that the
hypervisor bit means is that you can look for specific hypervisor APIs
in CPUID level 0x40000000+.

> My point is, the vmcall was made because the hypervisor bit was set. If
> this bit had been turned off, as it would be on a real processor, the
> vmcall wouldn't have happened.

And my point is that that is a bug.  In the driver.  A very serious one.
 You cannot call VMCALL until you know *which* hypervisor API(s) you
have available, period.

>> The hypervisor bit is a complete red herring. If the guest CPU is
>> running in VT-x mode, then VMCALL should VMEXIT inside the guest
>> (invoking the guest root VT-x), 
> 
> The CPU is running in VT-X. That was my point, the kernel is running in
> the KVM guest, and KVM is setting the CPU feature bits such that bit 31
> is enabled.

Which it is because it wants to export the KVM hypercall interface.
However, keying VMCALL *only* on the HYPERVISOR bit is wrong in the extreme.

> I don't think it's a red herring because the kernel uses this bit
> elsewhere - it is reported as X86_FEATURE_HYPERVISOR in the CPU
> features, and can be checked with the cpu_has_hypervisor macro (which
> was not used by the original author of the code in the driver, but
> should have been). VMWare and KVM support in the kernel also check for
> this bit before checking their hypervisor leaves for an ID. If it's not
> properly set it affects more than just the s-Par drivers.
> 
>> but the fact still remains that you
>> should never, ever, invoke VMCALL unless you know what hypervisor you
>> have underneath.
> 
> From the standpoint of the s-Par drivers, yes, I agree (as I already
> said). However, VMCALL is not a privileged instruction, so anyone could
> use it from user space and go right past the OS straight to the
> hypervisor. IMHO, making it *lethal* to the guest is a bad idea, since
> any user could hard-stop the guest with a couple of lines of C.

Typically the hypervisor wants to generate a #UD inside of the guest for
that case.  The guest OS will intercept it and SIGILL the user space
process.

	-hpa

