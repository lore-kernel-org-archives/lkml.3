Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755797Ab3JHTFe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 15:05:34 -0400
Received: from mail-vb0-f45.google.com ([209.85.212.45]:41535 "EHLO
	mail-vb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754063Ab3JHTFd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 15:05:33 -0400
MIME-Version: 1.0
In-Reply-To: <20131008185154.GA8258@redhat.com>
References: <20131005234430.GA22485@localhost>
	<CA+55aFxEeKixnH7mZZs5iwupA9_GsRN0N7QZxqcTcE4RKZvTTg@mail.gmail.com>
	<20131008075151.GA15689@localhost>
	<CA+55aFykGxmaE9hq9xd+6HHFtEube_2QnB+ipW4oF71c6vyXAw@mail.gmail.com>
	<20131008185154.GA8258@redhat.com>
Date: Tue, 8 Oct 2013 12:05:32 -0700
X-Google-Sender-Auth: DvAeECJVyVq4ZBnlWmXamBK0G0g
Message-ID: <CA+55aFzaWQV-f7PynpwCNy2J5WATnYVbfVT_tnq=AJFByd-HrQ@mail.gmail.com>
Subject: Re: [x86] BUG: unable to handle kernel paging request at 00740060
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>, Richard Henderson <rth@twiddle.net>,
        Jakub Jelinek <jakub@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 8, 2013 at 11:51 AM, Oleg Nesterov <oleg@redhat.com> wrote:
>
> I do not really understand inline assembly constraints, but I'll ask
> anyway.
>
>         +#define __GEN_RMWcc(fullop, var, cc, ...) \
>         +do { \
>         + asm volatile goto (fullop "; j" cc " %l[cc_label]" \
>         + : : "m" (var), ## __VA_ARGS__ \
>               ^^^^^^^^^
>
> don't we need
>
>         "+m" (var)

We have a memory clobber instead. So the memory is marked as input and
clobbered.

And we'd love to mark it "+m", but "ask goto" cannot have outputs.

For the serializing ones, the memory clobber is ok - they have barrier
semantics anyway. But we'd actually *want* to use "asm goto" for some
cases where the memory clobber is too big of a hammer, so if we ever
get input/output constraints to "asm goto" we'll be happy.

Of course, right now it looks like we shouldn't be in a rush to use
"asm goto" at all...

                   Linus
