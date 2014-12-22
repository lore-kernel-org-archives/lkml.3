Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752828AbaLVXb6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 18:31:58 -0500
Received: from mail-lb0-f173.google.com ([209.85.217.173]:35181 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751187AbaLVXb4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 18:31:56 -0500
MIME-Version: 1.0
In-Reply-To: <5498A5EC.4080101@redhat.com>
References: <CALCETrV4Bhc=pwjJR-S7dfgcR7n0xKtj0o=ofOxCfJmnVFcjGw@mail.gmail.com>
 <20141222133430.GA23631@amt.cnet> <CALCETrXU+Z_t3qon+DR1hUiqSgpWLe9w74guBxbDG68ytM0icg@mail.gmail.com>
 <54989FF0.3090300@redhat.com> <CALCETrXzKZ=RhT2h32QxCskY5_hWtNQOYMnKcaRXCWRtQCta7g@mail.gmail.com>
 <5498A5EC.4080101@redhat.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 22 Dec 2014 15:31:33 -0800
Message-ID: <CALCETrWmKGA-y=VyA3vz+ESprios5xytDUjS_=nQrphLdjVDew@mail.gmail.com>
Subject: Re: Cleaning up the KVM clock
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 22, 2014 at 3:14 PM, Paolo Bonzini <pbonzini@redhat.com> wrote:
>
>
> On 23/12/2014 00:00, Andy Lutomirski wrote:
>> On Mon, Dec 22, 2014 at 2:49 PM, Paolo Bonzini <pbonzini@redhat.com> wrote:
>>>
>>>
>>> On 22/12/2014 17:03, Andy Lutomirski wrote:
>>>> This is wrong.  The guest *kernel* might not see the intermediate
>>>> state because the kernel (presumably it disabled migration while
>>>> reading pvti), but the guest vdso can't do that and could very easily
>>>> observe pvti while it's being written.
>>>
>>> No.  kvm_guest_time_update is called by vcpu_enter_guest, while the vCPU
>>> is not running, so it's entirely atomic from the point of view of the guest.
>>
>> Which vCPU?  Unless kvm_guest_time_update freezes all of the vcpus,
>> then there's a race:
>>
>> vCPU 0 guest: __getcpu
>> vdso thread migrates to vCPU 1
>> vCPU 0 exits
>> host starts writing pvti for vCPU 0
>> vdso thread starts reading pvti
>> host finishes writing pvti for vCPU 0
>> vCPU 0 resumes
>> vdso migrates back to vCPU 0
>> __getcpu returns 0
>>
>> and we fail.
>
> Yes, it does.  See kvm_gen_update_masterclock.
>
> See also http://www.spinics.net/lists/kvm/msg95533.html for some
> discussion about KVM_REQ_MCLOCK_INPROGRESS.

Ah.  Assuming that works, then most of my patches are unnecessary.
But then I have a different question: why do we bother doing the
__getcpu at all?  Can we rely on cpu 0's pvti to be appropriate for
all of the vcpus to use if the stable bit is set?

>
>> I'm having a hard time testing, since KVM on 3.19-rc1 appears to be
>> entirely unusable.  No matter what I do, I get this very early in
>> guest boot:
>>
>> KVM internal error. Suberror: 1
>> emulation failure
>> EAX=000dee58 EBX=00000000 ECX=00000000 EDX=00000cfd
>> ESI=00000059 EDI=00000000 EBP=00000000 ESP=00006fc4
>> EIP=000f17f4 EFL=00010012 [----A--] CPL=0 II=0 A20=1 SMM=0 HLT=0
>> ES =0010 00000000 ffffffff 00c09300 DPL=0 DS   [-WA]
>> CS =0008 00000000 ffffffff 00c09b00 DPL=0 CS32 [-RA]
>> SS =0010 00000000 ffffffff 00c09300 DPL=0 DS   [-WA]
>> DS =0010 00000000 ffffffff 00c09300 DPL=0 DS   [-WA]
>> FS =0010 00000000 ffffffff 00c09300 DPL=0 DS   [-WA]
>> GS =0010 00000000 ffffffff 00c09300 DPL=0 DS   [-WA]
>> LDT=0000 00000000 0000ffff 00008200 DPL=0 LDT
>> TR =0000 00000000 0000ffff 00008b00 DPL=0 TSS32-busy
>> GDT=     000f6c58 00000037
>> IDT=     000f6c96 00000000
>> CR0=60000011 CR2=00000000 CR3=00000000 CR4=00000000
>> DR0=0000000000000000 DR1=0000000000000000 DR2=0000000000000000
>> DR3=0000000000000000
>> DR6=00000000ffff0ff0 DR7=0000000000000400
>> EFER=0000000000000000
>> Code=e8 75 fc ff ff 89 f2 a8 10 89 d8 75 0a b9 74 17 ff ff ff d1 <5b>
>> 5e c3 5b 5e e9 76 ff ff ff 57 56 53 8b 35 38 65 0f 00 85 f6 0f 88 be
>> 00 00 00 0f b7 f6
>>
>> and it sometimes comes with a lockdep splat, too.
>
> I can look at it tomorrow.  Does commit
> 2c4aa55a6af070262cca425745e8e54310e96b8d work for you?

Nope.

Running:

qemu-system-x86_64 -machine accel=kvm:tcg -cpu host -parallel none
-net none -echr 1 -serial none -chardev
stdio,id=console,signal=off,mux=on -serial chardev:console -mon
chardev=console -vga none -display none

from L1 where L1 is 3.19-rc1 or
2c4aa55a6af070262cca425745e8e54310e96b8d and L0 is a good Fedora
kernel results in the same failure after a couple of seconds.  This is
on Sandy Bridge Extreme.

I tried 3.19-rc1 on bare metal earlier today, and it didn't work any better.

--Andy

>
> Paolo



-- 
Andy Lutomirski
AMA Capital Management, LLC
