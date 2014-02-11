Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932156AbaBKUJU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 15:09:20 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:40032 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753558AbaBKTGq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 14:06:46 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Joe Thornber <ejt@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 3.12 054/107] dm space map metadata: fix bug in resizing of thin metadata
Date: Tue, 11 Feb 2014 11:05:20 -0800
Message-Id: <20140211184749.734366852@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140211184748.191276235@linuxfoundation.org>
References: <20140211184748.191276235@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joe Thornber <ejt@redhat.com>

commit fca028438fb903852beaf7c3fe1cd326651af57d upstream.

This bug was introduced in commit 7e664b3dec431e ("dm space map metadata:
fix extending the space map").

When extending a dm-thin metadata volume we:

- Switch the space map into a simple bootstrap mode, which allocates
  all space linearly from the newly added space.
- Add new bitmap entries for the new space
- Increment the reference counts for those newly allocated bitmap
  entries
- Commit changes to disk
- Switch back out of bootstrap mode.

But, the disk commit may allocate space itself, if so this fact will be
lost when switching out of bootstrap mode.

The bug exhibited itself as an error when the bitmap_root, with an
erroneous ref count of 0, was subsequently decremented as part of a
later disk commit.  This would cause the disk commit to fail, and thinp
to enter read_only mode.  The metadata was not damaged (thin_check
passed).

The fix is to put the increments + commit into a loop, running until
the commit has not allocated extra space.  In practise this loop only
runs twice.

With this fix the following device mapper testsuite test passes:
 dmtest run --suite thin-provisioning -n thin_remove_works_after_resize

Signed-off-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/persistent-data/dm-space-map-metadata.c |   18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

--- a/drivers/md/persistent-data/dm-space-map-metadata.c
+++ b/drivers/md/persistent-data/dm-space-map-metadata.c
@@ -617,13 +617,23 @@ static int sm_metadata_extend(struct dm_
 	if (r)
 		goto out;
 
-	for (i = old_len; !r && i < smm->begin; i++) {
-		r = sm_ll_inc(&smm->ll, i, &ev);
+	/*
+	 * We repeatedly increment then commit until the commit doesn't
+	 * allocate any new blocks.
+	 */
+	do {
+		for (i = old_len; !r && i < smm->begin; i++) {
+			r = sm_ll_inc(&smm->ll, i, &ev);
+			if (r)
+				goto out;
+		}
+		old_len = smm->begin;
+
+		r = sm_ll_commit(&smm->ll);
 		if (r)
 			goto out;
-	}
 
-	r = sm_metadata_commit(sm);
+	} while (old_len != smm->begin);
 
 out:
 	/*


