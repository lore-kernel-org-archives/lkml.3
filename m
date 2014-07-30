Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755583AbaG3Mjg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 08:39:36 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:36679 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752802AbaG3MP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 08:15:27 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Daniel Borkmann <dborkman@redhat.com>,
        "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 33/94] net: sctp: propagate sysctl errors from proc_do* properly
Date: Wed, 30 Jul 2014 14:14:22 +0200
Message-Id: <ad51ee3ff44cf847dac105e5687565e2b9fd329c.1406722270.git.jslaby@suse.cz>
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

[ Upstream commit ff5e92c1affe7166b3f6e7073e648ed65a6e2e59 ]

sysctl handler proc_sctp_do_hmac_alg(), proc_sctp_do_rto_min() and
proc_sctp_do_rto_max() do not properly reflect some error cases
when writing values via sysctl from internal proc functions such
as proc_dointvec() and proc_dostring().

In all these cases we pass the test for write != 0 and partially
do additional work just to notice that additional sanity checks
fail and we return with hard-coded -EINVAL while proc_do*
functions might also return different errors. So fix this up by
simply testing a successful return of proc_do* right after
calling it.

This also allows to propagate its return value onwards to the user.
While touching this, also fix up some minor style issues.

Fixes: 4f3fdf3bc59c ("sctp: add check rto_min and rto_max in sysctl")
Fixes: 3c68198e7511 ("sctp: Make hmac algorithm selection for cookie generation dynamic")
Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 net/sctp/sysctl.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/net/sctp/sysctl.c b/net/sctp/sysctl.c
index 3e5ac1948607..976c89d5295b 100644
--- a/net/sctp/sysctl.c
+++ b/net/sctp/sysctl.c
@@ -303,41 +303,40 @@ static int proc_sctp_do_hmac_alg(struct ctl_table *ctl,
 				loff_t *ppos)
 {
 	struct net *net = current->nsproxy->net_ns;
-	char tmp[8];
 	struct ctl_table tbl;
-	int ret;
-	int changed = 0;
+	bool changed = false;
 	char *none = "none";
+	char tmp[8];
+	int ret;
 
 	memset(&tbl, 0, sizeof(struct ctl_table));
 
 	if (write) {
 		tbl.data = tmp;
-		tbl.maxlen = 8;
+		tbl.maxlen = sizeof(tmp);
 	} else {
 		tbl.data = net->sctp.sctp_hmac_alg ? : none;
 		tbl.maxlen = strlen(tbl.data);
 	}
-		ret = proc_dostring(&tbl, write, buffer, lenp, ppos);
 
-	if (write) {
+	ret = proc_dostring(&tbl, write, buffer, lenp, ppos);
+	if (write && ret == 0) {
 #ifdef CONFIG_CRYPTO_MD5
 		if (!strncmp(tmp, "md5", 3)) {
 			net->sctp.sctp_hmac_alg = "md5";
-			changed = 1;
+			changed = true;
 		}
 #endif
 #ifdef CONFIG_CRYPTO_SHA1
 		if (!strncmp(tmp, "sha1", 4)) {
 			net->sctp.sctp_hmac_alg = "sha1";
-			changed = 1;
+			changed = true;
 		}
 #endif
 		if (!strncmp(tmp, "none", 4)) {
 			net->sctp.sctp_hmac_alg = NULL;
-			changed = 1;
+			changed = true;
 		}
-
 		if (!changed)
 			ret = -EINVAL;
 	}
-- 
2.0.1

