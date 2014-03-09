Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752779AbaCIUIS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2014 16:08:18 -0400
Received: from mail-ea0-f177.google.com ([209.85.215.177]:61205 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752590AbaCIUHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2014 16:07:18 -0400
Message-ID: <531CC9EC.1000804@redhat.com>
Date: Sun, 09 Mar 2014 21:07:08 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        alex.williamson@redhat.com, mtosatti@redhat.com, gleb@kernel.org,
        jan.kiszka@siemens.com
Subject: Re: [PATCH 3/7] KVM: x86: Allow the guest to run with dirty debug
 registers
References: <1394192571-11056-1-git-send-email-pbonzini@redhat.com> <1394192571-11056-4-git-send-email-pbonzini@redhat.com> <20140309182825.GA11078@potion.redhat.com>
In-Reply-To: <20140309182825.GA11078@potion.redhat.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 09/03/2014 19:28, Radim Krčmář ha scritto:
>> >  	/*
>> > +	 * Do this here before restoring debug registers on the host.  And
>> > +	 * since we do this before handling the vmexit, a DR access vmexit
>> > +	 * can (a) read the correct value of the debug registers, (b) set
>> > +	 * KVM_DEBUGREG_WONT_EXIT again.
> We re-enable intercepts on the next exit for the sake of simplicity?
> (Batched accesses make perfect sense, but it seems we don't have to care
>  about DRs at all, without guest-debug.)

It's not just for the sake of simplicity.  Synchronizing debug registers 
on entry does have some cost, and it's required for running without 
debug register intercepts.  You would incur this cost always, since 
no-guest-debug is actually the common case.

We're well into diminishing returns; Alex timed this patch vs. one that 
completely ignores MOV DR exits and (to the surprise of both of us) this 
patch completely restored performance despite still having a few tens of 
thousands MOV DR exits/second.

In the problematic case, each context switch will do a save and restore 
of debug registers; that's in total 13 debug register accesses (read 6 
registers, write DR7 to disable all registers, write 6 registers 
including DR7 which enables breakpoints), all very close in time.  It's 
quite likely that the final DR7 write is very expensive (e.g. it might 
have to flush the pipeline).  Also, this test case must be very heavy on 
context switches, and each context switch already incurs a few exits 
(for example to inject the interrupt that causes it, to read the current 
time).

A different optimization could be to skip the LOAD_DEBUG_CONTROLS 
vm-entry control if DR7 == host DR7 == 0x400 && MOV DR exits are 
enabled.  Not sure it's worthwhile though, and there's also the DEBUGCTL 
MSR to take into account.  Better do these kinds of tweaks if they 
actually show up in the profile: Alex's testcase shows that when they 
do, the impact is massive.

>> +		kvm_x86_ops->sync_dirty_debug_regs(vcpu);
>
> Sneaky functionality ... it would be nicer to split 'enable DR
> intercepts' into a new kvm op.

Why?  "Disable DR intercepts" is already folded into the handler for MOV 
DR exits.

> And we don't have to modify DR intercepts then, which is probably the
> main reason why sync_dirty_debug_regs() does two things.

Another is that indirect calls are relatively expensive and add 
complexity; in this case they would always be used back-to-back.

Paolo
