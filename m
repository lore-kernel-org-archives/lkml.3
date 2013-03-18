Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752770Ab3CREi4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 00:38:56 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33644 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751329Ab3CREbG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 00:31:06 -0400
Message-Id: <20130318042147.915377990@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 18 Mar 2013 04:22:22 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Seiji Aguchi <seiji.aguchi@hds.com>,
        Mike Waychison <mikew@google.com>, Tony Luck <tony.luck@intel.com>
Subject: [ 38/82] efi_pstore: Check remaining space with QueryVariableInfo() before
 writing data
In-Reply-To: <20130318042144.234468645@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:d98f:da4e:f620:7bea
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/firmware/efivars.c |   18 ++++++++++++++++++
 include/linux/efi.h        |    1 +
 2 files changed, 19 insertions(+)

--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -706,12 +706,29 @@ static int efi_pstore_write(enum pstore_
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
 
@@ -1235,6 +1252,7 @@ efivars_init(void)
 	ops.get_variable = efi.get_variable;
 	ops.set_variable = efi.set_variable;
 	ops.get_next_variable = efi.get_next_variable;
+	ops.query_variable_info = efi.query_variable_info;
 	error = register_efivars(&__efivars, &ops, efi_kobj);
 	if (error)
 		goto err_put;
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -470,6 +470,7 @@ struct efivar_operations {
 	efi_get_variable_t *get_variable;
 	efi_get_next_variable_t *get_next_variable;
 	efi_set_variable_t *set_variable;
+	efi_query_variable_info_t *query_variable_info;
 };
 
 struct efivars {


