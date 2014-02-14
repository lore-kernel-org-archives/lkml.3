Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752451AbaBNRnX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 12:43:23 -0500
Received: from mail-la0-f50.google.com ([209.85.215.50]:36119 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752298AbaBNRnS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 12:43:18 -0500
Date: Fri, 14 Feb 2014 21:43:14 +0400
From: Andrew Vagin <avagin@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrey Vagin <avagin@openvz.org>, linux-kernel@vger.kernel.org,
        criu@openvz.org, Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Kees Cook <keescook@chromium.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Pavel Emelyanov <xemul@parallels.com>,
        Aditya Kali <adityakali@google.com>
Subject: Re: [PATCH 1/3] prctl: reduce permissions to change boundaries of
 data, brk and stack
Message-ID: <20140214174314.GA5518@gmail.com>
References: <1392387209-330-1-git-send-email-avagin@openvz.org>
 <1392387209-330-2-git-send-email-avagin@openvz.org>
 <874n41znl5.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <874n41znl5.fsf@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 14, 2014 at 08:05:42AM -0800, Eric W. Biederman wrote:
> Andrey Vagin <avagin@openvz.org> writes:
> 
> > Currently this operation requires the global CAP_SYS_RESOURCE.
> > It's required, because a task can exceed limits (RLIMIT_DATA,
> > RLIMIT_STACK).
> >
> > So let's allow task to change these parameters if a proper limit is
> > unlimited.
> >
> > When we restore a task we need to set up text, data and data heap sizes
> > from userspace to the values a task had at checkpoint time.
> >
> > Currently we can not restore these parameters, if a task lives in
> > a non-root user name space, because it has no capabilities in the
> > parent namespace.
> 
> My brain hurts just looking at this patch and how you are justifying it.
> 
> For the resources you are mucking with below all you have to do is to
> verify that you are below the appropriate rlimit at all times and no
> CAP_SYS_RESOURCE check is needed.  You only need CAP_SYS_RESOURCE
> to exceed your per process limits.
> 
> All you have to do is to fix the current code to properly enforce the
> limits.

I'm afraid what you are suggesting doesn't work.

The first reason is that we can not change both boundaries in one call.
But when we are restoring these attributes, we may need to move their
too far.

Another problem is that the limits will not work at all in this case. We
will able to move start_brk forward before calling brk() and brk() will
never fail.

Sorry if I miss something.

> This half-assed code that forgets the permission checks if
> rlimit is set to rlimit_inifinity is wrong.
> 
> Eric
> 
> 
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: Oleg Nesterov <oleg@redhat.com>
> > Cc: Al Viro <viro@zeniv.linux.org.uk>
> > Cc: Kees Cook <keescook@chromium.org>
> > Cc: "Eric W. Biederman" <ebiederm@xmission.com>
> > Cc: Stephen Rothwell <sfr@canb.auug.org.au>
> > Cc: Pavel Emelyanov <xemul@parallels.com>
> > Cc: Aditya Kali <adityakali@google.com>
> > Signed-off-by: Andrey Vagin <avagin@openvz.org>
> > ---
> >  kernel/sys.c | 19 +++++++++++++++++--
> >  1 file changed, 17 insertions(+), 2 deletions(-)
> >
> > diff --git a/kernel/sys.c b/kernel/sys.c
> > index c0a58be..939370c 100644
> > --- a/kernel/sys.c
> > +++ b/kernel/sys.c
> > @@ -1701,8 +1701,23 @@ static int prctl_set_mm(int opt, unsigned long addr,
> >  	if (arg5 || (arg4 && opt != PR_SET_MM_AUXV))
> >  		return -EINVAL;
> >  
> > -	if (!capable(CAP_SYS_RESOURCE))
> > -		return -EPERM;
> > +	if (!capable(CAP_SYS_RESOURCE)) {
> > +		switch (opt) {
> > +		case PR_SET_MM_START_DATA:
> > +		case PR_SET_MM_END_DATA:
> > +		case PR_SET_MM_START_BRK:
> > +		case PR_SET_MM_BRK:
> > +			if (rlim < RLIM_INFINITY)
> > +				return -EPERM;
> > +			break;
> > +		case PR_SET_MM_START_STACK:
> > +			if (rlimit(RLIMIT_STACK) < RLIM_INFINITY)
> > +				return -EPERM;
> > +			break;
> > +		default:
> > +			return -EPERM;
> > +		}
> > +	}
> >  
> >  	if (opt == PR_SET_MM_EXE_FILE)
> >  		return prctl_set_mm_exe_file(mm, (unsigned int)addr);
