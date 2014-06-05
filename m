Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752036AbaFEPom (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 11:44:42 -0400
Received: from mail-ve0-f182.google.com ([209.85.128.182]:36135 "EHLO
	mail-ve0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751884AbaFEPol (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 11:44:41 -0400
MIME-Version: 1.0
In-Reply-To: <20140605090206.GA16642@pd.tnic>
References: <tip-baa916f39b50ad91661534652110df40396acda0@git.kernel.org>
 <538F9AFA.5050806@zytor.com> <20140604224920.GB4126@pd.tnic>
 <538FB775.8070405@amacapital.net> <20140605071805.GA16647@pd.tnic>
 <CAL01qpuj6jvH4XLvhHAszbqmSPXfW=VOdv+TqMwBuDnArL=ofw@mail.gmail.com> <20140605090206.GA16642@pd.tnic>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 5 Jun 2014 08:44:20 -0700
Message-ID: <CALCETrU2TZhxOZyCvBd1nLDiU4ceiSx_Sd2bsDUCX5arOFidBg@mail.gmail.com>
Subject: Re: [tip:x86/efi] x86/efi: Check for unsafe dealing with FPU state in
 irq ctxt
To: Borislav Petkov <bp@alien8.de>
Cc: Matt Fleming <matt.fleming@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Ricardo Neri <ricardo.neri-calderon@linux.intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 5, 2014 at 2:02 AM, Borislav Petkov <bp@alien8.de> wrote:
> On Thu, Jun 05, 2014 at 09:49:08AM +0100, Matt Fleming wrote:
>> On 5 June 2014 08:18, Borislav Petkov <bp@alien8.de> wrote:.
>> >
>> > How are you going to detect when to save/restore state? Do it
>> > unconditionally would probably be a no-no. Even with all that optimized
>> > XSAVE* fun.
>>
>> (I'm not talking about the crypto async code because I'm not familiar with it)
>>
>> For the EFI pstore case we'd only be using this newly allocated
>> context space if we can't do the usual FPU xsave dance. e.g. we'd be
>> adding a new feature specifically for the !irq_fpu_usable() case. Only
>> then would we do an unconditional save. It would be useful to get some
>> numbers for this but I don't think it would be too bad, especially
>> given that it's in a fatal crash handler state anyway.
>>
>> I don't think it's worth going to the trouble solely for the EFI
>> pstore code, but if it can also be used for the crypto code it might
>> be worth a look.
>
> Right, if we do this only for special, slowpath cases, then we're
> probably fine with unconditional. It would be simpler too.

Are there weird contexts from which EFI calls can happen?  It looks
like the current code isn't necessarily safe in things that aren't
normal process context but aren't interrupts either (e.g. debug traps,
#GP, etc).

I wonder if it would make sense at some point to maintain an explicit
stack of kernel entries.  There doesn't seem to be a reliable way to
answer the question of "what context am I in" from C code right now.

--Andy
