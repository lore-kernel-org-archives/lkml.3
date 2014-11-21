Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932470AbaKURTg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 12:19:36 -0500
Received: from mail-lb0-f172.google.com ([209.85.217.172]:43672 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755488AbaKURTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 12:19:34 -0500
MIME-Version: 1.0
In-Reply-To: <20141121164441.GA1730@ubuntu-mba51>
References: <1414013060-137148-1-git-send-email-seth.forshee@canonical.com>
 <1414013060-137148-3-git-send-email-seth.forshee@canonical.com>
 <20141111140454.GD333@tucsk> <87mw7xd9zt.fsf@x220.int.ebiederm.org>
 <20141112130915.GG333@tucsk> <20141112162254.GB31775@ubuntu-hedt>
 <20141118152156.GA21726@ubuntu-mba51> <CAJfpeguuT1V1Pf0iFXRozmeohDH2Jy=p8o=1EnvD_qfB1CTQuA@mail.gmail.com>
 <CAJfpeguctYFkzBPN26=WjOCLTt2mqvouHXqLZ1sRqZngtbw8CQ@mail.gmail.com>
 <20141119140911.GA27009@mail.hallyn.com> <20141121164441.GA1730@ubuntu-mba51>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 21 Nov 2014 09:19:12 -0800
Message-ID: <CALCETrUZhgJ7S69G=apiKLT3jp+AHubTQnY--R+NKhLTA-_vBA@mail.gmail.com>
Subject: Re: [PATCH v5 2/4] fuse: Support fuse filesystems outside of init_user_ns
To: Seth Forshee <seth.forshee@canonical.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, "Serge E. Hallyn" <serge@hallyn.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Serge H. Hallyn" <serge.hallyn@ubuntu.com>,
        Michael j Theall <mtheall@us.ibm.com>,
        fuse-devel <fuse-devel@lists.sourceforge.net>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 21, 2014 at 8:44 AM, Seth Forshee
<seth.forshee@canonical.com> wrote:
> On Wed, Nov 19, 2014 at 03:09:11PM +0100, Serge E. Hallyn wrote:
>> Quoting Miklos Szeredi (miklos@szeredi.hu):
>> > On Wed, Nov 19, 2014 at 9:50 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>> > > On Tue, Nov 18, 2014 at 4:21 PM, Seth Forshee
>> > > <seth.forshee@canonical.com> wrote:
>> > >>> I asked around a bit, and it turns out there are use cases for nested
>> > >> containers (i.e. a container within a container) where the rootfs for
>> > >> the outer container mounts a filesystem containing the rootfs for the
>> > >> inner container. If that mount is nosuid then suid utilities like ping
>> > >> aren't going to work in the inner container.
>> > >>
>> > >> So since there's a use case for suid in a userns mount and we have what
>> > >> we belive are sufficient protections against using this as a vector to
>> > >> get privileges outside the container, I'm planning to move ahead without
>> > >> the MNT_NOSUID restriction. Any objections?
>> > >
>> > > In the general case how'd we prevent suid executable being tricked to
>> > > do something it shouldn't do by unprivileged mounting into sensitive
>> > > places (i.e. config files) inside the container?
>>
>> The design of the namespaces would prevent that.  You cannot manipulate your
>> mounts namespace unless you own it.  You cannot manipulate the mounts namespace
>> for a task whose user namespace you do not own.  If you can, for instance,
>> bind mount $HOME/shadow onto /etc/shadow, then you already own your user
>> namespace and are root there, so any suid-root program which you mount through
>> fuse will only subjegate your own namespace.  Any task which running in the
>> parent user-ns (and therefore parent mount-ns) will not see your bind mount.
>>
>> > > Allowing SUID looks like a slippery slope to me.  And there are plenty
>> > > of solutions to the "ping" problem, AFAICS, that don't involve the
>> > > suid bit.
>> >
>> > ping isn't even suid on my system, it has security.capability xattr instead.
>>
>> security.capability xattrs that will have the exact same concerns wrt
>> confusion through bind mounts as suid.
>>
>> > Please just get rid of SUID/SGID.  It's a legacy, it's a hack, not
>> > worth the complexity and potential problems arising from that
>> > complexity.
>>
>> Oh boy, I don't know which side to sit on here :)  I'm all for replacing
>> suid with some use of file capabilities, but realistically there are reasons
>> why that hasn't happened more widely than it has - tar, package managers,
>> cpio, nfs, etc.
>
> Miklos: I we're all generally in agreement here that suid/sgid is not
> the best solution, but as Serge points out we are unfortunately not yet
> in a place where it can be completely dropped in favor of capabilities.
> In light of this can I convince you to reconsider your position?
>

I would go one step further: all the things that gain privilege on
exec (suig/sgid, fscaps, and LSM transitions) are not just "not the
best" but are in fact disasters.  They made sense when systems had a
few KB of RAM.

suid/sgid is at least a /standardized/ disaster, though, and
namespaced code should be able to use it.

Miklos, I'm not sure whether you saw it (it was a bit buried, I
think), but this series is intended to depend on a patch of mine that
makes all mounts that belong to foreign namespaces act as though
they're MNT_NOSUID.  That means that, in order for suid/sgid to do
anything, the namespace owner needs to indicate their trust in the fs
by explicitly mounting it.

--Andy
