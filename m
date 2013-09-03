Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760728Ab3ICVel (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 17:34:41 -0400
Received: from mail-ve0-f181.google.com ([209.85.128.181]:55551 "EHLO
	mail-ve0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753265Ab3ICVej convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 17:34:39 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFxjkzhdZqayiD9_f_tD3T9UJC2whVie-0K_bzdpogCF5Q@mail.gmail.com>
References: <CA+55aFzkZi6Q1bwSZUJxyfqUgLS05icjrObdCxC+4S-3Tup9Ew@mail.gmail.com>
	<CA+55aFzsXwFkYsWY45ZNTaVFC+-1Yh9nxx=NLhv+NxGmQAKHTg@mail.gmail.com>
	<20130901233005.GX13318@ZenIV.linux.org.uk>
	<CA+55aFyzas75yYP+AiwOxsAg5sG3KU+KEmO+ny=dn0-jxqUt5Q@mail.gmail.com>
	<CA+55aFyodR650Y8yXXenH1XHo-__5avng1WSK=AiSJx4mYy25g@mail.gmail.com>
	<20130902070538.GA31639@gmail.com>
	<CA+55aFyCBoeqceQcxA3JZ-k8a4uLbHf3N4rNmTZ4oh9XA7akEA@mail.gmail.com>
	<20130903101522.GA22369@gmail.com>
	<CA+55aFzhbhYK27n9C7WOgf=0NcmewpE+J6giKQhjAgare52gFg@mail.gmail.com>
	<CA+55aFxGWKJwo1CfS3EJFagUb+JRtc+URJOu2yz2RztWWrkraA@mail.gmail.com>
	<20130903191950.GC30757@gmail.com>
	<CA+55aFz2PmfdaaMUNR8aMn-Hcf8FjsydM7fF28WxZDhBZADHxw@mail.gmail.com>
	<CA+55aFxjkzhdZqayiD9_f_tD3T9UJC2whVie-0K_bzdpogCF5Q@mail.gmail.com>
Date: Tue, 3 Sep 2013 14:34:38 -0700
X-Google-Sender-Auth: z4-Zm2AQ6rh3IcWkpUpTK-kHuvk
Message-ID: <CA+55aFxE0fpdrjhG82JcwgT4jrmDXJ_dPv5FkqiVHYe3DdjtWA@mail.gmail.com>
Subject: Re: [PATCH v7 1/4] spinlock: A new lockref structure for lockless
 update of refcount
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Sedat Dilek <sedat.dilek@gmail.com>,
        Waiman Long <waiman.long@hp.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Jeff Layton <jlayton@redhat.com>, Miklos Szeredi <mszeredi@suse.cz>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 3, 2013 at 2:13 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> This is the one that actually compiles.  Whether it *works* is still a
> total mystery.

It generates ok code, and it booted, so it seems to work at least for my config.

However, it seems to make no performance-difference what-so-ever, and
lg_local_lock is still using about 7% cpu per the profiles.

The code generation is slightly better, but the profile looks the same:

       │    ffffffff81078e70 <lg_local_lock>:
  0.62 │      push   %rbp
  0.28 │      mov    %rsp,%rbp
  0.22 │      add    %gs:0xcd48,%rdi
  0.27 │      mov    $0x100,%eax
 97.22 │      lock   xadd   %ax,(%rdi)
  0.01 │      movzbl %ah,%edx
       │      cmp    %al,%dl
  0.56 │    ↓ je     29
       │      xchg   %ax,%ax
  0.00 │20:   pause
  0.00 │      movzbl (%rdi),%eax
       │      cmp    %dl,%al
       │    ↑ jne    20
       │29:   pop    %rbp
  0.81 │    ← retq

but it still obviously doesn't do the "lock xadd %ax,%gs:(%rdi)"
(without the preceding 'add') that would be the optimal code.

I'll try to hack that up too, but it's looking like it really is just
the "lock xadd", not the memory dependency chain..

            Linus
