Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754540AbaBUXcJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 18:32:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29699 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752769AbaBUXcH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 18:32:07 -0500
Date: Fri, 21 Feb 2014 18:32:02 -0500
From: Richard Guy Briggs <rgb@redhat.com>
To: Steve Grubb <sgrubb@redhat.com>
Cc: linux-audit@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] audit: add arch field to seccomp event log
Message-ID: <20140221233202.GH17952@madcap2.tricolour.ca>
References: <4bc8c03bda84e004c331546e228b334811b03254.1392409147.git.rgb@redhat.com>
 <1392412322.2760.21.camel@localhost>
 <20140218205044.GL16640@madcap2.tricolour.ca>
 <1455468.M1LNEKA0EJ@x2>
 <20140219031519.GM16640@madcap2.tricolour.ca>
 <20140219193751.GP16640@madcap2.tricolour.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140219193751.GP16640@madcap2.tricolour.ca>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/02/19, Richard Guy Briggs wrote:
> On 14/02/18, Richard Guy Briggs wrote:
> > On 14/02/18, Steve Grubb wrote:
> > > On Tuesday, February 18, 2014 03:50:44 PM Richard Guy Briggs wrote:
> > > > > missing '='   but this isn't what audit_get_context() does...   it's
> > > > > crappy naming...    I'd think a combo of audit_dummy_context() and
> > > > > current->audit_context would be most appropriate.
> > > > 
> > > > Ok.  I think I finally understand audit_dummy_context().  Thanks for the
> > > > hint.  However, it appears it is not useful in this sitation, since if
> > > > there is an audit_context, even a dummy context, it appears arch is
> > > > filled in.
> > > > 
> > > > diff --git a/kernel/auditsc.c b/kernel/auditsc.c
> > > > @@ -2406,12 +2406,18 @@ void audit_core_dumps(long signr)
> > > >  void __audit_seccomp(unsigned long syscall, long signr, int code)
> > > >  {
> > > >         struct audit_buffer *ab;
> > > > +       struct audit_context *context = current->audit_context;
> > > >  
> > > >         ab = audit_log_start(NULL, GFP_KERNEL, AUDIT_SECCOMP);
> > > >         if (unlikely(!ab))
> > > >                 return;
> > > >         audit_log_task(ab);
> > > >         audit_log_format(ab, " sig=%ld", signr);
> > > > +       audit_log_format(ab, " arch=");
> > > > +       if (context)
> > > > +               audit_log_format(ab, "%x", context->arch);
> > > > +       else
> > > > +               audit_log_format(ab, "(null)");
> > > >         audit_log_format(ab, " syscall=%ld", syscall);
> > > >         audit_log_format(ab, " compat=%d", is_compat_task());
> > > >         audit_log_format(ab, " ip=0x%lx", KSTK_EIP(current));
> > > 
> > > Is there anything that could be passed by the caller that might identify the 
> > > syscall ABI when this call was blocked? '(null)' still makes syscall number 
> > > uninterpretable.
> > 
> > This is the way it is done in the existing record that prints a syscall
> > record in audit_log_exit().
> > 
> > It is set by the arch-dependent assembler linkage for
> > __audit_syscall_entry() or set by the arch-dependent ptrace code that
> > calls audit_syscall_entry().  In some arches there are a couple of
> > choices.
> > 
> > 
> > To pass this in to __audit_seccomp() as an arg, I'd have to add that arg
> > to:
> > 	__audit_seccomp()
> > 	audit_seccomp()
> > 	__secure_computing()
> > 	secure_computing()
> > 
> > 
> > As you've pointed out in IRC, there is a syscall_get_arch(current, regs)
> > that could be used to get the arch when an audit context is not yet created.
> 
> s390x architecture doesn't have it defined.  :(

It is defined, but is having trouble finding it...

> > I was just looking for something like that...  I am noticing that all
> > arches call a variant of syscall_trace_enter() which first calls
> > secure_computing() [which eventually calls __audit_seccomp()] *before*
> > calling audit_syscall_entry() [which eventually sets context->arch].  So
> > I'm not sure how task->audit_context->arch got set...  Perhaps
> > __audit_syscall_entry() should just call syscall_get_arch() instead of
> > lugging it through the stack like it presently does.
> > 
> > Is this going to give the same information?  (I guess I should be able
> > to answer that question...)
> > 
> > > -Steve
> > 
> > - RGB
> 
> - RGB

- RGB

--
Richard Guy Briggs <rbriggs@redhat.com>
Senior Software Engineer, Kernel Security, AMER ENG Base Operating Systems, Red Hat
Remote, Ottawa, Canada
Voice: +1.647.777.2635, Internal: (81) 32635, Alt: +1.613.693.0684x3545
