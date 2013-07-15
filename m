Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933408Ab3GOQ5I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 12:57:08 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:45189 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932297Ab3GOQ5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 12:57:04 -0400
Subject: [PATCH 10/11] efi-pstore: Read and write to the 'compressed' flag
 of pstore
To: linuxppc-dev@ozlabs.org, paulus@samba.org, linux-kernel@vger.kernel.org,
        benh@kernel.crashing.org
From: Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>
Cc: jkenisto@linux.vnet.ibm.com, tony.luck@intel.com, ananth@in.ibm.com,
        mahesh@linux.vnet.ibm.com, ccross@android.com, anton@samba.org,
        cbouatmailru@gmail.com, keescook@chromium.org
Date: Mon, 15 Jul 2013 22:26:53 +0530
Message-ID: <20130715165653.1520.70263.stgit@aruna-ThinkPad-T420>
In-Reply-To: <20130715164844.1520.27771.stgit@aruna-ThinkPad-T420>
References: <20130715164844.1520.27771.stgit@aruna-ThinkPad-T420>
User-Agent: StGit/0.16-41-gd1dd
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13071516-3864-0000-0000-000009155DF6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In pstore write, Efi will add a character 'C'(compressed) or
D'(decompressed) in its header while writing to persistent store.
In pstore read, read the header and update the 'compressed' flag
accordingly.

Signed-off-by: Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>
---
 drivers/firmware/efi/efi-pstore.c |   22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/drivers/firmware/efi/efi-pstore.c b/drivers/firmware/efi/efi-pstore.c
index 9a5425f..5002d50 100644
--- a/drivers/firmware/efi/efi-pstore.c
+++ b/drivers/firmware/efi/efi-pstore.c
@@ -35,6 +35,7 @@ struct pstore_read_data {
 	enum pstore_type_id *type;
 	int *count;
 	struct timespec *timespec;
+	bool *compressed;
 	char **buf;
 };
 
@@ -42,7 +43,7 @@ static int efi_pstore_read_func(struct efivar_entry *entry, void *data)
 {
 	efi_guid_t vendor = LINUX_EFI_CRASH_GUID;
 	struct pstore_read_data *cb_data = data;
-	char name[DUMP_NAME_LEN];
+	char name[DUMP_NAME_LEN], data_type;
 	int i;
 	int cnt;
 	unsigned int part;
@@ -54,12 +55,23 @@ static int efi_pstore_read_func(struct efivar_entry *entry, void *data)
 	for (i = 0; i < DUMP_NAME_LEN; i++)
 		name[i] = entry->var.VariableName[i];
 
-	if (sscanf(name, "dump-type%u-%u-%d-%lu",
+	if (sscanf(name, "dump-type%u-%u-%d-%lu-%c",
+		   cb_data->type, &part, &cnt, &time, &data_type) == 5) {
+		*cb_data->id = part;
+		*cb_data->count = cnt;
+		cb_data->timespec->tv_sec = time;
+		cb_data->timespec->tv_nsec = 0;
+		if (data_type == 'C')
+			*cb_data->compressed = true;
+		else
+			*cb_data->compressed = false;
+	} else if (sscanf(name, "dump-type%u-%u-%d-%lu",
 		   cb_data->type, &part, &cnt, &time) == 4) {
 		*cb_data->id = part;
 		*cb_data->count = cnt;
 		cb_data->timespec->tv_sec = time;
 		cb_data->timespec->tv_nsec = 0;
+		*cb_data->compressed = false;
 	} else if (sscanf(name, "dump-type%u-%u-%lu",
 			  cb_data->type, &part, &time) == 3) {
 		/*
@@ -71,6 +83,7 @@ static int efi_pstore_read_func(struct efivar_entry *entry, void *data)
 		*cb_data->count = 0;
 		cb_data->timespec->tv_sec = time;
 		cb_data->timespec->tv_nsec = 0;
+		*cb_data->compressed = false;
 	} else
 		return 0;
 
@@ -96,6 +109,7 @@ static ssize_t efi_pstore_read(u64 *id, enum pstore_type_id *type,
 	data.type = type;
 	data.count = count;
 	data.timespec = timespec;
+	data.compressed = compressed;
 	data.buf = buf;
 
 	return __efivar_entry_iter(efi_pstore_read_func, &efivar_sysfs_list, &data,
@@ -112,8 +126,8 @@ static int efi_pstore_write(enum pstore_type_id type,
 	efi_guid_t vendor = LINUX_EFI_CRASH_GUID;
 	int i, ret = 0;
 
-	sprintf(name, "dump-type%u-%u-%d-%lu", type, part, count,
-		get_seconds());
+	sprintf(name, "dump-type%u-%u-%d-%lu-%c", type, part, count,
+		get_seconds(), compressed ? 'C' : 'D');
 
 	for (i = 0; i < DUMP_NAME_LEN; i++)
 		efi_name[i] = name[i];

