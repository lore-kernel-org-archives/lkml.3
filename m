Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755496AbaFDX77 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 19:59:59 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40439 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753565AbaFDXXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 19:23:06 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        James Duley <jagduley@gmail.com>, Phillip Dixon <phil@dixon.gen.nz>,
        Brandon Casey <drafnel@gmail.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 3.14 204/228] ACPI / TPM: Fix resume regression on Chromebooks
Date: Wed,  4 Jun 2014 16:23:53 -0700
Message-Id: <20140604232354.603646229@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140604232347.966798903@linuxfoundation.org>
References: <20140604232347.966798903@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>

commit f759546498d820670934c901a2fdf1ce948d2e5c upstream.

Chromebooks (at least Acer C720 and Pixel) implement an ACPI object
for TPM, but don't implement the _DSM method to support PPI.  As
a result, the TPM driver fails to load on those machines after
commit 1569a4c4ceba (ACPI / TPM: detect PPI features by checking
availability of _DSM functions) which causes them to fail to
resume from system suspend, becuase they require the TPM hardware
to be put into the right state during resume and the TPM driver
is necessary for that.

Fix the problem by making tpm_add_ppi() return 0 when tpm_ppi_handle
is still NULL after walking the ACPI namespace in search for the PPI
_DSM, which allows the TPM driver to load and operate the hardware
(during system resume in particular), but avoid creating the PPI
sysfs group in that case.

This change is based on a prototype patch from Jiang Liu.

Fixes: 1569a4c4ceba (ACPI / TPM: detect PPI features by checking availability of _DSM functions)
References: https://bugzilla.kernel.org/show_bug.cgi?id=74021
Reported-by: James Duley <jagduley@gmail.com>
Reported-by: Phillip Dixon <phil@dixon.gen.nz>
Tested-by: Brandon Casey <drafnel@gmail.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/char/tpm/tpm_ppi.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/drivers/char/tpm/tpm_ppi.c
+++ b/drivers/char/tpm/tpm_ppi.c
@@ -328,13 +328,11 @@ int tpm_add_ppi(struct kobject *parent)
 	/* Cache TPM ACPI handle and version string */
 	acpi_walk_namespace(ACPI_TYPE_DEVICE, ACPI_ROOT_OBJECT, ACPI_UINT32_MAX,
 			    ppi_callback, NULL, NULL, &tpm_ppi_handle);
-	if (tpm_ppi_handle == NULL)
-		return -ENODEV;
-
-	return sysfs_create_group(parent, &ppi_attr_grp);
+	return tpm_ppi_handle ? sysfs_create_group(parent, &ppi_attr_grp) : 0;
 }
 
 void tpm_remove_ppi(struct kobject *parent)
 {
-	sysfs_remove_group(parent, &ppi_attr_grp);
+	if (tpm_ppi_handle)
+		sysfs_remove_group(parent, &ppi_attr_grp);
 }


