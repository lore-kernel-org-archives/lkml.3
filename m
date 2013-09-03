Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933094Ab3ICVj5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 17:39:57 -0400
Received: from mail-vb0-f54.google.com ([209.85.212.54]:63878 "EHLO
	mail-vb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759989Ab3ICVjn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 17:39:43 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFxE0fpdrjhG82JcwgT4jrmDXJ_dPv5FkqiVHYe3DdjtWA@mail.gmail.com>
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
	<CA+55aFxE0fpdrjhG82JcwgT4jrmDXJ_dPv5FkqiVHYe3DdjtWA@mail.gmail.com>
Date: Tue, 3 Sep 2013 14:39:42 -0700
X-Google-Sender-Auth: DuMlU5M0fLtGiQCfweZ0aSG8Dhg
Message-ID: <CA+55aFxLdUbRReRwWUTkDKCUPaV+O5eDGh0T-aghV+WuqKvUSA@mail.gmail.com>
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

On Tue, Sep 3, 2013 at 2:34 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> I'll try to hack that up too, but it's looking like it really is just
> the "lock xadd", not the memory dependency chain..

Yeah, no difference: Better code generation with my quick hack for a
percpu spinlock:

       │    ffffffff81078e70 <lg_local_lock>:
  0.59 │      push   %rbp
  0.25 │      mov    %rsp,%rbp
  0.07 │      mov    $0x100,%eax
 97.55 │      lock   xadd   %ax,%gs:(%rdi)
  0.01 │      movzbl %ah,%edx
       │      cmp    %al,%dl
  0.68 │    ↓ je     29
       │      nop
       │20:   pause
       │      mov    %gs:(%rdi),%al
       │      cmp    %dl,%al
       │    ↑ jne    20
       │29:   pop    %rbp
  0.84 │    ← retq

but the actual cost is pretty much the same:

   6.81%   lg_local_lock

so it doesn't seem to be some odd weakness of the microarchitecture.

            Linus
