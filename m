Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751524AbaJCIoK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 04:44:10 -0400
Received: from smtp3-g21.free.fr ([212.27.42.3]:62423 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751159AbaJCIoF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 04:44:05 -0400
From: Yann Droneaud <ydroneaud@opteya.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Yann Droneaud <ydroneaud@opteya.com>, Jan Kara <jack@suse.cz>,
        Heinrich Schuchardt <xypron.glpk@gmx.de>,
        Eric Paris <eparis@redhat.com>, Richard Guy Briggs <rgb@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, stable@vger.kernel.org,
        linux-api@vger.kernel.org, Lino Sanfilippo <LinoSanfilippo@gmx.de>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        Michael Kerrisk-manpages <mtk.manpages@gmail.com>,
        =?UTF-8?q?Mihai=20Don=C8=9Bu?= <mihai.dontu@gmail.com>,
        =?UTF-8?q?P=C3=A1draig=20Brady?= <P@draigBrady.com>
Subject: [PATCHv8.2] fanotify: enable close-on-exec on events' fd when requested in fanotify_init()
Date: Fri,  3 Oct 2014 10:39:37 +0200
Message-Id: <1412325577-11591-1-git-send-email-ydroneaud@opteya.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <20141002124652.c877efeb35d07064e520a702@linux-foundation.org>
References: <cover.1411562410.git.ydroneaud@opteya.com> <9d050a2db4f9cf68cd6cb038f16cccb0f73c6e66.1411562410.git.ydroneaud@opteya.com> <542481B3.8070300@gmx.de> <1411721898.7778.18.camel@localhost.localdomain> <542666B2.9080700@gmx.de> <1411980555-10818-1-git-send-email-ydroneaud@opteya.com> <20141001153621.65e9258e65a6167bf2e4cb50@linux-foundation.org> <20141002104410.GB19748@quack.suse.cz> <20141002124652.c877efeb35d07064e520a702@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to commit 80af258867648 ('fanotify: groups can specify
their f_flags for new fd'), file descriptors created as part of
file access notification events inherit flags from the
event_f_flags argument passed to syscall fanotify_init(2)[1].

Unfortunately O_CLOEXEC is currently silently ignored.

Indeed, event_f_flags are only given to dentry_open(), which only
seems to care about O_ACCMODE and O_PATH in do_dentry_open(),
O_DIRECT in open_check_o_direct() and O_LARGEFILE in
generic_file_open().

It's a pity, since, according to some lookup on various search
engines and http://codesearch.debian.net/, there's already some
userspace code which use O_CLOEXEC:

- in systemd's readahead[2]:

    fanotify_fd = fanotify_init(FAN_CLOEXEC|FAN_NONBLOCK, O_RDONLY|O_LARGEFILE|O_CLOEXEC|O_NOATIME);

- in clsync[3]:

    #define FANOTIFY_EVFLAGS (O_LARGEFILE|O_RDONLY|O_CLOEXEC)

    int fanotify_d = fanotify_init(FANOTIFY_FLAGS, FANOTIFY_EVFLAGS);

- in examples [4] from "Filesystem monitoring in the Linux
  kernel" article[5] by Aleksander Morgado:

    if ((fanotify_fd = fanotify_init (FAN_CLOEXEC,
                                      O_RDONLY | O_CLOEXEC | O_LARGEFILE)) < 0)

Additionally, since commit 48149e9d3a7e ('fanotify: check file
flags passed in fanotify_init'). having O_CLOEXEC as part of
fanotify_init() second argument is expressly allowed.

So it seems expected to set close-on-exec flag on the file
descriptors if userspace is allowed to request it with O_CLOEXEC.

But Andrew Morton raised[6] the concern that enabling now
close-on-exec might break existing applications which ask for
O_CLOEXEC but expect the file descriptor to be inherited
across exec().

In the other hand, as reported by Mihai Donțu[7], not setting
close-on-exec on the file descriptor returned as part of file
access notify can break applications due to deadlock.
So close-on-exec is needed for most applications.

More, applications asking for close-on-exec are likely expecting
it to be enabled, relying on O_CLOEXEC being effective. If not,
it might weaken their security, as noted by Jan Kara[8].

So this patch replaces call to macro get_unused_fd() by a call
to function get_unused_fd_flags() with event_f_flags value as
argument. This way O_CLOEXEC flag in the second argument of
fanotify_init(2) syscall is interpreted and close-on-exec
get enabled when requested.

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
Cc: Mihai Donțu <mihai.dontu@gmail.com>
Cc: Pádraig Brady <P@draigBrady.com>
Cc: Heinrich Schuchardt <xypron.glpk@gmx.de>
Cc: Jan Kara <jack@suse.cz>
Cc: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Cc: Michael Kerrisk-manpages <mtk.manpages@gmail.com>
Cc: Lino Sanfilippo <LinoSanfilippo@gmx.de>
Cc: Richard Guy Briggs <rgb@redhat.com>
Cc: Eric Paris <eparis@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: stable@vger.kernel.org
Cc: linux-api@vger.kernel.org
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed by: Heinrich Schuchardt <xypron.glpk@gmx.de>
Tested-by: Heinrich Schuchardt <xypron.glpk@gmx.de>
Signed-off-by: Yann Droneaud <ydroneaud@opteya.com>
---
Hi Andrew,

> Fair enough, it sounds like the risk is acceptable.
>

OK.

> Can we get a new version sent out with all this new info appropriately
> changelogged?
>

Of course !

Please find an updated patch with revamped commit message.

Changes from v8.1:

- added more Cc:
- added Reviewed-by:
- rewrote commit message.

 fs/notify/fanotify/fanotify_user.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
index b13992a41bd9..c991616acca9 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -78,7 +78,7 @@ static int create_fd(struct fsnotify_group *group,
 
 	pr_debug("%s: group=%p event=%p\n", __func__, group, event);
 
-	client_fd = get_unused_fd();
+	client_fd = get_unused_fd_flags(group->fanotify_data.f_flags);
 	if (client_fd < 0)
 		return client_fd;
 
-- 
1.9.3

