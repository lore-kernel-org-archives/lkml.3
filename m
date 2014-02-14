Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752400AbaBNUG1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 15:06:27 -0500
Received: from mail-lb0-f180.google.com ([209.85.217.180]:55688 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751277AbaBNUGZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 15:06:25 -0500
Date: Sat, 15 Feb 2014 00:06:22 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Pavel Emelyanov <xemul@parallels.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Vagin <avagin@gmail.com>, Aditya Kali <adityakali@google.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
        criu@openvz.org, Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>
Subject: Re: [CRIU] [PATCH 1/3] prctl: reduce permissions to change
 boundaries of data, brk and stack
Message-ID: <20140214200622.GN13358@moon>
References: <1392387209-330-1-git-send-email-avagin@openvz.org>
 <1392387209-330-2-git-send-email-avagin@openvz.org>
 <874n41znl5.fsf@xmission.com>
 <20140214174314.GA5518@gmail.com>
 <20140214180129.GK13358@moon>
 <8761ohqzc6.fsf@xmission.com>
 <52FE72C1.9090100@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52FE72C1.9090100@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 14, 2014 at 11:47:13PM +0400, Pavel Emelyanov wrote:
> >> Maybe we could improve this api and provide argument as a pointer
> >> to a structure, which would have all the fields we're going to
> >> modify, which in turn would allow us to verify that all new values
> >> are sane and fit rlimits, then we could (probably) deprecate old
> >> api if noone except c/r camp is using it (I actually can't imagine
> >> who else might need this api). Then CAP_SYS_RESOURCE requirement
> >> could be ripped off. Hm? (sure touching api is always "no-no"
> >> case, but maybe...)
> > 
> > Hmm.  Let me rewind this a little bit.
> > 
> > I want to be very stupid and ask the following.
> > 
> > Why can't you have the process of interest do:
> > 	ptrace(PTRACE_ATTACHME);
> > 	execve(executable, args, ...);
> >         
> >         /* Have the ptracer inject the recovery/fixup code */
> > 	    /* Fix up the mostly correct process to look like it has been
> >          * executing for a while.
> >          */

Erik, it seems I don't understand how it will help us to restore
the mm fields mentioned above?

> Let's imagine we do that.
> 
> This means, that the whole memory contents should be restored _after_
> the execve() call, since the execve() flushes old mappings. In
> that case we lose the ability to preserve any shared memory regions
> between any two processes. This "shared" can be either regular
> MAP_SHARED mappings or MAP_ANONYMOUS but still not COW-ed ones.
> 
> > That should work, set all of the interesting fields, and works as
> > non-root today.  My gut feel says do that and we can just
> > deprecate/remove prctl_set_mm.
> > 
> > I am hoping we can move this conversation what makes sense from oh ick
> > checkpoint/restort does not work with user namespaces.

I fear you've got a wrong impression that we're "ick'ing" about user-ns ;)
Actually it's "must have" feature for containers thus we would _really_
love to be able to c/r them.
