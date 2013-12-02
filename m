Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757499Ab3LBUVS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 15:21:18 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39148 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753731Ab3LBTRR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:17:17 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ilija Hadzic <ihadzic@research.bell-labs.com>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.12 033/212] devpts: plug the memory leak in kill_sb
Date: Mon,  2 Dec 2013 11:13:44 -0800
Message-Id: <20131202191252.226169716@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191248.517975703@linuxfoundation.org>
References: <20131202191248.517975703@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilija Hadzic <ihadzic@research.bell-labs.com>

commit 66da0e1f9034140ae2f571ef96e254a25083906c upstream.

When devpts is unmounted, there may be a no-longer-used IDR tree hanging
off the superblock we are about to kill.  This needs to be cleaned up
before destroying the SB.

The leak is usually not a big deal because unmounting devpts is typically
done when shutting down the whole machine.  However, shutting down an LXC
container instead of a physical machine exposes the problem (the garbage
is detectable with kmemleak).

Signed-off-by: Ilija Hadzic <ihadzic@research.bell-labs.com>
Cc: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/devpts/inode.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/devpts/inode.c
+++ b/fs/devpts/inode.c
@@ -498,6 +498,7 @@ static void devpts_kill_sb(struct super_
 {
 	struct pts_fs_info *fsi = DEVPTS_SB(sb);
 
+	ida_destroy(&fsi->allocated_ptys);
 	kfree(fsi);
 	kill_litter_super(sb);
 }


