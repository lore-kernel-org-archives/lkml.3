Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755243AbaHFBB0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 21:01:26 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:56284 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755132AbaHFBBX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 21:01:23 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        <linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Date: Tue, 05 Aug 2014 17:57:31 -0700
Message-ID: <87fvhav3ic.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18bi4OTrvBO+XqIAj5/fOQPAv6bRSYGlQ8=
X-SA-Exim-Connect-IP: 98.234.51.111
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4846]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  1.2 XMSubMetaSxObfu_03 Obfuscated Sexy Noun-People
	*  1.0 T_XMDrugObfuBody_08 obfuscated drug references
	*  1.0 XMSubMetaSx_00 1+ Sexy Words
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ***;Linus Torvalds <torvalds@linux-foundation.org>
X-Spam-Relay-Country: 
Subject: [GIT PULL] namespace updates for v3.17-rc1
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 13:58:17 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus,

Please pull the for-linus branch from the git tree:

   git://git.kernel.org/pub/scm/linux/kernel/git/ebiederm/user-namespace.git for-linus

   HEAD: 344470cac42e887e68cfb5bdfa6171baf27f1eb5 proc: Point /proc/mounts at /proc/thread-self/mounts instead of /proc/self/mounts

This is a bunch of small changes built against 3.16-rc6.  The most
significant change for users is the first patch which makes setns
drmatically faster by removing unneded rcu handling.

The next chunk of changes are so that "mount -o remount,.." will not
allow the user namespace root to drop flags on a mount set by the system
wide root.  Aks this forces read-only mounts to stay read-only, no-dev
mounts to stay no-dev, no-suid mounts to stay no-suid, no-exec mounts to
stay no exec and it prevents unprivileged users from messing with a
mounts atime settings.  I have included my test case as the last patch
in this series so people performing backports can verify this change
works correctly.

The next change fixes a bug in NFS that was discovered while auditing
nsproxy users for the first optimization.  Today you can oops the kernel
by reading /proc/fs/nfsfs/{servers,volumes} if you are clever with pid
namespaces.  I rebased and fixed the build of the !CONFIG_NFS_FS case
yesterday when a build bot caught my typo.  Given that no one to my
knowledge bases anything on my tree fixing the typo in place seems more
responsible that requiring a typo-fix to be backported as well.

The last change is a small semantic cleanup introducing
/proc/thread-self and pointing /proc/mounts and /proc/net at it.  This
prevents several kinds of problemantic corner cases.  It is a
user-visible change so it has a minute chance of causing regressions so
the change to /proc/mounts and /proc/net are individual one line commits
that can be trivially reverted.  Unfortunately I lost and could not find
the email of the original reporter so he is not credited.  From at least
one perspective this change to /proc/net is a refgression fix to allow
pthread /proc/net uses that were broken by the introduction of the network
namespace.

Eric

Eric W. Biederman (11):
      namespaces: Use task_lock and not rcu to protect nsproxy
      mnt: Only change user settable mount flags in remount
      mnt: Move the test for MNT_LOCK_READONLY from change_mount_flags into do_remount
      mnt: Correct permission checks in do_remount
      mnt: Change the default remount atime from relatime to the existing value
      mnt: Add tests for unprivileged remount cases that have found to be faulty
      NFS: Fix /proc/fs/nfsfs/servers and /proc/fs/nfsfs/volumes
      proc: Have net show up under /proc/<tgid>/task/<tid>
      proc: Implement /proc/thread-self to point at the directory of the current thread
      proc: Point /proc/net at /proc/thread-self/net instead of /proc/self/net
      proc: Point /proc/mounts at /proc/thread-self/mounts instead of /proc/self/mounts

 fs/namespace.c                                     |  65 +++++-
 fs/nfs/client.c                                    |  95 ++++----
 fs/nfs/inode.c                                     |   3 +-
 fs/nfs/internal.h                                  |   9 +
 fs/nfs/netns.h                                     |   3 +
 fs/proc/Makefile                                   |   1 +
 fs/proc/base.c                                     |  18 +-
 fs/proc/inode.c                                    |   7 +-
 fs/proc/internal.h                                 |   6 +
 fs/proc/proc_net.c                                 |   6 +-
 fs/proc/root.c                                     |   5 +-
 fs/proc/thread_self.c                              |  85 ++++++++
 fs/proc_namespace.c                                |   8 +-
 include/linux/mount.h                              |   9 +-
 include/linux/nsproxy.h                            |  16 +-
 include/linux/pid_namespace.h                      |   1 +
 ipc/namespace.c                                    |   6 +-
 kernel/nsproxy.c                                   |  15 +-
 kernel/utsname.c                                   |   6 +-
 net/core/net_namespace.c                           |  10 +-
 tools/testing/selftests/Makefile                   |   1 +
 tools/testing/selftests/mount/Makefile             |  17 ++
 .../selftests/mount/unprivileged-remount-test.c    | 242 +++++++++++++++++++++
 23 files changed, 537 insertions(+), 97 deletions(-)
