Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756031AbaGVQ0J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 12:26:09 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42525 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754866AbaGVQ0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 12:26:07 -0400
Date: Tue, 22 Jul 2014 16:25:56 +0000
From: Serge Hallyn <serge.hallyn@ubuntu.com>
To: Andrew Vagin <avagin@parallels.com>
Cc: Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        Andrew Vagin <avagin@openvz.org>,
        "Andrew G. Morgan" <morgan@kernel.org>,
        "Serge E. Hallyn" <serge.hallyn@canonical.com>,
        Kees Cook <keescook@chromium.org>, Steve Grubb <sgrubb@redhat.com>,
        Dan Walsh <dwalsh@redhat.com>, stable@kernel.org
Subject: Re: [PATCH] CAPABILITIES: remove undefined caps from all processes
Message-ID: <20140722162556.GU21815@ubuntumail>
References: <1405976341-23818-1-git-send-email-eparis@redhat.com>
 <20140722153937.GA26122@paralelels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140722153937.GA26122@paralelels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Andrew Vagin (avagin@parallels.com):
> On Mon, Jul 21, 2014 at 04:59:01PM -0400, Eric Paris wrote:
> > This is effectively a revert of 7b9a7ec565505699f503b4fcf61500dceb36e744
> > plus fixing it a different way...
> > 
> > We found, when trying to run an application from an application which
> > had dropped privs that the kernel does security checks on undefined
> > capability bits.  This was ESPECIALLY difficult to debug as those
> > undefined bits are hidden from /proc/$PID/status.
> > 
> > Consider a root application which drops all capabilities from ALL 4
> > capability sets.  We assume, since the application is going to set
> > eff/perm/inh from an array that it will clear not only the defined caps
> > less than CAP_LAST_CAP, but also the higher 28ish bits which are
> > undefined future capabilities.
> > 
> > The BSET gets cleared differently.  Instead it is cleared one bit at a
> > time.  The problem here is that in security/commoncap.c::cap_task_prctl()
> > we actually check the validity of a capability being read.  So any task
> > which attempts to 'read all things set in bset' followed by 'unset all
> > things set in bset' will not even attempt to unset the undefined bits
> > higher than CAP_LAST_CAP.
> > 
> > So the 'parent' will look something like:
> > CapInh:	0000000000000000
> > CapPrm:	0000000000000000
> > CapEff:	0000000000000000
> > CapBnd:	ffffffc000000000
> > 
> > All of this 'should' be fine.  Given that these are undefined bits that
> > aren't supposed to have anything to do with permissions.  But they do...
> > 
> > So lets now consider a task which cleared the eff/perm/inh completely
> > and cleared all of the valid caps in the bset (but not the invalid caps
> > it couldn't read out of the kernel).  We know that this is exactly what
> > the libcap-ng library does and what the go capabilities library does.
> > They both leave you in that above situation if you try to clear all of
> > you capapabilities from all 4 sets.  If that root task calls execve()
> > the child task will pick up all caps not blocked by the bset.  The bset
> > however does not block bits higher than CAP_LAST_CAP.  So now the child
> > task has bits in eff which are not in the parent.  These are
> > 'meaningless' undefined bits, but still bits which the parent doesn't
> > have.
> > 
> > The problem is now in cred_cap_issubset() (or any operation which does a
> > subset test) as the child, while a subset for valid cap bits, is not a
> > subset for invalid cap bits!  So now we set durring commit creds that
> > the child is not dumpable.  Given it is 'more priv' than its parent.  It
> > also means the parent cannot ptrace the child and other stupidity.
> > 
> > The solution here is 2 things.
> > 1) stop hiding capability bits in status
> > 	we hide those upper bits which meant I couldn't spot this issue
> > 2) stop giving any task undefined capability bits.  it's simple, it you
> > don't put those invalid bits in CAP_FULL_SET you won't get them in init
> > and you won't get them in any other task either.
> 
> Pls, look at the comment for my first patch: https://lkml.org/lkml/2012/10/5/374
> 
> The following command fails with this patch (and succeeds without).
> 
> [root@avagin-fc19-cr ~]# capsh --caps="all=eip" -- -c /bin/bash
> Unable to set capabilities [--caps=all=eip]

Thanks - so at least capset will need to mask what is passed in
by the user with CAP_FULL_SET.
