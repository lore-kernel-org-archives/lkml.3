Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751034Ab3CADV1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 22:21:27 -0500
Received: from mail-qa0-f48.google.com ([209.85.216.48]:54834 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750696Ab3CADVZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 22:21:25 -0500
From: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>
To: matt@console-pimps.org
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Schroeder <mls@suse.com>, Josh Boyer <jwboyer@redhat.com>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        "Lee, Chun-Yi" <jlee@suse.com>
Subject: [PATCH] efivarfs: fix abnormal GUID in variable name by using strcpy to replace null with dash
Date: Fri,  1 Mar 2013 11:20:18 +0800
Message-Id: <1362108018-13117-1-git-send-email-jlee@suse.com>
X-Mailer: git-send-email 1.6.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Schroeder <mls@suse.com>

On HP z220 system (firmware version 1.54), some EFI variables are incorrectly
named :

ls -d /sys/firmware/efi/vars/*8be4d* | grep -v -- -8be returns
/sys/firmware/efi/vars/dbxDefault-pport8be4df61-93ca-11d2-aa0d-00e098032b8c
/sys/firmware/efi/vars/KEKDefault-pport8be4df61-93ca-11d2-aa0d-00e098032b8c
/sys/firmware/efi/vars/SecureBoot-pport8be4df61-93ca-11d2-aa0d-00e098032b8c
/sys/firmware/efi/vars/SetupMode-Information8be4df61-93ca-11d2-aa0d-00e098032b8c

That causes by the following statement in efivar_create_sysfs_entry function:

 *(short_name + strlen(short_name)) = '-';
efi_guid_unparse(vendor_guid, short_name + strlen(short_name));

The trailing \0 is overwritten with '-', but the next char doesn't seem to be a \0
as well for HP. So, the second strlen return the point of next '\0', causes there
have garbage string attached before GUID.

Tested on On HP z220.

Cc: Matt Fleming <matt@console-pimps.org>
Cc: Josh Boyer <jwboyer@redhat.com>
Cc: Jeremy Kerr <jeremy.kerr@canonical.com>
Cc: Michael Schroeder <mls@suse.com>
Reported-by: Frederic Crozat <fcrozat@suse.com>
Tested-by: Frederic Crozat <fcrozat@suse.com>
Signed-off-by: Lee, Chun-Yi <jlee@suse.com>
---
 drivers/firmware/efivars.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index 8bcb595..fbf18ff 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -1708,7 +1708,7 @@ efivar_create_sysfs_entry(struct efivars *efivars,
 	/* This is ugly, but necessary to separate one vendor's
 	   private variables from another's.         */
 
-	*(short_name + strlen(short_name)) = '-';
+	strcpy(short_name + strlen(short_name), "-");
 	efi_guid_unparse(vendor_guid, short_name + strlen(short_name));
 
 	new_efivar->kobj.kset = efivars->kset;
-- 
1.6.0.2

