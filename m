Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753643Ab3AVHJF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 02:09:05 -0500
Received: from hotel311.server4you.de ([85.25.146.15]:44967 "EHLO
	hotel311.server4you.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752883Ab3AVHJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 02:09:03 -0500
From: Daniel Wagner <wagi@monom.org>
To: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Cc: lizefan@huawei.com, Daniel Wagner <daniel.wagner@bmw-carit.de>,
        "David S. Miller" <davem@davemloft.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        John Fastabend <john.r.fastabend@intel.com>,
        Neil Horman <nhorman@tuxdriver.com>, netdev@vger.kernel.org
Subject: [PATCH v1] net: net_cls: fd passed in SCM_RIGHTS datagram not set correctly
Date: Tue, 22 Jan 2013 08:09:00 +0100
Message-Id: <1358838540-2910-1-git-send-email-wagi@monom.org>
X-Mailer: git-send-email 1.8.0.rc0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Wagner <daniel.wagner@bmw-carit.de>

Commit 6a328d8c6f03501657ad580f6f98bf9a42583ff7 changed the update
logic for the socket but it does not update the SCM_RIGHTS update
as well. This patch is based on the net_prio fix commit

48a87cc26c13b68f6cce4e9d769fcb17a6b3e4b8

    net: netprio: fd passed in SCM_RIGHTS datagram not set correctly

    A socket fd passed in a SCM_RIGHTS datagram was not getting
    updated with the new tasks cgrp prioidx. This leaves IO on
    the socket tagged with the old tasks priority.

    To fix this add a check in the scm recvmsg path to update the
    sock cgrp prioidx with the new tasks value.

Let's apply the same fix for net_cls.

Signed-off-by: Daniel Wagner <daniel.wagner@bmw-carit.de>
Reported-by: Li Zefan <lizefan@huawei.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: John Fastabend <john.r.fastabend@intel.com>
Cc: Neil Horman <nhorman@tuxdriver.com>
Cc: netdev@vger.kernel.org
Cc: cgroups@vger.kernel.org
---

v1: missing Sob added (d'oh)

 net/core/scm.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/core/scm.c b/net/core/scm.c
index 57fb1ee..905dcc6 100644
--- a/net/core/scm.c
+++ b/net/core/scm.c
@@ -35,6 +35,7 @@
 #include <net/sock.h>
 #include <net/compat.h>
 #include <net/scm.h>
+#include <net/cls_cgroup.h>
 
 
 /*
@@ -302,8 +303,10 @@ void scm_detach_fds(struct msghdr *msg, struct scm_cookie *scm)
 		}
 		/* Bump the usage count and install the file. */
 		sock = sock_from_file(fp[i], &err);
-		if (sock)
+		if (sock) {
 			sock_update_netprioidx(sock->sk, current);
+			sock_update_classid(sock->sk, current);
+		}
 		fd_install(new_fd, get_file(fp[i]));
 	}
 
-- 
1.8.0.rc0

