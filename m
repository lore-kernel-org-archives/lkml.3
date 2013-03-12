Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933814Ab3CLWjp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 18:39:45 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60407 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755796Ab3CLWdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 18:33:32 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Josef Bacik <jbacik@fusionio.com>
Subject: [ 077/100] Btrfs: cleanup orphan reservation if truncate fails
Date: Tue, 12 Mar 2013 15:32:02 -0700
Message-Id: <20130312223131.210109191@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130312223122.884099393@linuxfoundation.org>
References: <20130312223122.884099393@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <jbacik@fusionio.com>

commit 4a7d0f6854c4a4ad1dba00a3b128a32d39b9a742 upstream.

I noticed we were getting lots of warnings with xfstest 83 because we have
reservations outstanding.  This is because we moved the orphan add outside
of the truncate, but we don't actually cleanup our reservation if something
fails.  This fixes the problem and I no longer see warnings.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/inode.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2493,6 +2493,8 @@ int btrfs_orphan_cleanup(struct btrfs_ro
 				goto out;
 
 			ret = btrfs_truncate(inode);
+			if (ret)
+				btrfs_orphan_del(NULL, inode);
 		} else {
 			nr_unlink++;
 		}


