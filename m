Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758726Ab3IBI7V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 04:59:21 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:37896 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758570Ab3IBIzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 04:55:50 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, Josh Boyer <jwboyer@redhat.com>,
        Michael Schroeder <mls@suse.com>, "Lee, Chun-Yi" <jlee@suse.com>,
        Lingzhu Xiang <lxiang@redhat.com>, Seiji Aguchi <seiji.aguchi@hds.com>,
        Matt Fleming <matt.fleming@intel.com>,
        Hui Wang <hui.wang@canonical.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 50/58] efivars: explicitly calculate length of VariableName
Date: Mon,  2 Sep 2013 09:54:35 +0100
Message-Id: <1378112083-9475-51-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1378112083-9475-1-git-send-email-luis.henriques@canonical.com>
References: <1378112083-9475-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.21 -stable review patch.  If anyone has any objections, please let me know.

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
Cc: Hui Wang <hui.wang@canonical.com>
[ Hui Wang: backported to 3.5: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/firmware/efivars.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index d7c3540..8c7a8cf 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -1006,6 +1006,31 @@ static ssize_t efivar_delete(struct file *filp, struct kobject *kobj,
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
@@ -1232,6 +1257,8 @@ int register_efivars(struct efivars *efivars,
 						&vendor_guid);
 		switch (status) {
 		case EFI_SUCCESS:
+			variable_name_size = var_name_strnsize(variable_name,
+							       variable_name_size);
 			efivar_create_sysfs_entry(efivars,
 						  variable_name_size,
 						  variable_name,
-- 
1.8.3.2

