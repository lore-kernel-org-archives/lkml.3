Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755117AbaCHB33 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 20:29:29 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46366 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753288AbaCHBHP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 20:07:15 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jan Kara <jack@suse.cz>
Subject: [PATCH 3.4 40/99] quota: Fix race between dqput() and dquot_scan_active()
Date: Fri,  7 Mar 2014 17:07:36 -0800
Message-Id: <20140308010612.896117509@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140308010611.468206150@linuxfoundation.org>
References: <20140308010611.468206150@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/quota/dquot.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -580,9 +580,17 @@ int dquot_scan_active(struct super_block
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


