Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752324Ab3FQW4S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 18:56:18 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42007 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751994Ab3FQW4R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 18:56:17 -0400
Date: Mon, 17 Jun 2013 15:56:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: Andrey Vagin <avagin@openvz.org>, Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Serge E. Hallyn" <serge@hallyn.com>, Ingo Molnar <mingo@kernel.org>,
        Kees Cook <keescook@chromium.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH] [RFC] mnt: restrict a number of "struct mnt"
Message-Id: <20130617155614.f0c5b9458d4ff9372a05eaa0@linux-foundation.org>
In-Reply-To: <878v284iif.fsf@xmission.com>
References: <1371457498-27241-1-git-send-email-avagin@openvz.org>
	<878v284iif.fsf@xmission.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Jun 2013 12:58:00 -0700 ebiederm@xmission.com (Eric W. Biederman) wrote:

> > I found that a few processes can eat all host memory and nobody can kill them.
> > $ mount -t tmpfs xxx /mnt
> > $ mount --make-shared /mnt
> > $ for i in `seq 30`; do mount --bind /mnt `mktemp -d /mnt/test.XXXXXX` & done
> >
> > All this processes are unkillable, because they took i_mutex and waits
> > namespace_lock.
> >
> > ...
> > 21715 pts/0 ______D __________0:00 __________________\_ mount --bind /mnt /mnt/test.ht6jzO
> > 21716 pts/0 ______D __________0:00 __________________\_ mount --bind /mnt /mnt/test.97K4mI
> > 21717 pts/0 ______R __________0:01 __________________\_ mount --bind /mnt /mnt/test.gO2CD9
> > ...
> >
> > Each of this process doubles a number of mounts, so at the end we will
> > have about 2^32 mounts and the size of struct mnt is 256 bytes, so we
> > need about 1TB of RAM.
> >
> > Another problem is that ___umount___ of a big tree is very hard operation
> > and it requires a lot of time.
> > E.g.:
> > 16411
> > umount("/tmp/xxx", MNT_DETACH) __________________= 0 <7.852066> (7.8 sec)
> > 32795
> > umount("/tmp/xxx", MNT_DETACH) __________________= 0 <34.485501> ( 34 sec)
> >
> > For all this time sys_umoun takes namespace_sem and vfsmount_lock...
> >
> > Due to all this reasons I suggest to restrict a number of mounts.
> > Probably we can optimize this code in a future, but now this restriction
> > can help.
> 
> So for anyone seriously worried about this kind of thing in general we
> already have the memory control group, which is quite capable of
> limiting this kind of thing, and it limits all memory allocations not
> just mount.

What is the exposure here?  By what means can a non-CAP_SYS_ADMIN user
run sys_mount() under the namespace system?

IOW, what does the sysadmin have to do to permit this?  Is that a
typical thing to do, or did the sysadmin make a mistake?
