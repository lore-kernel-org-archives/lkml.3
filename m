Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753905AbaBLWLy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 17:11:54 -0500
Received: from relay.parallels.com ([195.214.232.42]:53173 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752638AbaBLWLx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 17:11:53 -0500
Date: Thu, 13 Feb 2014 02:11:20 +0400
From: Andrew Vagin <avagin@parallels.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Andrey Vagin <avagin@openvz.org>, <linux-kernel@vger.kernel.org>,
        <criu@openvz.org>, Oleg Nesterov <oleg@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Kees Cook <keescook@chromium.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Pavel Emelyanov <xemul@parallels.com>,
        Aditya Kali <adityakali@google.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>
Subject: Re: [PATCH] kernel: reduce required permission for prctl_set_mm
Message-ID: <20140212221120.GA17603@paralelels.com>
References: <1392219611-13260-1-git-send-email-avagin@openvz.org>
 <20140212133228.e4ff66c6add0c6b121232aad@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="koi8-r"
Content-Disposition: inline
In-Reply-To: <20140212133228.e4ff66c6add0c6b121232aad@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [10.24.24.113]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 12, 2014 at 01:32:28PM -0800, Andrew Morton wrote:
> On Wed, 12 Feb 2014 19:40:11 +0400 Andrey Vagin <avagin@openvz.org> wrote:
> 
> > Currently prctl_set_mm requires the global CAP_SYS_RESOURCE,
> > this patch reduce requiremence to CAP_SYS_RESOURCE in the current
> > namespace.
> > 
> > When we restore a task we need to set up text, data and data heap sizes
> > from userspace to the values a task had at checkpoint time.
> > 
> > Currently we can not restore these parameters, if a task lives in
> > a non-root user name space, because it has no capabilities in the
> > parent namespace.
> > 
> > prctl_set_mm() changes parameters of the current task and doesn't affect
> > other tasks.
> > 
> > This patch affects the RLIMIT_DATA limit, because a consumtiuon is
> > calculated relatively to mm->end_data, mm->start_data, mm->start_brk.
> 
> I can't for the life of me work out what you were trying to say here. 
> Please fix and resend this paragraph?

A task can exceed the RLIMIT_DATA limit by changing mm->start_brk,
so this patch reduces required permission for RLIMIT_DATA too

> 
> > rlim = rlimit(RLIMIT_DATA);
> > if (rlim < RLIM_INFINITY && (brk - mm->start_brk) +
> > 		(mm->end_data - mm->start_data) > rlim)
> > 	goto out;
> > 
> > This limit affects calls to brk() and sbrk(), but it doesn't affect
> > mmap. So I think requirement of CAP_SYS_RESOURCE in the current
> > namespace is enough for this limit.
> > 
> > ...
> >
> > Cc: security@kernel.org
> 
> That list is for reporting kernel security bugs.
> 
> >
> > --- a/kernel/sys.c
> > +++ b/kernel/sys.c
> > @@ -1701,7 +1701,7 @@ static int prctl_set_mm(int opt, unsigned long addr,
> >  	if (arg5 || (arg4 && opt != PR_SET_MM_AUXV))
> >  		return -EINVAL;
> >  
> > -	if (!capable(CAP_SYS_RESOURCE))
> > +	if (!ns_capable(current_user_ns(), CAP_SYS_RESOURCE))
> >  		return -EPERM;
> >  
> >  	if (opt == PR_SET_MM_EXE_FILE)
> 
> This looks harmless.
> 
> My relatively-up-to-date manpages don't mention prctl(PR_SET_MM).  I
> see from http://marc.info/?l=linux-man&m=133132612704130&w=2 that
> manpage additions were prepared nearly three years ago.  Michael, did
> this fall through a crack?
> 
