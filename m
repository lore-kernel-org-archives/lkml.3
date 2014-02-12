Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754663AbaBLXJf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 18:09:35 -0500
Received: from relay.parallels.com ([195.214.232.42]:59356 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754039AbaBLXJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 18:09:33 -0500
Date: Thu, 13 Feb 2014 03:08:57 +0400
From: Andrew Vagin <avagin@parallels.com>
To: Kees Cook <keescook@chromium.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Andrey Vagin <avagin@openvz.org>, LKML <linux-kernel@vger.kernel.org>,
        <criu@openvz.org>, Oleg Nesterov <oleg@redhat.com>,
        Robin Holt <holt@sgi.com>, Al Viro <viro@zeniv.linux.org.uk>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Chen Gang" <gang.chen@asianux.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        "Pavel Emelyanov" <xemul@parallels.com>,
        Aditya Kali <adityakali@google.com>,
        "Michael Kerrisk" <mtk.manpages@gmail.com>
Subject: Re: [PATCH] kernel: reduce required permission for prctl_set_mm
Message-ID: <20140212230856.GB17603@paralelels.com>
References: <1392219611-13260-1-git-send-email-avagin@openvz.org>
 <20140212133228.e4ff66c6add0c6b121232aad@linux-foundation.org>
 <CAGXu5jLwH82BSTMTB_iP=2_0yUBEeLuNOcCaotyw_iADvizb-A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="koi8-r"
Content-Disposition: inline
In-Reply-To: <CAGXu5jLwH82BSTMTB_iP=2_0yUBEeLuNOcCaotyw_iADvizb-A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [10.24.24.113]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 12, 2014 at 01:50:35PM -0800, Kees Cook wrote:
> On Wed, Feb 12, 2014 at 1:32 PM, Andrew Morton
> <akpm@linux-foundation.org> wrote:
> > On Wed, 12 Feb 2014 19:40:11 +0400 Andrey Vagin <avagin@openvz.org> wrote:
> >
> >> Currently prctl_set_mm requires the global CAP_SYS_RESOURCE,
> >> this patch reduce requiremence to CAP_SYS_RESOURCE in the current
> >> namespace.
> >>
> >> When we restore a task we need to set up text, data and data heap sizes
> >> from userspace to the values a task had at checkpoint time.
> >>
> >> Currently we can not restore these parameters, if a task lives in
> >> a non-root user name space, because it has no capabilities in the
> >> parent namespace.
> >>
> >> prctl_set_mm() changes parameters of the current task and doesn't affect
> >> other tasks.
> >>
> >> This patch affects the RLIMIT_DATA limit, because a consumtiuon is
> >> calculated relatively to mm->end_data, mm->start_data, mm->start_brk.
> >
> > I can't for the life of me work out what you were trying to say here.
> > Please fix and resend this paragraph?
> >
> >> rlim = rlimit(RLIMIT_DATA);
> >> if (rlim < RLIM_INFINITY && (brk - mm->start_brk) +
> >>               (mm->end_data - mm->start_data) > rlim)
> >>       goto out;
> >>
> >> This limit affects calls to brk() and sbrk(), but it doesn't affect
> >> mmap. So I think requirement of CAP_SYS_RESOURCE in the current
> >> namespace is enough for this limit.
> >>
> >> ...
> >>
> >> Cc: security@kernel.org
> >
> > That list is for reporting kernel security bugs.
> >
> >>
> >> --- a/kernel/sys.c
> >> +++ b/kernel/sys.c
> >> @@ -1701,7 +1701,7 @@ static int prctl_set_mm(int opt, unsigned long addr,
> >>       if (arg5 || (arg4 && opt != PR_SET_MM_AUXV))
> >>               return -EINVAL;
> >>
> >> -     if (!capable(CAP_SYS_RESOURCE))
> >> +     if (!ns_capable(current_user_ns(), CAP_SYS_RESOURCE))
> >>               return -EPERM;
> >>
> >>       if (opt == PR_SET_MM_EXE_FILE)
> >
> > This looks harmless.
> 
> I want to be convinced of this, but weakening this cap check seems
> like an easy way for a process to hide itself trivially from the real
> root user. It can change it's exe file link, and dodge RLIMIT_DATA by
> changing the brk addresses. The whole reason this cap check was there
> was to stop that kind of thing. Limiting it to a namespace isn't great
> since USER_NS means unprivileged processes can enter a new NS as the
> NS root user.

All what you are describing here we are doing on restoring tasks. We
need a way how to restore these parameters. One of our targets is to be
able to dump and restore Linux Containers. All processes of a container
live in a separate set of namespaces.

I was thinking to restore these parameters before entering into userns,
but this idea failed, because a process can't enter in pidns, but pidns
must be created in userns...


>> It can change it's exe file link
We can change memory content with help of ptrace. So if we want to hide
a process, we can execute another process and inject our code into it.

It can be equivalent to changing exe file link. Yes, it's a bit
harder, but we can do that even without this patch.

>> dodge RLIMIT_DATA

This limit affects calls to brk(2) and sbrk(2). But a task can use mmap() to
allocate memory. How is this limit used?

Sorry if I miss something.

> 
> -Kees
> 
> -- 
> Kees Cook
> Chrome OS Security
