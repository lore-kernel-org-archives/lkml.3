Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754632Ab3KAQOi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 12:14:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:65189 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752084Ab3KAQOh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 12:14:37 -0400
User-agent: mu4e 0.9.9.5; emacs 24.3.1
From: Madper Xie <cxie@redhat.com>
To: Tony Luck <tony.luck@gmail.com>, Seiji Aguchi <seiji.aguchi@hds.com>,
        "matt.fleming\@intel.com" <matt.fleming@intel.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Linux EFI <linux-efi@vger.kernel.org>, bbboson@gmail.com
Subject: [PATCH] Make efi-pstore return a unique id
Date: Sat, 02 Nov 2013 00:14:26 +0800
Message-ID: <87ppqk6qvx.fsf@redhat.com>
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
 drivers/firmware/efi/efi-pstore.c | 22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/drivers/firmware/efi/efi-pstore.c b/drivers/firmware/efi/efi-pstore.c
index 5002d50..0de9179 100644
--- a/drivers/firmware/efi/efi-pstore.c
+++ b/drivers/firmware/efi/efi-pstore.c
@@ -39,6 +39,17 @@ struct pstore_read_data {
 	char **buf;
 };
 
+static u64 efi_generate_id(unsigned long timestamp, unsigned int part, int count)
+{
+	char id_str[64];
+	u64 id = 0;
+
+	sprintf(id_str, "%lu%u%d", timestamp, part, count);
+	if (kstrtoull(id_str, 10, &id))
+		pr_warn("efi-pstore: failed to generate id\n");
+	return id;
+}
+
 static int efi_pstore_read_func(struct efivar_entry *entry, void *data)
 {
 	efi_guid_t vendor = LINUX_EFI_CRASH_GUID;
@@ -57,17 +68,18 @@ static int efi_pstore_read_func(struct efivar_entry *entry, void *data)
 
 	if (sscanf(name, "dump-type%u-%u-%d-%lu-%c",
 		   cb_data->type, &part, &cnt, &time, &data_type) == 5) {
-		*cb_data->id = part;
+		*cb_data->id = efi_generate_id(time, part, cnt);
 		*cb_data->count = cnt;
 		cb_data->timespec->tv_sec = time;
 		cb_data->timespec->tv_nsec = 0;
+
 		if (data_type == 'C')
 			*cb_data->compressed = true;
 		else
 			*cb_data->compressed = false;
 	} else if (sscanf(name, "dump-type%u-%u-%d-%lu",
 		   cb_data->type, &part, &cnt, &time) == 4) {
-		*cb_data->id = part;
+		*cb_data->id = efi_generate_id(time, part, cnt);
 		*cb_data->count = cnt;
 		cb_data->timespec->tv_sec = time;
 		cb_data->timespec->tv_nsec = 0;
@@ -79,7 +91,7 @@ static int efi_pstore_read_func(struct efivar_entry *entry, void *data)
 		 * which doesn't support holding
 		 * multiple logs, remains.
 		 */
-		*cb_data->id = part;
+		*cb_data->id = efi_generate_id(time, part, 0);
 		*cb_data->count = 0;
 		cb_data->timespec->tv_sec = time;
 		cb_data->timespec->tv_nsec = 0;
@@ -125,9 +137,11 @@ static int efi_pstore_write(enum pstore_type_id type,
 	efi_char16_t efi_name[DUMP_NAME_LEN];
 	efi_guid_t vendor = LINUX_EFI_CRASH_GUID;
 	int i, ret = 0;
+	unsigned long timestamp;
 
+	timestamp = get_seconds();
 	sprintf(name, "dump-type%u-%u-%d-%lu-%c", type, part, count,
-		get_seconds(), compressed ? 'C' : 'D');
+		timestamp, compressed ? 'C' : 'D');
 
 	for (i = 0; i < DUMP_NAME_LEN; i++)
 		efi_name[i] = name[i];
-- 
1.8.4.2

