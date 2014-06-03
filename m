Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933187AbaFCQap (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 12:30:45 -0400
Received: from mail-ve0-f173.google.com ([209.85.128.173]:46831 "EHLO
	mail-ve0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932455AbaFCQan (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 12:30:43 -0400
MIME-Version: 1.0
In-Reply-To: <20140603080826.GK11096@twins.programming.kicks-ass.net>
References: <20140602021319.9A5F9660C19@gitolite.kernel.org>
	<20140602202204.GA26649@redhat.com>
	<20140603080826.GK11096@twins.programming.kicks-ass.net>
Date: Tue, 3 Jun 2014 09:30:42 -0700
X-Google-Sender-Auth: o_DE5-uCMrnLA0NY_l4xygZsgaA
Message-ID: <CA+55aFwu_KMU=-=gYNsy1ms1SsVjadXKwFD--qXm=ErmSM3ucA@mail.gmail.com>
Subject: Re: sched: Disallow sched_attr::sched_policy < 0
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Michael Kerrisk-manpages <mtk.manpages@gmail.com>,
        Ingo Molnar <mingo@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 3, 2014 at 1:08 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>
> Once upon a time GCC also did warns like that, but my compiler is silent
> :-(

You should be happy. The gcc warnings were shit.

Iirc, gcc literally at one point warned about things like

   unsigned int i;

   if (i < 5)

because that's comparing an unsigned type ("i") with an expression
having a signed type ("5"). Yes, technically true, but it's not
actually a useful warning.

That got fixed pretty quickly, but I think gcc *still* warns about things like

    unsigned int i;

    if (i >= 0 && i <= 6)
        ...

which is actually a very valid thing to do, and is commonly the result
of using a range-checking macro, or in general writing code so that it
is robust and doesn't care about the actual underlying type.

Warnings about robust code are f*cking broken, and easily worse than
not having the warning at all. Because it results in people removing
the range check.

Btw, -Wsign-compare still complains about

   int i;

   if (i < 0 || i > sizeof(i))
       return error;

which is another example of a f*cking broken warning. There is no way
to avoid that warning without making the code worse. That code is
_correct_, dammit, and anybody who thinks it should warn (or the
programmer should cast the sizeof to "int") is a tool and a moron.

End result: disabling "-Wsign-compare" is thus the only correct thing
to do. Sadly compiler writers don't seem to care too deeply about the
sanity of their warnings.

              Linus
