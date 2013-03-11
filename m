Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752853Ab3CKO2J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 10:28:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:65190 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751105Ab3CKO2I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 10:28:08 -0400
Message-ID: <513DE9F3.9000802@redhat.com>
Date: Mon, 11 Mar 2013 15:28:03 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130219 Thunderbird/17.0.3
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, mtosatti@redhat.com,
        jan.kiszka@siemens.com
Subject: Re: [PATCH] x86: kvm: reset the bootstrap processor when it gets
 an INIT
References: <20130310114646.GM11223@redhat.com> <513C9E82.1020304@redhat.com> <20130310153540.GL24444@redhat.com> <513CC08B.2040800@redhat.com> <20130310181035.GM24444@redhat.com> <513DAE8F.3050102@redhat.com> <20130311102852.GE31619@redhat.com> <513DBF45.9030803@redhat.com> <20130311115144.GG31619@redhat.com> <513DDCC2.9070807@redhat.com> <20130311135441.GN31619@redhat.com>
In-Reply-To: <20130311135441.GN31619@redhat.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 11/03/2013 14:54, Gleb Natapov ha scritto:
>> Setting the mp_state to INIT_RECEIVED is that interface, and it already
>> works, for APs at least.  This patch extends it to work for the BSP as well.
>
> It does not for AP either. If AP has vmx on mp_sate should not be set to
> INIT_RECEIVED. mp_sate is a state as you can see from its name and we
> already had a discussion on the generic device API about importance of
> separating sending commands from setting state. There is a difference
> between setting mp_state during migration and signaling INIT#.

What does migration have to do with this?

>> In the corresponding userspace patch, I don't need to touch the CPU
>> state at all.  I can just signal the kernel.  If I touch the CPU, I'll
>> break the nested case, no matter how it is implemented.  So far, the
>> userspace did not have to worry about nested, and that's something that
>> should be kept that way.
> We are discussing two different things here. I'll try to separate them.
> 1. BSP is broken WRT #INIT
> 2. nested is broken WRT #INIT
> 
> You are fixing 1 with your patches, for that I proposed much easier
> solution (at last from kernel point of view): if BSP reset it in
> userspace and make it runnable. Nested virt is still broken, but this is
> not what you are fixing.

It's not what I'm fixing, but I don't want to make the fix for nested
virt unnecessarily more complicated.  Nested virt needs to know about
INIT and SIPI; redefining the meaning of INIT_RECEIVED and SIPI_RECEIVED
makes it more complicated to reflect these events to L1.

> For 2 much more involved fix is needed. Jan fixes it and it will require
> signaling INIT# from userspace by other means than mp_sate because
> signaling INIT# does not automatically means that mp_sate changes to
> INIT_RECEIVED.

In your interpretation of INIT_RECEIVED, no.  In mine, yes...

>> If we move away from the INIT_RECEIVED and SIPI_RECEIVED states for
>> in-kernel APIC -> VCPU communication, then the KVM_SET_MP_STATE ioctl
>> will have to convert them to the right bits in the requests field or in
>> the APIC state.  But I'm starting to see less benefit from moving away
>> from mp_state.
>>
> We are not moving away from mp_state, we are moving away from using
> mp_state for signaling

That's what I meant; sorry for the unclear abbreviation.

> because with nested virt INIT does not always
> change mp_state

Why not?  It does change mp_state, it changes how you react to the
change.  Which is why it's good to have the reset done in kernel space,
not in user space.

Paolo

> , not only that it can change mp_state long after signal
> is received after vmx off is done.
> 
> --
> 			Gleb.
> 

