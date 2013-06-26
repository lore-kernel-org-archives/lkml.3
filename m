Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752953Ab3FZU0z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 16:26:55 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56235 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752696Ab3FZU0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 16:26:53 -0400
Date: Wed, 26 Jun 2013 15:26:47 -0500
From: Serge Hallyn <serge.hallyn@ubuntu.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org, "Daniel P. Berrange" <berrange@redhat.com>,
        containers@lists.linux-foundation.org,
        Colin Ian King <colin.king@canonical.com>,
        =?iso-8859-1?Q?St=E9phane?= Graber <stgraber@ubuntu.com>
Subject: Re: [PATCH RFC] procfs: add pidnr file
Message-ID: <20130626202647.GA3001@sergelap>
References: <20130626161820.GA32142@tp>
 <877ghg4q6i.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <877ghg4q6i.fsf@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Eric W. Biederman (ebiederm@xmission.com):
> Serge Hallyn <serge.hallyn@ubuntu.com> writes:
> 
> > Add a file called pidnr under /proc/task/.  Reading this file gives the
> > pid of /proc/task in the reading task's namespace (or 0 if there is no
> > valid pid).
> >
> > This fills a need currently not solvable at all.  The particular need I
> > have for it is so that a task inside a container can pass requests to a
> > task outside the container (using an open fd for /proc/task) to have the
> > target task moved to a new cgroup.  Others have asked for this ability
> > for other reasons.
> 
> This is solvable today.  Just pass the pid using SCM_CREDENTIALS over a
> unix domain socket between the two processes.  That is actually better
> because a task can't claim to be a member of another task.  You already
> have the unix domain socket if you are using SCM_RIGHTS to pass file
> descriptors.

Hm, yeah, that should work.  (I was thinking I had to do a
getpeercon-like thing where I could only get the ucreds of the
task which opened the socket).  I'll try it to see if there are 
any gotchas.

Note though that this doesn't help the general admin case, because
it requires a program (and not a one-liner) running in the container.
So I can't just do

	cat /proc/`pidof container-init`/root/proc/200/pidnr"

to figure out the corresponding pid in my own ns.  Whereas that cat
doesn't require me to execute anything inside that container.

Wonder if coreutils should ship a program which clones a task in
same netns but target pidns, and sends ucred.pid = atoi(argv[1])
from that pidns to the first task which prints out what it reads.

That should be a tidy, purely userspace solution to the general admin
problem.  Only downside being that it requires the rights to setns to
the pidns, instead of just read access to its /proc.

thanks,
-serge
