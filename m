Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753536Ab3J3JpV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 05:45:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28768 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752544Ab3J3JpS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 05:45:18 -0400
From: Madper Xie <cxie@redhat.com>
To: tony.luck@intel.com, keescook@chromium.org, ccross@android.com,
        anton@enomsg.org, seiji.aguchi@hds.com
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, bbboson@gmail.com,
        Madper Xie <cxie@redhat.com>
Subject: [PATCH 1/2] pstore: avoid incorrectly mark entry as duplicate
Date: Wed, 30 Oct 2013 17:44:53 +0800
Message-Id: <1383126294-28793-2-git-send-email-cxie@redhat.com>
In-Reply-To: <1383126294-28793-1-git-send-email-cxie@redhat.com>
References: <1383126294-28793-1-git-send-email-cxie@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Madper Xie <bbboson@gmail.com>

pstore try to find duplicate entries by check both ID, type and psi.
They are not really enough for efi backend. dumped vars always have
the same type, psi and ID. like follows:
dump-type0-9-1-1382511508-C-cfc8fc79-be2e-4ddc-97f0-9f98bfe298a0
dump-type0-9-1-1382515661-C-cfc8fc79-be2e-4ddc-97f0-9f98bfe298a0

The "duplicate" entries won't appear in pstorefs. And a complain will be
print -- pstore: failed to load 76 record(s) from 'efi'
So I add two more checks: timespec and count.

Signed-off-by: Madper Xie <cxie@redhat.com>
---
 fs/pstore/inode.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/pstore/inode.c b/fs/pstore/inode.c
index 1282384..0ae994c 100644
--- a/fs/pstore/inode.c
+++ b/fs/pstore/inode.c
@@ -47,6 +47,7 @@ static LIST_HEAD(allpstore);
 struct pstore_private {
 	struct list_head list;
 	struct pstore_info *psi;
+	struct timespec time;
 	enum pstore_type_id type;
 	u64	id;
 	int	count;
@@ -290,7 +291,9 @@ int pstore_mkfile(enum pstore_type_id type, char *psname, u64 id, int count,
 	list_for_each_entry(pos, &allpstore, list) {
 		if (pos->type == type &&
 		    pos->id == id &&
-		    pos->psi == psi) {
+		    pos->psi == psi &&
+		    pos->count == count &&
+		    !timespec_compare(&pos->time, &time)) {
 			rc = -EEXIST;
 			break;
 		}
@@ -312,6 +315,7 @@ int pstore_mkfile(enum pstore_type_id type, char *psname, u64 id, int count,
 	private->id = id;
 	private->count = count;
 	private->psi = psi;
+	memcpy(&private->time, &time, sizeof(struct timespec));
 
 	switch (type) {
 	case PSTORE_TYPE_DMESG:
-- 
1.8.4.2

