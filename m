Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756763AbaCQRBR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 13:01:17 -0400
Received: from mail-ee0-f44.google.com ([74.125.83.44]:33150 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016AbaCQRBP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 13:01:15 -0400
Message-ID: <53272A53.8090605@redhat.com>
Date: Mon, 17 Mar 2014 18:01:07 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>, Igor Mammedov <imammedo@redhat.com>,
        linux-kernel@vger.kernel.org
CC: gleb@kernel.org, tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH 0/2] KVM: x86 emulator: emulate MOVAPS and MOVAPD SSE
 instructions
References: <1394913720-6466-1-git-send-email-imammedo@redhat.com> <8569d2b4-0593-4f7a-859c-3848670f718d@email.android.com> <5326C0C3.6000105@redhat.com> <fb38ff9d-8c00-4b02-b0da-2db989f7190e@email.android.com>
In-Reply-To: <fb38ff9d-8c00-4b02-b0da-2db989f7190e@email.android.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 17/03/2014 16:16, H. Peter Anvin ha scritto:
> After seeing the sheer number of one-off additions, I'm wondering if going through the opcode map systematically and see what is still missing might not be a bad idea.

Memory access instructions always need emulation, but there aren't that 
many left.  There are some, such as MOVUPS/MOVUPD.

However, this is not the only use of emulation.  The problem stems from 
pre-Westmere Intel chips that didn't have unrestricted mode 
virtualization.  For these chips, you need to emulate all instructions 
that might be used in protected mode transitions and also, possibly, in 
big real mode.  In practice you will rarely see big real mode (the main 
exception is option ROMs, due to PMM), still every OS likes to do 
something different in their protected mode transitions so this is the 
source of most one-off additions that you have seen.

Until around 3.6, KVM used to transform big real mode into a "good" real 
mode that the processor would like, while breaking completely in big 
real mode; this is now emulate_invalid_guest_state=N.  Nowadays, it uses 
emulation, which is emulate_invalid_guest_state=Y.  As you can imagine 
it's quite slow (though some performance can certainly be scraped off 
the emulator).

If CS and possibly SS are valid real mode selectors, it should be 
possible to run big real mode at almost-full speed, taking exits only 
for memory accesses via other segment registers.  It is on my todo list, 
but not very high.  Depending on the exit overhead, it may be a better 
idea to revert the emulate_invalid_guest_state default to N and let 
people who care about big real mode specify Y.

Paolo

> On March 17, 2014 2:30:43 AM PDT, Paolo Bonzini <pbonzini@redhat.com> wrote:
>> Il 15/03/2014 23:42, H. Peter Anvin ha scritto:
>>> Stupid question... what instructions do NOT need emulsion in KVM? It
>> would seem that at least anything that touches memory would?
>>
>> Yes, indeed.  Anything that touches memory can be used on MMIO and then
>>
>> needs emulation.
>>
>> Paolo
>>
>>> On March 15, 2014 1:01:58 PM PDT, Igor Mammedov <imammedo@redhat.com>
>> wrote:
>>>> MS HCK test fails on 32-bit Windows 8.1 due to missing MOVAPS
>>>> instruction emulation, this series adds it and while at it,
>>>> it adds emulation of MOVAPD which is trivial to implement on
>>>> top of MOVAPS.
>>>>
>>>> Igor Mammedov (2):
>>>>  KVM: x86 emulator: emulate MOVAPS
>>>>  KVM: x86 emulator: emulate MOVAPD
>>>>
>>>> arch/x86/kvm/emulate.c | 8 +++++++-
>>>> 1 file changed, 7 insertions(+), 1 deletion(-)
>>>
>

