Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966192AbaLLGtA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 01:49:00 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52598 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966102AbaLLGsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 01:48:42 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Jan Kara" <jack@suse.cz>,
        "Al Viro" <viro@zeniv.linux.org.uk>,
        "Yann Droneaud" <ydroneaud@opteya.com>,
        "Michael Kerrisk-manpages" <mtk.manpages@gmail.com>,
        "Eric Paris" <eparis@redhat.com>,
        "Lino Sanfilippo" <LinoSanfilippo@gmx.de>,
        "Valdis Kletnieks" <Valdis.Kletnieks@vt.edu>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Heinrich Schuchardt" <xypron.glpk@gmx.de>,
        "=?UTF-8?Q?P=C3=A1draig=20?=Brady" <P@draigBrady.com>,
        "Mihai Don\u021bu" <mihai.dontu@gmail.com>,
        "Richard Guy Briggs" <rgb@redhat.com>
Date: Fri, 12 Dec 2014 06:14:25 +0000
Message-ID: <lsq.1418364865.824022916@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 054/164] fanotify: enable close-on-exec on events' fd
 when requested in fanotify_init()
In-Reply-To: <lsq.1418364865.554543691@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:c97:8151:cc89:c28d
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.65-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Yann Droneaud <ydroneaud@opteya.com>

commit 0b37e097a648aa71d4db1ad108001e95b69a2da4 upstream.

According to commit 80af258867648 ("fanotify: groups can specify their
f_flags for new fd"), file descriptors created as part of file access
notification events inherit flags from the event_f_flags argument passed
to syscall fanotify_init(2)[1].

Unfortunately O_CLOEXEC is currently silently ignored.

Indeed, event_f_flags are only given to dentry_open(), which only seems to
care about O_ACCMODE and O_PATH in do_dentry_open(), O_DIRECT in
open_check_o_direct() and O_LARGEFILE in generic_file_open().

It's a pity, since, according to some lookup on various search engines and
http://codesearch.debian.net/, there's already some userspace code which
use O_CLOEXEC:

- in systemd's readahead[2]:

    fanotify_fd = fanotify_init(FAN_CLOEXEC|FAN_NONBLOCK, O_RDONLY|O_LARGEFILE|O_CLOEXEC|O_NOATIME);

- in clsync[3]:

    #define FANOTIFY_EVFLAGS (O_LARGEFILE|O_RDONLY|O_CLOEXEC)

    int fanotify_d = fanotify_init(FANOTIFY_FLAGS, FANOTIFY_EVFLAGS);

- in examples [4] from "Filesystem monitoring in the Linux
  kernel" article[5] by Aleksander Morgado:

    if ((fanotify_fd = fanotify_init (FAN_CLOEXEC,
                                      O_RDONLY | O_CLOEXEC | O_LARGEFILE)) < 0)

Additionally, since commit 48149e9d3a7e ("fanotify: check file flags
passed in fanotify_init").  having O_CLOEXEC as part of fanotify_init()
second argument is expressly allowed.

So it seems expected to set close-on-exec flag on the file descriptors if
userspace is allowed to request it with O_CLOEXEC.

But Andrew Morton raised[6] the concern that enabling now close-on-exec
might break existing applications which ask for O_CLOEXEC but expect the
file descriptor to be inherited across exec().

In the other hand, as reported by Mihai Dontu[7] close-on-exec on the file
descriptor returned as part of file access notify can break applications
due to deadlock.  So close-on-exec is needed for most applications.

More, applications asking for close-on-exec are likely expecting it to be
enabled, relying on O_CLOEXEC being effective.  If not, it might weaken
their security, as noted by Jan Kara[8].

So this patch replaces call to macro get_unused_fd() by a call to function
get_unused_fd_flags() with event_f_flags value as argument.  This way
O_CLOEXEC flag in the second argument of fanotify_init(2) syscall is
interpreted and close-on-exec get enabled when requested.

[1] http://man7.org/linux/man-pages/man2/fanotify_init.2.html
[2] http://cgit.freedesktop.org/systemd/systemd/tree/src/readahead/readahead-collect.c?id=v208#n294
[3] https://github.com/xaionaro/clsync/blob/v0.2.1/sync.c#L1631
    https://github.com/xaionaro/clsync/blob/v0.2.1/configuration.h#L38
[4] http://www.lanedo.com/~aleksander/fanotify/fanotify-example.c
[5] http://www.lanedo.com/2013/filesystem-monitoring-linux-kernel/
[6] http://lkml.kernel.org/r/20141001153621.65e9258e65a6167bf2e4cb50@linux-foundation.org
[7] http://lkml.kernel.org/r/20141002095046.3715eb69@mdontu-l
[8] http://lkml.kernel.org/r/20141002104410.GB19748@quack.suse.cz

Link: http://lkml.kernel.org/r/cover.1411562410.git.ydroneaud@opteya.com
Signed-off-by: Yann Droneaud <ydroneaud@opteya.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed by: Heinrich Schuchardt <xypron.glpk@gmx.de>
Tested-by: Heinrich Schuchardt <xypron.glpk@gmx.de>
Cc: Mihai Don\u021bu <mihai.dontu@gmail.com>
Cc: Pádraig Brady <P@draigBrady.com>
Cc: Heinrich Schuchardt <xypron.glpk@gmx.de>
Cc: Jan Kara <jack@suse.cz>
Cc: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Cc: Michael Kerrisk-manpages <mtk.manpages@gmail.com>
Cc: Lino Sanfilippo <LinoSanfilippo@gmx.de>
Cc: Richard Guy Briggs <rgb@redhat.com>
Cc: Eric Paris <eparis@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/notify/fanotify/fanotify_user.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -65,7 +65,7 @@ static int create_fd(struct fsnotify_gro
 
 	pr_debug("%s: group=%p event=%p\n", __func__, group, event);
 
-	client_fd = get_unused_fd();
+	client_fd = get_unused_fd_flags(group->fanotify_data.f_flags);
 	if (client_fd < 0)
 		return client_fd;
 

