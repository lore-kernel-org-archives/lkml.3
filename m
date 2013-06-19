Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934215Ab3FSBxx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 21:53:53 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:45515 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S934080Ab3FSBxK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 21:53:10 -0400
X-IronPort-AV: E=Sophos;i="4.87,893,1363104000"; 
   d="scan'208";a="7596293"
From: Gao feng <gaofeng@cn.fujitsu.com>
To: containers@lists.linux-foundation.org, linux-audit@redhat.com,
        linux-kernel@vger.kernel.org
Cc: eparis@redhat.com, serge.hallyn@ubuntu.com, ebiederm@xmission.com,
        sgrubb@redhat.com, aris@redhat.com, matthltc@linux.vnet.ibm.com,
        Gao feng <gaofeng@cn.fujitsu.com>
Subject: [Part1 PATCH 00/22] Add namespace support for audit
Date: Wed, 19 Jun 2013 09:53:32 +0800
Message-Id: <1371606834-5802-1-git-send-email-gaofeng@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.1.4
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/06/19 09:51:55,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/06/19 09:52:01,
	Serialize complete at 2013/06/19 09:52:01
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset is first part of namespace support for audit.
in this patchset, the mainly resources of audit system have
been isolated. the audit filter, rules havn't been isolated
now. It will be implemented in Part2. We finished the isolation
of user audit message in this patchset.

I choose to assign audit to the user namespace.
Right now,there are six kinds of namespaces, such as
net, mount, ipc, pid, uts and user. the first five
namespaces have special usage. the audit isn't suitable to
belong to these five namespaces, And since the flag of system
call clone is in short supply, we can't provide a new flag such
as CLONE_NEWAUDIT to enable audit namespace separately. so the
user namespace may be the best choice.

[Patch 4/21] add a compare function pointer for netlink table,
so audit subsystem can use it's self-defined compare function
to make sure audit netlink sockets can communicate with each
other when they in the same user namespace. this patch has been
merged into David's net-next tree.

There is one point that some people may dislike,in [PATCH 3/21],
the kernel side audit netlink socket is created only when we create
the first netns for the userns, and this userns will hold the netns
until we destroy this userns. It also means if we only unshare the
user namespace, the audit is unavailable since we don't have audit
netlink socket. if we should unshare user and net namespace both.

change from RFC:
1, Move the cleanup patches to the head of this patchset.
2, Fix a scheduling while atomic BUG. This bug is caused by
   kthread_stop in audit_free_user_ns.
3, Only allow init user namespace to change backlog_limit.
4, Audit subsystem is available only when kernel side audit
   netlink socket has been created.
5, Only isolate the basic resources of audit, and only make
   user audit message namespace aware.


This patchset is based on linus' linux tree.

You can pull this patchset from:
git://github.com/gao-feng/auditns.git

The following changes since commit 8177a9d79c0e942dcac3312f15585d0344d505a5

"lseek(fd, n, SEEK_END) does *not* go to eof - n"

are available in the git repository at:

git://github.com/gao-feng/auditns.git

for you to fetch changes up to 85c36b981ac692ec18e362ba484629a457d50cb2

"Audit: Allow GET,SET,USER MSG operations in uninit user namespace"

Gao feng (22):
  Audit: change type of audit_ever_enabled to bool
  Audit: remove duplicate comments
  Audit: make audit kernel side netlink sock per userns
  netlink: Add compare function for netlink_table
  Audit: implement audit self-defined compare function
  Audit: make audit_skb_queue per user namespace
  Audit: make audit_skb_hold_queue per user namespace
  Audit: make kauditd_task per user namespace
  Audit: make audit_nlk_portid per user namesapce
  Audit: make audit_enabled per user namespace
  Audit: make audit_ever_enabled per user namespace
  Audit: make audit_initialized per user namespace
  Audit: only allow init user namespace to change rate limit
  Audit: only allow init user namespace to change audit_failure
  Audit: only allow init user namespace to change backlog_limit
  Audit: make kauditd_wait per user namespace
  Audit: make audit_backlog_wait per user namespace
  Audit: introduce new audit logging interface for user namespace
  Audit: pass proper user namespace to audit_log_common_recv_msg
  Audit: Log audit config change in uninit user namespace
  Audit: send reply message to the auditd in proper user namespace
  Audit: Allow GET,SET,USER MSG operations in uninit user namespace

 include/linux/audit.h          |  39 +++-
 include/linux/netlink.h        |   1 +
 include/linux/user_namespace.h |  33 ++-
 kernel/audit.c                 | 452 +++++++++++++++++++++++++----------------
 kernel/audit.h                 |   7 +-
 kernel/auditsc.c               |  11 +-
 kernel/user_namespace.c        |   3 +
 net/netlink/af_netlink.c       |  32 ++-
 net/netlink/af_netlink.h       |   1 +
 9 files changed, 387 insertions(+), 192 deletions(-)

-- 
1.8.1.4

