Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933164AbaHYR0R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 13:26:17 -0400
Received: from mail-vc0-f171.google.com ([209.85.220.171]:51128 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933039AbaHYR0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 13:26:14 -0400
MIME-Version: 1.0
In-Reply-To: <20140825170920.GA8338@redhat.com>
References: <20140824194700.GA27281@redhat.com>
	<20140824194736.GA27441@redhat.com>
	<CA+55aFyQzvvmWUDA01x69vYkrwUG07q9P3Mv5KaT31pOFsBZGQ@mail.gmail.com>
	<20140825144111.GB31880@redhat.com>
	<CA+55aFwNUF+CLWKkDBe56xOtK_JTj9zHWip+_Ep41GJniN+sPw@mail.gmail.com>
	<20140825170920.GA8338@redhat.com>
Date: Mon, 25 Aug 2014 10:26:12 -0700
X-Google-Sender-Auth: nkkj3pC7iglQ-mD3b2noLxdeShw
Message-ID: <CA+55aFw_-_h9Rj8F1H-nRm2-x8wMZ=f0ee122UXCVyJ_seuk2w@mail.gmail.com>
Subject: Re: [PATCH 2/5] x86, fpu: don't drop_fpu() in __restore_xstate_sig()
 if use_eager_fpu()
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Fenghua Yu <fenghua.yu@intel.com>, Suresh Siddha <sbsiddha@gmail.com>,
        Bean Anderson <bean@azulsystems.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 25, 2014 at 10:09 AM, Oleg Nesterov <oleg@redhat.com> wrote:
>
> I'd like to change it only because this code is the main source of the
> nasty special case, used_math() and/or __thread_has_fpu(current) can be
> false even if use_eager_fpu().

Well, if you think it is correct (apart from missing preemption), then
I disagree *violently* with your "clean it up by restoring things
twice" model.

The signal handling overhead of floating point restore is not small,
and it's not theoretical. It's actually one of the main things that
make signal handling slow. I haven't tested with the new optimized
fxrstor, but it was one of the main annoyances with the lmbench
numbers back when we used to track those closely (and which were one
of the only tests to check signal handling performance).

Of course, these days people try to avoid signals (because they are
slow), but still..

              Linus
