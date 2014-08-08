Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932541AbaHHUvk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 16:51:40 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41020 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757057AbaHHUvf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 16:51:35 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Daniel Borkmann <dborkman@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 234/259] net: sctp: check proc_dointvec result in proc_sctp_do_auth
Date: Fri,  8 Aug 2014 13:40:57 -0700
Message-Id: <1407530482-4483-235-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407530482-4483-1-git-send-email-kamal@canonical.com>
References: <1407530482-4483-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Borkmann <dborkman@redhat.com>

[ Upstream commit 24599e61b7552673dd85971cf5a35369cd8c119e ]

When writing to the sysctl field net.sctp.auth_enable, it can well
be that the user buffer we handed over to proc_dointvec() via
proc_sctp_do_auth() handler contains something other than integers.

In that case, we would set an uninitialized 4-byte value from the
stack to net->sctp.auth_enable that can be leaked back when reading
the sysctl variable, and it can unintentionally turn auth_enable
on/off based on the stack content since auth_enable is interpreted
as a boolean.

Fix it up by making sure proc_dointvec() returned sucessfully.

Fixes: b14878ccb7fa ("net: sctp: cache auth_enable per endpoint")
Reported-by: Florian Westphal <fwestpha@redhat.com>
Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
Acked-by: Neil Horman <nhorman@tuxdriver.com>
Acked-by: Vlad Yasevich <vyasevich@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/sctp/sysctl.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/sctp/sysctl.c b/net/sctp/sysctl.c
index 7c4eac4..99abe1a 100644
--- a/net/sctp/sysctl.c
+++ b/net/sctp/sysctl.c
@@ -423,8 +423,7 @@ static int proc_sctp_do_auth(struct ctl_table *ctl, int write,
 		tbl.data = &net->sctp.auth_enable;
 
 	ret = proc_dointvec(&tbl, write, buffer, lenp, ppos);
-
-	if (write) {
+	if (write && ret == 0) {
 		struct sock *sk = net->sctp.ctl_sock;
 
 		net->sctp.auth_enable = new_value;
-- 
1.9.1

