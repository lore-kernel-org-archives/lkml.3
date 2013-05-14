Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758492Ab3ENVCR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 17:02:17 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:43192 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758091Ab3ENVCP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 17:02:15 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Serge Hallyn <serge.hallyn@ubuntu.com>
Cc: Aristeu Rozanski <aris@redhat.com>, linux-kernel@vger.kernel.org,
        amorgan@redhat.com, cgroups@vger.kernel.org
References: <20121022134536.172969567@napanee.usersys.redhat.com>
	<20130514150539.GA26090@sergelap> <20130514155111.GJ680@redhat.com>
	<20130514162238.GA9056@sergelap>
Date: Tue, 14 May 2013 14:02:06 -0700
In-Reply-To: <20130514162238.GA9056@sergelap> (Serge Hallyn's message of "Tue,
	14 May 2013 11:22:38 -0500")
Message-ID: <87y5bhwa0h.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/bfw+jslpPv+azTK7VQvnYkA7bzX8Xx5o=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  1.2 XM_Multi_Part_URI URI: Long-Multi-Part URIs
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Serge Hallyn <serge.hallyn@ubuntu.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH 0/4] Rebase device_cgroup v2 patchset
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Serge Hallyn <serge.hallyn@ubuntu.com> writes:

> Quoting Aristeu Rozanski (aris@redhat.com):
>> On Tue, May 14, 2013 at 10:05:39AM -0500, Serge Hallyn wrote:
>> > so now that the device cgroup properly respects hierarchy, not allowing
>> > a cgroup to be given greater permission than its parent, should we consider
>> > relaxing the capability checks?
>> > 
>> > There are two capable(CAP_SYS_ADMIN) checks in deice_cgroup.c: one in
>> > devcgroup_can_attach() to protect changing another task's cgroup, and
>> > one in devcgroup_update_access() to protect writes to the devices.allow
>> > and devices.deny files.
>> > 
>> > I think the first should be changed to a check for ns_capable() to
>> > the victim's user_ns.  Something like 
>> > 
>> > --- a/security/device_cgroup.c
>> > +++ b/security/device_cgroup.c
>> > @@ -70,10 +70,16 @@ static int devcgroup_can_attach(struct cgroup *new_cgrp,
>> >                                 struct cgroup_taskset *set)
>> >  {
>> >         struct task_struct *task = cgroup_taskset_first(set);
>> > +       struct user_namespace *ns;
>> > +       int ret = -EPERM;
>> > 
>> > -       if (current != task && !capable(CAP_SYS_ADMIN))
>> > -               return -EPERM;
>> > -       return 0;
>> > +       if (current == task)
>> > +               return 0;
>> > +
>> > +       ns = userns_get(task);;
>> > +       ret = ns_capable(ns, CAP_SYS_ADMIN) ? 0 : -EPERM;
>> > +       put_user_ns(ns);
>> > +       return ret;
>> >  }
>> 
>> wouldn't this allow a userns root to move a task in the same userns into
>> a parent cgroup? I believe than anything but moving down the hierarchy
>> would be very complicated to verify (how far up can you go).
>
> But only if they are able to open the tasks file for writing, which
> they shouldn't be able to do, right?

That should be looked at very closely.  There are some funny exploits of
setuid root applications writing to files that have required some
additional permission checks on /proc/<pid>/uid_map.  I think the
cgroups files may be vulnerable to some of the same kind of exploits.

Certainly we should be verifying that the opener of the file had the
capabilities we are trying to use to avoid being open to those kinds of
problems.

I am trying to see the utilitity of the proposed patch.  It doesn't
allow mknod.  So what is the benefit of having the user namespace bits?

Is the point to allow the userns root to remove access to selected
devices from it's children even if the DAC permissions would allow the
access?

>> > For the second, the hierarchy support should let us ignore concerns
>> > about unprivileged users escalating privilege, but I'm trying to decide
>> > whether we  need to worry about the sendmail capability class of bugs.
>> 
>> You have a pointer for more information on those?
>
> Darn - unfortunately the best description of it, which was at
> http://userweb.kernel.org/~morgan/sendmail-capabilities-war-story.html
> is no longer there since userweb was taken down, and it was never
> captured by archive.org.  There's a brief description in
> http://lwn.net/Articles/280279/ at the paragraph starting with "The
> memory of the sendmail-capabilities bug from 2000..."

I think the sendmail website has something as well.  The core problem
was programs not dealing safely with having some of their privileges
removed.  As I recall an unprivileged attacker at one point could drop
the CAP_SYS_SETUID on sendmail and get it to deliver mail as root.

I took a good hard look at this issue before implementing limits on
setuid in the user namespace and it appears that the authors of setuid
application learned from this as well and I could not find an single
program that would call setuid without out checking it's return code.

That said I haven't looked at open or mknod, and usually we are talking
about calls that aren't made by suid apps so I think there is a fair
chance that dropping some of those permissions could cause issues.

The first danger that crosses my mind is what happens if you remove
access to /dev/tty from a normal application that would trying and log
strange goings on to a user if they could.

Shrug mostly I don't see the advantage of this change.

Eric


>> > My sense is actually the answer is no, and we can drop the capable()
>> > check altogether.  The reason is that while userspace frequently doesn't
>> > properly handle a failing system call due to unexpected lack of partial
>> > privilege, I wouldn't expect any setuid root program to ignore failure
>> > to open or mknod a device file (and proceed into a bad failure mode).
>> > Does this sound rasonable, or a recipe for disaster?
>> 
>> The second case sounds ok to me
>
> -serge
