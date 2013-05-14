Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755022Ab3ENQWp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 12:22:45 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40467 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194Ab3ENQWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 12:22:44 -0400
Date: Tue, 14 May 2013 11:22:38 -0500
From: Serge Hallyn <serge.hallyn@ubuntu.com>
To: Aristeu Rozanski <aris@redhat.com>
Cc: linux-kernel@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>,
        amorgan@redhat.com, cgroups@vger.kernel.org
Subject: Re: [PATCH 0/4] Rebase device_cgroup v2 patchset
Message-ID: <20130514162238.GA9056@sergelap>
References: <20121022134536.172969567@napanee.usersys.redhat.com>
 <20130514150539.GA26090@sergelap>
 <20130514155111.GJ680@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130514155111.GJ680@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Aristeu Rozanski (aris@redhat.com):
> On Tue, May 14, 2013 at 10:05:39AM -0500, Serge Hallyn wrote:
> > so now that the device cgroup properly respects hierarchy, not allowing
> > a cgroup to be given greater permission than its parent, should we consider
> > relaxing the capability checks?
> > 
> > There are two capable(CAP_SYS_ADMIN) checks in deice_cgroup.c: one in
> > devcgroup_can_attach() to protect changing another task's cgroup, and
> > one in devcgroup_update_access() to protect writes to the devices.allow
> > and devices.deny files.
> > 
> > I think the first should be changed to a check for ns_capable() to
> > the victim's user_ns.  Something like 
> > 
> > --- a/security/device_cgroup.c
> > +++ b/security/device_cgroup.c
> > @@ -70,10 +70,16 @@ static int devcgroup_can_attach(struct cgroup *new_cgrp,
> >                                 struct cgroup_taskset *set)
> >  {
> >         struct task_struct *task = cgroup_taskset_first(set);
> > +       struct user_namespace *ns;
> > +       int ret = -EPERM;
> > 
> > -       if (current != task && !capable(CAP_SYS_ADMIN))
> > -               return -EPERM;
> > -       return 0;
> > +       if (current == task)
> > +               return 0;
> > +
> > +       ns = userns_get(task);;
> > +       ret = ns_capable(ns, CAP_SYS_ADMIN) ? 0 : -EPERM;
> > +       put_user_ns(ns);
> > +       return ret;
> >  }
> 
> wouldn't this allow a userns root to move a task in the same userns into
> a parent cgroup? I believe than anything but moving down the hierarchy
> would be very complicated to verify (how far up can you go).

But only if they are able to open the tasks file for writing, which
they shouldn't be able to do, right?

> > For the second, the hierarchy support should let us ignore concerns
> > about unprivileged users escalating privilege, but I'm trying to decide
> > whether we  need to worry about the sendmail capability class of bugs.
> 
> You have a pointer for more information on those?

Darn - unfortunately the best description of it, which was at
http://userweb.kernel.org/~morgan/sendmail-capabilities-war-story.html
is no longer there since userweb was taken down, and it was never
captured by archive.org.  There's a brief description in
http://lwn.net/Articles/280279/ at the paragraph starting with "The
memory of the sendmail-capabilities bug from 2000..."

> > My sense is actually the answer is no, and we can drop the capable()
> > check altogether.  The reason is that while userspace frequently doesn't
> > properly handle a failing system call due to unexpected lack of partial
> > privilege, I wouldn't expect any setuid root program to ignore failure
> > to open or mknod a device file (and proceed into a bad failure mode).
> > Does this sound rasonable, or a recipe for disaster?
> 
> The second case sounds ok to me

-serge
