Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933766AbaJ2PT3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 11:19:29 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:32951 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933194AbaJ2PT2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 11:19:28 -0400
MIME-Version: 1.0
In-Reply-To: <20141029142052.GR12020@console-pimps.org>
References: <20141007150132.GA7307@nazgul.tnic>
	<20141007170748.GA25767@jig.fritz.box>
	<20141008151730.GB16892@pd.tnic>
	<CA+rthh_Q0HQfLX6P3kcuOUwggjSnhYGCc5YJNOn0UCCRPZbaxA@mail.gmail.com>
	<20141008222619.GG16892@pd.tnic>
	<20141012125515.GA32045@jig.fritz.box>
	<20141028185756.GD10873@pd.tnic>
	<CA+rthh9qePkJogFDT+ttSLvYPvJrAM6CXMJ407Hq3PjcRw9WTw@mail.gmail.com>
	<20141028201342.GG10873@pd.tnic>
	<CA+rthh9LSRm12qYORAd5BWzpw7DEP7hqHLA3EDdfUDxwx-4=2g@mail.gmail.com>
	<20141029142052.GR12020@console-pimps.org>
Date: Wed, 29 Oct 2014 16:19:26 +0100
Message-ID: <CA+rthh-x2WbooWpP+wFLe99mSUczUan8Oof=pbHKZhTeir16rg@mail.gmail.com>
Subject: Re: [PATCHv2 1/3] x86, ptdump: Add section for EFI runtime services
From: Mathias Krause <minipli@googlemail.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        x86-ml <x86@kernel.org>, Matt Fleming <matt.fleming@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29 October 2014 15:20, Matt Fleming <matt@console-pimps.org> wrote:
> On Tue, 28 Oct, at 10:14:25PM, Mathias Krause wrote:
>>
>> Mapping the kernel into the EFI page table may help ;) Then the
>> kernel's #PF handler would be present and able to print a register
>> dump, at least.
>
> The kernel is already mapped into the EFI page table.

I was referring to Boris' ongoing work, trying to completely separate
the EFI page table from the kernel's. He was hinting to only map the
data parts of the kernel into the EFI page table and only for the
actual EFI call. But that's not such a good idea, IMHO, as explained
below.

>
>> So, assuming you're not mapping the EFI virtual mappings below the
>> pgd[511] hierarchy, making pgd[511] equal init_level4_pgt[511] should
>> help in this case. In fact, you need to map portions of the kernel
>> into the EFI page table anyway. Otherwise the EFI code wouldn't be
>> able to access, e.g., the data it should write to NVRAM. So the EFI
>> code would just trap and trigger a #PF -- and because of the missing
>> #PF handler, a #DF -- and because of the missing #DF handler the
>> triple fault. ;)
>
> Exactly.

>
> We don't setup a separate page table for EFI calls for any kind of
> isolation, we do it to make use of the existing 1:1 mappings in
> trampoline_pgd because some firmware directly reference physical
> addresses at runtime.

Ah, that makes sense now. I though we need those only for the
SetVirtualAddressMap transition.

> It actually doesn't work too well in practice,
> because you soon hit other issues on those firmware, but there you go.
>
> So the fact that we have EFI mappings in init_level4_pgt[] isn't
> indicative of any kind of bug, it's potentially a bit unclean, but
> that's about it.

Well, not only unclean but ugly, because of the RWX mappings. That's
all I was complaining about. I tried to make those r/o and nx during
normal operation and only change the attributes to RWX for the EFI
call but unfortunately set_memory_{x,nx,ro,rw} don't like to be called
with interrupts/preemption disabled.
Maybe moving the EFI virtual mappings to another pgd slot will make it
possible as in this case only the pgd entry needs to be modified. But
I leave those experiments to Boris. I had enough "fun" with EFI
already ;)

Regards,
Mathias
