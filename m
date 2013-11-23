Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755432Ab3KWLz5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Nov 2013 06:55:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:65054 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752744Ab3KWLzz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Nov 2013 06:55:55 -0500
User-agent: mu4e 0.9.9.6pre2; emacs 24.3.1
From: Madper Xie <cxie@redhat.com>
To: "'linux-kernel\@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "linux-efi\@vger.kernel.org" <linux-efi@vger.kernel.org>
Cc: "matt.fleming\@intel.com" <matt.fleming@intel.com>,
        Seiji Aguchi <seiji.aguchi@hds.com>,
        "richard\@nod.at" <richard@nod.at>, Tony Luck <tony.luck@gmail.com>
Subject: [PATCH v2] efi-pstore: Make efi-pstore return a unique id
Date: Sat, 23 Nov 2013 19:55:37 +0800
Message-ID: <87bo1bnxhi.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Pstore fs expects that backends provide a uniqued id which could avoid
pstore making entries as duplication or denominating entries the same
name. So I combine the timestamp, part and count into id.

Signed-off-by: Madper Xie <cxie@redhat.com>
---
 drivers/firmware/efi/efi-pstore.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/firmware/efi/efi-pstore.c b/drivers/firmware/efi/efi-pstore.c
index 5002d50..c6075f8 100644
--- a/drivers/firmware/efi/efi-pstore.c
+++ b/drivers/firmware/efi/efi-pstore.c
@@ -39,6 +39,12 @@ struct pstore_read_data {
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
@@ -57,7 +63,7 @@ static int efi_pstore_read_func(struct efivar_entry *entry, void *data)
 
 	if (sscanf(name, "dump-type%u-%u-%d-%lu-%c",
 		   cb_data->type, &part, &cnt, &time, &data_type) == 5) {
-		*cb_data->id = part;
+		*cb_data->id = generic_id(time, part, cnt);
 		*cb_data->count = cnt;
 		cb_data->timespec->tv_sec = time;
 		cb_data->timespec->tv_nsec = 0;
@@ -67,7 +73,7 @@ static int efi_pstore_read_func(struct efivar_entry *entry, void *data)
 			*cb_data->compressed = false;
 	} else if (sscanf(name, "dump-type%u-%u-%d-%lu",
 		   cb_data->type, &part, &cnt, &time) == 4) {
-		*cb_data->id = part;
+		*cb_data->id = generic_id(time, part, cnt);
 		*cb_data->count = cnt;
 		cb_data->timespec->tv_sec = time;
 		cb_data->timespec->tv_nsec = 0;
@@ -79,7 +85,7 @@ static int efi_pstore_read_func(struct efivar_entry *entry, void *data)
 		 * which doesn't support holding
 		 * multiple logs, remains.
 		 */
-		*cb_data->id = part;
+		*cb_data->id = generic_id(time, part, 0);
 		*cb_data->count = 0;
 		cb_data->timespec->tv_sec = time;
 		cb_data->timespec->tv_nsec = 0;
@@ -199,14 +205,15 @@ static int efi_pstore_erase(enum pstore_type_id type, u64 id, int count,
 	char name[DUMP_NAME_LEN];
 	efi_char16_t efi_name[DUMP_NAME_LEN];
 	int found, i;
+	unsigned int part;
 
-	sprintf(name, "dump-type%u-%u-%d-%lu", type, (unsigned int)id, count,
-		time.tv_sec);
+	part = (id / 1000) % 100;
+	sprintf(name, "dump-type%u-%u-%d-%lu", type, part, count, time.tv_sec);
 
 	for (i = 0; i < DUMP_NAME_LEN; i++)
 		efi_name[i] = name[i];
 
-	edata.id = id;
+	edata.id = part;
 	edata.type = type;
 	edata.count = count;
 	edata.time = time;
-- 
1.8.4.2

