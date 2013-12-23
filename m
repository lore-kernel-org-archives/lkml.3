Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758105Ab3LWW26 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 17:28:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46472 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757627Ab3LWW24 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 17:28:56 -0500
From: Richard Guy Briggs <rgb@redhat.com>
To: linux-audit@redhat.com, linux-kernel@vger.kernel.org
Cc: Richard Guy Briggs <rgb@redhat.com>, Eric Paris <eparis@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        John Johansen <john.johansen@canonical.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Oleg Nesterov <oleg@redhat.com>
Subject: [PATCH 0/5][RFC][v2] steps to make audit pid namespace-safe
Date: Mon, 23 Dec 2013 17:27:34 -0500
Message-Id: <cover.1387834776.git.rgb@redhat.com>
In-Reply-To: <cover.1377032086.git.rgb@redhat.com>
References: <cover.1377032086.git.rgb@redhat.com>
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
should be accessed using their respective helper functions.

See: https://lkml.org/lkml/2013/8/20/638

Richard Guy Briggs (5):
  pid: get pid_t ppid of task in init_pid_ns
  audit: convert PPIDs to the inital PID namespace.
  audit: store audit_pid as a struct pid pointer
  audit: anchor all pid references in the initial pid namespace
  audit: allow user processes to log from another PID namespace

 drivers/tty/tty_audit.c              |    3 +-
 include/linux/sched.h                |   24 +++++++++++++++
 kernel/audit.c                       |   54 ++++++++++++++++++++++++----------
 kernel/audit.h                       |    4 +-
 kernel/auditfilter.c                 |   17 ++++++++++-
 kernel/auditsc.c                     |   24 ++++++++-------
 security/apparmor/audit.c            |    2 +-
 security/integrity/integrity_audit.c |    2 +-
 security/lsm_audit.c                 |   11 ++++--
 9 files changed, 104 insertions(+), 37 deletions(-)

