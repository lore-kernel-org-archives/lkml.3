Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754373AbaABRTm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 12:19:42 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40456 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136AbaABRJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 12:09:21 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Madper Xie <cxie@redhat.com>, Seiji Aguchi <seiji.aguchi@hds.com>,
        Matt Fleming <matt.fleming@intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 76/91] efi-pstore: Make efi-pstore return a unique id
Date: Thu,  2 Jan 2014 09:04:51 -0800
Message-Id: <1388682306-30859-77-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1388682306-30859-1-git-send-email-kamal@canonical.com>
References: <1388682306-30859-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Madper Xie <cxie@redhat.com>

commit fdeadb43fdf1e7d5698c027b555c389174548e5a upstream.

Pstore fs expects that backends provide a unique id which could avoid
pstore making entries as duplication or denominating entries the same
name. So I combine the timestamp, part and count into id.

Signed-off-by: Madper Xie <cxie@redhat.com>
Cc: Seiji Aguchi <seiji.aguchi@hds.com>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
[ kamal: backport to 3.8 ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/firmware/efivars.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index e3e95dd..e2d4c7a 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -1314,6 +1314,12 @@ static int efi_pstore_close(struct pstore_info *psi)
 	return 0;
 }
 
+static inline u64 generic_id(unsigned long timestamp,
+			     unsigned int part, int count)
+{
+	return (timestamp * 100 + part) * 1000 + count;
+}
+
 static ssize_t efi_pstore_read(u64 *id, enum pstore_type_id *type,
 			       int *count, struct timespec *timespec,
 			       char **buf, struct pstore_info *psi)
@@ -1334,7 +1340,7 @@ static ssize_t efi_pstore_read(u64 *id, enum pstore_type_id *type,
 			}
 			if (sscanf(name, "dump-type%u-%u-%d-%lu",
 				   type, &part, &cnt, &time) == 4) {
-				*id = part;
+				*id = generic_id(time, part, cnt);
 				*count = cnt;
 				timespec->tv_sec = time;
 				timespec->tv_nsec = 0;
@@ -1345,7 +1351,7 @@ static ssize_t efi_pstore_read(u64 *id, enum pstore_type_id *type,
 				 * which doesn't support holding
 				 * multiple logs, remains.
 				 */
-				*id = part;
+				*id = generic_id(time, part, cnt);
 				*count = 0;
 				timespec->tv_sec = time;
 				timespec->tv_nsec = 0;
@@ -1436,9 +1442,11 @@ static int efi_pstore_erase(enum pstore_type_id type, u64 id, int count,
 	struct efivars *efivars = psi->data;
 	struct efivar_entry *entry, *found = NULL;
 	int i;
+	unsigned int part;
 
-	sprintf(name, "dump-type%u-%u-%d-%lu", type, (unsigned int)id, count,
-		time.tv_sec);
+	do_div(id, 1000);
+	part = do_div(id, 100);
+	sprintf(name, "dump-type%u-%u-%d-%lu", type, part, count, time.tv_sec);
 
 	spin_lock_irq(&efivars->lock);
 
-- 
1.8.3.2

