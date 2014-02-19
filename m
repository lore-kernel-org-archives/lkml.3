Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755014AbaBSU67 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 15:58:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60557 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754034AbaBSU66 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 15:58:58 -0500
From: Richard Guy Briggs <rgb@redhat.com>
To: linux-audit@redhat.com, linux-kernel@vger.kernel.org
Cc: Richard Guy Briggs <rgb@redhat.com>, oleg@redhat.com, peterz@infradead.org,
        ebiederm@xmission.com, eparis@redhat.com, sgrubb@redhat.com
Subject: [PATCH 0/5][RFC][v3] steps to make audit pid namespace-safe
Date: Wed, 19 Feb 2014 15:57:38 -0500
Message-Id: <cover.1392842865.git.rgb@redhat.com>
In-Reply-To: <cover.1387834776.git.rgb@redhat.com>
References: <cover.1387834776.git.rgb@redhat.com>
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
 include/linux/sched.h                |   18 ++++++++++
 kernel/audit.c                       |   59 ++++++++++++++++++++++++----------
 kernel/audit.h                       |    4 +-
 kernel/auditfilter.c                 |   17 +++++++++-
 kernel/auditsc.c                     |   24 +++++++------
 security/integrity/integrity_audit.c |    2 +-
 security/lsm_audit.c                 |   11 ++++--
 8 files changed, 101 insertions(+), 37 deletions(-)

