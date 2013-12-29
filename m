Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755955Ab3L2C3F (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 21:29:05 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55539 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752500Ab3L2CK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 21:10:56 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Ilija Hadzic" <ihadzic@research.bell-labs.com>,
        "Sukadev Bhattiprolu" <sukadev@linux.vnet.ibm.com>,
        "Linus Torvalds" <torvalds@linux-foundation.org>
Date: Sun, 29 Dec 2013 03:08:43 +0100
Message-ID: <lsq.1388282923.773087876@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 061/185] devpts: plug the memory leak in kill_sb
In-Reply-To: <lsq.1388282923.751256928@decadent.org.uk>
X-SA-Exim-Connect-IP: 31.18.200.85
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.54-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/devpts/inode.c | 1 +
 1 file changed, 1 insertion(+)

--- a/fs/devpts/inode.c
+++ b/fs/devpts/inode.c
@@ -413,6 +413,7 @@ static void devpts_kill_sb(struct super_
 {
 	struct pts_fs_info *fsi = DEVPTS_SB(sb);
 
+	ida_destroy(&fsi->allocated_ptys);
 	kfree(fsi);
 	kill_litter_super(sb);
 }

