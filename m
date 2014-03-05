Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758099AbaCEOgm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 09:36:42 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41229 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757601AbaCEO0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 09:26:55 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jan Kara <jack@suse.cz>, Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 105/131] quota: Fix race between dqput() and dquot_scan_active()
Date: Wed,  5 Mar 2014 14:23:49 +0000
Message-Id: <1394029455-23128-106-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1394029455-23128-1-git-send-email-luis.henriques@canonical.com>
References: <1394029455-23128-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

commit 1362f4ea20fa63688ba6026e586d9746ff13a846 upstream.

Currently last dqput() can race with dquot_scan_active() causing it to
call callback for an already deactivated dquot. The race is as follows:

CPU1					CPU2
  dqput()
    spin_lock(&dq_list_lock);
    if (atomic_read(&dquot->dq_count) > 1) {
     - not taken
    if (test_bit(DQ_ACTIVE_B, &dquot->dq_flags)) {
      spin_unlock(&dq_list_lock);
      ->release_dquot(dquot);
        if (atomic_read(&dquot->dq_count) > 1)
         - not taken
					  dquot_scan_active()
					    spin_lock(&dq_list_lock);
					    if (!test_bit(DQ_ACTIVE_B, &dquot->dq_flags))
					     - not taken
					    atomic_inc(&dquot->dq_count);
					    spin_unlock(&dq_list_lock);
        - proceeds to release dquot
					    ret = fn(dquot, priv);
					     - called for inactive dquot

Fix the problem by making sure possible ->release_dquot() is finished by
the time we call the callback and new calls to it will notice reference
dquot_scan_active() has taken and bail out.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/quota/dquot.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index fbad622..e980b6f 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -581,9 +581,17 @@ int dquot_scan_active(struct super_block *sb,
 		dqstats_inc(DQST_LOOKUPS);
 		dqput(old_dquot);
 		old_dquot = dquot;
-		ret = fn(dquot, priv);
-		if (ret < 0)
-			goto out;
+		/*
+		 * ->release_dquot() can be racing with us. Our reference
+		 * protects us from new calls to it so just wait for any
+		 * outstanding call and recheck the DQ_ACTIVE_B after that.
+		 */
+		wait_on_dquot(dquot);
+		if (test_bit(DQ_ACTIVE_B, &dquot->dq_flags)) {
+			ret = fn(dquot, priv);
+			if (ret < 0)
+				goto out;
+		}
 		spin_lock(&dq_list_lock);
 		/* We are safe to continue now because our dquot could not
 		 * be moved out of the inuse list while we hold the reference */
-- 
1.9.0

