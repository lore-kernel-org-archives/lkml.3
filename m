Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755531Ab3HaFba (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Aug 2013 01:31:30 -0400
Received: from static.92.5.9.176.clients.your-server.de ([176.9.5.92]:45649
	"EHLO hallynmail2" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753636Ab3HaFb3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Aug 2013 01:31:29 -0400
Date: Sat, 31 Aug 2013 05:31:25 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>,
        Linux Containers <containers@lists.linux-foundation.org>,
        linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>
Subject: Re: [REVIEW][PATCH 3/5] pidns: Don't have unshare(CLONE_NEWPID)
 imply CLONE_THREAD
Message-ID: <20130831053125.GA24025@mail.hallyn.com>
References: <87ob8gys0d.fsf@xmission.com>
 <87a9k0yrvu.fsf@xmission.com>
 <20130830163805.GB18857@mail.hallyn.com>
 <87ppsuviwb.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ppsuviwb.fsf@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Eric W. Biederman (ebiederm@xmission.com):
> "Serge E. Hallyn" <serge@hallyn.com> writes:
> 
> > Quoting Eric W. Biederman (ebiederm@xmission.com):
> >> 
> >> I goofed when I made unshare(CLONE_NEWPID) only work in a
> >> single-threaded process.  There is no need for that requirement and in
> >> fact I analyzied things right for setns.  The hard requirement
> >> is for tasks that share a VM to all be in the pid namespace and
> >> we properly prevent that in do_fork.
> >
> > I don't understand though - copy_process does have the right test:
> >
> >    1176          * If the new process will be in a different pid namespace
> >    1177          * don't allow the creation of threads.
> >    1178          */
> >    1179         if ((clone_flags & (CLONE_VM|CLONE_NEWPID)) &&
> >    1180             (task_active_pid_ns(current) != current->nsproxy->pid_ns))
> >    1181                 return ERR_PTR(-EINVAL);
> >
> > but why is it ok for sys_unshare not to do that?  Note that
> > in order for check_unshare_flags() to bail on &current->mm->mm_users > 1
> > you do have to set CLONE_VM (for inverse interpretation).
> >
> > So it seems to me this isn't safe as is, and we need to at least
> > set CLONE_VM if CLONE_PID is set.
> 
> Partly this is the difference in the meaning of the flags between
> unshare and clone.
> 
> Basically in unshare all othat gets changed is
> current->nsproxy->pid_ns_for_children (the rename is in the net tree).

D'oh, right.  Thanks!

Acked-by: Serge Hallyn <serge.hallyn@canonical.com>


> So because unshare of the pid namespace does not actually effect the
> current processes, just the pid namespace the children of the current
> thread will be in this is safe.
> 
> And frankly having the checks be obviously different is a good thing
> because it means that people will ask why in the world this is so and
> realize the difference in meaning.
> 
> Eric
