Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756957Ab3KNQnq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 11:43:46 -0500
Received: from mail-pb0-f42.google.com ([209.85.160.42]:36843 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755284Ab3KNQnf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 11:43:35 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, "John L. Hammond" <john.hammond@intel.com>,
        Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 01/26] staging/lustre/hsm: handle file ownership and timestamps
Date: Fri, 15 Nov 2013 00:42:48 +0800
Message-Id: <1384447393-13838-2-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384447393-13838-1-git-send-email-bergwolf@gmail.com>
References: <1384447393-13838-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John L. Hammond" <john.hammond@intel.com>

In hsm_init_ucred() set the capability mask to CFS_CAP_FS_MASK thereby
allowing the coordinator to swap layouts of files not owned by
root. In mdt_orphan_open() raise CFS_CAP_DAC_OVERRIDE before creating
the orphan filee in the MDT's local root. In mdt_hsm_release() set
inode size and timestamps before getting the LOV xattr and ensure that
the orphan file is created with the same UID and GID of the original.
In lhsmtool_posix.c similalrly ensure that the volatile file used for
restore has the same ownership, access and modification timestamps as
the original.

Strengthen sanity-hsm test 24 to check that none of archive, release,
or restore will change the access or modified timestamps. Add 24b to
check that root can archive, release, and restore an ordinary user's
files and that the user will be able to read a released file even if
the parent directory is unwritable.

Lustre-change: http://review.whamcloud.com/7461
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-3811
Signed-off-by: John L. Hammond <john.hammond@intel.com>
Reviewed-by: Aurelien Degremont <aurelien.degremont@cea.fr>
Reviewed-by: jacques-Charles Lafoucriere <jacques-charles.lafoucriere@cea.fr>
Reviewed-by: Oleg Drokin <oleg.drokin@intel.com>
Signed-off-by: Peng Tao <bergwolf@gmail.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 .../lustre/lustre/include/lustre/lustreapi.h       |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/lustre/lustre/include/lustre/lustreapi.h b/drivers/staging/lustre/lustre/include/lustre/lustreapi.h
index e6ce238..597822c 100644
--- a/drivers/staging/lustre/lustre/include/lustre/lustreapi.h
+++ b/drivers/staging/lustre/lustre/include/lustre/lustreapi.h
@@ -313,8 +313,8 @@ extern int llapi_hsm_action_begin(struct hsm_copyaction_private **phcp,
 				  int restore_mdt_index, int restore_open_flags,
 				  bool is_error);
 extern int llapi_hsm_action_end(struct hsm_copyaction_private **phcp,
-				const struct hsm_extent *he, int flags,
-				int errval);
+				const struct hsm_extent *he,
+				int hp_flags, int errval);
 extern int llapi_hsm_action_progress(struct hsm_copyaction_private *hcp,
 				     const struct hsm_extent *he, int hp_flags);
 extern int llapi_hsm_action_get_dfid(const struct hsm_copyaction_private *hcp,
-- 
1.7.9.5

