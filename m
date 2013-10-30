Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753105Ab3J3Jp1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 05:45:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62642 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752544Ab3J3JpY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 05:45:24 -0400
From: Madper Xie <cxie@redhat.com>
To: tony.luck@intel.com, keescook@chromium.org, ccross@android.com,
        anton@enomsg.org, seiji.aguchi@hds.com
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, bbboson@gmail.com,
        Madper Xie <cxie@redhat.com>
Subject: [PATCH 2/2] pstore: Differentiating names by adding count and timestamp
Date: Wed, 30 Oct 2013 17:44:54 +0800
Message-Id: <1383126294-28793-3-git-send-email-cxie@redhat.com>
In-Reply-To: <1383126294-28793-1-git-send-email-cxie@redhat.com>
References: <1383126294-28793-1-git-send-email-cxie@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Madper Xie <bbboson@gmail.com>

pstore denominates dumped file as type-psname-id. it makes many file have
the same name if there are many entries in backend have the same id.
So adding count and timestamp to file name for differentiating.

Signed-off-by: Madper Xie <cxie@redhat.com>
---
 fs/pstore/inode.c | 29 ++++++++++++++++++-----------
 1 file changed, 18 insertions(+), 11 deletions(-)

diff --git a/fs/pstore/inode.c b/fs/pstore/inode.c
index 0ae994c..36b502f 100644
--- a/fs/pstore/inode.c
+++ b/fs/pstore/inode.c
@@ -285,7 +285,7 @@ int pstore_mkfile(enum pstore_type_id type, char *psname, u64 id, int count,
 	int			rc = 0;
 	char			name[PSTORE_NAMELEN];
 	struct pstore_private	*private, *pos;
-	unsigned long		flags;
+	unsigned long		flags, timestamp;
 
 	spin_lock_irqsave(&allpstore_lock, flags);
 	list_for_each_entry(pos, &allpstore, list) {
@@ -316,35 +316,42 @@ int pstore_mkfile(enum pstore_type_id type, char *psname, u64 id, int count,
 	private->count = count;
 	private->psi = psi;
 	memcpy(&private->time, &time, sizeof(struct timespec));
+	timestamp = time.tv_sec;
 
 	switch (type) {
 	case PSTORE_TYPE_DMESG:
-		sprintf(name, "dmesg-%s-%lld%s", psname, id,
-						compressed ? ".enc.z" : "");
+		sprintf(name, "dmesg-%s-%lld-%d-%ld%s", psname, id, count,
+			timestamp, compressed ? ".enc.z" : "");
 		break;
 	case PSTORE_TYPE_CONSOLE:
-		sprintf(name, "console-%s", psname);
+		sprintf(name, "console-%s-%d-%ld", psname, count, timestamp);
 		break;
 	case PSTORE_TYPE_FTRACE:
-		sprintf(name, "ftrace-%s", psname);
+		sprintf(name, "ftrace-%s-%d-%ld", psname, count, timestamp);
 		break;
 	case PSTORE_TYPE_MCE:
-		sprintf(name, "mce-%s-%lld", psname, id);
+		sprintf(name, "mce-%s-%lld-%d-%ld", psname, id, count,
+			timestamp);
 		break;
 	case PSTORE_TYPE_PPC_RTAS:
-		sprintf(name, "rtas-%s-%lld", psname, id);
+		sprintf(name, "rtas-%s-%lld-%d-%ld", psname, id, count,
+			timestamp);
 		break;
 	case PSTORE_TYPE_PPC_OF:
-		sprintf(name, "powerpc-ofw-%s-%lld", psname, id);
+		sprintf(name, "powerpc-ofw-%s-%lld-%d-%ld", psname, id, count,
+			timestamp);
 		break;
 	case PSTORE_TYPE_PPC_COMMON:
-		sprintf(name, "powerpc-common-%s-%lld", psname, id);
+		sprintf(name, "powerpc-common-%s-%lld-%d-%ld", psname, id,
+			count, timestamp);
 		break;
 	case PSTORE_TYPE_UNKNOWN:
-		sprintf(name, "unknown-%s-%lld", psname, id);
+		sprintf(name, "unknown-%s-%lld-%d-%ld", psname, id, count,
+			timestamp);
 		break;
 	default:
-		sprintf(name, "type%d-%s-%lld", type, psname, id);
+		sprintf(name, "type%d-%s-%lld-%d-%ld", type, psname, id, count,
+			timestamp);
 		break;
 	}
 
-- 
1.8.4.2

