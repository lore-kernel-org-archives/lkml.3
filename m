Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752098AbaJ0CG5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2014 22:06:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42071 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751816AbaJ0CG4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2014 22:06:56 -0400
Date: Sun, 26 Oct 2014 22:06:46 -0400
From: Richard Guy Briggs <rgb@redhat.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Eric Paris <eparis@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        X86 ML <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-audit@redhat.com
Subject: Re: [PATCH] i386/audit: stop scribbling on the stack frame
Message-ID: <20141027020646.GX15532@madcap2.tricolour.ca>
References: <1414037043-30647-1-git-send-email-eparis@redhat.com>
 <54494B74.2080504@amacapital.net>
 <1414091732.2363.11.camel@redhat.com>
 <CALCETrWQNuGr=Sf7X4E6ZkJQ+diJao30=CeH4xd0T855TgX+rg@mail.gmail.com>
 <1414092624.2363.13.camel@redhat.com>
 <1414093104.2363.14.camel@redhat.com>
 <544AB462.9070708@zytor.com>
 <CALCETrVhqzurg=DF4PV+zv3d4z7nNxgsWgyXJm5kUG1bB75MjQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrVhqzurg=DF4PV+zv3d4z7nNxgsWgyXJm5kUG1bB75MjQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/10/24, Andy Lutomirski wrote:
> On Fri, Oct 24, 2014 at 1:19 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> > On 10/23/2014 12:38 PM, Eric Paris wrote:
> >>> After the call __audit_syscall_entry aren't they already polluted?
> >>> Isn't that the reason we need to reload EAX?
> >>
> >> Well, I guess EAX is special...
> >
> > Because system calls are "asmlinkage", all the parameters are on the
> > stack, but %eax is used as the index into the system call table.  This
> > should thus be fine until we get rid of regparm(0) entirely, if that
> > ever happens.
> 
> ...and because __audit_syscall_entry *isn't* asmlinkage, it uses the
> other convention, which is where the confusion comes from.  And, by
> the time you get to sysenter_do_call, nothing cares about ecx, so you
> can freely clobber it while popping from the stack.  I get it now.

So you could just as easily clobber %eax since that'll be restored from
PT_EAX(%esp) anyways in the following step...

Or instead of popping these two values, could ajust the stack with
	addl $8,%esp
	CFI_ADJUST_CFA_OFFSET -8
since we don't need either value popped off the stack?

> --Andy
> 
> >         -hpa

- RGB

--
Richard Guy Briggs <rbriggs@redhat.com>
Senior Software Engineer, Kernel Security, AMER ENG Base Operating Systems, Red Hat
Remote, Ottawa, Canada
Voice: +1.647.777.2635, Internal: (81) 32635, Alt: +1.613.693.0684x3545
