Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756512Ab3KNQxn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 11:53:43 -0500
Received: from mail-pb0-f53.google.com ([209.85.160.53]:37493 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756344Ab3KNQkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 11:40:08 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, wang di <di.wang@intel.com>,
        Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 26/39] staging/lustre/osd: remove fld lookup during configuration
Date: Fri, 15 Nov 2013 00:32:49 +0800
Message-Id: <1384446782-13741-27-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384446782-13741-1-git-send-email-bergwolf@gmail.com>
References: <1384446782-13741-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: wang di <di.wang@intel.com>

Remove fld lookup during configuration, so to avoid accessing
FLDB on MDT0 before MDT0 is setup.

1. add od_is_ost to check whether the FID is on OST, instead
of lookup in FLDB.

2. add oic_device in OI cache, so in OI cache lookup, it will
try to match device to avoid the ino of agent inode is being
retrieved from OI cache. Then osd_remote_fid, which will trigger
fld lookup, can be removed from osd index lookup.

Lustre-change: http://review.whamcloud.com/7266
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-3126
Signed-off-by: wang di <di.wang@intel.com>
Reviewed-by: Alex Zhuravlev <alexey.zhuravlev@intel.com>
Reviewed-by: Niu Yawei <yawei.niu@intel.com>
Reviewed-by: Mike Pershin <mike.pershin@intel.com>
Reviewed-by: John L. Hammond <john.hammond@intel.com>
Reviewed-by: Fan Yong <fan.yong@intel.com>
Reviewed-by: Andreas Dilger <andreas.dilger@intel.com>
Reviewed-by: Oleg Drokin <oleg.drokin@intel.com>
[pick up only lustre_idl.h change -- Peng Tao]
Signed-off-by: Peng Tao <bergwolf@gmail.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 .../lustre/lustre/include/lustre/lustre_idl.h      |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/lustre/lustre/include/lustre/lustre_idl.h b/drivers/staging/lustre/lustre/include/lustre/lustre_idl.h
index 7bdb24f..15f70dc 100644
--- a/drivers/staging/lustre/lustre/include/lustre/lustre_idl.h
+++ b/drivers/staging/lustre/lustre/include/lustre/lustre_idl.h
@@ -611,10 +611,15 @@ static inline obd_id fid_idif_id(obd_seq seq, __u32 oid, __u32 ver)
 	return ((__u64)ver << 48) | ((seq & 0xffff) << 32) | oid;
 }
 
+static inline __u32 idif_ost_idx(obd_seq seq)
+{
+	return (seq >> 16) & 0xffff;
+}
+
 /* extract ost index from IDIF FID */
 static inline __u32 fid_idif_ost_idx(const struct lu_fid *fid)
 {
-	return (fid_seq(fid) >> 16) & 0xffff;
+	return idif_ost_idx(fid_seq(fid));
 }
 
 /* extract OST sequence (group) from a wire ost_id (id/seq) pair */
-- 
1.7.9.5

