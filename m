Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755797AbaJ2IHC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 04:07:02 -0400
Received: from mail-lb0-f173.google.com ([209.85.217.173]:60216 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755554AbaJ2IG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 04:06:57 -0400
MIME-Version: 1.0
In-Reply-To: <20141028220731.GI10873@pd.tnic>
References: <20141008151730.GB16892@pd.tnic>
	<CA+rthh_Q0HQfLX6P3kcuOUwggjSnhYGCc5YJNOn0UCCRPZbaxA@mail.gmail.com>
	<20141008222619.GG16892@pd.tnic>
	<20141012125515.GA32045@jig.fritz.box>
	<20141028185756.GD10873@pd.tnic>
	<CA+rthh9qePkJogFDT+ttSLvYPvJrAM6CXMJ407Hq3PjcRw9WTw@mail.gmail.com>
	<20141028201342.GG10873@pd.tnic>
	<CA+rthh9LSRm12qYORAd5BWzpw7DEP7hqHLA3EDdfUDxwx-4=2g@mail.gmail.com>
	<20141028212642.GH10873@pd.tnic>
	<CA+rthh-Tk3PO0qUeyLzxggCYOhr5D4EvPjKR+jhmjdPXi4yu=Q@mail.gmail.com>
	<20141028220731.GI10873@pd.tnic>
Date: Wed, 29 Oct 2014 09:06:55 +0100
Message-ID: <CA+rthh_t7gw=+j5M91hGv29py7JpH7Whffjakp4YS5zS1i15jw@mail.gmail.com>
Subject: Re: [PATCHv2 1/3] x86, ptdump: Add section for EFI runtime services
From: Mathias Krause <minipli@googlemail.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Matt Fleming <matt@console-pimps.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        x86-ml <x86@kernel.org>, Matt Fleming <matt.fleming@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28 October 2014 23:07, Borislav Petkov <bp@alien8.de> wrote:
> On Tue, Oct 28, 2014 at 10:49:36PM +0100, Mathias Krause wrote:
>> Sync only data or kernel code, too?
>
> Data only should be enough.

No, not really. This is why:

1/ When setting up the virtual mapping via a call to the
SetVirtualAddressMap EFI service we're running with interrupts
enabled, as we skip to disable them in efi_call_phys_prolog(). This
means, IRQs might happen and, in fact, they *do* happen. I know for
sure, because I had to debug an issue with a "wbinvd" instruction
within that EFI code delaying execution long enough, that the timer
interrupt triggers. So we should be prepared to handle those by having
the kernel mapped during the EFI call or bad things will happen.
2/ When the EFI code traps, e.g., because the EFI code is buggy or the
arguments the kernel provides are borked, not having a trap handler
for #PF, #GP, #UD, you name it, will make the system just triple fault
and reset. From a user perspective, that's not nice. ;)

So, having the kernel mapped during EFI calls is kinda required. I
rather prefer seeing the system panic with a backtrace instead of just
triple faulting.

>> Really, I'd just map the EFI RT service virtual mappings "somewhere"
>> but at pgd[511] and have pgd[511] initially set up as
>> init_level4_pgt[511]. Then, thing should "just work"(TM).
>
> Nah, nothing with EFI just works :-)

Yeah, learned it the hard way, too ;)

>
>> If you fear the EFI code might do harm to the kernel code/data, then
>> you've lost anyway. Nothing will prevent the EFI code from doing nasty
>> things -- like setting up its own mappings to tamper with the kernel's
>> memory.
>
> Sure, nothing would surprise me anymore. However, I'd prefer to not be
> an enabler. :)

We have the EFI code 'n data mapped RWX into the kernel address space
at predictable addresses, now. It can't get any worse ;)


Regards,
Mathias
