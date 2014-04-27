Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754185AbaD0RIK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 13:08:10 -0400
Received: from linuxhacker.ru ([217.76.32.60]:48007 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753852AbaD0RH4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 13:07:56 -0400
From: Oleg Drokin <green@linuxhacker.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Cc: Andreas Dilger <andreas.dilger@intel.com>,
        Oleg Drokin <oleg.drokin@intel.com>
Subject: [PATCH 14/47] staging/lustre: quiet console permission error messages
Date: Sun, 27 Apr 2014 13:06:38 -0400
Message-Id: <1398618431-29757-15-git-send-email-green@linuxhacker.ru>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1398618431-29757-1-git-send-email-green@linuxhacker.ru>
References: <1398618431-29757-1-git-send-email-green@linuxhacker.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Dilger <andreas.dilger@intel.com>

Quiet some common console error messages for permission errors
that can be hit in common cases.

Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
Reviewed-on: http://review.whamcloud.com/8988
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-4522
Reviewed-by: Jinshan Xiong <jinshan.xiong@intel.com>
Reviewed-by: Faccini Bruno <bruno.faccini@intel.com>
Reviewed-by: Bob Glossman <bob.glossman@intel.com>
Signed-off-by: Oleg Drokin <oleg.drokin@intel.com>
---
 drivers/staging/lustre/lustre/llite/file.c    | 7 ++++---
 drivers/staging/lustre/lustre/mdc/mdc_locks.c | 5 ++++-
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/lustre/lustre/llite/file.c b/drivers/staging/lustre/lustre/llite/file.c
index d01c864..c991ea5 100644
--- a/drivers/staging/lustre/lustre/llite/file.c
+++ b/drivers/staging/lustre/lustre/llite/file.c
@@ -2882,9 +2882,10 @@ static int ll_inode_revalidate_fini(struct inode *inode, int rc)
 		if (!S_ISREG(inode->i_mode) && !S_ISDIR(inode->i_mode))
 			return 0;
 	} else if (rc != 0) {
-		CERROR("%s: revalidate FID "DFID" error: rc = %d\n",
-		       ll_get_fsname(inode->i_sb, NULL, 0),
-		       PFID(ll_inode2fid(inode)), rc);
+		CDEBUG_LIMIT((rc == -EACCES || rc == -EIDRM) ? D_INFO : D_ERROR,
+			     "%s: revalidate FID "DFID" error: rc = %d\n",
+			     ll_get_fsname(inode->i_sb, NULL, 0),
+			     PFID(ll_inode2fid(inode)), rc);
 	}
 
 	return rc;
diff --git a/drivers/staging/lustre/lustre/mdc/mdc_locks.c b/drivers/staging/lustre/lustre/mdc/mdc_locks.c
index 53022ec..f86f697 100644
--- a/drivers/staging/lustre/lustre/mdc/mdc_locks.c
+++ b/drivers/staging/lustre/lustre/mdc/mdc_locks.c
@@ -893,7 +893,10 @@ resend:
 	mdc_put_rpc_lock(obddev->u.cli.cl_rpc_lock, it);
 
 	if (rc < 0) {
-		CERROR("ldlm_cli_enqueue: %d\n", rc);
+		CDEBUG_LIMIT((rc == -EACCES || rc == -EIDRM) ? D_INFO : D_ERROR,
+			     "%s: ldlm_cli_enqueue failed: rc = %d\n",
+			     obddev->obd_name, rc);
+
 		mdc_clear_replay_flag(req, rc);
 		ptlrpc_req_finished(req);
 		return rc;
-- 
1.8.5.3

