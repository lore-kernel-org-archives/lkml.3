Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756526Ab3LECqu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 21:46:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43175 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756462Ab3LECqq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 21:46:46 -0500
From: Richard Guy Briggs <rgb@redhat.com>
To: linux-audit@redhat.com, linux-kernel@vger.kernel.org
Cc: Richard Guy Briggs <rgb@redhat.com>, Eric Paris <eparis@redhat.com>,
        Gao feng <gaofeng@cn.fujitsu.com>,
        Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Subject: [PATCH 0/3] audit: remove audit_log_start() contention in AUDIT_USER type calls
Date: Wed,  4 Dec 2013 21:45:53 -0500
Message-Id: <cover.1386206544.git.rgb@redhat.com>
In-Reply-To: <1382713941.2954.19.camel@flatline.rdu.redhat.com>
References: <1382713941.2954.19.camel@flatline.rdu.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a race condition between systemd and auditd:

systemd                                    |auditd
-------------------------------------------+-----------------------------------
...                                        |
-> audit_receive                           |...
   -> mutex_lock(&audit_cmd_mutex)         |-> audit_receive
      ... -> audit_log_start               |   -> mutex_lock(&audit_cmd_mutex)
             -> wait_for_auditd            |      // wait for systemd
                -> schedule_timeout(60*HZ) |

This fix will take care of systemd and anything USING audit.  It still means
that we could race with something configuring audit and auditd shutting down.

The idea of dropping the lock at the top of audit_receive_msg() isn't as clean
as I had hoped, with AUDIT_ADD_RULE, AUDIT_TRIM, AUDIT_MAKE_EQUIV all
potentially allocating additional audit buffers indirectly through
trim_marked().  It may make sense to have trim_marked() send its queue through
a new thread.

Richard Guy Briggs (3):
  selinux: call WARN_ONCE() instead of calling audit_log_start()
  smack: call WARN_ONCE() instead of calling audit_log_start()
  audit: drop audit_cmd_lock in AUDIT_USER family of cases

 kernel/audit.c                 |    2 ++
 security/selinux/ss/services.c |   12 ++++--------
 security/smack/smack_lsm.c     |    5 ++---
 3 files changed, 8 insertions(+), 11 deletions(-)

