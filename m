Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756227AbaE3UfA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 16:35:00 -0400
Received: from mail-ve0-f169.google.com ([209.85.128.169]:52730 "EHLO
	mail-ve0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754614AbaE3Ue6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 16:34:58 -0400
MIME-Version: 1.0
In-Reply-To: <5388E83A.5000500@zytor.com>
References: <CALCETrXef77JLoEp5hCXSdMAk7usWsL-sUG6NrcgLgrz3krfag@mail.gmail.com>
 <cover.1401464755.git.luto@amacapital.net> <2cf258df123cb24bad63c274c8563c050547d99d.1401464755.git.luto@amacapital.net>
 <5388E3EF.6030700@zytor.com> <CALCETrVvR3SaYX7jvoX_q7m=HSzt1xvrDurrOpm2XT5SG3JVqw@mail.gmail.com>
 <5388E83A.5000500@zytor.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 30 May 2014 13:34:37 -0700
Message-ID: <CALCETrWgfRiknJTQtDSAavF1695NDy-h-DW1big+65-HmEOtwg@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] x86,vdso: Fix cross-compilation from big-endian architectures
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>,
        Josh Boyer <jwboyer@fedoraproject.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 30, 2014 at 1:21 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 05/30/2014 01:09 PM, Andy Lutomirski wrote:
>>>
>>> I came up with the following, it seems like a reasonable simplification:
>>>
>>>> #define _LE(x, bits, ifnot)                                           \
>>>>       __builtin_choose_expr(                                          \
>>>>               (sizeof(x) == bits/8),                                  \
>>>>               (__typeof__(x))le##bits##toh(x), ifnot)
>>
>> This will do awful things if x is a floating-point type, and, for
>> integers, the cast is probably unnecessary.  But it should be okay.
>>
>
> I mostly wanted to preserve the signedness.  Yes, if we care about
> floating-point it gets trickier.
>
> At some point hopefully there will be a native C feature to handle this
> crap.
>
>>>> extern void bad_le(uint64_t);
>>
>> If this ever goes in a common header, then we should do the
>> __attribute__((error)) thing.  I wonder if it would ever make sense to
>> have __LINUX_HOSTPROG__ and make some of the basic headers work.  Hmm.
>>
>>>> #define _LAST_LE(x)                                                   \
>>>>       __builtin_choose_expr(sizeof(x) == 1, (x), bad_le(x))
>>>>
>>>> #define LE(x)                                                         \
>>>>       _LE(x, 64, _LE(x, 32, _LE(x, 16, _LAST_LE(x))))
>>>
>>> What do you think?
>>
>> My only real real objection is that _LE sounds like converting *to*
>> little-endian to me.  Admittedly, that's the same thing on any
>> remotely sane architecture, but still.
>
> GET_LE() then?

Sounds good.

Are you planning on writing the patch?

I think my v2 is good -- the only diff I could find in my image.c
files and Stephen's was in the alt_xyz output, and I think I fixed
that in v2.

--Andy
