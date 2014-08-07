Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757448AbaHGJyZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 05:54:25 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:39157 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754131AbaHGJyX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 05:54:23 -0400
MIME-Version: 1.0
In-Reply-To: <CALCETrUToxhfNy42A38R1cUU1HFrQV=jycf2LFqtPv_6b6nRRw@mail.gmail.com>
References: <1406904498-21647-1-git-send-email-dvlasenk@redhat.com>
 <1406904498-21647-4-git-send-email-dvlasenk@redhat.com> <CALCETrWA6SL52SOM3yifvc0Pjz-HTOvs8G8fXo9TqF5v=0eTzw@mail.gmail.com>
 <CAK1hOcOwD0cpVWZEV8FP40y9149feUdaxoszQC+wWQfAwU4MNQ@mail.gmail.com>
 <CALCETrV6rap+rZirLsMmdzML9rSKnWEmq-ACNLLGYgKtT-K6uA@mail.gmail.com>
 <CAK1hOcM_KLqi9MVa_b-WoimCD084F-t_qE-maEX7ibgtzg8BnQ@mail.gmail.com> <CALCETrUToxhfNy42A38R1cUU1HFrQV=jycf2LFqtPv_6b6nRRw@mail.gmail.com>
From: Denys Vlasenko <vda.linux@googlemail.com>
Date: Thu, 7 Aug 2014 11:54:01 +0200
Message-ID: <CAK1hOcMhh4iajPXrWZ3wDZwsu-twaZOoao3GRGDPBj0tdMMxhw@mail.gmail.com>
Subject: Re: [PATCH 4/5] x86: entry_64.S: always allocate complete "struct pt_regs"
To: Andy Lutomirski <luto@amacapital.net>
Cc: X86 ML <x86@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Denys Vlasenko <dvlasenk@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Alexei Starovoitov <ast@plumgrid.com>,
        Kees Cook <keescook@chromium.org>, Will Drewry <wad@chromium.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 5, 2014 at 4:53 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> On Aug 5, 2014 7:36 PM, "Denys Vlasenko" <vda.linux@googlemail.com> wrote:
>> Then old_rsp can be nuked everywhere else,
>> RESTORE_TOP_OF_STACK can be nuked, and
>> FIXUP_TOP_OF_STACK can be reduced to merely:
>>
>>         movq $__USER_DS,SS(%rsp)
>>         movq $__USER_CS,CS(%rsp)
>
> Mmm, right.  That's probably better than doing this on the fast path.

I measured it. These particular insns have a nasty huge encoding in x86 -
12 bytes each, no less!

48 c7 84 24 88 00 00 00 33 00 00 00   movq   $0x33,0x88(%rsp)
48 c7 84 24 a0 00 00 00 2b 00 00 00   movq   $0x2b,0xa0(%rsp)

With them in hot path, I measure 55.6 ns per syscall,
with them moved out of hot path it's 54.8 ns.
This is 2.70GHz CPU, so it must be 2 CPU cycles.

-- 
vda
