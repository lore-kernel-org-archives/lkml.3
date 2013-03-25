Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756150Ab3CYBQK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 21:16:10 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33969 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756017Ab3CYBQA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 21:16:00 -0400
Message-Id: <20130325010532.004377196@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 25 Mar 2013 01:06:42 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Matt Fleming <matt.fleming@intel.com>,
        Frederic Crozat <fcrozat@suse.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Josh Boyer <jwboyer@redhat.com>,
        Michael Schroeder <mls@suse.com>, "Lee, Chun-Yi" <jlee@suse.com>,
        Lingzhu Xiang <lxiang@redhat.com>, Seiji Aguchi <seiji.aguchi@hds.com>
Subject: [ 078/104] efivars: explicitly calculate length of VariableName
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130325010524.240972766@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:f137:78a:b654:affb
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matt Fleming <matt.fleming@intel.com>

commit ec50bd32f1672d38ddce10fb1841cbfda89cfe9a upstream.

It's not wise to assume VariableNameSize represents the length of
VariableName, as not all firmware updates VariableNameSize in the same
way (some don't update it at all if EFI_SUCCESS is returned). There
are even implementations out there that update VariableNameSize with
values that are both larger than the string returned in VariableName
and smaller than the buffer passed to GetNextVariableName(), which
resulted in the following bug report from Michael Schroeder,

  > On HP z220 system (firmware version 1.54), some EFI variables are
  > incorrectly named :
  >
  > ls -d /sys/firmware/efi/vars/*8be4d* | grep -v -- -8be returns
  > /sys/firmware/efi/vars/dbxDefault-pport8be4df61-93ca-11d2-aa0d-00e098032b8c
  > /sys/firmware/efi/vars/KEKDefault-pport8be4df61-93ca-11d2-aa0d-00e098032b8c
  > /sys/firmware/efi/vars/SecureBoot-pport8be4df61-93ca-11d2-aa0d-00e098032b8c
  > /sys/firmware/efi/vars/SetupMode-Information8be4df61-93ca-11d2-aa0d-00e098032b8c

The issue here is that because we blindly use VariableNameSize without
verifying its value, we can potentially read garbage values from the
buffer containing VariableName if VariableNameSize is larger than the
length of VariableName.

Since VariableName is a string, we can calculate its size by searching
for the terminating NULL character.

Reported-by: Frederic Crozat <fcrozat@suse.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Josh Boyer <jwboyer@redhat.com>
Cc: Michael Schroeder <mls@suse.com>
Cc: Lee, Chun-Yi <jlee@suse.com>
Cc: Lingzhu Xiang <lxiang@redhat.com>
Cc: Seiji Aguchi <seiji.aguchi@hds.com>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/firmware/efivars.c |   32 +++++++++++++++++++++++++++++++-
 1 file changed, 31 insertions(+), 1 deletion(-)

--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -1043,6 +1043,31 @@ static bool variable_is_present(efi_char
 	return found;
 }
 
+/*
+ * Returns the size of variable_name, in bytes, including the
+ * terminating NULL character, or variable_name_size if no NULL
+ * character is found among the first variable_name_size bytes.
+ */
+static unsigned long var_name_strnsize(efi_char16_t *variable_name,
+				       unsigned long variable_name_size)
+{
+	unsigned long len;
+	efi_char16_t c;
+
+	/*
+	 * The variable name is, by definition, a NULL-terminated
+	 * string, so make absolutely sure that variable_name_size is
+	 * the value we expect it to be. If not, return the real size.
+	 */
+	for (len = 2; len <= variable_name_size; len += sizeof(c)) {
+		c = variable_name[(len / sizeof(c)) - 1];
+		if (!c)
+			break;
+	}
+
+	return min(len, variable_name_size);
+}
+
 static void efivar_update_sysfs_entries(struct work_struct *work)
 {
 	struct efivars *efivars = &__efivars;
@@ -1083,10 +1108,13 @@ static void efivar_update_sysfs_entries(
 		if (!found) {
 			kfree(variable_name);
 			break;
-		} else
+		} else {
+			variable_name_size = var_name_strnsize(variable_name,
+							       variable_name_size);
 			efivar_create_sysfs_entry(efivars,
 						  variable_name_size,
 						  variable_name, &vendor);
+		}
 	}
 }
 
@@ -1317,6 +1345,8 @@ int register_efivars(struct efivars *efi
 						&vendor_guid);
 		switch (status) {
 		case EFI_SUCCESS:
+			variable_name_size = var_name_strnsize(variable_name,
+							       variable_name_size);
 			efivar_create_sysfs_entry(efivars,
 						  variable_name_size,
 						  variable_name,


