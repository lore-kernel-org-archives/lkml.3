Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751570Ab3HTVd0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 17:33:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52726 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751202Ab3HTVdX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 17:33:23 -0400
From: Richard Guy Briggs <rgb@redhat.com>
To: linux-audit@redhat.com, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org
Cc: Richard Guy Briggs <rgb@redhat.com>, Eric Paris <eparis@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        John Johansen <john.johansen@canonical.com>,
        James Morris <james.l.morris@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Kentaro Takeda <takedakn@nttdata.co.jp>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 00/12] RFC: steps to make audit pid namespace-safe
Date: Tue, 20 Aug 2013 17:31:52 -0400
Message-Id: <cover.1377032086.git.rgb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset is a revival of some of Eric Biederman's work to make audit
pid-namespace-safe.

In a couple of places, audit was printing PIDs in the task's pid namespace
rather than relative to the audit daemon's pid namespace, which currently is
init_pid_ns.

It also allows processes to log audit user messages in their own pid
namespaces, which was not previously permitted.  Please see:
	https://bugzilla.redhat.com/show_bug.cgi?id=947530
	https://bugs.launchpad.net/ubuntu/+source/vsftpd/+bug/1160372
	https://bugzilla.novell.com/show_bug.cgi?id=786024

Part of the cleanup here involves deprecating task->pid and task->tgid, which
are error-prone duplicates of the task->pids structure

The next step which I hope to add to this patchset will be to purge task->pid
and task->tgid from the rest of the kernel if possible.  Once that is done,
task_pid_nr_init_ns() and task_tgid_nr_init_ns() that were introduced in patch
05/12 and used in patches 06/12 and 08/12 could be replaced with task_pid_nr()
and task_tgid_nr().  Eric B. did take a stab at that, but checking all the
subtleties will be non-trivial.

Does anyone have any opinions or better yet hard data on cache line misses
between pid_nr(struct pid*) and pid_nr_ns(struct pid*, &init_pid_ns)?  I'd
like to see pid_nr() use pid_nr_ns(struct pid*, &init_pid_ns), or
pid_nr_init_ns() eliminated in favour of the original pid_nr().  pid_nr()
currently accesses the first level of the pid structure without having to
dereference the level number.  If there is an actual speed difference, it could
be worth keeping, otherwise, I'd prefer to simplify that code.

Eric also had a patch to add a printk option to format a struct pid pointer
which was PID namespace-aware.  I don't see the point, but I'll let him explain
it.

Discuss.

Eric W. Biederman (5):
  audit: Kill the unused struct audit_aux_data_capset
  audit: Simplify and correct audit_log_capset

Richard Guy Briggs (7):
  audit: fix netlink portid naming and types
  pid: get ppid pid_t of task in init_pid_ns safely
  audit: convert PPIDs to the inital PID namespace.
  pid: get pid_t of task in init_pid_ns correctly
  audit: store audit_pid as a struct pid pointer
  audit: anchor all pid references in the initial pid namespace
  pid: modify task_pid_nr to work without task->pid.
  pid: modify task_tgid_nr to work without task->tgid.
  pid: rewrite task helper functions avoiding task->pid and task->tgid
  pid: mark struct task const in helper functions

 drivers/tty/tty_audit.c              |    3 +-
 include/linux/audit.h                |    8 ++--
 include/linux/pid.h                  |    6 +++
 include/linux/sched.h                |   81 ++++++++++++++++++++++++----------
 kernel/audit.c                       |   76 +++++++++++++++++++------------
 kernel/audit.h                       |   12 +++---
 kernel/auditfilter.c                 |   35 +++++++++++----
 kernel/auditsc.c                     |   36 ++++++---------
 kernel/capability.c                  |    2 +-
 kernel/pid.c                         |    4 +-
 security/apparmor/audit.c            |    7 +--
 security/integrity/integrity_audit.c |    2 +-
 security/lsm_audit.c                 |   11 +++--
 security/tomoyo/audit.c              |    2 +-
 14 files changed, 177 insertions(+), 108 deletions(-)

