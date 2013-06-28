Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753726Ab3F1URD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 16:17:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24053 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753374Ab3F1URB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 16:17:01 -0400
From: Lenny Szubowicz <lszubowi@redhat.com>
To: tony.luck@intel.com, cbouatmailru@gmail.com, matt.fleming@intel.com,
        linux-kernel@vger.kernel.org
Cc: n.hamaguchi@jp.fujitsu.com, dzickus@redhat.com
Subject: [PATCH 2/3] acpi: Eliminate console msg if pstore.backend excludes ERST
Date: Fri, 28 Jun 2013 16:14:10 -0400
Message-Id: <1372450451-8790-3-git-send-email-lszubowi@redhat.com>
In-Reply-To: <1372450451-8790-1-git-send-email-lszubowi@redhat.com>
References: <1372450451-8790-1-git-send-email-lszubowi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is patch 2/3 of a patch set that avoids what misleadingly appears
to be a error during boot:

ERST: Could not register with persistent store

This message is displayed if the system has a valid ACPI ERST table and the
pstore.backend kernel parameter has been used to disable use of ERST by
pstore. But this same message is used for errors that preclude registration.

In erst_init don't complain if the setting of kernel parameter pstore.backend
precludes use of ACPI ERST for pstore. Routine pstore_register will inform
about the facility that does register.

Also, don't leave a dangling pointer to deallocated mem for the pstore
buffer when registration fails.

Signed-off-by: Lenny Szubowicz <lszubowi@redhat.com>
Reported-by: Naotaka Hamaguchi <n.hamaguchi@jp.fujitsu.com>
---
 drivers/acpi/apei/erst.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/acpi/apei/erst.c b/drivers/acpi/apei/erst.c
index 6d894bf..f7b3b39 100644
--- a/drivers/acpi/apei/erst.c
+++ b/drivers/acpi/apei/erst.c
@@ -1180,20 +1180,28 @@ static int __init erst_init(void)
 	if (!erst_erange.vaddr)
 		goto err_release_erange;
 
+	pr_info(ERST_PFX
+	"Error Record Serialization Table (ERST) support is initialized.\n");
+
 	buf = kmalloc(erst_erange.size, GFP_KERNEL);
 	spin_lock_init(&erst_info.buf_lock);
 	if (buf) {
 		erst_info.buf = buf + sizeof(struct cper_pstore_record);
 		erst_info.bufsize = erst_erange.size -
 				    sizeof(struct cper_pstore_record);
-		if (pstore_register(&erst_info)) {
-			pr_info(ERST_PFX "Could not register with persistent store\n");
+		rc = pstore_register(&erst_info);
+		if (rc) {
+			if (rc != -EPERM)
+				pr_info(ERST_PFX
+				"Could not register with persistent store\n");
+			erst_info.buf = NULL;
+			erst_info.bufsize = 0;
 			kfree(buf);
 		}
-	}
-
-	pr_info(ERST_PFX
-	"Error Record Serialization Table (ERST) support is initialized.\n");
+	} else
+		pr_err(ERST_PFX
+		"Failed to allocate %lld bytes for persistent store error log\n",
+		erst_erange.size);
 
 	return 0;
 
-- 
1.8.2.1

