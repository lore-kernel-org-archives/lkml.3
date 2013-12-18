Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755069Ab3LRVT3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 16:19:29 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:36633 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754616Ab3LRVOR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 16:14:17 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Josef Bacik <jbacik@fusionio.com>,
        Chris Mason <chris.mason@fusionio.com>
Subject: [PATCH 3.12 109/118] Btrfs: fix hole check in log_one_extent
Date: Wed, 18 Dec 2013 13:12:26 -0800
Message-Id: <20131218211222.547101607@linuxfoundation.org>
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

From: Josef Bacik <jbacik@fusionio.com>

commit ed9e8af88e2551aaa6bf51d8063a2493e2d71597 upstream.

I added an assert to make sure we were looking up aligned offsets for csums and
I tripped it when running xfstests.  This is because log_one_extent was checking
if block_start == 0 for a hole instead of EXTENT_MAP_HOLE.  This worked out fine
in practice it seems, but it adds a lot of extra work that is uneeded.  With
this fix I'm no longer tripping my assert.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
Signed-off-by: Chris Mason <chris.mason@fusionio.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/tree-log.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -3375,7 +3375,7 @@ static int log_one_extent(struct btrfs_t
 		btrfs_set_token_file_extent_type(leaf, fi,
 						 BTRFS_FILE_EXTENT_REG,
 						 &token);
-		if (em->block_start == 0)
+		if (em->block_start == EXTENT_MAP_HOLE)
 			skip_csum = true;
 	}
 


