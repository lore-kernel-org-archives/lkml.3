Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753238AbaHXUFm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2014 16:05:42 -0400
Received: from mail-vc0-f178.google.com ([209.85.220.178]:43316 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752706AbaHXUFk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2014 16:05:40 -0400
MIME-Version: 1.0
In-Reply-To: <20140824194736.GA27441@redhat.com>
References: <20140824194700.GA27281@redhat.com>
	<20140824194736.GA27441@redhat.com>
Date: Sun, 24 Aug 2014 13:05:39 -0700
X-Google-Sender-Auth: CUCe9gsXwf1Pw-sCZeeYzZz8hII
Message-ID: <CA+55aFyQzvvmWUDA01x69vYkrwUG07q9P3Mv5KaT31pOFsBZGQ@mail.gmail.com>
Subject: Re: [PATCH 2/5] x86, fpu: don't drop_fpu() in __restore_xstate_sig()
 if use_eager_fpu()
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Bean Anderson <bean@azulsystems.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I really dislike this one.

If I read it right, you now do *two* math_state_restore calls for each
FPU signal state restore. That's potentially quite expensive.

Also, you can actually end up with multiple threads pointing to the
same math state in init_task.thread.fpu.state, right? Why is that any
better than just having the save state temporarily contain garbage?

The other patches look sane, this one I really don't like. You may
have good reasons for it, but it's disgusting.

           Linus

On Sun, Aug 24, 2014 at 12:47 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> __restore_xstate_sig() calls math_state_restore() with preemption
> enabled, not good. But this is minor, [...]
