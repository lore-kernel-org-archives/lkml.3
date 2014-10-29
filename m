Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933674AbaJ2OU5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 10:20:57 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:45094 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932475AbaJ2OUz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 10:20:55 -0400
Date: Wed, 29 Oct 2014 14:20:52 +0000
From: Matt Fleming <matt@console-pimps.org>
To: Mathias Krause <minipli@googlemail.com>
Cc: Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        x86-ml <x86@kernel.org>, Matt Fleming <matt.fleming@intel.com>
Subject: Re: [PATCHv2 1/3] x86, ptdump: Add section for EFI runtime services
Message-ID: <20141029142052.GR12020@console-pimps.org>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+rthh9LSRm12qYORAd5BWzpw7DEP7hqHLA3EDdfUDxwx-4=2g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Oct, at 10:14:25PM, Mathias Krause wrote:
> 
> Mapping the kernel into the EFI page table may help ;) Then the
> kernel's #PF handler would be present and able to print a register
> dump, at least.
 
The kernel is already mapped into the EFI page table.

> So, assuming you're not mapping the EFI virtual mappings below the
> pgd[511] hierarchy, making pgd[511] equal init_level4_pgt[511] should
> help in this case. In fact, you need to map portions of the kernel
> into the EFI page table anyway. Otherwise the EFI code wouldn't be
> able to access, e.g., the data it should write to NVRAM. So the EFI
> code would just trap and trigger a #PF -- and because of the missing
> #PF handler, a #DF -- and because of the missing #DF handler the
> triple fault. ;)
 
Exactly.

We don't setup a separate page table for EFI calls for any kind of
isolation, we do it to make use of the existing 1:1 mappings in
trampoline_pgd because some firmware directly reference physical
addresses at runtime. It actually doesn't work too well in practice,
because you soon hit other issues on those firmware, but there you go.

So the fact that we have EFI mappings in init_level4_pgt[] isn't
indicative of any kind of bug, it's potentially a bit unclean, but
that's about it.

-- 
Matt Fleming, Intel Open Source Technology Center
