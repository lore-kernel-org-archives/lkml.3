Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933182AbaHHVQN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 17:16:13 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41048 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932555AbaHHUvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 16:51:45 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Daniel Borkmann <dborkman@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 232/259] net: sctp: propagate sysctl errors from proc_do* properly
Date: Fri,  8 Aug 2014 13:40:55 -0700
Message-Id: <1407530482-4483-233-git-send-email-kamal@canonical.com>
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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/sctp/sysctl.c | 43 +++++++++++++++++++++++--------------------
 1 file changed, 23 insertions(+), 20 deletions(-)

diff --git a/net/sctp/sysctl.c b/net/sctp/sysctl.c
index b2da788..7c4eac4 100644
--- a/net/sctp/sysctl.c
+++ b/net/sctp/sysctl.c
@@ -307,41 +307,40 @@ static int proc_sctp_do_hmac_alg(struct ctl_table *ctl, int write,
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
@@ -354,11 +353,10 @@ static int proc_sctp_do_rto_min(struct ctl_table *ctl, int write,
 				loff_t *ppos)
 {
 	struct net *net = current->nsproxy->net_ns;
-	int new_value;
-	struct ctl_table tbl;
 	unsigned int min = *(unsigned int *) ctl->extra1;
 	unsigned int max = *(unsigned int *) ctl->extra2;
-	int ret;
+	struct ctl_table tbl;
+	int ret, new_value;
 
 	memset(&tbl, 0, sizeof(struct ctl_table));
 	tbl.maxlen = sizeof(unsigned int);
@@ -367,12 +365,15 @@ static int proc_sctp_do_rto_min(struct ctl_table *ctl, int write,
 		tbl.data = &new_value;
 	else
 		tbl.data = &net->sctp.rto_min;
+
 	ret = proc_dointvec(&tbl, write, buffer, lenp, ppos);
-	if (write) {
-		if (ret || new_value > max || new_value < min)
+	if (write && ret == 0) {
+		if (new_value > max || new_value < min)
 			return -EINVAL;
+
 		net->sctp.rto_min = new_value;
 	}
+
 	return ret;
 }
 
@@ -381,11 +382,10 @@ static int proc_sctp_do_rto_max(struct ctl_table *ctl, int write,
 				loff_t *ppos)
 {
 	struct net *net = current->nsproxy->net_ns;
-	int new_value;
-	struct ctl_table tbl;
 	unsigned int min = *(unsigned int *) ctl->extra1;
 	unsigned int max = *(unsigned int *) ctl->extra2;
-	int ret;
+	struct ctl_table tbl;
+	int ret, new_value;
 
 	memset(&tbl, 0, sizeof(struct ctl_table));
 	tbl.maxlen = sizeof(unsigned int);
@@ -394,12 +394,15 @@ static int proc_sctp_do_rto_max(struct ctl_table *ctl, int write,
 		tbl.data = &new_value;
 	else
 		tbl.data = &net->sctp.rto_max;
+
 	ret = proc_dointvec(&tbl, write, buffer, lenp, ppos);
-	if (write) {
-		if (ret || new_value > max || new_value < min)
+	if (write && ret == 0) {
+		if (new_value > max || new_value < min)
 			return -EINVAL;
+
 		net->sctp.rto_max = new_value;
 	}
+
 	return ret;
 }
 
-- 
1.9.1

