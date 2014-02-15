Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751788AbaBOG32 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Feb 2014 01:29:28 -0500
Received: from mail-la0-f45.google.com ([209.85.215.45]:55422 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751043AbaBOG31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Feb 2014 01:29:27 -0500
Date: Sat, 15 Feb 2014 10:29:22 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Pavel Emelyanov <xemul@parallels.com>, Andrew Vagin <avagin@gmail.com>,
        Aditya Kali <adityakali@google.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
        criu@openvz.org, Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>
Subject: Re: [CRIU] [PATCH 1/3] prctl: reduce permissions to change
 boundaries of data, brk and stack
Message-ID: <20140215062922.GA22779@moon>
References: <1392387209-330-1-git-send-email-avagin@openvz.org>
 <1392387209-330-2-git-send-email-avagin@openvz.org>
 <874n41znl5.fsf@xmission.com>
 <20140214174314.GA5518@gmail.com>
 <20140214180129.GK13358@moon>
 <8761ohqzc6.fsf@xmission.com>
 <52FE72C1.9090100@parallels.com>
 <20140214200622.GN13358@moon>
 <877g8xphw9.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <877g8xphw9.fsf@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 14, 2014 at 12:18:46PM -0800, Eric W. Biederman wrote:
> >> > 
> >> > Why can't you have the process of interest do:
> >> > 	ptrace(PTRACE_ATTACHME);
> >> > 	execve(executable, args, ...);
> >> >         
> >> >         /* Have the ptracer inject the recovery/fixup code */
> >> > 	    /* Fix up the mostly correct process to look like it has been
> >> >          * executing for a while.
> >> >          */
> >
> > Erik, it seems I don't understand how it will help us to restore
> > the mm fields mentioned above?
> 
> Because exec is how those mm fields are set when you don't use
> prctl_set_mm.  So execpt for the stack and the brk limits that
> will simply result in the values being set to what the usually
> would be set to.

Yes, all these fields are set up by kernel's elf loader but this
routine is a way more time consuming than a clone call. But gimme
some time to examine all possible problems we might have with such
approach and if there a way to solve them.

> >> Let's imagine we do that.
> >> 
> >> This means, that the whole memory contents should be restored _after_
> >> the execve() call, since the execve() flushes old mappings. In
> >> that case we lose the ability to preserve any shared memory regions
> >> between any two processes. This "shared" can be either regular
> >> MAP_SHARED mappings or MAP_ANONYMOUS but still not COW-ed ones.
