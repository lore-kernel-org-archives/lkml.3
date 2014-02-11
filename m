Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754867AbaBKTc6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 14:32:58 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:40378 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754127AbaBKTHw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 14:07:52 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Joe Thornber <ejt@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 3.10 39/79] dm space map metadata: fix extending the space map
Date: Tue, 11 Feb 2014 11:05:43 -0800
Message-Id: <20140211184722.073696089@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140211184720.928667275@linuxfoundation.org>
References: <20140211184720.928667275@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joe Thornber <ejt@redhat.com>

commit 7e664b3dec431eebf0c5df5ff704d6197634cf35 upstream.

When extending a metadata space map we should do the first commit whilst
still in bootstrap mode -- a mode where all blocks get allocated in the
new area.

That way the commit overhead is allocated from the newly added space.
Otherwise we risk running out of space.

With this fix, and the previous commit "dm space map common: make sure
new space is used during extend", the following device mapper testsuite
test passes:
 dmtest run --suite thin-provisioning -n /resize_metadata_no_io/

Signed-off-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/persistent-data/dm-space-map-metadata.c |   18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

--- a/drivers/md/persistent-data/dm-space-map-metadata.c
+++ b/drivers/md/persistent-data/dm-space-map-metadata.c
@@ -608,20 +608,28 @@ static int sm_metadata_extend(struct dm_
 	 * Flick into a mode where all blocks get allocated in the new area.
 	 */
 	smm->begin = old_len;
-	memcpy(&smm->sm, &bootstrap_ops, sizeof(smm->sm));
+	memcpy(sm, &bootstrap_ops, sizeof(*sm));
 
 	/*
 	 * Extend.
 	 */
 	r = sm_ll_extend(&smm->ll, extra_blocks);
+	if (r)
+		goto out;
 
+	for (i = old_len; !r && i < smm->begin; i++) {
+		r = sm_ll_inc(&smm->ll, i, &ev);
+		if (r)
+			goto out;
+	}
+
+	r = sm_metadata_commit(sm);
+
+out:
 	/*
 	 * Switch back to normal behaviour.
 	 */
-	memcpy(&smm->sm, &ops, sizeof(smm->sm));
-	for (i = old_len; !r && i < smm->begin; i++)
-		r = sm_ll_inc(&smm->ll, i, &ev);
-
+	memcpy(sm, &ops, sizeof(*sm));
 	return r;
 }
 


