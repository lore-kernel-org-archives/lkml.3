Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754224Ab3L0DTO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 22:19:14 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48991 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754125Ab3L0DTM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 22:19:12 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <52BCCDC4.1090409@zytor.com>
References: <CA+55aFxZ2u+M72u3HSD7TVY2+WRRi27pYC=_4Wawr5y1m8DfnQ@mail.gmail.com> <20131224204625.GB20471@gmail.com> <CA+55aFzPBdbfKovMT8Edr4SmE2_=+OKJFac9XW2awegogTkVTA@mail.gmail.com> <52BCCDC4.1090409@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [RFC] speeding up the stat() family of system calls...
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Thu, 26 Dec 2013 19:18:34 -0800
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>
CC: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Al Viro <viro@zeniv.linux.org.uk>,
        the arch/x86 maintainers <x86@kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-ID: <2a58cbc0-77a1-4770-a399-ef820c88c1bd@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok the sign bit doesn't really make any sense on second thought... to work with set_fs() we have to load something from memory anyway and then we might as well do a compare...

"H. Peter Anvin" <hpa@zytor.com> wrote:
>On 12/26/2013 11:00 AM, Linus Torvalds wrote:
>> 
>> Interestingly, looking at the cp_new_stat() profiles, the games we
>> play to get efficient range checking seem to actually hurt us. Maybe
>> it's the "sbb" that is just expensive, or maybe it's turning a (very
>> predictable) conditional branch into a data dependency chain instead.
>> Or maybe it's just random noise in my profiles that happened to make
>> those sbb's look bad.
>> 
>
>I'm not at all surprised... there is a pretty serious data dependency
>chain here and in the end we end up manifesting a value in a register
>that has to be tested even though it is available in the flags.  Inline
>assembly also means the compiler can't optimize it at all.
>
>I have to wonder if we actually have to test the upper limit, though:
>we
>can always guarantee a guard zone between user space and kernel space,
>and thus guarantee either a #PF or #GP if someone tries to overflow
>user
>space.  Testing just the lower limit would be much cheaper, especially
>on 64 bits where we can simply test the sign bit.
>
>What do you think?
>
>	-hpa

-- 
Sent from my mobile phone.  Please pardon brevity and lack of formatting.
