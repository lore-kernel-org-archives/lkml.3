Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933780Ab3DBWOe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 18:14:34 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33533 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933733Ab3DBWO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 18:14:26 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Frederic Crozat <fcrozat@suse.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Josh Boyer <jwboyer@redhat.com>,
        Michael Schroeder <mls@suse.com>, "Lee, Chun-Yi" <jlee@suse.com>,
        Lingzhu Xiang <lxiang@redhat.com>, Seiji Aguchi <seiji.aguchi@hds.com>,
        Matt Fleming <matt.fleming@intel.com>, CAI Qian <caiqian@redhat.com>
Subject: [ 38/68] efivars: explicitly calculate length of VariableName
Date: Tue,  2 Apr 2013 15:13:27 -0700
Message-Id: <20130402221334.321137554@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130402221329.915209206@linuxfoundation.org>
References: <20130402221329.915209206@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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

[Backported for 3.8-stable. Removed workqueue code added in
a93bc0c 3.9-rc1.]

Reported-by: Frederic Crozat <fcrozat@suse.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Josh Boyer <jwboyer@redhat.com>
Cc: Michael Schroeder <mls@suse.com>
Cc: Lee, Chun-Yi <jlee@suse.com>
Cc: Lingzhu Xiang <lxiang@redhat.com>
Cc: Seiji Aguchi <seiji.aguchi@hds.com>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
Signed-off-by: Lingzhu Xiang <lxiang@redhat.com>
Reviewed-by: CAI Qian <caiqian@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/firmware/efivars.c |   27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -943,6 +943,31 @@ static ssize_t efivar_delete(struct file
 }
 
 /*
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
+/*
  * Let's not leave out systab information that snuck into
  * the efivars driver
  */
@@ -1169,6 +1194,8 @@ int register_efivars(struct efivars *efi
 						&vendor_guid);
 		switch (status) {
 		case EFI_SUCCESS:
+			variable_name_size = var_name_strnsize(variable_name,
+							       variable_name_size);
 			efivar_create_sysfs_entry(efivars,
 						  variable_name_size,
 						  variable_name,


