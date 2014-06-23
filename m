Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750944AbaFWEHg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 00:07:36 -0400
Received: from static.92.5.9.176.clients.your-server.de ([176.9.5.92]:34715
	"EHLO mail.hallyn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711AbaFWEHf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 00:07:35 -0400
Date: Mon, 23 Jun 2014 06:07:32 +0200
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Marian Marinov <mm@1h.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        Linux Containers <containers@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        LXC development mailing-list 
	<lxc-devel@lists.linuxcontainers.org>
Subject: Re: [RFC] Per-user namespace process accounting
Message-ID: <20140623040732.GA24001@mail.hallyn.com>
References: <5386D58D.2080809@1h.com>
 <87tx88nbko.fsf@x220.int.ebiederm.org>
 <53870EAA.4060101@1h.com>
 <20140529153232.GB9714@ubuntumail>
 <538DFF72.7000209@parallels.com>
 <20140603172631.GL9714@ubuntumail>
 <8738flkhf0.fsf@x220.int.ebiederm.org>
 <538E4088.7010605@1h.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <538E4088.7010605@1h.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Marian Marinov (mm@1h.com):
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> On 06/03/2014 08:54 PM, Eric W. Biederman wrote:
> > Serge Hallyn <serge.hallyn@ubuntu.com> writes:
> > 
> >> Quoting Pavel Emelyanov (xemul@parallels.com):
> >>> On 05/29/2014 07:32 PM, Serge Hallyn wrote:
> >>>> Quoting Marian Marinov (mm@1h.com):
> >>>>> We are not using NFS. We are using a shared block storage that offers us snapshots. So provisioning new
> >>>>> containers is extremely cheep and fast. Comparing that with untar is comparing a race car with Smart. Yes
> >>>>> it can be done and no, I do not believe we should go backwards.
> >>>>> 
> >>>>> We do not share filesystems between containers, we offer them block devices.
> >>>> 
> >>>> Yes, this is a real nuisance for openstack style deployments.
> >>>> 
> >>>> One nice solution to this imo would be a very thin stackable filesystem which does uid shifting, or, better
> >>>> yet, a non-stackable way of shifting uids at mount.
> >>> 
> >>> I vote for non-stackable way too. Maybe on generic VFS level so that filesystems don't bother with it. From
> >>> what I've seen, even simple stacking is quite a challenge.
> >> 
> >> Do you have any ideas for how to go about it?  It seems like we'd have to have separate inodes per mapping for
> >> each file, which is why of course stacking seems "natural" here.
> >> 
> >> Trying to catch the uid/gid at every kernel-userspace crossing seems like a design regression from the current
> >> userns approach.  I suppose we could continue in the kuid theme and introduce a iiud/igid for the in-kernel inode
> >> uid/gid owners.  Then allow a user privileged in some ns to create a new mount associated with a different
> >> mapping for any ids over which he is privileged.
> > 
> > There is a simple solution.
> > 
> > We pick the filesystems we choose to support. We add privileged mounting in a user namespace. We create the user
> > and mount namespace. Global root goes into the target mount namespace with setns and performs the mounts.
> > 
> > 90% of that work is already done.
> > 
> > As long as we don't plan to support XFS (as it XFS likes to expose it's implementation details to userspace) it
> > should be quite straight forward.
> > 
> > The permission check change would probably only need to be:
> > 
> > 
> > @@ -2180,6 +2245,10 @@ static int do_new_mount(struct path *path, const char *fstype, int flags, return -ENODEV;
> > 
> > if (user_ns != &init_user_ns) { +               if (!(type->fs_flags & FS_UNPRIV_MOUNT) && !capable(CAP_SYS_ADMIN))
> > { +                       put_filesystem(type); +                       return -EPERM; +               } if
> > (!(type->fs_flags & FS_USERNS_MOUNT)) { put_filesystem(type); return -EPERM;
> > 
> > 
> > There are also a few funnies with capturing the user namespace of the filesystem when we perform the mount (in the
> > superblock?), and not allowing a mount of that same filesystem in a different user namespace.
> > 
> > But as long as the kuid conversions don't measurably slow down the filesystem when mounted in the initial mount and
> > user namespaces I don't see how this would be a problem for anyone, and is very little code.
> > 
> 
> This may solve one of the problems, but it does not solve the issue with UID/GID maps that overlap in different user
> namespaces.
> In our cases, this means breaking container migration mechanisms.
> 
> Will this at all be addressed or I'm the only one here that has this sort of requirement?

You're not.  The openstack scenario has the same problem.  So we have a
single base rootfs in a qcow2 or raw file which we want to mount into
multiple containers, each of which has a distinct set of uid mappings.

We'd like some way to identify uid mappings at mount time, without having
to walk the whole rootfs to chown every file.

(Of course safety would demand that the shared qcow2 use a set of high
subuids, NOT host uids - i.e. if we end up allowing a container to
own files owned by 0 on the host - even in a usually unmapped qcow2 -
there's danger we'd rather avoid, see again Andy's suggestions of
accidentidally auto-mounted filesystem images which happen to share a
UUID with host's / or /etc.  So we'd want to map uids 100000-106536
in the qcow2 to uids 0-65536 in the container, which in turn map to
uids 200000-206536 on the host)

-serge
