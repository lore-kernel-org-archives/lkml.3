Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752416Ab3FRGLu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 02:11:50 -0400
Received: from mail-lb0-f169.google.com ([209.85.217.169]:60934 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750704Ab3FRGLs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 02:11:48 -0400
Date: Tue, 18 Jun 2013 10:09:35 +0400
From: Andrew Vagin <avagin@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrey Vagin <avagin@openvz.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Serge E. Hallyn" <serge@hallyn.com>, Ingo Molnar <mingo@kernel.org>,
        Kees Cook <keescook@chromium.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH] [RFC] mnt: restrict a number of "struct mnt"
Message-ID: <20130618060935.GA28077@gmail.com>
References: <1371457498-27241-1-git-send-email-avagin@openvz.org>
 <878v284iif.fsf@xmission.com>
 <20130617155614.f0c5b9458d4ff9372a05eaa0@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <20130617155614.f0c5b9458d4ff9372a05eaa0@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 17, 2013 at 03:56:14PM -0700, Andrew Morton wrote:
> On Mon, 17 Jun 2013 12:58:00 -0700 ebiederm@xmission.com (Eric W. Biederman) wrote:
> 
> > > I found that a few processes can eat all host memory and nobody can kill them.
> > > $ mount -t tmpfs xxx /mnt
> > > $ mount --make-shared /mnt
> > > $ for i in `seq 30`; do mount --bind /mnt `mktemp -d /mnt/test.XXXXXX` & done
> > >
> > > All this processes are unkillable, because they took i_mutex and waits
> > > namespace_lock.
> > >
> > > ...
> > > 21715 pts/0 ______D __________0:00 __________________\_ mount --bind /mnt /mnt/test.ht6jzO
> > > 21716 pts/0 ______D __________0:00 __________________\_ mount --bind /mnt /mnt/test.97K4mI
> > > 21717 pts/0 ______R __________0:01 __________________\_ mount --bind /mnt /mnt/test.gO2CD9
> > > ...
> > >
> > > Each of this process doubles a number of mounts, so at the end we will
> > > have about 2^32 mounts and the size of struct mnt is 256 bytes, so we
> > > need about 1TB of RAM.
> > >
> > > Another problem is that ___umount___ of a big tree is very hard operation
> > > and it requires a lot of time.
> > > E.g.:
> > > 16411
> > > umount("/tmp/xxx", MNT_DETACH) __________________= 0 <7.852066> (7.8 sec)
> > > 32795
> > > umount("/tmp/xxx", MNT_DETACH) __________________= 0 <34.485501> ( 34 sec)
> > >
> > > For all this time sys_umoun takes namespace_sem and vfsmount_lock...
> > >
> > > Due to all this reasons I suggest to restrict a number of mounts.
> > > Probably we can optimize this code in a future, but now this restriction
> > > can help.
> > 
> > So for anyone seriously worried about this kind of thing in general we
> > already have the memory control group, which is quite capable of
> > limiting this kind of thing, and it limits all memory allocations not
> > just mount.
> 
> What is the exposure here?  By what means can a non-CAP_SYS_ADMIN user
> run sys_mount() under the namespace system?
> 
> IOW, what does the sysadmin have to do to permit this?  Is that a
> typical thing to do, or did the sysadmin make a mistake?

It's a problem for Linux Containers. Because usually the root user in
container should have enough rights to mount something (tmpfs,
bindmounts, etc).  Our target is to make containers completely isolated.

A container is isolated with help of namespaces. The user namespace
creates a new sets of capabilities and users.


> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
