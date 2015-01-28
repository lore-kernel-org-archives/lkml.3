Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755747AbbA1UUL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:20:11 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:30033 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933078AbbA1UUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:20:06 -0500
From: HuKeping <hukeping@huawei.com>
To: <gregkh@linuxfoundation.org>
CC: <linux-kernel@vger.kernel.org>, <matt.fleming@intel.com>,
        <cbouatmailru@gmail.com>, <ccross@android.com>,
        <keescook@chromium.org>, <tony.luck@intel.com>,
        <stable@vger.kernel.org>, <rob.herring@calxeda.com>, <cxie@redhat.com>,
        <sdu.liu@huawei.com>, <wangnan0@huawei.com>, <peifeiyue@huawei.com>
Subject: [PATCH v3 2/2] efi-pstore: Make efi-pstore return a unique id
Date: Wed, 28 Jan 2015 16:06:26 +0800
Message-ID: <1422432386-15761-3-git-send-email-hukeping@huawei.com>
X-Mailer: git-send-email 1.8.5.5
In-Reply-To: <1422432386-15761-1-git-send-email-hukeping@huawei.com>
References: <1422432386-15761-1-git-send-email-hukeping@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.107.197.247]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Madper Xie <cxie@redhat.com>

Commit fdeadb43fdf1e7d5698c027b555c389174548e5a upstream.

Pstore fs expects that backends provide a unique id which could avoid
pstore making entries as duplication or denominating entries the same
name. So I combine the timestamp, part and count into id.

Signed-off-by: Madper Xie <cxie@redhat.com>
Cc: Seiji Aguchi <seiji.aguchi@hds.com>
Cc: stable@vger.kernel.org
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
[hkp: Backported to 3.10: adjust context]
Signed-off-by: Hu Keping <hukeping@huawei.com>

---
 drivers/firmware/efi/efi-pstore.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/firmware/efi/efi-pstore.c b/drivers/firmware/efi/efi-pstore.c
index 66c0c76..c5163e3 100644
--- a/drivers/firmware/efi/efi-pstore.c
+++ b/drivers/firmware/efi/efi-pstore.c
@@ -38,6 +38,12 @@ struct pstore_read_data {
 	char **buf;
 };
 
+static inline u64 generic_id(unsigned long timestamp,
+			     unsigned int part, int count)
+{
+	return (timestamp * 100 + part) * 1000 + count;
+}
+
 static int efi_pstore_read_func(struct efivar_entry *entry, void *data)
 {
 	efi_guid_t vendor = LINUX_EFI_CRASH_GUID;
@@ -56,7 +62,7 @@ static int efi_pstore_read_func(struct efivar_entry *entry, void *data)
 
 	if (sscanf(name, "dump-type%u-%u-%d-%lu",
 		   cb_data->type, &part, &cnt, &time) == 4) {
-		*cb_data->id = part;
+		*cb_data->id = generic_id(time, part, cnt);
 		*cb_data->count = cnt;
 		cb_data->timespec->tv_sec = time;
 		cb_data->timespec->tv_nsec = 0;
@@ -67,7 +73,7 @@ static int efi_pstore_read_func(struct efivar_entry *entry, void *data)
 		 * which doesn't support holding
 		 * multiple logs, remains.
 		 */
-		*cb_data->id = part;
+		*cb_data->id = generic_id(time, part, 0);
 		*cb_data->count = 0;
 		cb_data->timespec->tv_sec = time;
 		cb_data->timespec->tv_nsec = 0;
@@ -185,14 +191,16 @@ static int efi_pstore_erase(enum pstore_type_id type, u64 id, int count,
 	char name[DUMP_NAME_LEN];
 	efi_char16_t efi_name[DUMP_NAME_LEN];
 	int found, i;
+	unsigned int part;
 
-	sprintf(name, "dump-type%u-%u-%d-%lu", type, (unsigned int)id, count,
-		time.tv_sec);
+	do_div(id, 1000);
+	part = do_div(id, 100);
+	sprintf(name, "dump-type%u-%u-%d-%lu", type, part, count, time.tv_sec);
 
 	for (i = 0; i < DUMP_NAME_LEN; i++)
 		efi_name[i] = name[i];
 
-	edata.id = id;
+	edata.id = part;
 	edata.type = type;
 	edata.count = count;
 	edata.time = time;
-- 
1.8.5.5

