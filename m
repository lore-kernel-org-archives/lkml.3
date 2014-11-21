Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752185AbaKUSZv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 13:25:51 -0500
Received: from mail-lb0-f181.google.com ([209.85.217.181]:38050 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751958AbaKUSZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 13:25:48 -0500
MIME-Version: 1.0
In-Reply-To: <87ppcgju9w.fsf@x220.int.ebiederm.org>
References: <1414013060-137148-1-git-send-email-seth.forshee@canonical.com>
 <1414013060-137148-3-git-send-email-seth.forshee@canonical.com>
 <20141111140454.GD333@tucsk> <87mw7xd9zt.fsf@x220.int.ebiederm.org>
 <20141112130915.GG333@tucsk> <20141112162254.GB31775@ubuntu-hedt>
 <20141118152156.GA21726@ubuntu-mba51> <CAJfpeguuT1V1Pf0iFXRozmeohDH2Jy=p8o=1EnvD_qfB1CTQuA@mail.gmail.com>
 <CAJfpeguctYFkzBPN26=WjOCLTt2mqvouHXqLZ1sRqZngtbw8CQ@mail.gmail.com>
 <20141119140911.GA27009@mail.hallyn.com> <20141121164441.GA1730@ubuntu-mba51> <87ppcgju9w.fsf@x220.int.ebiederm.org>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 21 Nov 2014 10:25:26 -0800
Message-ID: <CALCETrVKPFW_3cSet+2qKWkfyOM=pk=9OvJYeVAX2hMeizeLtw@mail.gmail.com>
Subject: Re: [PATCH v5 2/4] fuse: Support fuse filesystems outside of init_user_ns
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Seth Forshee <seth.forshee@canonical.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        "Serge H. Hallyn" <serge.hallyn@ubuntu.com>,
        Michael j Theall <mtheall@us.ibm.com>,
        fuse-devel <fuse-devel@lists.sourceforge.net>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 21, 2014 at 10:14 AM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
> Seth Forshee <seth.forshee@canonical.com> writes:
>
>> On Wed, Nov 19, 2014 at 03:09:11PM +0100, Serge E. Hallyn wrote:
>>> Quoting Miklos Szeredi (miklos@szeredi.hu):
>>> > On Wed, Nov 19, 2014 at 9:50 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>>> > > On Tue, Nov 18, 2014 at 4:21 PM, Seth Forshee
>>> > > <seth.forshee@canonical.com> wrote:
>>> > >>> I asked around a bit, and it turns out there are use cases for nested
>>> > >> containers (i.e. a container within a container) where the rootfs for
>>> > >> the outer container mounts a filesystem containing the rootfs for the
>>> > >> inner container. If that mount is nosuid then suid utilities like ping
>>> > >> aren't going to work in the inner container.
>>> > >>
>>> > >> So since there's a use case for suid in a userns mount and we have what
>>> > >> we belive are sufficient protections against using this as a vector to
>>> > >> get privileges outside the container, I'm planning to move ahead without
>>> > >> the MNT_NOSUID restriction. Any objections?
>>> > >
>>> > > In the general case how'd we prevent suid executable being tricked to
>>> > > do something it shouldn't do by unprivileged mounting into sensitive
>>> > > places (i.e. config files) inside the container?
>>>
>>> The design of the namespaces would prevent that.  You cannot manipulate your
>>> mounts namespace unless you own it.  You cannot manipulate the mounts namespace
>>> for a task whose user namespace you do not own.  If you can, for instance,
>>> bind mount $HOME/shadow onto /etc/shadow, then you already own your user
>>> namespace and are root there, so any suid-root program which you mount through
>>> fuse will only subjegate your own namespace.  Any task which running in the
>>> parent user-ns (and therefore parent mount-ns) will not see your bind mount.
>>>
>>> > > Allowing SUID looks like a slippery slope to me.  And there are plenty
>>> > > of solutions to the "ping" problem, AFAICS, that don't involve the
>>> > > suid bit.
>>> >
>>> > ping isn't even suid on my system, it has security.capability xattr instead.
>>>
>>> security.capability xattrs that will have the exact same concerns wrt
>>> confusion through bind mounts as suid.
>>>
>>> > Please just get rid of SUID/SGID.  It's a legacy, it's a hack, not
>>> > worth the complexity and potential problems arising from that
>>> > complexity.
>>>
>>> Oh boy, I don't know which side to sit on here :)  I'm all for replacing
>>> suid with some use of file capabilities, but realistically there are reasons
>>> why that hasn't happened more widely than it has - tar, package managers,
>>> cpio, nfs, etc.
>>
>> Miklos: I we're all generally in agreement here that suid/sgid is not
>> the best solution, but as Serge points out we are unfortunately not yet
>> in a place where it can be completely dropped in favor of capabilities.
>> In light of this can I convince you to reconsider your position?
>
> Regardless of what fuse does user namespaces must support mounting
> filesystems that have the setuid and setgid bits set.  Likewise we need
> to handle capabilities.
>
> There is a parallel bit of work to the fuse patches that I think at this
> point should be completed first.
>
> - Add s_user_ns to struct super.  So we can have filesystems whose
>   labels are not interpreted at a global scope.
>

I agree with this.  Although I'm not sure why fuse needs to wait for it.

> - Tweak the file capability code to look at s_user_ns and treat it
>   properly.
>
> - Tweak the lsms to look at s_user_ns and ignore security labels that
>   don't come from init_user_ns.  (The lsms at their discrection can
>   be more trusting but the default should be for them to ignore those
>   labels).
>

These two make me a bit nervous.  Suppose that I take filesystem with
s_user_ns == &init_user_ns and bind mount it somewhere in my
namespace.  Then I pass an fd to it back out to the init ns.  Under
this logic, LSMs and fscaps will trust that fd.  If we look at the
mount namespace instead, fscps will not trust that fd.  (I haven't
updated LSMs, but I think that LSMs should consider the mount ns, not
the super ns, as well.)

It's not clear to me that allowing unprivileged users to mess around
like this is safe.  It ought to be okay for fscaps and maybe even for
selinux, but apparmor may get very confused, since the unprivileged
user has essentially full control over the pathnames (at least if
they're relative to the fd's mount ns).

It may be safe, but I'm less confident in it than I am in trusting the
path's mount ns.

> - Tweak the security checks to allow setting file capabilities and
>   other security xattrs if we have the appropriate capabilities in
>   s_user_ns.
>
> - Update tmpfs and ramfs to set s_user_ns when being mounted.
>
>
> When those bits are done we can tweak the fuse patches to also set
> s_user_ns.
>
> As for MNT_NO_SUID if fuse wants to enforce that in some way.  I don't
> particularly care, but I don't think that makes sense as a vfs property.
>


--Andy
