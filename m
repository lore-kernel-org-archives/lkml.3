Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752816AbaE0FWF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 01:22:05 -0400
Received: from mail-lb0-f175.google.com ([209.85.217.175]:36480 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751713AbaE0FWB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 01:22:01 -0400
MIME-Version: 1.0
In-Reply-To: <538335CD.2000101@redhat.com>
References: <CALeycy_c4P+vvWBXVYts5WaZOB-=-ovMgA1eK+A9Dk1Zs1Sptw@mail.gmail.com>
	<CALeycy8P0R-+jN2SQKR3tU3y6JWzjK9J4NbY6cuynFOPWN5XNA@mail.gmail.com>
	<538335CD.2000101@redhat.com>
Date: Tue, 27 May 2014 00:22:00 -0500
Message-ID: <CALeycy9s_NFDC+p6d8W_xYXPjXE4PFWJGz6kwvJi9EQ1Kqg_Vw@mail.gmail.com>
Subject: Re: [PATCH v2 4/4] KVM: x86: get CPL from SS.DPL
From: Wei Huang <huangwei.virt@gmail.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        "J. Kiszka" <jan.kiszka@siemens.com>, gleb@kernel.org,
        Avi Kivity <avi.kivity@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>
>>
>> Is this specified anywhere in SDM as a requirement for x86 OS? If so,
>> maybe provide a pointer to support this.
>
>
> In the case of the Intel manuals, it mentions in several places that
> SS.DPL=CPL.  All the mentions are in the VMX sections of the manual, though
> I've found non-Intel material saying that system-management mode also used
> SS.DPL as the CPL:
>
> * "SS.DPL corresponds to the logical processor’s current privilege level
> (CPL)" (footnote in 26.3.1.5 Checks on Guest Non-Register State).
>
> * "SS.DPL is always loaded from the SS access-rights field. This will be the
> current privilege level (CPL) after the VM entry completes" (26.3.2.2
> Loading Guest Segment Registers and Descriptor-Table Registers)
>
> * "VMX-critical state [...] consists of the following: (1) SS.DPL (the
> current privilege level);" (34.14.1 Default Treatment of SMI delivery [in
> VMX mode]).
>
> Instead, AMD says that "the SS segment base, limit and attributes are not
> modified" by sysret.  It almost looks as if AMD processors never use SS.DPL;
> almost because searching "SS.attr" in the AMD manuals shows that the
> processor does write to SS.attr sometimes.  In the SVM documentation, it
> says "The processor reads the current privilege level from the CPL field in
> the VMCB, not from SS.DPL.  However, SS.DPL should match the CPL field" and
> sneakily leaves out what happens if they do not match...

My guess is that SS.DPL==CPL will fail during VMRUN. This can be
quickly tested by slightly
tweaking VMCB content of a regular VM.

>
>
>>> case of SYSRET on AMD processors, which sets SS.DPL=SS.RPL from the
>>> value in the STAR MSR, but force CPL=3 (Intel instead forces
>>> SS.DPL=SS.RPL=CPL=3).
>>
>>
>> Thinking out loud here... Should we force SYSRET SS.RPL to be 3 when
>> VM updates STAR MSR? Following the same thought, does it make sense to
>> check (and force) SS.DPL==3 when STAR MSR is being updated. Will
>> forcing SYSRET SS.DPL=3 break any OS? I think any reasonable OS would
>> probably sets SS.RPL=SS.DPL=3.
>
>
> Yes, I wondered in fact how much the AMD behavior is a bug.
>
> We could emulate Intel behavior on AMD by shadowing the STAR MSR; the guest
> reads the intended SS.DPL and SS.RPL but the processor actually always runs
> with bits 49-48 of STAR set to 3.  This should ensure that CPL=SS.DPL always
> even on AMD.  I'm not sure if this has any worth though...

When SS.DPL != CPL for a VM, the worst case without STAR emulation
proposed above
is the crash of the VM, which it deserves. So I think we are fine here.

>
> Paolo
>
>
