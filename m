Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756237Ab3HaAaU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 20:30:20 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:41707 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752725Ab3HaAaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 20:30:18 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Serge Hallyn <serge.hallyn@ubuntu.com>, linux-kernel@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>
References: <20130829211114.GA20726@sergelap> <87mwo0xb9p.fsf@xmission.com>
	<20130830144232.GA18281@mail.hallyn.com>
Date: Fri, 30 Aug 2013 17:30:07 -0700
In-Reply-To: <20130830144232.GA18281@mail.hallyn.com> (Serge E. Hallyn's
	message of "Fri, 30 Aug 2013 14:42:33 +0000")
Message-ID: <87hae6vh0w.fsf_-_@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19BCrzyz39TTdvRR+Ji2d/1KbCyxrfJaCY=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.5 XMGappySubj_01 Very gappy subject
	*  3.0 XMDrug1234561 Drug references
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  1.2 LotsOfNums_01 BODY: Lots of long strings of numbers
	* -0.5 BAYES_05 BODY: Bayes spam probability is 1 to 5%
	*      [score: 0.0286]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
	*  1.0 T_XMDrugObfuBody_08 obfuscated drug references
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ******;"Serge E. Hallyn" <serge@hallyn.com>
X-Spam-Relay-Country: 
Subject: [REVIEW][PATCH] pidns: Fix hang in zap_pid_ns_processes by sending a potentially extra wakeup
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


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

CC: stable@vger.kernel.org
Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
Tested-by: Serge Hallyn <serge.hallyn@canonical.com>
Reported-by: Serge Hallyn <serge.hallyn@ubuntu.com>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 kernel/pid.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/pid.c b/kernel/pid.c
index 17755ae..ab75add 100644
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
-- 
1.7.5.4

