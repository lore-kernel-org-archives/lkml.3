Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933121Ab3GKO1O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 10:27:14 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43259 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933019Ab3GKO1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 10:27:06 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Seiji Aguchi <seiji.aguchi@hds.com>, Tony Luck <tony.luck@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 87/98] efi_pstore: Check remaining space with QueryVariableInfo() before writing data
Date: Thu, 11 Jul 2013 15:24:57 +0100
Message-Id: <1373552708-15235-88-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1373552708-15235-1-git-send-email-luis.henriques@canonical.com>
References: <1373552708-15235-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.17 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Seiji Aguchi <seiji.aguchi@hds.com>

commit d80a361d779a9f19498943d1ca84243209cd5647 upstream.

[Issue]

As discussed in a thread below, Running out of space in EFI isn't a well-tested scenario.
And we wouldn't expect all firmware to handle it gracefully.
http://marc.info/?l=linux-kernel&m=134305325801789&w=2

On the other hand, current efi_pstore doesn't check a remaining space of storage at writing time.
Therefore, efi_pstore may not work if it tries to write a large amount of data.

[Patch Description]

To avoid handling the situation above, this patch checks if there is a space enough to log with
QueryVariableInfo() before writing data.

Signed-off-by: Seiji Aguchi <seiji.aguchi@hds.com>
Acked-by: Mike Waychison <mikew@google.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/firmware/efivars.c | 18 ++++++++++++++++++
 include/linux/efi.h        |  1 +
 2 files changed, 19 insertions(+)

diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index 303bc8e..3c8fd0f 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -710,12 +710,29 @@ static int efi_pstore_write(enum pstore_type_id type,
 	struct efivars *efivars = psi->data;
 	struct efivar_entry *entry, *found = NULL;
 	int i, ret = 0;
+	u64 storage_space, remaining_space, max_variable_size;
+	efi_status_t status = EFI_NOT_FOUND;
 
 	sprintf(stub_name, "dump-type%u-%u-", type, part);
 	sprintf(name, "%s%lu", stub_name, get_seconds());
 
 	spin_lock(&efivars->lock);
 
+	/*
+	 * Check if there is a space enough to log.
+	 * size: a size of logging data
+	 * DUMP_NAME_LEN * 2: a maximum size of variable name
+	 */
+	status = efivars->ops->query_variable_info(PSTORE_EFI_ATTRIBUTES,
+						   &storage_space,
+						   &remaining_space,
+						   &max_variable_size);
+	if (status || remaining_space < size + DUMP_NAME_LEN * 2) {
+		spin_unlock(&efivars->lock);
+		*id = part;
+		return -ENOSPC;
+	}
+
 	for (i = 0; i < DUMP_NAME_LEN; i++)
 		efi_name[i] = stub_name[i];
 
@@ -1220,6 +1237,7 @@ efivars_init(void)
 	ops.get_variable = efi.get_variable;
 	ops.set_variable = efi.set_variable;
 	ops.get_next_variable = efi.get_next_variable;
+	ops.query_variable_info = efi.query_variable_info;
 	error = register_efivars(&__efivars, &ops, efi_kobj);
 	if (error)
 		goto err_put;
diff --git a/include/linux/efi.h b/include/linux/efi.h
index eee8b0b..8554af9 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -652,6 +652,7 @@ struct efivar_operations {
 	efi_get_variable_t *get_variable;
 	efi_get_next_variable_t *get_next_variable;
 	efi_set_variable_t *set_variable;
+	efi_query_variable_info_t *query_variable_info;
 };
 
 struct efivars {
-- 
1.8.1.2

