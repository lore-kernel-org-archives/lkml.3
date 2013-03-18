Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753682Ab3CRP3z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 11:29:55 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:37372 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752120Ab3CRP3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 11:29:54 -0400
Message-ID: <514732EF.20609@console-pimps.org>
Date: Mon, 18 Mar 2013 15:29:51 +0000
From: Matt Fleming <matt@console-pimps.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130219 Thunderbird/17.0.3
MIME-Version: 1.0
To: joeyli <jlee@suse.com>
CC: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Schroeder <mls@suse.com>, Josh Boyer <jwboyer@redhat.com>,
        Peter Jones <pjones@redhat.com>, Matthew Garrett <mjg59@srcf.ucam.org>,
        Frederic Crozat <fcrozat@suse.com>
Subject: Re: [PATCH] efivarfs: fix abnormal GUID in variable name by using
 strcpy to replace null with dash
References: <1362108018-13117-1-git-send-email-jlee@suse.com>  <1362151068.2842.440.camel@mfleming-mobl1.ger.corp.intel.com>  <1362155493.2842.446.camel@mfleming-mobl1.ger.corp.intel.com>  <1362181299.23932.168.camel@linux-s257.site>  <1362555258.23932.573.camel@linux-s257.site>  <1362568750.15011.24.camel@mfleming-mobl1.ger.corp.intel.com>  <1362652440.28562.26.camel@linux-s257.site>  <1362656348.15011.166.camel@mfleming-mobl1.ger.corp.intel.com>  <1362664663.15011.194.camel@mfleming-mobl1.ger.corp.intel.com> <1363007873.13754.44.camel@linux-s257.site>
In-Reply-To: <1363007873.13754.44.camel@linux-s257.site>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/11/2013 01:17 PM, joeyli wrote:
> Sorry for after I wrote patch, I think it's better we still use your
> original patch to fix this bug, because I found the
> efi_variable->VariableName allocated 1024 size and it also used by old
> vars system. 
> 
> The following is my patch for reference, but I think your original patch
> is better for backward compatible on variable name.
> 
> Please consider to merge your original patch!

OK, this is what I've got queued up (note I removed the warning).

---

>From afa9ae7bf47145d661487f88f2ec67b062ca98bc Mon Sep 17 00:00:00 2001
From: Matt Fleming <matt.fleming@intel.com>
Date: Fri, 1 Mar 2013 14:49:12 +0000
Subject: [PATCH] efivars: explicitly calculate length of VariableName

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
---
 drivers/firmware/efivars.c | 32 +++++++++++++++++++++++++++++++-
 1 file changed, 31 insertions(+), 1 deletion(-)

diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index d90b061..ae26d5e 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -1704,6 +1704,31 @@ static bool variable_is_present(efi_char16_t *variable_name, efi_guid_t *vendor)
        return found;
 }
 
+/*
+ * Returns the size of variable_name, in bytes, including the
+ * terminating NULL character, or variable_name_size if no NULL
+ * character is found among the first variable_name_size bytes.
+ */
+static unsigned long var_name_strnsize(efi_char16_t *variable_name,
+                                      unsigned long variable_name_size)
+{
+       unsigned long len;
+       efi_char16_t c;
+
+       /*
+        * The variable name is, by definition, a NULL-terminated
+        * string, so make absolutely sure that variable_name_size is
+        * the value we expect it to be. If not, return the real size.
+        */
+       for (len = 2; len <= variable_name_size; len += sizeof(c)) {
+               c = variable_name[(len / sizeof(c)) - 1];
+               if (!c)
+                       break;
+       }
+
+       return min(len, variable_name_size);
+}
+
 static void efivar_update_sysfs_entries(struct work_struct *work)
 {
        struct efivars *efivars = &__efivars;
@@ -1744,10 +1769,13 @@ static void efivar_update_sysfs_entries(struct work_struct *work)
                if (!found) {
                        kfree(variable_name);
                        break;
-               } else
+               } else {
+                       variable_name_size = var_name_strnsize(variable_name,
+                                                              variable_name_size);
                        efivar_create_sysfs_entry(efivars,
                                                  variable_name_size,
                                                  variable_name, &vendor);
+               }
        }
 }
 
@@ -1994,6 +2022,8 @@ int register_efivars(struct efivars *efivars,
                                                &vendor_guid);
                switch (status) {
                case EFI_SUCCESS:
+                       variable_name_size = var_name_strnsize(variable_name,
+                                                              variable_name_size);
                        efivar_create_sysfs_entry(efivars,
                                                  variable_name_size,
                                                  variable_name,
-- 
1.7.11.7



-- 
Matt Fleming, Intel Open Source Technology Center
