Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751214AbaLPSGH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 13:06:07 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:47971 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996AbaLPSGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 13:06:05 -0500
Date: Tue, 16 Dec 2014 18:06:03 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [git pull] vfs.git pile 2
Message-ID: <20141216180603.GF22149@ZenIV.linux.org.uk>
References: <20141215235124.GX22149@ZenIV.linux.org.uk>
 <20141216133330.GB22149@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141216133330.GB22149@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 16, 2014 at 01:33:30PM +0000, Al Viro wrote:
> On Mon, Dec 15, 2014 at 11:51:25PM +0000, Al Viro wrote:
> > Next pile (and there'll be one or two more).  The large piece in this one is
> > getting rid of /proc/*/ns/* weirdness; among other things, it allows to
> > (finally) make nameidata completely opaque outside of fs/namei.c, making for
> > easier further cleanups in there.
> > 
> > I have _not_ included removal of unshare_fs_struct() into that pile; I think
> > it'll turn out to be OK, but it's clearly the next cycle fodder.
> 
> ... but I have included the "obviously safe" patch separating PID 1
> ->fs.  Without letting it sit in -next long enough.  And it turns out
> to be not safe at all - it might be salvagable, but not in this form.
> 
> Mea maxima culpa - I should've known better than that.  Self-LART applied;
> please, drop this pull request, I'll send a saner one (for stuff that *did*
> sit in -next long enough) in a bit.
> 
> Again, my apologies ;-/

... and this time around - only the stuff that has sat in -next for a while,
with no "obviously safe" additions thrown in.  Please, pull from
git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git for-linus

Shortlog:
Al Viro (17):
      common object embedded into various struct ....ns
      make mntns ->get()/->put()/->install()/->inum() work with &mnt_ns->ns
      netns: switch ->get()/->put()/->install()/->inum() to working with &net->ns
      switch the rest of proc_ns_operations to working with &...->ns
      make proc_ns_operations work with struct ns_common * instead of void *
      new helpers: ns_alloc_inum/ns_free_inum
      copy address of proc_ns_ops into ns_common
      bury struct proc_ns in fs/proc
      take the targets of /proc/*/ns/* symlinks to separate fs
      kill proc_ns completely
      make nameidata completely opaque outside of fs/namei.c
      make default ->i_fop have ->open() fail with ENXIO
      path_init(): store the "base" pointer to file in nameidata itself
      fs/namei.c: new helper (path_cleanup())
      path_init(): don't bother with LOOKUP_PARENT in argument
      fs/namei.c: fold link_path_walk() call into path_init()
      coda_venus_readdir(): use file_inode()

Diffstat:
 arch/ia64/kernel/perfmon.c     |  10 ---
 fs/Makefile                    |   2 +-
 fs/coda/dir.c                  |   4 +-
 fs/inode.c                     |  11 ++-
 fs/internal.h                  |   5 ++
 fs/mount.h                     |   3 +-
 fs/namei.c                     |  98 +++++++++++++------------
 fs/namespace.c                 |  51 ++++++-------
 fs/nsfs.c                      | 161 +++++++++++++++++++++++++++++++++++++++++
 fs/proc/inode.c                |  10 +--
 fs/proc/internal.h             |   2 +-
 fs/proc/namespaces.c           | 153 ++++-----------------------------------
 include/linux/fs.h             |   1 -
 include/linux/ipc_namespace.h  |   3 +-
 include/linux/namei.h          |  25 +------
 include/linux/ns_common.h      |  12 +++
 include/linux/pid_namespace.h  |   3 +-
 include/linux/proc_ns.h        |  43 ++++++-----
 include/linux/user_namespace.h |   3 +-
 include/linux/utsname.h        |   3 +-
 include/net/net_namespace.h    |   3 +-
 include/uapi/linux/magic.h     |   1 +
 init/main.c                    |   2 +
 init/version.c                 |   5 +-
 ipc/msgutil.c                  |   5 +-
 ipc/namespace.c                |  32 ++++----
 kernel/nsproxy.c               |  10 +--
 kernel/pid.c                   |   5 +-
 kernel/pid_namespace.c         |  29 ++++----
 kernel/user.c                  |   5 +-
 kernel/user_namespace.c        |  29 ++++----
 kernel/utsname.c               |  31 ++++----
 net/Makefile                   |   2 -
 net/core/net_namespace.c       |  39 +++++-----
 net/nonet.c                    |  26 -------
 net/socket.c                   |  19 -----
 36 files changed, 416 insertions(+), 430 deletions(-)
 create mode 100644 fs/nsfs.c
 create mode 100644 include/linux/ns_common.h
 delete mode 100644 net/nonet.c
