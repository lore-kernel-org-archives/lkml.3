Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753915AbaDDSah (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 14:30:37 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:37084 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753401AbaDDSag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 14:30:36 -0400
Date: Fri, 4 Apr 2014 13:30:22 -0500
From: Serge Hallyn <serge.hallyn@ubuntu.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: "Serge E. Hallyn" <serge@hallyn.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Sean Pajot <sean.pajot@execulink.com>,
        lxc-devel@lists.linuxcontainers.org, linux-kernel@vger.kernel.org
Subject: Re: [lxc-devel] Kernel bug? Setuid apps and user namespaces
Message-ID: <20140404183022.GA6728@sergelap>
References: <5266BEA3.6020008@execulink.com>
 <20131022193718.GA18463@ac100>
 <874n89rsoc.fsf@xmission.com>
 <20140402172049.GA13240@sergelap>
 <20140402173248.GA22804@mail.hallyn.com>
 <533EF65E.6050508@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <533EF65E.6050508@mit.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Andy Lutomirski (luto@amacapital.net):
> On 04/02/2014 10:32 AM, Serge E. Hallyn wrote:
> > (Sorry - the lxc-devel list has moved, so replying to all with the
> > correct list address;   please reply to this rather than my previous
> > email)
> > 
> > Quoting Serge Hallyn (serge.hallyn@ubuntu.com):
> >> Hi Eric,
> >>
> >> (sorry, I don't seem to have the email I actually wanted to reply
> >> to in my mbox, but it is
> >> https://lists.linuxcontainers.org/pipermail/lxc-devel/2013-October/005857.html)
> >>
> >> You'd said,
> >>> Someone needs to read and think through all of the corner cases and see
> >>> if we can ever have a time when task_dumpable is false but root in the
> >>> container would not or should not be able to see everything.
> >>>
> >>> In particular I am worried about the case of a setuid app calling setns,
> >>> and entering a lesser privileged user namespace.  In my foggy mind that
> >>> might be a security problem.  And there might be other similar crazy
> >>> cases.
> >>
> >> Can we make use of current->mm->exe_file->f_cred->user_ns?
> >>
> >> So either always use 
> >> make_kgid(current->mm->exe_file->f_cred->user_ns, 0)
> >> instead of make_kuid(cred->user_ns, 0), or check that
> >> (current->mm->exe_file->f_cred->user_ns == cred->user_ns)
> >> and, if not, assume that the caller has done a setns?
> 
> Do you have a summary of the issue?  I'm a little lost here.

Sure - when running an unprivileged container, tasks which become
!dumpable end up with /proc/$pid/fd/ being owned by the global
root user, which inside the container is nobody:nogroup.  Examples
are the user's sshd threads and apache, and in the past I think I've
seen it with logind or getty too.

> I suspect that what we really need is to revoke a bunch of proc files
> every time a task does anything involving setuid (or, more generally,
> any of the LSM_UNSAFE_PTRACE things).

setuid, or do you mean setns?  In any case, I'm not thinking through
attach (setns'ing into a container) yet, but the cases I'm looking at
right now are just a root daemon - already inside the non-init user
ns - doing something to become !dumpable, and having its fds become
owned by GLOBAL_ROOT_UID.  Since these tasks are running a program
which came from inside the non-init userns, I think it's sane to
allow root in the non-init userns own any coredumps.

Whereas if the program had started as /bin/passwd in the init userns,
then coredumps (and /proc/$$/fd/*) should be owned by the GLOBAL_ROOT_UID.

-serge
