Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756464Ab3JHQVz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 12:21:55 -0400
Received: from mail-vc0-f181.google.com ([209.85.220.181]:35449 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755389Ab3JHQVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 12:21:53 -0400
MIME-Version: 1.0
In-Reply-To: <20131008075151.GA15689@localhost>
References: <20131005234430.GA22485@localhost>
	<CA+55aFxEeKixnH7mZZs5iwupA9_GsRN0N7QZxqcTcE4RKZvTTg@mail.gmail.com>
	<20131008075151.GA15689@localhost>
Date: Tue, 8 Oct 2013 09:21:51 -0700
X-Google-Sender-Auth: YQbJGUBI5g7N8Pqy9bAVoQdWPS4
Message-ID: <CA+55aFykGxmaE9hq9xd+6HHFtEube_2QnB+ipW4oF71c6vyXAw@mail.gmail.com>
Subject: Re: [x86] BUG: unable to handle kernel paging request at 00740060
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Fengguang Wu <fengguang.wu@intel.com>, Richard Henderson <rth@twiddle.net>,
        Jakub Jelinek <jakub@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ Richard and Jakub added to cc, they can perhaps help or at least
point us to the right gcc person.

  Richard, Jakub, the bug is triggered by kernel commit 0c44c2d0f459
(not yet merged), see:

    http://git.kernel.org/cgit/linux/kernel/git/tip/tip.git/commit/?id=0c44c2d0f459cd7e275242b72f500137c4fa834d

  for the patch. The actual inline asm is pretty dang small, and the
non-asm-goto version works fine. Can you take a look? ]

On Tue, Oct 8, 2013 at 12:51 AM, Fengguang Wu <fengguang.wu@intel.com> wrote:
> [    9.844709] *pdpt = 00000000072c1001 *pde = 0000000000000000
>
>> That said, Fengguang, can you try two things just to check:
>>
>>  - add "cc" to the clobbers list for the asm goto (technically it
>> should be on the non-asm-goto as well, but we never had that, and
>> maybe the fact that gcc always ends up testing a register afterwards
>> hides the need for the clobber).
>>
>> So it would look like this in arch/x86/include/asm/rmwcc.h
>>
>>   #define __GEN_RMWcc(fullop, var, cc, ...) \
>>   do { \
>>       asm volatile goto (fullop "; j" cc " %l[cc_label]" \
>>           : : "m" (var), ## __VA_ARGS__ \
>>           : "memory", "cc" : cc_label); \
>>       return 0; \
>>   cc_label: \
>>       return 1; \
>>
>> (where that "cc" thing is new). I'm not sure if "cc" really matters on
>> x86 at all (it didn't use to, long long ago), but maybe it does these
>> days..
>
> Tests show that it makes no difference by adding the "cc" this way:
>
> -                       : "memory" : cc_label);                         \
> +                       : "memory", "cc" : cc_label);                           \

Ok, that was a long shot, I don't think gcc actually ever assumes cc
is live over an asm on x86.

>> If that makes no difference, please just verify that the non-asm-goto
>> version works fine, by changing the
>>
>>   #ifdef CC_HAVE_ASM_GOTO
>>
>> into a simple "#if 0" to disable the asm-goto version.
>
> Yeah, this will quiet the oops messages:
>
> -#ifdef CC_HAVE_ASM_GOTO
> +#if 0

Ok. So it looks very much like "asm goto()" is simply buggered. Too
bad, since it  generated nice clear code.

I suspect it's the memory clobber - maybe it only marks memory as
clobbered for the fallthrough case, and the actual "goto" case might
used old cached values? What do I know, it's just a theory.

We do have "asm goto" with memory clobbers elsewhere (our x86 version
of __mutex_fastpath_lock()), but that use is very limited and only
gets expanded in a single place. The new bitop cases get expanded
*everywhere*, so if there is something subtly wrong wrt code
generation that requires some particular pattern, they'd trigger it
much more easily.

Anybody have any ideas?

                    Linus
