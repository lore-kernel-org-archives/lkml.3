Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756544Ab3JGSrn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 14:47:43 -0400
Received: from mail-vc0-f180.google.com ([209.85.220.180]:46401 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752518Ab3JGSrk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 14:47:40 -0400
MIME-Version: 1.0
In-Reply-To: <20131005234430.GA22485@localhost>
References: <20131005234430.GA22485@localhost>
Date: Mon, 7 Oct 2013 11:47:39 -0700
X-Google-Sender-Auth: jMTIO0gF7vXjw-QUsVl5ZFHA0uQ
Message-ID: <CA+55aFxEeKixnH7mZZs5iwupA9_GsRN0N7QZxqcTcE4RKZvTTg@mail.gmail.com>
Subject: Re: [x86] BUG: unable to handle kernel paging request at 00740060
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Fengguang Wu <fengguang.wu@intel.com>, Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 5, 2013 at 4:44 PM, Fengguang Wu <fengguang.wu@intel.com> wrote:
>
> I got the below dmesg and the first bad commit is
>
> commit 0c44c2d0f459 ("x86: Use asm goto to implement better modify_and_test() functions"

Hmm. I'm looking at the final version of that patch, and I'm not
seeing anything wrong. It may trigger a compiler bug - there aren't
that many "asm goto" users, and using them for the bitops adds a lot
of new cases.

Your oops makes very little sense, it looks like task_work_run() just
called out to random crap, probably because the work was already
released, so "work->func()" ends up being bad. I'm adding Oleg to the
participants anyway, just in case there is some race. The comment says
that it can race with task_work_cancel() playing with *work. Oleg,
comments?

However, I don't see any actual bit-op code in task_work_run() itself,
so it's something else that got miscompiled and corrupted memory. In
that respect, the oops you have looks more like the oopses you got
with DEBUG_KOBJECT_RELEASE. Are you sure that wasn't set?

That said, Fengguang, can you try two things just to check:

 - add "cc" to the clobbers list for the asm goto (technically it
should be on the non-asm-goto as well, but we never had that, and
maybe the fact that gcc always ends up testing a register afterwards
hides the need for the clobber).

So it would look like this in arch/x86/include/asm/rmwcc.h

  #define __GEN_RMWcc(fullop, var, cc, ...) \
  do { \
      asm volatile goto (fullop "; j" cc " %l[cc_label]" \
          : : "m" (var), ## __VA_ARGS__ \
          : "memory", "cc" : cc_label); \
      return 0; \
  cc_label: \
      return 1; \

(where that "cc" thing is new). I'm not sure if "cc" really matters on
x86 at all (it didn't use to, long long ago), but maybe it does these
days..

If that makes no difference, please just verify that the non-asm-goto
version works fine, by changing the

  #ifdef CC_HAVE_ASM_GOTO

into a simple "#if 0" to disable the asm-goto version.

            Linus
