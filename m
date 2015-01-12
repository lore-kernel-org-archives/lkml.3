Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753609AbbALTrQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 14:47:16 -0500
Received: from mail-lb0-f171.google.com ([209.85.217.171]:50971 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751569AbbALTrO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 14:47:14 -0500
MIME-Version: 1.0
In-Reply-To: <20150112193704.GG3904@pd.tnic>
References: <1421017655-25561-1-git-send-email-dvlasenk@redhat.com>
 <20150112192314.GF3904@pd.tnic> <CALCETrXzEPKPFKBeKF3UMduNe1ViQTC6vULEySo_0XTJcK7Qkw@mail.gmail.com>
 <20150112193704.GG3904@pd.tnic>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 12 Jan 2015 11:46:53 -0800
Message-ID: <CALCETrUVXGnqqtgw1eZRK5g0B+5vwGuvSV6dwnm5witA-fJWLQ@mail.gmail.com>
Subject: Re: [PATCH] x86: introduce push/pop macros which generate
 CFI_REL_OFFSET and CFI_RESTORE
To: Borislav Petkov <bp@alien8.de>
Cc: Denys Vlasenko <dvlasenk@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, X86 ML <x86@kernel.org>,
        Alexei Starovoitov <ast@plumgrid.com>, Will Drewry <wad@chromium.org>,
        Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2015 at 11:37 AM, Borislav Petkov <bp@alien8.de> wrote:
> Andy, please trim your replies.
>
> On Mon, Jan 12, 2015 at 11:25:39AM -0800, Andy Lutomirski wrote:
>> I think that some users don't want the CFI_REL_OFFSET.
>
> Why? I thought those two annotations are independent? As you said:
>
> "IOW, one is to keep the stack frame tracking consistent and the other
> is to tell the unwinder about the register we just saved."
>
> Sounds to me like we want both...
>

Dumb example:

    pushq_cfi $__KERNEL_DS /* ss */

This doesn't save anything that the unwinder would care about.

Better example:

    pushq_cfi \child_rip /* rip */
    CFI_REL_OFFSET    rip,0

Doing this with a macro would need a fancier macro.

Then there's crap like:

    pushq_cfi %rdi
    SCHEDULE_USER
    popq_cfi %rdi

I would need to look a lot more carefully to figure out whether this
would need CFI_REL_OFFSET.

If we actually had a DWARF unwinder in the kernel, maybe we could have
real test cases :-/

--Andy
