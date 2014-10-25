Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752767AbaJYT6C (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2014 15:58:02 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:62777 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751014AbaJYT6A convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2014 15:58:00 -0400
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 8.0 \(1990.1\))
Subject: Re: [PATCH 05/14] KVM: x86: Emulator fixes for eip canonical checks on near branches
From: Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <544A922B.5070505@amacapital.net>
Date: Sat, 25 Oct 2014 22:57:55 +0300
Cc: Paolo Bonzini <pbonzini@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>, Nadav Amit <namit@cs.technion.ac.il>,
        stable@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <4C1F2620-8DFD-4F62-B9D3-4B241459AEE0@gmail.com>
References: <1414163245-18555-1-git-send-email-pbonzini@redhat.com> <1414163245-18555-6-git-send-email-pbonzini@redhat.com> <544A922B.5070505@amacapital.net>
To: Andy Lutomirski <luto@amacapital.net>
X-Mailer: Apple Mail (2.1990.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> On Oct 24, 2014, at 20:53, Andy Lutomirski <luto@amacapital.net> wrote:
> 
> On 10/24/2014 08:07 AM, Paolo Bonzini wrote:
>> From: Nadav Amit <namit@cs.technion.ac.il>
>> 
>> Before changing rip (during jmp, call, ret, etc.) the target should be asserted
>> to be canonical one, as real CPUs do.  During sysret, both target rsp and rip
>> should be canonical. If any of these values is noncanonical, a #GP exception
>> should occur.  The exception to this rule are syscall and sysenter instructions
>> in which the assigned rip is checked during the assignment to the relevant
>> MSRs.
> 
> Careful here.  AMD CPUs (IIUC) send #PF (or maybe #GP) from CPL3 instead
> of #GP from CPL0 on sysret to a non-canonical address.  That behavior is
> *far* better than the Intel behavior, and it may be important.
I wasn’t aware of this discrepancy, and it is really not written clearly in AMD manual (I have to take your word). It is possible AMD decided to inject #GP from CPL3 (#PF makes no sense).

Anyhow, I think it is much harder to emulate AMD’s behaviour on Intel. Theoretically, the easy way would be for the host to set a non-canonical guest RIP/RSP and inject #GP, but Intel CPUs don’t allow the host to do so. Instead, the host needs to emulate the entire exception injection. This is very hard and error-prone process due to the variety of scenarios (interrupt/task-gate on the IDT, #DF, nested-exceptions, etc.)


> 
> If an OS relies on that behavior on AMD CPUs, and guest ring 3 can force
> guest ring 0 to do an emulated sysret to a non-canonical address, than
> the guest ring3 code can own the guest ring0 code.
> 
> —Andy

Sysexit (I mistakenly wrote sysret on the description), out of all the control transfer instructions, seems the hardest to exploit, since it must be executed in CPL0.
Remember that this bug does not result in host crashing, but in guest crashing: If guest userspace is able to cause KVM to emulate a jump instruction to a non-canonical address, it can crash the entire guest (by preventing VM-entry from succeeding). To use sysexit for such exploit, the guest userspace needs also to somehow fool the guest kernel into returning into non-canonical RIP.

Nadav