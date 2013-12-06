Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162063Ab3LFNFh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 08:05:37 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44701 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162045Ab3LFNFe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 08:05:34 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Eric Sandeen <sandeen@redhat.com>, Ben Myers <bpm@sgi.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 239/272] xfs: be more forgiving of a v4 secondary sb w/ junk in v5 fields
Date: Fri,  6 Dec 2013 12:58:48 +0000
Message-Id: <1386334761-25517-240-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
References: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Sandeen <sandeen@sandeen.net>

commit 10e6e65dfcedff63275c3d649d329c044caa8e26 upstream.

Today, if xfs_sb_read_verify encounters a v4 superblock
with junk past v4 fields which includes data in sb_crc,
it will be treated as a failing checksum and a significant
corruption.

There are known prior bugs which leave junk at the end
of the V4 superblock; we don't need to actually fail the
verification in this case if other checks pan out ok.

So if this is a secondary superblock, and the primary
superblock doesn't indicate that this is a V5 filesystem,
don't treat this as an actual checksum failure.

We should probably check the garbage condition as
we do in xfs_repair, and possibly warn about it
or self-heal, but that's a different scope of work.

Stable folks: This can go back to v3.10, which is what
introduced the sb CRC checking that is tripped up by old,
stale, incorrect V4 superblocks w/ unzeroed bits.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Acked-by: Dave Chinner <david@fromorbit.com>
Reviewed-by: Mark Tinguely <tinguely@sgi.com>
Signed-off-by: Ben Myers <bpm@sgi.com>
[ luis: backported to 3.5:
  - xfs_sb_read_verify() is defined in fs/xfs/xfs_mount.c in 3.11 ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/xfs/xfs_mount.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 2b0ba35..fd078b7 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -749,6 +749,11 @@ xfs_sb_verify(
  * single bit error could clear the feature bit and unused parts of the
  * superblock are supposed to be zero. Hence a non-null crc field indicates that
  * we've potentially lost a feature bit and we should check it anyway.
+ *
+ * However, past bugs (i.e. in growfs) left non-zeroed regions beyond the
+ * last field in V4 secondary superblocks.  So for secondary superblocks,
+ * we are more forgiving, and ignore CRC failures if the primary doesn't
+ * indicate that the fs version is V5.
  */
 static void
 xfs_sb_read_verify(
@@ -769,8 +774,12 @@ xfs_sb_read_verify(
 
 		if (!xfs_verify_cksum(bp->b_addr, be16_to_cpu(dsb->sb_sectsize),
 				      offsetof(struct xfs_sb, sb_crc))) {
-			error = EFSCORRUPTED;
-			goto out_error;
+			/* Only fail bad secondaries on a known V5 filesystem */
+			if (bp->b_bn != XFS_SB_DADDR &&
+			    xfs_sb_version_hascrc(&mp->m_sb)) {
+				error = EFSCORRUPTED;
+				goto out_error;
+			}
 		}
 	}
 	error = xfs_sb_verify(bp, true);
-- 
1.8.3.2

