Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932360Ab3IYAVE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 20:21:04 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39783 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932346Ab3IYAVB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 20:21:01 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [ 096/117] pidns: Fix hang in zap_pid_ns_processes by sending a potentially extra wakeup
Date: Tue, 24 Sep 2013 17:19:22 -0700
Message-Id: <20130925001751.404690496@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130925001740.833541979@linuxfoundation.org>
References: <20130925001740.833541979@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Eric W. Biederman" <ebiederm@xmission.com>

commit a606488513543312805fab2b93070cefe6a3016c upstream.

Serge Hallyn <serge.hallyn@ubuntu.com> writes:

> Since commit af4b8a83add95ef40716401395b44a1b579965f4 it's been
> possible to get into a situation where a pidns reaper is
> <defunct>, reparented to host pid 1, but never reaped.  How to
> reproduce this is documented at
>
> https://bugs.launchpad.net/ubuntu/+source/lxc/+bug/1168526
> (and see
> https://bugs.launchpad.net/ubuntu/+source/lxc/+bug/1168526/comments/13)
> In short, run repeated starts of a container whose init is
>
> Process.exit(0);
>
> sysrq-t when such a task is playing zombie shows:
>
> [  131.132978] init            x ffff88011fc14580     0  2084   2039 0x00000000
> [  131.132978]  ffff880116e89ea8 0000000000000002 ffff880116e89fd8 0000000000014580
> [  131.132978]  ffff880116e89fd8 0000000000014580 ffff8801172a0000 ffff8801172a0000
> [  131.132978]  ffff8801172a0630 ffff88011729fff0 ffff880116e14650 ffff88011729fff0
> [  131.132978] Call Trace:
> [  131.132978]  [<ffffffff816f6159>] schedule+0x29/0x70
> [  131.132978]  [<ffffffff81064591>] do_exit+0x6e1/0xa40
> [  131.132978]  [<ffffffff81071eae>] ? signal_wake_up_state+0x1e/0x30
> [  131.132978]  [<ffffffff8106496f>] do_group_exit+0x3f/0xa0
> [  131.132978]  [<ffffffff810649e4>] SyS_exit_group+0x14/0x20
> [  131.132978]  [<ffffffff8170102f>] tracesys+0xe1/0xe6
>
> Further debugging showed that every time this happened, zap_pid_ns_processes()
> started with nr_hashed being 3, while we were expecting it to drop to 2.
> Any time it didn't happen, nr_hashed was 1 or 2.  So the reaper was
> waiting for nr_hashed to become 2, but free_pid() only wakes the reaper
> if nr_hashed hits 1.

The issue is that when the task group leader of an init process exits
before other tasks of the init process when the init process finally
exits it will be a secondary task sleeping in zap_pid_ns_processes and
waiting to wake up when the number of hashed pids drops to two.  This
case waits forever as free_pid only sends a wake up when the number of
hashed pids drops to 1.

To correct this the simple strategy of sending a possibly unncessary
wake up when the number of hashed pids drops to 2 is adopted.

Sending one extraneous wake up is relatively harmless, at worst we
waste a little cpu time in the rare case when a pid namespace
appropaches exiting.

We can detect the case when the pid namespace drops to just two pids
hashed race free in free_pid.

Dereferencing pid_ns->child_reaper with the pidmap_lock held is safe
without out the tasklist_lock because it is guaranteed that the
detach_pid will be called on the child_reaper before it is freed and
detach_pid calls __change_pid which calls free_pid which takes the
pidmap_lock.  __change_pid only calls free_pid if this is the
last use of the pid.  For a thread that is not the thread group leader
the threads pid will only ever have one user because a threads pid
is not allowed to be the pid of a process, of a process group or
a session.  For a thread that is a thread group leader all of
the other threads of that process will be reaped before it is allowed
for the thread group leader to be reaped ensuring there will only
be one user of the threads pid as a process pid.  Furthermore
because the thread is the init process of a pid namespace all of the
other processes in the pid namespace will have also been already freed
leading to the fact that the pid will not be used as a session pid or
a process group pid for any other running process.

Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
Tested-by: Serge Hallyn <serge.hallyn@canonical.com>
Reported-by: Serge Hallyn <serge.hallyn@ubuntu.com>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/pid.c |    1 +
 1 file changed, 1 insertion(+)

--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -265,6 +265,7 @@ void free_pid(struct pid *pid)
 		struct pid_namespace *ns = upid->ns;
 		hlist_del_rcu(&upid->pid_chain);
 		switch(--ns->nr_hashed) {
+		case 2:
 		case 1:
 			/* When all that is left in the pid namespace
 			 * is the reaper wake up the reaper.  The reaper


