Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753485AbaGaRW2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 13:22:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21002 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751574AbaGaRW0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 13:22:26 -0400
Message-ID: <53DA7B28.701@redhat.com>
Date: Thu, 31 Jul 2014 19:21:44 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Peter Maydell <peter.maydell@linaro.org>
CC: =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        arm-mail-list <linux-arm-kernel@lists.infradead.org>,
        kvm-devel <kvm@vger.kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        open list <linux-kernel@vger.kernel.org>,
        Gleb Natapov <gleb@kernel.org>
Subject: Re: [PATCH] arm64: KVM: export current vcpu->pause state via pseudo
 regs
References: <1404914112-7298-1-git-send-email-alex.bennee@linaro.org> <53DA7583.2030504@redhat.com> <CAFEAcA9cT617t8JqOXtuO-wQ5xg5T3Sw_DUHB1fpPD6g3SSNaQ@mail.gmail.com>
In-Reply-To: <CAFEAcA9cT617t8JqOXtuO-wQ5xg5T3Sw_DUHB1fpPD6g3SSNaQ@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 31/07/2014 19:04, Peter Maydell ha scritto:
> On 31 July 2014 17:57, Paolo Bonzini <pbonzini@redhat.com> wrote:
>> Il 09/07/2014 15:55, Alex Bennée ha scritto:
>>> To cleanly restore an SMP VM we need to ensure that the current pause
>>> state of each vcpu is correctly recorded. Things could get confused if
>>> the CPU starts running after migration restore completes when it was
>>> paused before it state was captured.
>>>
>>> I've done this by exposing a register (currently only 1 bit used) via
>>> the GET/SET_ONE_REG logic to pass the state between KVM and the VM
>>> controller (e.g. QEMU).
>>>
>>> Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
>>> ---
>>>  arch/arm64/include/uapi/asm/kvm.h |  8 +++++
>>>  arch/arm64/kvm/guest.c            | 61 ++++++++++++++++++++++++++++++++++++++-
>>>  2 files changed, 68 insertions(+), 1 deletion(-)
>>
>> Since it's a pseudo register anyway, would it make sense to use the
>> existing KVM_GET/SET_MP_STATE ioctl interface?
> 
> That appears to be an x86-specific thing relating to
> IRQ chips.

No, it's not.  It's just the state of the CPU, s390 will be using it too.

On x86 the states are uninitialized (UNINITIALIZED), stopped
(INIT_RECEIVED), running (RUNNABLE), halted (HALTED).  CPU 0 starts in
RUNNABLE state, other CPUs start in UNINITIALIZED state.  There are
x86-specific cases (uninitialized) and x86-isms (the INIT_RECEIVED
name), but the idea is widely applicable.

>> Also, how is KVM/ARM
>> representing (and passing to QEMU) the halted state of the
>> VCPU?
> 
> We don't. In ARM the equivalent of x86 HLT (which is
> WFI, wait-for-interrupt) is allowed to resume at any time.
> So we don't need to care about saving and restoring
> whether we were sat in a WFI at point of migration.

What does ARM do if you have a WFI while interrupts are disabled?  On
x86 after "cli;hlt" only an NMI will wake you up.  With spurious
wakeups, it's pretty much guaranteed that you will break such "cli;hlt"
sequences.

Paolo
