Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933126AbbA2Jzw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 04:55:52 -0500
Received: from mail-lb0-f171.google.com ([209.85.217.171]:38263 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933079AbbA2Jzr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 04:55:47 -0500
MIME-Version: 1.0
In-Reply-To: <CAPvkgC0-e9DGH8zSZ+d6G5_mk49m1ToqBUJT3GnNAbuwdHh8QA@mail.gmail.com>
References: <CAPvkgC0-e9DGH8zSZ+d6G5_mk49m1ToqBUJT3GnNAbuwdHh8QA@mail.gmail.com>
Date: Thu, 29 Jan 2015 09:55:45 +0000
Message-ID: <CAKv+Gu-vngBfAn1C-5sa=-q3d7VtrDMGPMr6tUdsGp4QO+B+3A@mail.gmail.com>
Subject: Re: [PATCH v5 6/8] arm64/efi: move SetVirtualAddressMap() to UEFI stub
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: Steve Capper <steve.capper@linaro.org>
Cc: Leif Lindholm <leif.lindholm@linaro.org>, Roy Franz <roy.franz@linaro.org>,
        Matt Fleming <matt.fleming@intel.com>,
        Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        Borislav Petkov <bp@alien8.de>, Mark Salter <msalter@redhat.com>,
        Geoff Levand <geoff.levand@linaro.org>, Dave Young <dyoung@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-next@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29 January 2015 at 09:50, Steve Capper <steve.capper@linaro.org> wrote:
> On 8 January 2015 at 18:48, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
>> In order to support kexec, the kernel needs to be able to deal with the
>> state of the UEFI firmware after SetVirtualAddressMap() has been called.
>> To avoid having separate code paths for non-kexec and kexec, let's move
>> the call to SetVirtualAddressMap() to the stub: this will guarantee us
>> that it will only be called once (since the stub is not executed during
>> kexec), and ensures that the UEFI state is identical between kexec and
>> normal boot.
>>
>> This implies that the layout of the virtual mapping needs to be created
>> by the stub as well. All regions are rounded up to a naturally aligned
>> multiple of 64 KB (for compatibility with 64k pages kernels) and recorded
>> in the UEFI memory map. The kernel proper reads those values and installs
>> the mappings in a dedicated set of page tables that are swapped in during
>> UEFI Runtime Services calls.
>>
>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>
> Hi,
> I've been testing out linux-next next-20150128 and have run into an
> early bootup failure on Seattle.
> Having done a bisect, this patch comes up as the first "bad" patch:
> f3cdfd2 arm64/efi: move SetVirtualAddressMap() to UEFI stub
>
> I've tried the defconfig with 4-levels 4KB and 2-levels 64KB pages and
> the failure mode doesn't change.
>
> The point of failure for me is in setup_arch, just after call to
> local_async_enable.
>
> I'm not very knowledgeable of EFI, my guess is that a System Error
> occurs early (during the EFI stub activity?), then manifests once the
> asynchronous aborts are enabled?
>

This is a known issue with older versions of the Seattle firmware, and
a fix is available (ask Rutland)

Basically, the firmware dereferences the virtual mapping while it is
being installed, which is a violation of the spec. With the new code,
the virtual mapping is not actually active at that time, which is why
you are getting SErrors now.

-- 
Ard.



> The full boot log:
> EFI stub: Booting Linux Kernel...
> EFI stub: Using DTB from configuration table
> EFI stub: Exiting boot services and installing virtual address map...
> Booting Linux on physical CPU 0x0
> Initializing cgroup subsys cpu
> Linux version 3.19.0-rc4+ (steven@capper-seattle) (gcc version 4.9.2
> 20141101 (Red Hat 4.9.2-1) (GCC) ) #42 SMP Thu Jan 29 09:28:34 GMT
> 2015
> CPU: AArch64 Processor [410fd070] revision 0
> Detected PIPT I-cache on CPU0
> alternatives: enabling workaround for ARM erratum 832075
> Early serial console at MMIO 0xe1010000 (options '')
> bootconsole [uart0] enabled
> Bad mode in Error handler detected, code 0xbf000000
> CPU: 0 PID: 0 Comm: swapper Not tainted 3.19.0-rc4+ #42
> Hardware name: amd,seattle (DT)
> task: fffffe0000aaddf0 ti: fffffe0000a70000 task.ti: fffffe0000a70000
> PC is at setup_arch+0x1f8/0x510
> LR is at setup_arch+0x1f4/0x510
> pc : [<fffffe00009b2818>] lr : [<fffffe00009b2814>] pstate: 000002c5
> sp : fffffe0000a73f10
> x29: fffffe0000a73f10 x28: 0000028001000000
> x27: fffffe0000081230 x26: 0000008001c00000
> x25: 0000008001be0000 x24: fffffe0000aa6000
> x23: 0000000000000000 x22: fffffe0000aa6000
> x21: fffffe0000a73fe8 x20: fffffe0000b60000
> x19: fffffe0000080000 x18: 0000000000000000
> x17: 0000000000000800 x16: 0000000000001000
> x15: 0000000000001c00 x14: 0ffffffffffffffe
> x13: 0000000000000001 x12: 0000000000000010
> x11: 0000000000000007 x10: 0101010101010101
> x9 : fffffffffffffffe x8 : 0000000000000008
> x7 : 0000000000000006 x6 : 0000800000000000
> x5 : 000000000000005f x4 : 0000000000000000
> x3 : 0000000000000063 x2 : 0000000000000065
> x1 : 0000000000000000 x0 : 0000000000000001
>
> Internal error: Oops - bad mode: 0 [#1] SMP
> Modules linked in:
> CPU: 0 PID: 0 Comm: swapper Not tainted 3.19.0-rc4+ #42
> Hardware name: amd,seattle (DT)
> task: fffffe0000aaddf0 ti: fffffe0000a70000 task.ti: fffffe0000a70000
> PC is at setup_arch+0x1f8/0x510
> LR is at setup_arch+0x1f4/0x510
> pc : [<fffffe00009b2818>] lr : [<fffffe00009b2814>] pstate: 000002c5
> sp : fffffe0000a73f10
> x29: fffffe0000a73f10 x28: 0000028001000000
> x27: fffffe0000081230 x26: 0000008001c00000
> x25: 0000008001be0000 x24: fffffe0000aa6000
> x23: 0000000000000000 x22: fffffe0000aa6000
> x21: fffffe0000a73fe8 x20: fffffe0000b60000
> x19: fffffe0000080000 x18: 0000000000000000
> x17: 0000000000000800 x16: 0000000000001000
> x15: 0000000000001c00 x14: 0ffffffffffffffe
> x13: 0000000000000001 x12: 0000000000000010
> x11: 0000000000000007 x10: 0101010101010101
> x9 : fffffffffffffffe x8 : 0000000000000008
> x7 : 0000000000000006 x6 : 0000800000000000
> x5 : 000000000000005f x4 : 0000000000000000
> x3 : 0000000000000063 x2 : 0000000000000065
> x1 : 0000000000000000 x0 : 0000000000000001
>
> Process swapper (pid: 0, stack limit = 0xfffffe0000a70058)
> Stack: (0xfffffe0000a73f10 to 0xfffffe0000a74000)
> 3f00:                                     00a73fa0 fffffe00 009b0688 fffffe00
> 3f20: 009ef3b8 fffffe00 00b60000 fffffe00 00b60000 fffffe00 00aa6000 fffffe00
> 3f40: 00000000 00000000 01000000 00000080 01be0000 00000080 01c00000 00000080
> 3f60: 00081230 fffffe00 00630088 fffffe00 00000001 00000000 1fe00000 00000080
> 3f80: 00b63870 fffffe00 00000002 00000000 00b6451a fffffe00 00000000 00000000
> 3fa0: 00000000 00000000 010906e0 00000080 f0f1e938 00000083 00000e12 00000000
> 3fc0: 1fe00000 00000080 410fd070 00000000 01ab0000 00000080 01000000 00000080
> 3fe0: 00000000 00000000 009ef3b8 fffffe00 00000000 00000000 00000000 00000000
> Call trace:
> [<fffffe00009b2818>] setup_arch+0x1f8/0x510
> [<fffffe00009b0684>] start_kernel+0xa4/0x3a8
> Code: 94000b2c 940009f7 97fff760 d50344ff (d00007f5)
> ---[ end trace cb88537fdc8fa200 ]---
> Kernel panic - not syncing: Attempted to kill the idle task!
> ---[ end Kernel panic - not syncing: Attempted to kill the idle task!
