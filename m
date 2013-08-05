Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752922Ab3HENht (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 09:37:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48108 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751860Ab3HENhs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 09:37:48 -0400
Message-ID: <51FFAB13.4090603@redhat.com>
Date: Mon, 05 Aug 2013 15:39:31 +0200
From: Laszlo Ersek <lersek@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130621 Thunderbird/17.0.7
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: edk2-devel@lists.sourceforge.net, David Woodhouse <dwmw2@infradead.org>,
        linux-efi@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Gleb Natapov <gleb@redhat.com>, Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [edk2] Corrupted EFI region
References: <20130731205431.GG4724@pd.tnic> <1375307727.22084.103.camel@shinybook.infradead.org> <20130801164927.GA7445@pd.tnic> <51FF8C14.2070405@redhat.com> <20130805130258.GB31845@pd.tnic>
In-Reply-To: <20130805130258.GB31845@pd.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/05/13 15:02, Borislav Petkov wrote:
> On Mon, Aug 05, 2013 at 01:27:16PM +0200, Laszlo Ersek wrote:
>>> --- before      2013-07-31 22:20:52.316039492 +0200
>>> +++ after       2013-07-31 22:21:30.960731706 +0200
>>> @@ -9,7 +9,7 @@ efi: mem07: type=2, attr=0xf, range=[0x0
>>>  efi: mem08: type=7, attr=0xf, range=[0x0000000040000000-0x000000007c000000) (960MB)
>>>  efi: mem09: type=4, attr=0xf, range=[0x000000007c000000-0x000000007c020000) (0MB)
>>>  efi: mem10: type=7, attr=0xf, range=[0x000000007c020000-0x000000007e0ad000) (32MB)
>>> -efi: mem11: type=4, attr=0xf, range=[0x000000007e0ad000-0x000000007e0cc000) (0MB)
>>> +efi: mem11: type=4, attr=0xf, range=[0x000000007e0ad000-0x000000007e0ad000) (0MB)
>>
>> (type 4 is EfiBootServicesData)
> 
> Yes.
> 
>>>  efi: mem12: type=7, attr=0xf, range=[0x000000007e0cc000-0x000000007e0cd000) (0MB)
>>>  efi: mem13: type=4, attr=0xf, range=[0x000000007e0cd000-0x000000007e55d000) (4MB)
>>>  efi: mem14: type=3, attr=0xf, range=[0x000000007e55d000-0x000000007e59c000) (0MB)
>>>
>>> That second boundary of region mem11 suddenly changes *before* we merge
>>> the regions. edk2 bug?
>>
>> I take it you mean this change (ie. appearance of the zero-sized range)
>> occurs when you enable KVM acceleration in qemu?
> 
> Right. And I'm booting with qemu -enable-kvm so KVM acceleration is
> enabled?? Or do you mean something else.

My question was: is my understanding correct that you only see this
problem with "-enable-kvm"? Because,

On 08/01/13 18:49, Borislav Petkov wrote:
> so I'm seeing this funny thing where an EFI region changes when we
> enter efi_enter_virtual_mode when booting with edk2 on kvm. Here's
> the diff:

You said "on kvm", and provided a diff. I think (hope) I understand the
environment you've denoted with "after", but what's your "before"? The
absence of "-enable-kvm", or something else?

> 
>> If so, please locate "gEfiMdePkgTokenSpaceGuid.PcdDebugPrintErrorLevel"
>> in OvmfPkg/OvmfPkgX64.dsc, and set the following bit in its value:
>>
>>   # DEBUG_GCD      0x00100000 Global Coherency Database changes
>>
>> Then please rebuild OVMF, and capture the debug port output of qemu
>> ("-debugcon file:debug.log -global isa-debugcon.iobase=0x402") both with
>> and without KVM.
>>
>> DEBUG_GCD should produce messages related to CoreAllocateSpace(), and
>> might help us find the spot the difference is introduced.
> 
> Ok, I'll try to get this thing done before my vacation. If not, we'll
> deal with it afterwards but I won't forget, I promise! :-)
> 
>> BTW does this have anything to do with the NX bit report of yours, or
>> have you noticed this independently?
> 
> Independently, while testing my runtime services mapping patchset.

What's the purpose of that series? Can you please provide a link (if you
posted versions of it already)?

> I was
> getting an empty region and was wondering whether to discard it from the
> mapping or not and then I looked at why I get it in the first place.
> 
> Basically, I get this empty region which appears at some point. It is
> there when we enter efi_enter_virtual_mode in the kernel to setup the
> runtime mappings:
> 
> [    0.005012] efi: efi_enter_virtual_mode: enter
> [    0.006004] efi: mem00: type=7, attr=0xf, range=[0x0000000000000000-0x000000000009f000) (0MB)
> [    0.007004] efi: mem01: type=2, attr=0xf, range=[0x000000000009f000-0x00000000000a0000) (0MB)
> [    0.008003] efi: mem02: type=7, attr=0xf, range=[0x0000000000100000-0x0000000000800000) (7MB)
> [    0.009004] efi: mem03: type=4, attr=0xf, range=[0x0000000000800000-0x0000000001000000) (8MB)
> [    0.010004] efi: mem04: type=7, attr=0xf, range=[0x0000000001000000-0x0000000002000000) (16MB)
> [    0.011004] efi: mem05: type=2, attr=0xf, range=[0x0000000002000000-0x00000000036e3000) (22MB)
> [    0.012004] efi: mem06: type=7, attr=0xf, range=[0x00000000036e3000-0x000000003fffb000) (969MB)
> [    0.013003] efi: mem07: type=2, attr=0xf, range=[0x000000003fffb000-0x0000000040000000) (0MB)
> [    0.014004] efi: mem08: type=7, attr=0xf, range=[0x0000000040000000-0x000000007c000000) (960MB)
> [    0.015004] efi: mem09: type=4, attr=0xf, range=[0x000000007c000000-0x000000007c020000) (0MB)
> [    0.016004] efi: mem10: type=7, attr=0xf, range=[0x000000007c020000-0x000000007e0ad000) (32MB)
> [    0.017004] efi: mem11: type=4, attr=0xf, range=[0x000000007e0ad000-0x000000007e0ad000) (0MB)
> 							^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> 
> [    0.018003] efi: mem12: type=7, attr=0xf, range=[0x000000007e0cc000-0x000000007e0cd000) (0MB)
> 
> When we dump the EFI regions initially, it is ok.
> 
> [    0.000000] efi: mem10: type=7, attr=0xf, range=[0x000000007c020000-0x000000007e0ad000) (32MB)
> [    0.000000] efi: mem11: type=4, attr=0xf, range=[0x000000007e0ad000-0x000000007e0cc000) (0MB)
> [    0.000000] efi: mem12: type=7, attr=0xf, range=[0x000000007e0cc000-0x000000007e0cd000) (0MB)
> 
> So what basically happens is the end boundary of the region becomes the
> start, practically turning it into a 0-size one.

... and you guys suspect that some firmware code is responsible, code
that runs between the initial memory map dump, and efi_enter_virtual_mode():

https://lkml.org/lkml/2013/7/31/550

> Thanks for looking into it.

Hopefully DEBUG_GCD will tell us something.

Thanks
Laszlo
