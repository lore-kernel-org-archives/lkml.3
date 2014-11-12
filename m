Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753304AbaKLQXD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 11:23:03 -0500
Received: from mail-oi0-f46.google.com ([209.85.218.46]:40714 "EHLO
	mail-oi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752377AbaKLQXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 11:23:00 -0500
Date: Wed, 12 Nov 2014 10:22:54 -0600
From: Seth Forshee <seth.forshee@canonical.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        "Serge H. Hallyn" <serge.hallyn@ubuntu.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Michael j Theall <mtheall@us.ibm.com>,
        fuse-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, seth.forshee@canonical.com
Subject: Re: [PATCH v5 2/4] fuse: Support fuse filesystems outside of
 init_user_ns
Message-ID: <20141112162254.GB31775@ubuntu-hedt>
Mail-Followup-To: Miklos Szeredi <miklos@szeredi.hu>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	"Serge H. Hallyn" <serge.hallyn@ubuntu.com>,
	Andy Lutomirski <luto@amacapital.net>,
	Michael j Theall <mtheall@us.ibm.com>,
	fuse-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
References: <1414013060-137148-1-git-send-email-seth.forshee@canonical.com>
 <1414013060-137148-3-git-send-email-seth.forshee@canonical.com>
 <20141111140454.GD333@tucsk>
 <87mw7xd9zt.fsf@x220.int.ebiederm.org>
 <20141112130915.GG333@tucsk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141112130915.GG333@tucsk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 12, 2014 at 02:09:15PM +0100, Miklos Szeredi wrote:
> On Tue, Nov 11, 2014 at 09:37:10AM -0600, Eric W. Biederman wrote:
> 
> > > Maybe I'm being dense, but can someone give a concrete example of such an
> > > attack?
> > 
> > There are two variants of things at play here.
> > 
> > There is the classic if you don't freeze your context at open time when
> > you pass that file descriptor to another process unexpected things can
> > happen.  
> > 
> > An essentially harmless but extremely confusing example is what happens
> > to a partial read when it stops halfway through a uid value and the next
> > read on the same file descriptor is from a process in a different user
> > namespace.  Which uid value should be returned to userspace.
> 
> Fuse device doesn't currently do partial reads, so that's a non-issue.
> 
> > Now if I am in a nefarious mood I can create a unprivileged user
> > namespace, open /dev/fuse and mount a fuse filesystem.  Pass the file
> > descriptor to /dev/fuse to a processes that is in the default user
> > namespace (and thus can use any uid/gid).   With that file desctipor
> > report that there is a setuid 0 exectuable on that file system.
> 
> Yes, and this would also be prevented by MNT_NOSUID, which would be a good idea
> anyway.  I just don't see the reason we'd want to allow clearing MNT_NOSUID in a
> private namespace.
> 
> So we don't currently see a use case for relaxing either the MNT_NOSUID
> restriction or for relaxing the requirement on the user namespace the fuse
> server is in.  Is that correct?
> 
> If so, we should leave both restrictions in place since that allows the greatest
> flexibility in the future, is either of those needs to be relaxed.

I'm not aware of specific use cases for either at this point. However,
Andy's patch [1] will limit suid to the set of namespaces where the user
who mounted the filesystem already has privileges. Enforcing MNT_NOSUID
will require enforcement in the vfs, and in that case we definitely need
to decide whether the policy is to implicitly add the flag or fail the
mount attempt if the flag is not present [2].

> > > That might also help me understand how exactly user/pid namespaces work...
> > 
> > The idea of user/pid namespaces is to translate uid, gids and pids at
> > the edge of userspace into a kernel internal form that can be use
> > everywhere.  In this case we get into the subtlties of which
> > translations make sense.
> 
> I mean, what's the point of translating uid, gids and pids?  What are the use
> cases?

Do you mean in general, or for fuse specifically? In general user/pid
namespaces are primarily used to implement containers with isolated sets
of resources (if you're unfamiliar with containers, think of something
which looks more or less like a VM from within but runs under the same
kernel as the host).

For fuse: an unprivileged user has a regular file containing a
filesystem image which they wish to mount inside a container using fuse.
Assume that in this container uid 0 maps to uid 100000 in the host, etc.
The filesystem image is likely to be using ids like 0, 1000, etc. If the
kernel translates these to kuid 0, 1000, ... then these will map to
overflowuid in the container, and the mount won't be very useful to the
user. What the user expects is that uid 0 in the filesystem will map to
uid 0 within the container (kuid 100000 in this example).

The pids aren't nearly so user-visible, but if the userspace fuse driver
is running in a pid namespace then pids must be translated into the
namespace to be useful to the driver.

Does that answer your questions?

> What are the rules on the translations between parent and child namespaces?
> 
> Is all this documented anywhere?

I haven't found any documentation. Eric?

As far as I can tell though the most important rules are to translate
to/from the kernel's internal representation as close to the
userspace/kernel boundary as possible and to work with kernel-internal
representations within the kernel (e.g. kuid_t, kgid_t, etc.).

The series of articles starting with [3] also serve as a good
introduction.

Thanks,
Seth

[1] http://lkml.kernel.org/g/252a4d87d99fc2b5fe4411c838f65b312c4e13cd.1413330857.git.luto@amacapital.net
[2] http://lkml.kernel.org/g/2686c32f00b14148379e8cfee9c028c794d4aa1a.1407974494.git.luto@amacapital.net
[3] http://lwn.net/Articles/531114/
