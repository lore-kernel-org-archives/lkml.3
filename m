Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755384AbaA1RTY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 12:19:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40759 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755157AbaA1RTX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 12:19:23 -0500
Date: Tue, 28 Jan 2014 18:19:02 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Anvin <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Subject: Re: [RFC] de-asmify the x86-64 system call slowpath
Message-ID: <20140128171902.GA9151@redhat.com>
References: <CA+55aFzNxTtvNX7zqBELHs489e5mEx1sM=i=red=aQAGviXrNw@mail.gmail.com> <20140127102759.GY11314@laptop.programming.kicks-ass.net> <20140127113627.GC10323@ZenIV.linux.org.uk> <20140127173931.GB32450@redhat.com> <20140128011841.GG10323@ZenIV.linux.org.uk> <20140128163730.GA7596@redhat.com> <20140128164811.GH10323@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140128164811.GH10323@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/28, Al Viro wrote:
>
> On Tue, Jan 28, 2014 at 05:38:08PM +0100, Oleg Nesterov wrote:
> > On 01/28, Al Viro wrote:
> > >
> > > On Mon, Jan 27, 2014 at 06:39:31PM +0100, Oleg Nesterov wrote:
> > > > On 01/27, Al Viro wrote:
> > > > >
> > > > > Why is _TIF_UPROBE *not* a part
> > > > > of _TIF_DO_NOTIFY_MASK, for example?
> > > >
> > > > Yes, please see another email. That is why uprobe_deny_signal()
> > > > sets TIF_NOTIFY_RESUME along with TIF_UPROBE.
> > >
> > > *grumble* Can it end up modifying *regs?  From very cursory reading of
> > > kernel/events/uprobe.c it seems to do so, so we probably want to leave
> > > via iretq if that has hit, right?
> >
> > But we do this anyway, restore_args path does iretq?
> >
> > I mean, uprobe_notify_resume() is called from do_notify_resume(), it
> > should be fine to modify*regs there?
>
> See Linus' patch trying to avoid iretq path; it's really costly.  Looks
> like that patch will have to treat _TIF_UPROBE the same way it treats
> _TIF_SIGPENDING...

Ah, this one I guess: http://marc.info/?l=linux-kernel&m=139077532507926

I think this should be fine wrt uprobes, unless I misread this patch
syscall_exit_slowpath() is actually only called by ret_from_sys_call
path, it this case TIF_UPROBE should not be set. But perhaps
"retval = 1" after uprobe_notify_resume() makes sense anyway.

And while I am almost sure I missed something, can't we (with or without
that patch) simply add TIF_UPROBE into _TIF_DO_NOTIFY_MASK and remove
set_tsk_thread_flag(t, TIF_NOTIFY_RESUME) from uprobe_deny_signal ?

Oleg.

