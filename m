Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754008AbaG2Q4c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 12:56:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58015 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753918AbaG2Q4a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 12:56:30 -0400
Date: Tue, 29 Jul 2014 18:54:16 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>, Will Drewry <wad@chromium.org>,
        X86 ML <x86@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux MIPS Mailing List <linux-mips@linux-mips.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        Alexei Starovoitov <ast@plumgrid.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v3 6/8] x86: Split syscall_trace_enter into two phases
Message-ID: <20140729165416.GA967@redhat.com>
References: <cover.1405992946.git.luto@amacapital.net> <3f649f5658a163645e3ce15156176c325283762e.1405992946.git.luto@amacapital.net> <20140728173723.GA20993@redhat.com> <CALCETrWUFo_zXcAZja-vdL4_MgJDd=1ed5Vt54eyUuim930xAw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrWUFo_zXcAZja-vdL4_MgJDd=1ed5Vt54eyUuim930xAw@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/28, Andy Lutomirski wrote:
>
> On Mon, Jul 28, 2014 at 10:37 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> > Hi Andy,
> >
> > I am really sorry for delay.
> >
> > This is on top of the recent change from Kees, right? Could me remind me
> > where can I found the tree this series based on? So that I could actually
> > apply these changes...
>
> https://git.kernel.org/cgit/linux/kernel/git/kees/linux.git/log/?h=seccomp/fastpath
>
> The first four patches are already applied there.

Thanks!

> > If I understand correctly, syscall_trace_enter() can avoid _phase2() above.
> > But we should always call user_exit() unconditionally?
>
> Damnit.  I read that every function called by user_exit, and none of
> them give any indication of why they're needed for traced syscalls but
> not for untraced syscalls.  On a second look, it seems that TIF_NOHZ
> controls it.

Yes, just to trigger the slow path, I guess.

> I'll update the code to call user_exit iff TIF_NOHZ is
> set.

Or perhaps it would be better to not add another user of this (strange) flag
and just call user_exit() unconditionally(). But, yes, you need to use
from "work = flags & (_TIF_WORK_SYSCALL_ENTRY & ~TIF_NOHZ)" then.

> > And we should always set X86_EFLAGS_TF if TIF_SINGLESTEP? IIRC, TF can be
> > actually cleared on a 32bit kernel if we step over sysenter insn?
>
> I don't follow.  If TIF_SINGLESTEP, then phase1 will return a nonzero
> value,

Ah yes, thanks, I missed this.

Oleg.

