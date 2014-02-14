Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752034AbaBNSBe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 13:01:34 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:57024 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751277AbaBNSBc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 13:01:32 -0500
Date: Fri, 14 Feb 2014 22:01:29 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Andrew Vagin <avagin@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Aditya Kali <adityakali@google.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Pavel Emelyanov <xemul@parallels.com>, Oleg Nesterov <oleg@redhat.com>,
        linux-kernel@vger.kernel.org, criu@openvz.org,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>
Subject: Re: [CRIU] [PATCH 1/3] prctl: reduce permissions to change
 boundaries of data, brk and stack
Message-ID: <20140214180129.GK13358@moon>
References: <1392387209-330-1-git-send-email-avagin@openvz.org>
 <1392387209-330-2-git-send-email-avagin@openvz.org>
 <874n41znl5.fsf@xmission.com>
 <20140214174314.GA5518@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140214174314.GA5518@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 14, 2014 at 09:43:14PM +0400, Andrew Vagin wrote:
> > My brain hurts just looking at this patch and how you are justifying it.
> > 
> > For the resources you are mucking with below all you have to do is to
> > verify that you are below the appropriate rlimit at all times and no
> > CAP_SYS_RESOURCE check is needed.  You only need CAP_SYS_RESOURCE
> > to exceed your per process limits.
> > 
> > All you have to do is to fix the current code to properly enforce the
> > limits.
> 
> I'm afraid what you are suggesting doesn't work.
> 
> The first reason is that we can not change both boundaries in one call.
> But when we are restoring these attributes, we may need to move their
> too far.

When this code was introduced, there were no user-namespace implementation,
if I remember correctly, so CAP_SYS_RESOURCE was enough barrier point
to prevent modifying this values by anyone. Now user-ns brings a limit --
we need somehow to provide a way to modify these mm fields having no
CAP_SYS_RESOURCE set. "Verifying rlimit" not an option here because
we're modifying members one by one (looking back I think this was not
a good idea to modify the fields in this manner).

Maybe we could improve this api and provide argument as a pointer
to a structure, which would have all the fields we're going to
modify, which in turn would allow us to verify that all new values
are sane and fit rlimits, then we could (probably) deprecate old
api if noone except c/r camp is using it (I actually can't imagine
who else might need this api). Then CAP_SYS_RESOURCE requirement
could be ripped off. Hm? (sure touching api is always "no-no"
case, but maybe...)

> 
> Another problem is that the limits will not work at all in this case. We
> will able to move start_brk forward before calling brk() and brk() will
> never fail.

