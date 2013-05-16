Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754983Ab3EPBWI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 21:22:08 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:32118 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751567Ab3EPBWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 21:22:05 -0400
X-Authority-Analysis: v=2.0 cv=DKcNElxb c=1 sm=0 a=tLUlnkoJZcZI9ocdGARlSQ==:17 a=c11ml42nfjYA:10 a=wom5GMh1gUkA:10 a=gZNcz0yrxDgA:10 a=Rj1_iGo3bfgA:10 a=kj9zAlcOel0A:10 a=hBqU3vQJAAAA:8 a=o0DOYjv4zn4A:10 a=PtDNVHqPAAAA:8 a=fxJcL_dCAAAA:8 a=20KFwNOVAAAA:8 a=D19gQVrFAAAA:8 a=cbXIOlfOAUVm-qHza74A:9 a=CjuIK1q_8ugA:10 a=4gZ4WExUoD4A:10 a=wYE_KDyynt4A:10 a=2eKvNQJKnqYA:10 a=jEp0ucaQiEUA:10 a=BowpvxSqkqVERDpy:21 a=86iZi5sp8u_hX6fG:21 a=tLUlnkoJZcZI9ocdGARlSQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 70.114.148.7
Date: Wed, 15 May 2013 20:23:10 -0500
From: "Serge E. Hallyn" <serge@hallyn.com>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        Aristeu Rozanski <aris@redhat.com>, linux-kernel@vger.kernel.org,
        morgan@kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH 0/4] Rebase device_cgroup v2 patchset
Message-ID: <20130516012310.GA17819@austin.hallyn.com>
References: <20121022134536.172969567@napanee.usersys.redhat.com>
 <20130514150539.GA26090@sergelap>
 <20130514155111.GJ680@redhat.com>
 <20130514162238.GA9056@sergelap>
 <87y5bhwa0h.fsf@xmission.com>
 <20130516011401.GA17462@austin.hallyn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130516011401.GA17462@austin.hallyn.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Serge E. Hallyn (serge@hallyn.com):
> Quoting Eric W. Biederman (ebiederm@xmission.com):
> > Serge Hallyn <serge.hallyn@ubuntu.com> writes:
> > 
> > > Quoting Aristeu Rozanski (aris@redhat.com):
> > >> On Tue, May 14, 2013 at 10:05:39AM -0500, Serge Hallyn wrote:
> > >> > so now that the device cgroup properly respects hierarchy, not allowing
> > >> > a cgroup to be given greater permission than its parent, should we consider
> > >> > relaxing the capability checks?
> > >> > 
> > >> > There are two capable(CAP_SYS_ADMIN) checks in deice_cgroup.c: one in
> > >> > devcgroup_can_attach() to protect changing another task's cgroup, and
> > >> > one in devcgroup_update_access() to protect writes to the devices.allow
> > >> > and devices.deny files.
> > >> > 
> > >> > I think the first should be changed to a check for ns_capable() to
> > >> > the victim's user_ns.  Something like 
> > >> > 
> > >> > --- a/security/device_cgroup.c
> > >> > +++ b/security/device_cgroup.c
> > >> > @@ -70,10 +70,16 @@ static int devcgroup_can_attach(struct cgroup *new_cgrp,
> > >> >                                 struct cgroup_taskset *set)
> > >> >  {
> > >> >         struct task_struct *task = cgroup_taskset_first(set);
> > >> > +       struct user_namespace *ns;
> > >> > +       int ret = -EPERM;
> > >> > 
> > >> > -       if (current != task && !capable(CAP_SYS_ADMIN))
> > >> > -               return -EPERM;
> > >> > -       return 0;
> > >> > +       if (current == task)
> > >> > +               return 0;
> > >> > +
> > >> > +       ns = userns_get(task);;
> > >> > +       ret = ns_capable(ns, CAP_SYS_ADMIN) ? 0 : -EPERM;
> > >> > +       put_user_ns(ns);
> > >> > +       return ret;
> > >> >  }
> > >> 
> > >> wouldn't this allow a userns root to move a task in the same userns into
> > >> a parent cgroup? I believe than anything but moving down the hierarchy
> > >> would be very complicated to verify (how far up can you go).
> > >
> > > But only if they are able to open the tasks file for writing, which
> > > they shouldn't be able to do, right?
> > 
> > That should be looked at very closely.  There are some funny exploits of
> > setuid root applications writing to files that have required some
> > additional permission checks on /proc/<pid>/uid_map.  I think the
> > cgroups files may be vulnerable to some of the same kind of exploits.
> > 
> > Certainly we should be verifying that the opener of the file had the
> > capabilities we are trying to use to avoid being open to those kinds of
> > problems.
> > 
> > I am trying to see the utilitity of the proposed patch.  It doesn't
> > allow mknod.  So what is the benefit of having the user namespace bits?
> 
> I'm still thinking through it, which is why I haven't sent a real
> patch.  What I'm working on is the unprivileged startup of a container.
> Right now most things are not allowed in a private user ns, so device
> cgroup is not as useful.  But it should be possible eventually to use
> block devices, which the original unprivileged user owned, by chowning
> the blockdev to a user mapped into the target userns.
> 
> The unprivileged user may want to use devices cgroup so he can chown
> the loop file into the container, but only allow read-only mounts, for
> instance.
> 
> > Is the point to allow the userns root to remove access to selected
> > devices from it's children even if the DAC permissions would allow the
> > access?
> 
> Yes I think that's it - except userns root before forking the container
> init (and venturing into the really untrusted category).
> 
> ...
> 
> > That said I haven't looked at open or mknod, and usually we are talking
> > about calls that aren't made by suid apps so I think there is a fair
> > chance that dropping some of those permissions could cause issues.
> > The first danger that crosses my mind is what happens if you remove
> > access to /dev/tty from a normal application that would trying and log
> > strange goings on to a user if they could.
> 
> If they were going to do that over tty, that would be to the malicious
> user anyway, so that should just either be ignored, or result in the
> program exiting early.
> 
> > Shrug mostly I don't see the advantage of this change.
> 
> It's also possible that this will end up being worked around by the new
> (not-yet-designed) interface/library which Tejun wants people to use,
> sitting above the cgroupfs.  At least at a first layer.
> 
> Anyway this isn't urgent, as it's not in the way for general unprivileged
> container creation.  But in general if we don't need the check to be
> capable(), it would be better to introduce the right check.
> 
> -serge

I'm terribly sorry, Andrew, I have no idea how that address for you got
into my address book.  (Corrected)  fwiw the thread can be followed at
https://lkml.org/lkml/2013/5/14/363 .

-serge
