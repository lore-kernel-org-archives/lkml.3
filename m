Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751616AbaHTPOh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 11:14:37 -0400
Received: from mail-vc0-f170.google.com ([209.85.220.170]:39910 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750916AbaHTPOf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 11:14:35 -0400
MIME-Version: 1.0
In-Reply-To: <87fvhav3ic.fsf@x220.int.ebiederm.org>
References: <87fvhav3ic.fsf@x220.int.ebiederm.org>
Date: Wed, 20 Aug 2014 17:06:59 +0200
Message-ID: <CAFLxGvwi-iJRyfwv8v9fcRkiSu2d-az8W55xMPbp_d8wQKmwjg@mail.gmail.com>
Subject: Re: [GIT PULL] namespace updates for v3.17-rc1
From: Richard Weinberger <richard.weinberger@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Containers <containers@lists.linux-foundation.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "libvir-list@redhat.com" <libvir-list@redhat.com>,
        "Daniel P. Berrange" <berrange@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 6, 2014 at 2:57 AM, Eric W. Biederman <ebiederm@xmission.com> wrote:
>
> Linus,
>
> Please pull the for-linus branch from the git tree:
>
>    git://git.kernel.org/pub/scm/linux/kernel/git/ebiederm/user-namespace.git for-linus
>
>    HEAD: 344470cac42e887e68cfb5bdfa6171baf27f1eb5 proc: Point /proc/mounts at /proc/thread-self/mounts instead of /proc/self/mounts
>
> This is a bunch of small changes built against 3.16-rc6.  The most
> significant change for users is the first patch which makes setns
> drmatically faster by removing unneded rcu handling.
>
> The next chunk of changes are so that "mount -o remount,.." will not
> allow the user namespace root to drop flags on a mount set by the system
> wide root.  Aks this forces read-only mounts to stay read-only, no-dev
> mounts to stay no-dev, no-suid mounts to stay no-suid, no-exec mounts to
> stay no exec and it prevents unprivileged users from messing with a
> mounts atime settings.  I have included my test case as the last patch
> in this series so people performing backports can verify this change
> works correctly.
>
> The next change fixes a bug in NFS that was discovered while auditing
> nsproxy users for the first optimization.  Today you can oops the kernel
> by reading /proc/fs/nfsfs/{servers,volumes} if you are clever with pid
> namespaces.  I rebased and fixed the build of the !CONFIG_NFS_FS case
> yesterday when a build bot caught my typo.  Given that no one to my
> knowledge bases anything on my tree fixing the typo in place seems more
> responsible that requiring a typo-fix to be backported as well.
>
> The last change is a small semantic cleanup introducing
> /proc/thread-self and pointing /proc/mounts and /proc/net at it.  This
> prevents several kinds of problemantic corner cases.  It is a
> user-visible change so it has a minute chance of causing regressions so
> the change to /proc/mounts and /proc/net are individual one line commits
> that can be trivially reverted.  Unfortunately I lost and could not find
> the email of the original reporter so he is not credited.  From at least
> one perspective this change to /proc/net is a refgression fix to allow
> pthread /proc/net uses that were broken by the introduction of the network
> namespace.
>
> Eric
>
> Eric W. Biederman (11):
>       namespaces: Use task_lock and not rcu to protect nsproxy
>       mnt: Only change user settable mount flags in remount
>       mnt: Move the test for MNT_LOCK_READONLY from change_mount_flags into do_remount
>       mnt: Correct permission checks in do_remount

This commit breaks libvirt-lxc.
libvirt does in lxcContainerMountBasicFS():

        /*
         * We can't immediately set the MS_RDONLY flag when mounting filesystems
         * because (in at least some kernel versions) this will propagate back
         * to the original mount in the host OS, turning it readonly too. Thus
         * we mount the filesystem in read-write mode initially, and then do a
         * separate read-only bind mount on top of that.
         */
        bindOverReadonly = !!(mnt_mflags & MS_RDONLY);

        VIR_DEBUG("Mount %s on %s type=%s flags=%x",
                  mnt_src, mnt->dst, mnt->type, mnt_mflags & ~MS_RDONLY);
        if (mount(mnt_src, mnt->dst, mnt->type, mnt_mflags &
~MS_RDONLY, NULL) < 0) {

^^^^ Here it fails for sysfs because with user namespaces we bind the
existing /sys into the container
and would have to read out all existing mount flags from the current /sys mount.
Otherwise mount() fails with EPERM.
On my test system /sys is mounted with
"rw,nosuid,nodev,noexec,relatime" and libvirt
misses the realtime...

            virReportSystemError(errno,
                                 _("Failed to mount %s on %s type %s flags=%x"),
                                 mnt_src, mnt->dst, NULLSTR(mnt->type),
                                 mnt_mflags & ~MS_RDONLY);
            goto cleanup;
        }

        if (bindOverReadonly &&
            mount(mnt_src, mnt->dst, NULL,
                  MS_BIND|MS_REMOUNT|MS_RDONLY, NULL) < 0) {

^^^ Here it fails because now we'd have to specify all flags as used
for the first
mount. For the procfs case MS_NOSUID|MS_NOEXEC|MS_NODEV.
See lxcBasicMounts[].
In this case the fix is easy, add mnt_mflags to the mount flags.

         virReportSystemError(errno,
                                 _("Failed to re-mount %s on %s flags=%x"),
                                 mnt_src, mnt->dst,
                                 MS_BIND|MS_REMOUNT|MS_RDONLY);
            goto cleanup;
        }


-- 
Thanks,
//richard
