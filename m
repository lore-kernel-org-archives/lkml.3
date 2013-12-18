Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754576Ab3LRVOM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 16:14:12 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:36598 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754547Ab3LRVOK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 16:14:10 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Joe Thornber <ejt@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 3.12 083/118] dm array: fix a reference counting bug in shadow_ablock
Date: Wed, 18 Dec 2013 13:12:00 -0800
Message-Id: <20131218211221.798478723@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20131218211219.461663463@linuxfoundation.org>
References: <20131218211219.461663463@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joe Thornber <ejt@redhat.com>

commit ed9571f0cf1fe09d3506302610f3ccdfa1d22c4a upstream.

An old array block could have its reference count decremented below
zero when it is being replaced in the btree by a new array block.

The fix is to increment the old ablock's reference count just before
inserting a new ablock into the btree.

Signed-off-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/persistent-data/dm-array.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/drivers/md/persistent-data/dm-array.c
+++ b/drivers/md/persistent-data/dm-array.c
@@ -317,8 +317,16 @@ static int shadow_ablock(struct dm_array
 	 * The shadow op will often be a noop.  Only insert if it really
 	 * copied data.
 	 */
-	if (dm_block_location(*block) != b)
+	if (dm_block_location(*block) != b) {
+		/*
+		 * dm_tm_shadow_block will have already decremented the old
+		 * block, but it is still referenced by the btree.  We
+		 * increment to stop the insert decrementing it below zero
+		 * when overwriting the old value.
+		 */
+		dm_tm_inc(info->btree_info.tm, b);
 		r = insert_ablock(info, index, *block, root);
+	}
 
 	return r;
 }


