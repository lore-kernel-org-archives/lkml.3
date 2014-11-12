Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965635AbaKLBtL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 20:49:11 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60883 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965598AbaKLBtJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:49:09 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Chris Mason <clm@fb.com>, Erik Berg <btrfs@slipsprogrammoer.no>
Subject: [PATCH 3.14 202/203] Btrfs: fix kfree on list_head in btrfs_lookup_csums_range error cleanup
Date: Wed, 12 Nov 2014 10:17:52 +0900
Message-Id: <20141112011551.958395226@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112011542.686743533@linuxfoundation.org>
References: <20141112011542.686743533@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Mason <clm@fb.com>

commit 6e5aafb27419f32575b27ef9d6a31e5d54661aca upstream.

If we hit any errors in btrfs_lookup_csums_range, we'll loop through all
the csums we allocate and free them.  But the code was using list_entry
incorrectly, and ended up trying to free the on-stack list_head instead.

This bug came from commit 0678b6185

btrfs: Don't BUG_ON kzalloc error in btrfs_lookup_csums_range()

Signed-off-by: Chris Mason <clm@fb.com>
Reported-by: Erik Berg <btrfs@slipsprogrammoer.no>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/file-item.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -423,7 +423,7 @@ int btrfs_lookup_csums_range(struct btrf
 	ret = 0;
 fail:
 	while (ret < 0 && !list_empty(&tmplist)) {
-		sums = list_entry(&tmplist, struct btrfs_ordered_sum, list);
+		sums = list_entry(tmplist.next, struct btrfs_ordered_sum, list);
 		list_del(&sums->list);
 		kfree(sums);
 	}


