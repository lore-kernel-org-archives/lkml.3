Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755476AbaG3Mgc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 08:36:32 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:36705 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752864AbaG3MPb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 08:15:31 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Daniel Borkmann <dborkman@redhat.com>,
        "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 35/94] net: sctp: check proc_dointvec result in proc_sctp_do_auth
Date: Wed, 30 Jul 2014 14:14:24 +0200
Message-Id: <a6c33e4d990a0bab8f57b0a1ba92430ddc780dff.1406722270.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <e43bbc2c2b44d8f0bd0b7f65d6fd50ef738c57aa.1406722270.git.jslaby@suse.cz>
References: <e43bbc2c2b44d8f0bd0b7f65d6fd50ef738c57aa.1406722270.git.jslaby@suse.cz>
In-Reply-To: <cover.1406722269.git.jslaby@suse.cz>
References: <cover.1406722269.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Borkmann <dborkman@redhat.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 net/sctp/sysctl.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/sctp/sysctl.c b/net/sctp/sysctl.c
index 976c89d5295b..968355f0de60 100644
--- a/net/sctp/sysctl.c
+++ b/net/sctp/sysctl.c
@@ -361,8 +361,7 @@ static int proc_sctp_do_auth(struct ctl_table *ctl, int write,
 		tbl.data = &net->sctp.auth_enable;
 
 	ret = proc_dointvec(&tbl, write, buffer, lenp, ppos);
-
-	if (write) {
+	if (write && ret == 0) {
 		struct sock *sk = net->sctp.ctl_sock;
 
 		net->sctp.auth_enable = new_value;
-- 
2.0.1

