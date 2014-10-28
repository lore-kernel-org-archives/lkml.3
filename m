Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752201AbaJ1Ts2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 15:48:28 -0400
Received: from mail-la0-f42.google.com ([209.85.215.42]:63107 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855AbaJ1TsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 15:48:25 -0400
MIME-Version: 1.0
In-Reply-To: <20141028185756.GD10873@pd.tnic>
References: <1411313216-2641-1-git-send-email-minipli@googlemail.com>
	<1411313216-2641-2-git-send-email-minipli@googlemail.com>
	<20141003134707.GJ14343@console-pimps.org>
	<20141007150132.GA7307@nazgul.tnic>
	<20141007170748.GA25767@jig.fritz.box>
	<20141008151730.GB16892@pd.tnic>
	<CA+rthh_Q0HQfLX6P3kcuOUwggjSnhYGCc5YJNOn0UCCRPZbaxA@mail.gmail.com>
	<20141008222619.GG16892@pd.tnic>
	<20141012125515.GA32045@jig.fritz.box>
	<20141028185756.GD10873@pd.tnic>
Date: Tue, 28 Oct 2014 20:48:23 +0100
Message-ID: <CA+rthh9qePkJogFDT+ttSLvYPvJrAM6CXMJ407Hq3PjcRw9WTw@mail.gmail.com>
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

On 28 October 2014 19:57, Borislav Petkov <bp@alien8.de> wrote:
> [...]
>
> Ok, thanks for refreshing this for me, your patch is good, so
>
> Acked-by: Borislav Petkov <bp@suse.de>

Thanks. But as you said, the EFI mappings shouldn't be in the kernel's
page table in the first place, so I'd rather see a patch doing that
instead. But, in the meantime, this patch is valid, as it shows the
"status quo".

> What this whole story shows, however, is that the EFI mappings are in
> fact in the kernel page table and this shouldn't be IMO - I'd like to
> very much have them split because otherwise there's no need to switch
> page tables at all.

Indeed.

> And besides, having UEFI in its own address space is
> a good thing in itself anyway.
>
> So, I've already hacked up something to have a completely separate EFI
> page table - need to find out why it doesn't work yet

I tried so too but failed early as well. I tried putting the EFI
virtual mappings not in trampoline_pgd[511] but trampoline_pgd[510].
However, that didn't work out. I got page faults when trying to invoke
EFI functions, as, apparently, efi.systab was only mapped in the EFI
page table but not the kernel's page table -- at least not at the same
address. So when efi_call_virt() tries to dereference
efi.systab->runtime->f, it just traps.
I tried to hack around that by fiddling with get_systab_virt_addr() to
make it point to the direct mapping for the phys_addr but failed on
the first few attempts to get the math right. Then I noticed it was
way to late to hack EFI code and fell asleep. Next day I just gave up
and 'git reset --hard HEAD'. :(

> but qemu was
> b0rked until recently so we had to deal with that first... bla bla.

Debian's version of qemu + OVMF works fine here. Probably slightly
outdated but still good enough for testing EFI stuff ;)


Regards,
Mathias
