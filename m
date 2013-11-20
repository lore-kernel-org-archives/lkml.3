Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753460Ab3KTLPw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 06:15:52 -0500
Received: from mail.skyhub.de ([78.46.96.112]:34721 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752441Ab3KTLPr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 06:15:47 -0500
Date: Wed, 20 Nov 2013 12:15:41 +0100
From: Borislav Petkov <bp@alien8.de>
To: Francis Moreau <francis.moro@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 3.12: kernel panic when resuming from suspend to RAM (x86_64)
Message-ID: <20131120111541.GA30147@pd.tnic>
References: <20131117160126.GG27323@pd.tnic>
 <CAC9WiBikz8kTAmKs1HVBmeb2Wu6hfHCh2d=w1sQC03EVHa1QOQ@mail.gmail.com>
 <20131117195358.GO27323@pd.tnic>
 <CAC9WiBggfssh+31_MqVCT-hDf2E8zTuc81q-DhLYQuVF053mEA@mail.gmail.com>
 <20131117220611.GQ27323@pd.tnic>
 <528A05D0.30907@gmail.com>
 <20131118133210.GG24851@pd.tnic>
 <528B36EA.20301@gmail.com>
 <20131119101521.GA3515@pd.tnic>
 <528C84A1.5030707@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <528C84A1.5030707@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 20, 2013 at 10:45:05AM +0100, Francis Moreau wrote:
> Unfortunately the bisect session didn't give any positive results: I
> couldn't be sure if a specific revision was good or bad because the
> bug wasn't reproductible every time.
>
> But I got a different kernel oops on my stripped system that may give
> us a clue: http://imgur.com/zdCknbY
>
> Does this help ?

Unfortunately, this is the second oops:

"Oops: 0000 [#2] ..."

The first has scrolled off but I can see the RIP: ioread32+0x40 and the
code must be:

ffffffff812a1e40 <ioread32>:
ffffffff812a1e40:       48 81 ff ff ff 03 00    cmp    $0x3ffff,%rdi
ffffffff812a1e47:       77 37                   ja     ffffffff812a1e80 <ioread32+0x40>

...

ffffffff812a1e77:       66 0f 1f 84 00 00 00    nopw   0x0(%rax,%rax,1)
ffffffff812a1e7e:       00 00 
ffffffff812a1e80:       8b 07                   mov    (%rdi),%eax			<--- faulting insn
ffffffff812a1e82:       c3                      retq   
ffffffff812a1e83:       66 66 66 66 2e 0f 1f    data32 data32 data32 nopw %cs:0x0(%rax,%rax,1)
ffffffff812a1e8a:       84 00 00 00 00 00

and judging by the instruction, that's addr in %rdi which we try to read
and I'd guess %rdi contains garbage after resume.

IOW, this looks like another corruption that happens when you suspend to
ram.

I asked you already but you didn't say:

"Also, you can check for BIOS updates for your machine and if there are,
check their changelogs whether they fix something suspend-related."

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
